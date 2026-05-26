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

/**
 *  添加设备页面
 */
import SettingAlertDialog from '../view/SettingAlertDialog';
import emitter from '@ohos.events.emitter';
import { EventConstants } from '@ohos/common/src/main/ets/constants/EventConstants';
import {
  CommonConstants,
  EnvManager,
  getProtocolCode,
  Logger,
  NavBar,
  PageViewUtils,
  ProtocolType
} from '@ohos/common';
import ScanModel, { ScanState } from '../viewmodel/ScanModel';
import { FindAnimateView } from '../view/FindAnimateView';
import { AddDevicesListView } from '../view/AddDevicesListView';
import { TipButton } from '../view/TipButton';
import { HMRouter } from '@hadss/hmrouter';
import { WifiAddDevicesManager } from '../viewmodel/WifiAddDevicesManager';
import { WifiAddDevicesListView } from '../view/WifiAddDevicesListView';
import { WifiFindAnimateView } from '../view/WifiFindAnimateView';

@HMRouter({ pageUrl: 'WifiAddDevicePage' })
@Component
export struct WifiAddDevicePage {
  @Provide addDevicesModel: WifiAddDevicesManager = new WifiAddDevicesManager();
  @State @Watch('changeMode') scanModel: ScanModel = this.addDevicesModel.scanModel;
  @Provide addNoAccessCode: string[] = [];
  //是否是动画模式
  @State isAnimationMode: boolean = true;
  @State title: Resource = $r('app.string.add_device');
  private controller: CustomDialogController = new CustomDialogController({
    builder: SettingAlertDialog(
      {
        onConfirm: async (): Promise<void> => await this.onSettingConfirm()
      }
    ),
    customStyle: true,
    alignment: DialogAlignment.Center,
  });

  async onSettingConfirm() {
    let noAccessArray: string[] = EnvManager.getInstance().getNoAccessCodes();
    this.controller.close();
    if (noAccessArray.length != 0) {
      if (noAccessArray.includes(getProtocolCode(ProtocolType.BLE))) {
        await EnvManager.getInstance().enableAccessByCode(getContext(this), getProtocolCode(ProtocolType.BLE));
      }
      if (noAccessArray.includes(getProtocolCode(ProtocolType.WIFI))) {
        await EnvManager.getInstance().enableAccessByCode(getContext(this), getProtocolCode(ProtocolType.WIFI));
      }
    }
    await this.checkAccess();
  }

  changeMode() {
    if (this.scanModel.currentScanState == ScanState.SCANNING &&
      this.addDevicesModel.showDevices.totalCount() !== 0) {
      this.isAnimationMode = false;
    }
  }

  /**
   * 重新检查环境状态
   */
  async startScanCheck() {
    if (!EnvManager.getInstance().isNoAccess() && this.scanModel.currentScanState == ScanState.NOT_START) {
      this.addDevicesModel.startScan();
    }
  }

  /**
   * 只有第一次，所有权限都不存在时，提示权限弹窗
   * @param first
   */
  async checkAccess(first: boolean = false) {
    this.addNoAccessCode = await EnvManager.getInstance().recheckNoAccessCodes();
    Logger.debug('this.noAccessCode=' + this.addNoAccessCode);
    if (EnvManager.getInstance().isNoAccess() && first) {
      this.controller.open();
    } else {
      this.startScanCheck();
    }
  }

  aboutToAppear() {
    Logger.debug('aboutToAppear()');
    setTimeout(() => {
      PageViewUtils.tabClick();
    }, 100);
    this.checkAccess(true);
    // 当应用到前台后重新检查
    let innerEvent: emitter.InnerEvent = {
      eventId: EventConstants.ON_FOREGROUND_EVENT
    };
    emitter.on(innerEvent, () => {
      this.checkAccess();
    });
  }

  aboutToDisappear() {
    Logger.debug('aboutToDisappear()');
  }

  getRescanBarShow(): boolean {
    return this.scanModel.currentScanState == ScanState.SCANNING_FINISH;
  }

  @Builder
  itemHead() {
    Row() {
      if (!this.isAnimationMode) {
        Text(this.scanModel.currentScanState == ScanState.SCANNING ? $r('app.string.scanning_tip0') :
        $r('app.string.scan_result'))
          .fontSize($r('app.string.fp_15'))
          .backgroundColor($r('app.color.bg_scan'))
          .padding($r('app.string.vp_5'))
          .visibility(this.isAnimationMode ? Visibility.Hidden : Visibility.Visible);
        if (this.scanModel.currentScanState == ScanState.SCANNING) {
          LoadingProgress()
            .color($r('app.color.loading_color'))
            .width($r('app.string.vp_25'))
            .height($r('app.string.vp_25'));
        }
      }
      Blank();
    }
    .justifyContent(FlexAlign.Start)
    .padding({
      left: $r('app.string.vp_30'),
      right: $r('app.string.vp_30'),
      bottom: $r('app.string.vp_10'),
      top: $r('app.string.vp_10'),
    })
    .width(CommonConstants.FULL_WIDTH_PERCENT);
  }

  build() {
    Column() {
      NavBar({
        title: this.title
      });
      this.itemHead();
      Stack() {
        if (this.isAnimationMode) {
          WifiFindAnimateView({ scanModel: this.scanModel });
        } else {
          WifiAddDevicesListView();
        }
      }.backgroundColor($r('app.color.bg_scan'))
      .layoutWeight(1);

      TipButton({
        btnStyle: {
          btnRes: $r('app.string.restart_scan'), clickEvent: () => {
            this.addDevicesModel.startScan();
          }
        }
      })
        .visibility(this.getRescanBarShow() ? Visibility.Visible : Visibility.Hidden)
        .margin({ bottom: '30lpx' });
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}