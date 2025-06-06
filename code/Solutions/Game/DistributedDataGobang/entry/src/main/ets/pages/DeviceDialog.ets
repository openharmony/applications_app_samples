/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import deviceManager from '@ohos.distributedDeviceManager';
import Logger from '../util/Logger';

const TAG: string = 'DeviceDialog';

@CustomDialog
export struct DeviceDialog {
  private controller?: CustomDialogController;
  private deviceList: Array<deviceManager.DeviceBasicInfo> = [];
  @Link selectedIndex: number;

  build() {
    Column() {
      Text($r('app.string.select_device'))
        .fontSize(30)
        .width('100%')
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
      List() {
        ForEach(this.deviceList, (item: deviceManager.DeviceBasicInfo, index: number) => {
          ListItem() {
            Row() {
              Text(item.deviceName)
                .fontSize(21)
                .width(350)
                .fontColor(Color.Black)
              Image(index === this.selectedIndex ? $r('app.media.checked') : $r('app.media.uncheck'))
                .width(35)
                .objectFit(ImageFit.Contain)
            }
            .height(55)
            .onClick(() => {
              Logger.info(TAG, `select device: ${item.deviceId}`);
              if (index === this.selectedIndex) {
                Logger.info(TAG, `index === this.selectedIndex`);
                return;
              }
              this.selectedIndex = index;
            })
          }
        }, (item: deviceManager.DeviceBasicInfo) => item.deviceName)
      }
      .width('100%')
      .height(150)

      Button() {
        Text($r('app.string.cancel'))
          .width(300)
          .fontSize(21)
          .fontColor('#0D9FFB')
          .textAlign(TextAlign.Center)
      }
      .type(ButtonType.Capsule)
      .backgroundColor(Color.White)
      .onClick(() => {
        this.controller?.close();
      })
    }
    .padding(10)
    .backgroundColor(Color.White)
    .border({ color: Color.White, radius: 20 })
  }
}