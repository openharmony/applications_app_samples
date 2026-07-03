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
import ScanModel, { ScanState } from '../viewmodel/ScanModel';
import { WifiAddDevicesManager } from '../viewmodel/WifiAddDevicesManager';

// 扫描动画背景尺寸倍率
const SCAN_ANIMATION_RATE: number = 3;

/**
 * 添加设备动画页面
 */
@Component
export struct WifiFindAnimateView {
  //扫描的设备数据
  @Consume addDevicesModel: WifiAddDevicesManager;
  @Link @Watch('onStateChange') scanModel: ScanModel;
  originSize: number = ResourceUtil.getNumberToLpx(getContext(), $r('app.float.origin_circle_size'));
  targetSize: number = this.originSize * SCAN_ANIMATION_RATE;
  @Consume addNoAccessCode: Array<string>;
  @State animationCircleSize: number = this.originSize;
  @State animationFlag: boolean = false;
  @State title: Resource = $r('app.string.add_device');

  startScanAnimation() {
    if (this.animationFlag) {
      return;
    }
    if (this.scanModel.scanLastTime > 0) {
      let animationTimes =
        Math.floor(this.scanModel.scanLastTime * 1000 / CommonConstants.ANIMATION_DURATION) + 1;
      Logger.debug('当前动画剩余时间' + this.scanModel.scanLastTime + 's，剩余次数' + animationTimes);
      animateTo({
        duration: CommonConstants.ANIMATION_DURATION,
        curve: Curve.EaseIn,
        iterations: animationTimes,
        playMode: PlayMode.Normal,
        finishCallbackType: FinishCallbackType.REMOVED,
        onFinish: () => {
          Logger.info('play end');
          this.animationCircleSize = this.originSize;
          this.animationFlag = false;
        }
      }, () => {
        this.animationCircleSize = this.targetSize;
        this.animationFlag = true;
      });
    }

  }

  aboutToAppear() {
    //切换模式的时候会回调，需要重新检查状态
    this.onStateChange();
  }

  /**
   * 扫描状态变更
   */
  onStateChange() {
    switch (this.scanModel.currentScanState) {
      case ScanState.SCANNING:
        this.startScanAnimation();
        break;
    }
  }

  isTip0Show(): boolean {
    switch (this.scanModel.currentScanState) {
      case ScanState.SCANNING:
      case ScanState.SCANNING_FINISH:
        return this.addDevicesModel.showDevices.totalCount() == 0;
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
      this.addNoAccessCode,
      (item: string, index: number) => {
        Span(EnvManager.getInstance().getAccessNameResourceByCode(item))
          .onClick(async () => {
            const result: boolean = await EnvManager.getInstance().enableAccessByCode(getContext(this), item);
            if (result) {
              //重新扫描
              this.addNoAccessCode = await EnvManager.getInstance().recheckNoAccessCodes();
              this.addDevicesModel.startScan();
            }
          })
          .fontColor($r('app.color.button_text_color'));
        if (index != this.addNoAccessCode.length - 1) {
          Span($r('app.string.comma'))
            .fontColor($r('app.color.button_text_color'));
        }
      },
    );
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
  getTip1Text() {
    Text() {
      if (this.scanModel.currentScanState == ScanState.NOT_START) {
        Span($r('app.string.scan_not_start_tip1'));
        this.getNoAccessButton();
      } else if (this.addNoAccessCode.length == 0 && this.scanModel.currentScanState == ScanState.SCANNING) {
        Span($r('app.string.scanning_tip2'));
      }
    }
    .alignRules(
      {
        top: { 'anchor': 'center_bg', 'align': VerticalAlign.Bottom },
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
    if (this.scanModel.currentScanState.valueOf() == ScanState.NOT_START) {
      return $r('app.string.scan_not_start_tip0');
    } else if (this.scanModel.currentScanState.valueOf() == ScanState.SCANNING) {
      return $r('app.string.scanning_tip0');
    } else if (this.scanModel.currentScanState.valueOf() == ScanState.SCANNING_FINISH &&
      this.addDevicesModel.showDevices.totalCount() == 0) {
      return $r('app.string.add_device_no_find');
    } else {
      return $r('app.string.scan_finish');
    }
  }

  build() {
    RelativeContainer() {
      Row()
        .width(this.animationCircleSize)
        .height(this.animationCircleSize)
        .backgroundColor($r('app.color.scan_animator_bg'))
        .borderRadius(this.targetSize / 2)
        .opacity(this.animationFlag ? 0 : 1)
        .id('animation')
        .alignRules(RelativeRules.centerRule);

      Shape() {
        Circle({ width: this.originSize, height: this.originSize }).fill($r('app.color.scan_shape_bg'));
      }.alignRules(RelativeRules.centerRule)
      .id('center_bg');

      Image($r('app.media.bg_device'))
        .width($r('app.string.bg_device_size'))
        .height($r('app.string.bg_device_size'))
        .alignRules(RelativeRules.centerRule)
        .id('phone_bg');
      Image($r('app.media.ic_device'))
        .width($r('app.string.ic_device_size'))
        .height($r('app.string.ic_device_size'))
        .alignRules(RelativeRules.centerRule)
        .id('phone');

      Text(this.getScanText())
        .fontSize($r('app.string.scan_tip_font_size'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.san_title_font_color'))
        .alignRules(
          {
            top: { 'anchor': 'phone_bg', 'align': VerticalAlign.Bottom },
            middle: { 'anchor': '__container__', align: HorizontalAlign.Center }
          }
        )
        .id('tip0');

      this.getTip1Text();
    }.width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT);
  }
}
