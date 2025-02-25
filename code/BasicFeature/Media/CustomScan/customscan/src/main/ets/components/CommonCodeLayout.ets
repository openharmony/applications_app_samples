/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { curves, promptAction} from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { vibrator } from '@kit.SensorServiceKit';
import { GlobalContext } from '../common/util/GlobalUtil';
import { XComponentSize } from '../model/ScanSize'
import { ScanTitle } from './ScanTitle';
import { scanBarcode } from '@kit.ScanKit';
import { logger } from '../common/util/Logger';
import CommonConstants from '../common/constants/CommonConstants';
import CustomScanViewModel, { ScanResults } from '../viewmodel/CustomScanViewModel';
import { PromptTone } from '../model/PromptTone';
import { funcDelayer } from '../common/util/FunctionUtil';

/**
 * 二维码位置的样式
 */
@Extend(Image)
function selected(scanState: boolean, x: number, y: number) {
  .width(40)
  .height(40)
  .position({ x: x, y: y })
  .markAnchor({ x: 20, y: 20 })
  .visibility(scanState ? Visibility.Visible : Visibility.Hidden)
  .draggable(false)
}

/**
 * 二维码位置组件
 */
@Component
export struct CodeLayout {
  @Consume('subPageStack') subPageStack: NavPathStack;
  @ObjectLink xComponentSize: XComponentSize;
  @Prop navHeight: number;
  @State scanResults: ScanResults = {
    code: 0,
    data: [],
    size: 0,
    uri: ''
  }
  @Prop foldStatus: number = -1; // 折叠状态
  @State multiCodeScanLocation: number[][] = [];
  @State multiCodeScanResult: scanBarcode.ScanResult[] = [];// 多个二维码结果集
  @State isMultiSelected: boolean = false;// 多二维码下是否已选择
  @State multiSelectedIndex: number = 0;// 多二维码下是否选择的index
  @State singleCodeX: number = 0;// 单个结果的位置
  @State singleCodeY: number = 0;
  @State multiCodeScale: number = 0.3; // 多二维码图案比例参数
  @State multiCodeOpacity: number = 0; // 透明度设置
  @State singleCodeScale: number = 0.3; // 单二维码图案比例参数
  @State singleCodeOpacity: number = 0; // 透明度设置
  @State fadeOutScale: number = 1;
  @State fadeOutOpacity: number = 1;
  @State isPickerDialogShow: boolean = false;
  @State isShowCode: boolean = true;
  @Consume('customScanVM') customScanVM: CustomScanViewModel;
  @Link avPlayer: PromptTone;// 成功扫描二维码的提示音

  aboutToAppear() {
    // 触发传感器震动
    this.vibratorPlay();
    // 播放二维码扫描成功提示音
    this.avplayerPlay();
    // 处理扫码结果信息
    for (let i = 0; i < this.scanResults.size; i++) {
      let scanResult: scanBarcode.ScanResult = this.scanResults.data[i];
      this.multiCodeScanResult.push(scanResult);
      let scanCodeRect: scanBarcode.ScanCodeRect | undefined = scanResult.scanCodeRect;
      if (scanCodeRect) {
        this.multiCodeScanLocation.push(
          [scanCodeRect.left,
            scanCodeRect.top,
            scanCodeRect.right,
            scanCodeRect.bottom]
        );
      }
    }

    // 只扫描到一个二维码时，单独处理
    if (this.scanResults.size === 1) {
      this.multiSelectedIndex = 0;
      let location = this.multiCodeScanLocation[0];
      this.singleCodeX = this.getOffset('x', location);
      this.singleCodeY = this.getOffset('y', location);
    }

  }

  aboutToDisappear() {
    GlobalContext.getContext().setProperty((CommonConstants.GLOBAL_SCAN_SELECT_A_PICTURE), false);
    this.isPickerDialogShow = false;
  }

  /**
   * 单个二维码的位置图片
   */
  @Builder
  SingleCodeLayout() {
    Column() {
      Image($rawfile('scan_selected.svg'))
        // TODO: 知识点: 在扫描结果返回的水平坐标和纵坐标位置上展示图片
        .selected(true, this.singleCodeX, this.singleCodeY)
        .scale({ x: this.singleCodeScale, y: this.singleCodeScale })
        .opacity(this.singleCodeOpacity)
        .onAppear(() => {
          this.singleCodeBreathe();
        })
    }
    .position({ x: 0, y: 0 })
    .width('100%')
    .height('100%')
  }

  /**
   * 多个二维码的位置图片渲染
   */
  @Builder
  MultiCodeLayout(arr: number[], index: number) {
    Row() {
      Image($rawfile('scan_selected2.svg'))
        .width(40)
        .height(40)
        .visibility((this.isMultiSelected && this.multiSelectedIndex !== index) ? Visibility.None : Visibility.Visible)
        .scale({ x: this.multiCodeScale, y: this.multiCodeScale })
        .opacity(this.multiCodeOpacity)
        .onAppear(() => {
          // 展示动画，因为共用状态变量，只需要第一次执行
          if (index === 0) {
            this.multiAppear();
          }
        })
        .onClick(() => {
          // 点击打开二维码信息弹窗
          this.openMultiCode(arr, index);
        })
    }
    // TODO: 知识点: 预览流有固定比例，XComponent只能展示部分，返回的扫码结果和当前展示存在一定偏移量
    .position({
      x: this.getOffset('x', arr),
      y: this.getOffset('y', arr)
    })
    .width(40)
    .height(40)
    .markAnchor({ x: 20, y: 20 })
    .scale({ x: this.fadeOutScale, y: this.fadeOutScale })
    .opacity(this.fadeOutOpacity)
    .animation({
      duration: 200,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Alternate,
    })
  }

  build() {
    Stack() {
      // 如果只有一个结果，渲染单个位置
      if (this.scanResults.size === 1 && this.isShowCode) {
        this.SingleCodeLayout();
      } else {
        // 多结果提示文案
        ScanTitle({
          navHeight: this.navHeight,
        }).width('100%').height('100%')

        // 渲染多二维码位置结果
        ForEach(this.multiCodeScanLocation, (item: number[], index: number) => {
          this.MultiCodeLayout(item, index)
        }, (item: number) => item.toString())
        // 点击某一个二维码后，展示选中图案
        Image($rawfile('scan_selected.svg'))
          .selected(true, this.singleCodeX, this.singleCodeY)
          .scale({ x: this.singleCodeScale, y: this.singleCodeScale })
          .opacity(this.singleCodeOpacity)
          .visibility(this.isMultiSelected ? Visibility.Visible : Visibility.None)
      }
    }
    .width('100%')
    .height('100%')
  }

  // 计算水平或者竖直的偏移量
  getOffset(coordinateAxis: string, location: number[]): number {
    if (coordinateAxis === 'x') {
      return this.setOffsetXByOrientation(location);
    }
    return this.setOffsetYByOrientation(location);
  }

  setOffsetXByOrientation(location: number[]): number {
    let offset: number = (location[0] + location[2]) / 2 + this.xComponentSize.offsetX;
    return offset;
  }

  setOffsetYByOrientation(location: number[]): number {
    let offset: number = (location[3] + location[1]) / 2 + this.xComponentSize.offsetY;
    return offset;
  }

  // 传感器震动
  vibratorPlay() {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: 100
      }, {
        id: 0,
        usage: 'alarm'
      }).then((): void => {
      }, (error: BusinessError) => {
        logger.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
      });
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      logger.error(`Failed to play vibration, An unexpected error occurred. Code: ${error.code}, message: ${error.message}`);
    }
  }

  // 播放二维码扫描成功提示音
  avplayerPlay() {
    if (this.avPlayer) {
      this.avPlayer.playDrip();
    }
  }

  /**
   * 多个二维码，点击查看某个二维码信息
   * @param arr
   * @param index
   */
  openMultiCode(arr: number[], index: number): void {
    this.singleCodeX = this.getOffset('x', arr);
    this.singleCodeY = this.getOffset('y', arr);
    this.isMultiSelected = true;
    this.singleCodeScale = 0.3;
    this.singleCodeOpacity = 0;
    this.multiSelectedIndex = index || 0;
    this.fadeOutScale = 0.3;
    this.fadeOutOpacity = 0;
    this.showScanResult(this.scanResults.data[index])
  }

  /**
   * 二维码图标呼吸动效
   */
  singleCodeBreathe(): void {
    this.singleCodeOpacity = 0.3;
    this.singleCodeScale = 0.3;
    animateTo({
      duration: 300,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Alternate,
      onFinish: () => {
        this.showScanResult(this.scanResults.data[0])
      }
    }, () => {
      this.singleCodeOpacity = 1;
      this.singleCodeScale = 1;
    });
  }

  multiAppear(): void {
    this.multiCodeScale = 0.3;
    animateTo({
      duration: 350,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), // Animation curve.
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Alternate,
      onFinish: () => {
        this.multiAppearEnd();
      }
    }, () => {
      this.multiCodeScale = 1.1;
      this.multiCodeOpacity = 1;
    });
  }

  multiAppearEnd(): void {
    animateTo({
      duration: 250,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), // Animation curve.
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Alternate,
      onFinish: () => {
        funcDelayer(() => {
          this.multiCodeBreathe();
        }, 500);
      }
    }, () => {
      this.multiCodeScale = 1;
    });
  }

  /**
   * 多二维码结果图案的呼吸动效
   */
  multiCodeBreathe(): void {
    this.multiCodeScale = 1;
    animateTo({
      duration: 300,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), // Animation curve.
      delay: 0,
      iterations: 4,
      playMode: PlayMode.Alternate,
      onFinish: () => {
        funcDelayer(() => {
          this.multiCodeBreathe();
        }, 400);
      }
    }, () => {
      this.multiCodeScale = 0.8;
    });
  }

  /**
   * 显示扫码结果
   * @param {scanBarcode.ScanResult} result 扫码结果数据
   * @returns {Promise<void>}
   */
  async showScanResult(scanResult: scanBarcode.ScanResult): Promise<void> {
    // 码源信息
    const originalValue: string = scanResult.originalValue;
    // 二维码识别结果展示
    this.subPageStack.pushPathByName(CommonConstants.SUB_PAGE_DETECT_BARCODE, originalValue, true);
  }
}