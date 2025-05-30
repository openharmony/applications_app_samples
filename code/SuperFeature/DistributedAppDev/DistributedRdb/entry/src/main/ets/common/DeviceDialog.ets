/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

@CustomDialog
export struct DeviceDialog {
  private controller?: CustomDialogController;
  private selectedIndex: number = 0;
  private onSelectedIndexChange: (selectedIndex: number) => void = (selectedIndex: number) => {}
  @State deviceList: Array<deviceManager.DeviceBasicInfo> = [];

  build() {
    Column() {
      Text($r('app.string.check_device'))
        .fontSize(20)
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
      List() {
        ForEach(this.deviceList, (item: deviceManager.DeviceBasicInfo, index: number) => {
          ListItem() {
            Row() {
              Text(item.deviceName)
                .fontSize(20)
                .width('90%')
                .fontColor(Color.Black)
              if (index === this.selectedIndex) {
                Image($r('app.media.checked'))
                  .width('8%')
                  .objectFit(ImageFit.Contain)
              } else {
                Image($r('app.media.uncheck'))
                  .width('8%')
                  .objectFit(ImageFit.Contain)
              }
            }
            .height(55)
            .onClick(() => {
              this.selectedIndex = index
              this.onSelectedIndexChange(index)
            })
          }
        }, (item: deviceManager.DeviceBasicInfo) => item.deviceName)
      }
      .width('80%')
      .height(150)

      Button() {
        Text($r('app.string.cancel'))
          .fontColor('#0D9FFB')
          .width('90%')
          .textAlign(TextAlign.Center)
          .fontSize(20)
      }
      .key('cancelBtn')
      .type(ButtonType.Capsule)
      .backgroundColor(Color.White)
      .onClick(() => {
        if (this.controller != null) {
          this.controller.close()
        }
      })
    }
    .backgroundColor(Color.White)
    .border({ color: Color.White, radius: 20 })
    .padding(10)
  }
}