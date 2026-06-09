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
import DeviceDiscoverManager from '../viewmodel/DeviceDiscoverManager';
import { ColorMetrics, LengthMetrics, promptAction } from '@kit.ArkUI';
import { access } from '@kit.ConnectivityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '@ohos/common';

/**
 * 重新扫描按钮
 */
@Component
export struct RescanButton {
  @LocalStorageLink('isDragMode') isDragMode: boolean = true;

  promptActionShowToast() {
    promptAction.showToast({
      message: $r('app.string.Bluetooth_switch'),
      duration: 1000,
    });
  }

  build() {
    Button(
      $r('app.string.scan_no_result_button_text'),
      { type: ButtonType.Capsule, stateEffect: true }
    )
      .onClick(() => {
        this.isDragMode = true;
        Logger.info('bleStartScan button');
        try {
          let state = access.getState();
          Logger.info('bleStartScan state==' + state);
          if (state == 2) {
            DeviceDiscoverManager.getInstance().startScan();
          } else {
            this.promptActionShowToast();
          }
        } catch (err) {
          Logger.error('bleStartScan errCode: ' + (err as BusinessError).code + ', errMessage: ' +
          (err as BusinessError).message);
          this.promptActionShowToast();
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