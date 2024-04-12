/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import Logger from '../model/Logger';

const TAG: string = 'MultiCameraDialog';

@CustomDialog
export struct MultiCameraDialog {
  private controller: CustomDialogController;

  build() {
    Column() {
      Row() {
        Text('选择摄像头')
          .fontSize(20)
          .fontWeight(500)
          .fontColor('#182431')
        Image($r('app.media.ic_camera_ProgressBar_circle')).size({ width: 20, height: 20 })
      }
      .margin({ top: 10 })
      .width('96%')
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        Text('已连接的设备')
          .fontSize(14)
          .fontWeight(500)
          .opacity(0.5)
          .fontFamily('HarmonyHeiTi')
          .fontColor('#182431')
          .textAlign(TextAlign.Start)
          .width('100%')
          .margin({ bottom: 10 })
        Row() {
          Image($r('app.media.ic_camera_pad')).size({ width: 20, height: 20 })
            .margin({ left: 18 })
          Text('本机（前置）')
            .fontSize(16)
            .fontColor('#182431')
            .fontWeight(500).width('60%')
          Radio({ value: 'Radio1', group: 'radioGroup' }).checked(false)
            .size({ width: 20, height: 20 })
            .onChange((isChecked: boolean) => {
              Logger.info(TAG, `onChange Radio1 status is: ${isChecked}`);
              this.controller.close();
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('110%')

        Divider().width('86%').margin({ left: 40 })
        Row() {
          Image($r('app.media.ic_camera_pad')).size({ width: 20, height: 20 })
            .margin({ left: 18 })
          Text('本机（后置）')
            .fontSize(16)
            .fontColor('#182431')
            .fontWeight(500).width('60%')
          Radio({ value: 'Radio1', group: 'radioGroup' }).checked(false)
            .size({ width: 20, height: 20 })
            .onChange((isChecked: boolean) => {
              Logger.info(TAG, `onChange Radio1 status is ${isChecked}`);
              this.controller.close();
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('110%')

        Divider().width('86%').margin({ left: 40 })
        Row() {
          Image($r('app.media.ic_camera_pad')).size({ width: 20, height: 20 })
            .margin({ left: 18 })
          Text('Nova8（前置）')
            .fontSize(16)
            .fontColor('#182431')
            .fontWeight(500).width('60%')
          Radio({ value: 'Radio1', group: 'radioGroup' }).checked(false)
            .size({ width: 20, height: 20 })
            .onChange((isChecked: boolean) => {
              Logger.info(TAG, `onChange Radio1 status is ${isChecked}`);
              this.controller.close();
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('110%')

        Divider().width('86%').margin({ left: 40 })
        Row() {
          Image($r('app.media.ic_camera_pad')).size({ width: 20, height: 20 })
            .margin({ left: 18 })
          Text('Nova8（后置）')
            .fontSize(16)
            .fontColor('#182431')
            .fontWeight(500).width('60%')
          Radio({ value: 'Radio1', group: 'radioGroup' }).checked(false)
            .size({ width: 20, height: 20 })
            .onChange((isChecked: boolean) => {
              this.controller.close();
              Logger.info(TAG, `onChange Radio1 status is ${isChecked}`);
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('110%')
      }
      .margin({ top: 24 })
      .width('96%')
    }
    .justifyContent(FlexAlign.SpaceAround)
    .width(336)
    .padding('2%')
    .borderRadius(32)
    .backgroundColor('#FFFFFF')
  }
}