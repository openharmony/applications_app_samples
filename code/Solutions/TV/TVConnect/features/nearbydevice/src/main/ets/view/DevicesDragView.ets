/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { CommonConstants, EnvManager, Logger, RelativeRules } from '@ohos/common';
import ResourceUtil from '../util/ResourceUtil';
import DeviceDiscoverManager from '../viewmodel/DeviceDiscoverManager';
import DeviceItem from '../viewmodel/DeviceItem';
import { ConnectState } from '../viewmodel/DevicesManager';
import DevicesModel from '../viewmodel/DevicesModel';
import ScanModel, { ScanState } from '../viewmodel/ScanModel';
import { DeviceAnimation } from './DeviceAnimation';
import { RescanButton } from './RescanButton';
import '../pages/DeviceDetailPage';
import { DeviceDetailDialog } from './DeviceDetailDialog';
import DragSceneConstants from '../constants/DragSceneConstants';
import { scale } from '../util/ScreenAdaptation';

// 扫描动画背景尺寸倍率
const SCAN_ANIMATION_RATE: number = 3;

export class Sheet {
  private click: boolean = false;
  private static instance: Sheet;

  public static getContext(): Sheet {
    if (!Sheet.instance) {
      Sheet.instance = new Sheet();
    }
    return Sheet.instance;
  }

  clicked() {
    this.click = !this.click;
  }

  public getClicked(): boolean {
    return this.click;
  }
}

/**
 * 设备拖拽连接页面
 */
@Component
export struct DevicesDragView {
  //扫描状态
  @Consume @Watch('onStateChange') scanModel: ScanModel;
  //带连接设备数据
  @Consume @Watch('changePopWindowState') devicesModel: DevicesModel;
  @Consume sheet: Sheet;
  originSize: number = ResourceUtil.getNumberToLpx(getContext(), $r('app.float.origin_circle_size'));
  targetSize: number = this.originSize * SCAN_ANIMATION_RATE;
  @Consume noAccessCode: Array<string>;
  @State animationCircleSize: number = this.originSize;
  @State animationFlag: boolean = false;
  //当前页面是否已经渲染好，只有当前页面渲染好，才能根据onStateChange接受到scanning事件
  @Link finishInit: boolean;
  @State isShow: boolean = false;
  // 主页标签坐标
  @Link @Watch('changePopWindowState') categoryTabIndex: number;
  // 设备页面子标签坐标
  @Link @Watch('changePopWindowState') currentIndex: number;
  @State isShowPopWindow: boolean = true;
  @StorageLink('CategoryPageShow') @Watch('changePopWindowState') isPageShow: boolean = true;
  @LocalStorageLink('isDragMode') isDragMode: boolean = true;

  changePopWindowState() {
    if (this.isPageShow && this.categoryTabIndex == 1 && this.currentIndex == 1) {
      setTimeout(() => {
        this.isShowPopWindow = true;
      }, 200);
    } else {
      this.isShowPopWindow = false;
    }
  }

  startScanAnimation() {
    if (this.animationFlag) {
      return;
    }
    if (this.scanModel.scanLastTime > 0) {
      let animationTimes = Math.floor(this.scanModel.scanLastTime * 1000 / CommonConstants.ANIMATION_DURATION) + 1;
      Logger.debug('===>当前动画剩余时间' + this.scanModel.scanLastTime + 's，剩余次数' + animationTimes);
      animateTo({
        duration: CommonConstants.ANIMATION_DURATION,
        curve: Curve.EaseIn,
        iterations: animationTimes,
        playMode: PlayMode.Normal,
        finishCallbackType: FinishCallbackType.REMOVED,
        onFinish: () => {
          Logger.info('DevicesDragView',
            `===>play end',this.devicesModel.currentDevicesNum:${this.devicesModel.currentDevicesNum}`);
          this.animationCircleSize = this.originSize;
          this.animationFlag = false;
          if (this.devicesModel.currentDevicesNum > 0) {
            this.isDragMode = false;
          }
        }
      }, () => {
        this.animationCircleSize = this.targetSize;
        this.animationFlag = true;
      });
    }

  }

  aboutToAppear() {
    Logger.info('DevicesDragView', '===>aboutToAppear: this.isDragMode: ' + this.isDragMode);
    Logger.debug('this.originSize=' + this.originSize);
    if (!this.finishInit) {
      this.finishInit = true;
    }
    //切换模式的时候会回调，需要重新检查状态
    this.onStateChange();
  }

  /**
   * 扫描状态变更
   */
  onStateChange() {
    Logger.debug('onStateChange,this.state = ' + this.scanModel.currentScanState);
    switch (this.scanModel.currentScanState) {
      case ScanState.SCANNING:
        this.startScanAnimation();
        break;
    }
  }

  isTip0Show(): boolean {
    switch (this.scanModel.currentScanState) {
      case ScanState.SCANNING:
        return true;
      case ScanState.SCANNING_FINISH:
        return this.devicesModel.currentDevicesNum == 0;
      case ScanState.NOT_START:
      default:
        return true;
    }
  }

  isTip1Show(): boolean {
    switch (this.scanModel.currentScanState) {
      case ScanState.SCANNING:
        return this.devicesModel.currentDevicesNum == 0 && this.noAccessCode.length != 0;
      case ScanState.SCANNING_FINISH:
        return false;
      case ScanState.NOT_START:
      default:
        return true;
    }
  }

  isButtonShow(): boolean {
    return this.scanModel.currentScanState == ScanState.SCANNING_FINISH;
  }

  @Builder
  getNoAccessButton() {
    ForEach(
      this.noAccessCode,
      (item: string, index: number) => {
        Span(EnvManager.getInstance().getAccessNameResourceByCode(item))
          .onClick(async () => {
            const result: boolean = await EnvManager.getInstance().enableAccessByCode(getContext(this), item);
            if (result) {
              //重新扫描
              this.noAccessCode = await EnvManager.getInstance().recheckNoAccessCodes();
              DeviceDiscoverManager.getInstance().startScan();
            }
          })
          .fontColor($r('app.color.button_text_color'));
        if (index != this.noAccessCode.length - 1) {
          Span($r('app.string.comma'))
            .fontColor($r('app.color.button_text_color'));
        }
      },
    );
  }

  @Builder
  DeviceDetailDialog() {
    Column() {
      DeviceDetailDialog({
        sheet: true,
        deviceName: this.devicesModel.connectingDevice?.name,
      });
      Column() {
        Text($r('app.string.more'))
          .onClick(() => {
            this.isShow = false;
            this.sheet.clicked();
          })
          .fontColor(Color.Blue)
          .margin({
            left: $r('app.string.distance_8'),
            top: $r('app.string.distance_8'),
            bottom: $r('app.string.distance_8')
          });
      };
    }.backgroundColor($r('sys.color.ohos_id_color_sub_background'));
  }

  @Builder
  popWindow() {
    Row() {
      Text($r('app.string.pop_tip'))
        .fontSize($r('app.string.fp_13'))
        .fontColor($r('app.color.black'))
        .fontWeight(FontWeight.Medium)
        .margin({ right: $r('app.string.vp_5') });
      Image($r('app.media.ic_arrow_right'))
        .width($r('app.string.vp_10'))
        .height($r('app.string.vp_20'));
    }.padding({
      left: $r('app.string.vp_14'),
      right: $r('app.string.vp_14'),
      top: $r('app.string.vp_12'),
      bottom: $r('app.string.vp_12')
    }).onClick(() => {
      //临时提示，后续改为具体逻辑
      this.isShow = true;
    })
    .bindSheet($$this.isShow, this.DeviceDetailDialog(), {
      detents: [SheetSize.MEDIUM, SheetSize.LARGE, 500],
      backgroundColor: $r('sys.color.ohos_id_color_sub_background'),
      showClose: true,
      preferType: SheetType.CENTER,
      shouldDismiss: ((sheetDismiss: SheetDismiss) => {
        Logger.info('bind sheet shouldDismiss');
        sheetDismiss.dismiss();
      })
    });
  }

  @Builder
  getConnectingWidget() {
    Stack() {
      Image($r('app.media.bg_light_equipment'))
        .width($r('app.string.vp_50'))
        .height($r('app.string.vp_50'))
        .id('bg_connect_device');
      LoadingProgress()
        .color($r('app.color.loading_color'))
        .width($r('app.string.vp_40'))
        .height($r('app.string.vp_40'))
        .id('ic_loading');
    }.alignRules(
      {
        top: {
          'anchor': 'phone_bg', 'align': VerticalAlign.Center
        },
        left: {
          'anchor': 'phone_bg', 'align': HorizontalAlign.End
        },
      }
    )
    .offset({
      x: $r('app.string.vp_n20')
    })
    .id('connect_device');
  }

  @Builder
  getConnectSuccessWidget(isConnectedDeviceVirtual: boolean) {
    Stack() {
      Image(isConnectedDeviceVirtual ? $r('app.media.bg_light_equipment_virtual_connected') : $r('app.media.bg_device'))
        .width(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
        .height(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
        .id('bg_connect_device');
      Image($r('app.media.ic_device'))
        .alt(CommonConstants.DEFAULT_DEVICE_ICON)
        .width(DragSceneConstants.DEVICE_ITEM_IC_SIZE)
        .height(DragSceneConstants.DEVICE_ITEM_IC_SIZE)
        .id('ic_device');
    }
    .alignRules(
      {
        top: {
          'anchor': 'phone_bg', 'align': VerticalAlign.Center
        },
        left: {
          'anchor': 'phone_bg', 'align': HorizontalAlign.End
        },
      }
    )
    .offset({
      x: scale(-28)
    })
    .id('connect_success')
    .bindPopup(this.isShowPopWindow, {
      builder: this.popWindow(),
      placement: Placement.Bottom,
      enableArrow: true,
      popupColor: '#ffffff',
      autoCancel: false,
      offset: {
        y: scale(-8)
      },
      mask: false,
    });
  }

  @Builder
  getTip1Text() {
    Text() {
      if (this.noAccessCode.length == EnvManager.getInstance().getAccessNumber()) {
        Span($r('app.string.scan_not_start_tip1'));
        this.getNoAccessButton();
      } else if (this.noAccessCode.length < EnvManager.getInstance().getAccessNumber()) {
        Span($r('app.string.scanning_tip1'));
        this.getNoAccessButton();
      } else if (this.noAccessCode.length == 0) {
        Span($r('app.string.scanning_tip2'));
      }
    }
    .alignRules(
      {
        top: { 'anchor': 'tip0', 'align': VerticalAlign.Bottom },
        middle: { 'anchor': '__container__', align: HorizontalAlign.Center }
      }
    )
    .fontSize($r('app.string.scan_tip_font_size'))
    .fontColor($r('app.color.san_tip_font_color'))
    .margin({
      top: $r('app.string.scan_tip_margin_top')
    })
    .id('tip1');
  }

  getScanText(): Resource {
    switch (this.scanModel.currentScanState) {
      case ScanState.NOT_START:
        return $r('app.string.scan_not_start_tip0');
      case ScanState.SCANNING:
        return $r('app.string.scanning_tip0');
      case ScanState.SCANNING_FINISH:
      default:
        return $r('app.string.scan_no_result_tip');
    }
  }

  build() {
    Column() {
      RelativeContainer() {
        Row()
          .width(this.animationCircleSize)
          .height(this.animationCircleSize)
          .backgroundColor($r('app.color.scan_device_bg'))
          .borderRadius(this.targetSize / 2)
          .opacity(this.animationFlag ? 0 : 1)
          .id('animation')
          .alignRules(RelativeRules.centerRule);

        Shape() {
          Circle({ width: this.originSize, height: this.originSize }).fill($r('app.color.scan_device_bg2'));
        }.alignRules(RelativeRules.centerRule)
        .id('center_bg')
        .onDrop((event: DragEvent, extraParams?: string) => {
          Logger.debug('onDrop,x=' + event.getWindowX() + ',y=' + event.getWindowY());
          event.useCustomDropAnimation = false;
        })
        .onDragMove((event: DragEvent, extraParams?: string) => {
          Logger.debug('onDragMove(),x=' + event.getWindowX() + ',y=' + event.getWindowY());
        });

        Image($r('app.media.bg_device'))
          .width($r('app.string.wh_value_120'))
          .height($r('app.string.wh_value_120'))
          .alignRules(RelativeRules.centerRule)
          .id('phone_bg')
          .margin({ top: '10lpx' });
        Image($r('app.media.ic_device'))
          .width('25lpx')
          .alignRules(RelativeRules.centerRule)
          .id('phone');
        if (this.isTip0Show()) {
          Text(this.getScanText())
            .fontSize($r('app.string.scan_tip_font_size'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_color_white'))
            .margin({
              top: $r('app.string.vp_60')
            })
            .alignRules(
              {
                top: { 'anchor': 'phone_bg', 'align': VerticalAlign.Bottom },
                middle: { 'anchor': '__container__', align: HorizontalAlign.Center }
              }
            )
            .id('tip0');
        }

        if (this.isTip1Show()) {
          this.getTip1Text();
        }
      }
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .layoutWeight(1)
      .backgroundColor($r('app.color.canConnect_device_bg'))
      .borderRadius($r('app.string.vp_14'));

      RescanButton()
        .margin({
          top: $r('app.string.vp_10'),
          bottom: $r('app.string.button_margin_bottom')
        })
        .visibility(this.isButtonShow() ? Visibility.Visible : Visibility.Hidden)
        .id('bt');
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT)
    .padding({ left: $r('app.string.24_vp'), right: $r('app.string.24_vp') });
  }
}
