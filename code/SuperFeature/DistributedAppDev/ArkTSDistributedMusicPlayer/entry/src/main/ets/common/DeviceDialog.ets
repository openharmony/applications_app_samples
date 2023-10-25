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
import Logger from '../model/Logger';

const TAG: string = 'DeviceDialog';

@CustomDialog
export struct DeviceDialog {
  controller?: CustomDialogController;
  private deviceLists: Array<deviceManager.DeviceBasicInfo> = [];
  private selectedIndex: number = 0;
  private selectedIndexChange: (selectedIndex: number) => void = () => {
  };

  build() {
    Column() {
      Text($r('app.string.choiceDevice'))
        .fontSize('32px')
        .width('434px')
        .fontColor(Color.Black)
        .textAlign(TextAlign.Start)
        .fontWeight(600)
      List() {
        ForEach(this.deviceLists, (item: deviceManager.DeviceBasicInfo, index: number | undefined) => {
          ListItem() {
            Flex({
              direction: FlexDirection.Row,
              justifyContent: FlexAlign.SpaceBetween,
              alignItems: ItemAlign.Center
            }) {
              Text(item.deviceName)
                .fontSize(16)
                .width('86%')
                .fontColor(Color.Black)
                .textAlign(TextAlign.Start)
              Radio({ value: '', group: 'radioGroup' })
                .radioStyle({
                  checkedBackgroundColor: '#ff0d64fb'
                })
                .width('7%')
                .checked(index === this.selectedIndex ? true : false)
            }
            .height(55)
            .onClick(() => {
              Logger.info(TAG, `select device: ${item.deviceId}`)
              if (index === this.selectedIndex) {
                Logger.info(TAG, 'index === this.selectedIndex')
                return
              }
              this.selectedIndex = index !== undefined ? index : 0
              if (this.controller !== undefined) {
                this.controller.close()
              }
              this.selectedIndexChange(this.selectedIndex)
            })
          }
          .width('434px')
          .height('80px')
        })
      }
      .margin({ top: 12 })
      .width('434px')
      .height('18%')

      Button() {
        Text($r('app.string.cancel'))
          .width('90%')
          .fontSize(21)
          .fontColor('#ff0d64fb')
          .textAlign(TextAlign.Center)
      }
      .margin({ bottom: 16 })
      .type(ButtonType.Capsule)
      .backgroundColor(Color.White)
      .onClick(() => {
        if (this.controller !== undefined) {
          this.controller.close()
        }
      })
    }
    .margin({ bottom: 36 })
    .width('500px')
    .padding(10)
    .backgroundColor(Color.White)
    .border({ color: Color.White, radius: 20 })
  }
}