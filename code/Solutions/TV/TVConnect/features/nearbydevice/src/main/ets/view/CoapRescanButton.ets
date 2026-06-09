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
import { ColorMetrics, LengthMetrics, promptAction } from '@kit.ArkUI';
import CoapDeviceDiscoverManager from '../viewmodel/CoapDeviceDiscoverManager';
import { wifiManager } from '@kit.ConnectivityKit';
import ethernet from '@ohos.net.ethernet';
import { Logger } from '@ohos/common';

/**
 * 重新扫描按钮
 */
@Component
export struct CoapRescanButton {
  @LocalStorageLink('isDragModeCoap') isDragMode: boolean = true;
  @State networkStateType: number = 0;
  @State curActiveIFace: string = '';
  private timerId: number = -1; // 定时器ID

  async aboutToAppear(): Promise<void> {
    // 初始化默认值
    this.networkStateType = 0;
    // 启动定时器，每隔一秒执行一次查询
    this.startPolling();
  }

  aboutToDisappear(): void {
    // 界面隐藏时清除定时器
    this.stopPolling();
  }

  private startPolling(): void {
    // 先执行一次立即查询
    this.pollNetworkState();
    // 设置定时器，每秒执行一次
    this.timerId = setInterval(() => {
      this.pollNetworkState();
    }, 1000);
  }

  private stopPolling(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  private async pollNetworkState(): Promise<void> {
    try {
      const isWifiActive = wifiManager.isWifiActive();
      Logger.info('pollNetworkState isWifiActive:' + isWifiActive);
      if (isWifiActive) {
        const wifiInfo = await wifiManager.getLinkedInfo();
        if (wifiInfo?.ssid) {
          await this.handleEthernetConfig();
        } else {
          // WiFi激活但无ssid，保持默认值或根据业务需要设置
          this.networkStateType = 0; // 可根据实际需求调整
        }
      } else {
        // WiFi未激活，保持默认值或根据业务需要设置
        this.networkStateType = 0; // 可根据实际需求调整
      }
    } catch (error) {
      Logger.error('pollNetworkState error：', JSON.stringify(error));
    }
  }

  private async handleEthernetConfig(): Promise<void> {
    try {
      const iFaces = await ethernet.getAllActiveIfaces();
      Logger.info('handleEthernetConfig getAllActiveIfaces iFaces ==> ' + JSON.stringify(iFaces));
      if (iFaces.length > 0) {
        this.curActiveIFace = iFaces[iFaces.length - 1];
        Logger.info('handleEthernetConfig this.curActiveIFace ==> ' + JSON.stringify(this.curActiveIFace));
        const data = await ethernet.getIfaceConfig(this.curActiveIFace);
        Logger.info('handleEthernetConfig getIfaceConfig data ==> ' + JSON.stringify(data));
        this.networkStateType = data?.ipAddr ? 0 : 1;
      } else {
        this.networkStateType = 1;
      }
    } catch (error) {
      Logger.error('handleEthernetConfig error：', JSON.stringify(error));
      this.networkStateType = 1;
    }
  }

  build() {
    Button(
      $r('app.string.scan_no_result_button_text_coap'),
      { type: ButtonType.Capsule, stateEffect: true }
    )
      .onClick(() => {
        this.isDragMode = true;
        Logger.info('getCurActiveIFaceConfig coapButton' + this.networkStateType);
        if (this.networkStateType == 0) {
          promptAction.showToast({
            message: $r('app.string.Scan_failed'),
            duration: 1000,
          });
        } else if (this.networkStateType == 1) {
          CoapDeviceDiscoverManager.getInstance().startScan();
        }
      })
      .fontColor($r('app.color.black'))
      .fontSize($r('app.string.button_font_size'))
      .padding({
        left: $r('app.string.button_padding_horizontal'),
        right: $r('app.string.button_padding_horizontal'),
        top: $r('app.string.button_padding_vertical'),
        bottom: $r('app.string.button_padding_vertical')
      })
      .backgroundColor($r('app.color.default_button_bg'))
      .focusBox({
        margin: LengthMetrics.lpx(8),
        strokeColor: ColorMetrics.resourceColor($r('app.color.white')),
        strokeWidth: LengthMetrics.lpx(2)
      });
  }
}