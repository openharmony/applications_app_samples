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

import deviceInfo from '@ohos.deviceInfo';
import deviceManager from '@ohos.distributedHardware.deviceManager';
import { GlobalContext, getGlobalObject, setGlobalObject } from '../common/GlobalThis';
import logger from '../common/Logger';
import remoteDeviceModel from '../model/RemoteDeviceModel';

@CustomDialog
struct DeleteDeviceDialog {
  @Prop deviceName: string = '';
  @Link deviceInfo: deviceManager.DeviceInfo;
  controller?: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };
  private isDelete: string = '';

  aboutToAppear() {
    this.isDelete = getContext(this).resourceManager.getStringSync($r('app.string.isDelete').id);
    setGlobalObject('isDelete', this.isDelete)
  }

  build() {
    Column() {
      Text(this.isDelete + this.deviceName)
        .fontSize(20)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontWeight(500)
        .lineHeight(26)
        .margin({ bottom: 26 })
        .fontSize(20)
        .fontColor('#182431')

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.cancel'))
          .fontSize(16)
          .onClick(() => {
            this.controller!.close();
            this.cancel();
          })
          .backgroundColor(0xffffff)
          .fontColor('#007DFF')
          .fontWeight(500)
        Divider()
          .vertical(true)
          .height(24)
          .color('#182431')
          .opacity(0.2)
          .alignSelf(ItemAlign.Center)
        Button($r('app.string.delete'))
          .fontSize(16)
          .onClick(() => {
            this.controller!.close();
            this.confirm();
          })
          .backgroundColor(0xffffff)
          .fontColor('#FA2A2D')
          .fontWeight(500)
      }
    }
    .margin({ bottom: 12, left: 12, right: 12 })
    .borderRadius(24)
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .padding(24)
  }
}

@Component
export struct ListDeviceView {
  @State deviceInfo: deviceManager.DeviceInfo | undefined = undefined;
  @State visible: Visibility = Visibility.None;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DeleteDeviceDialog({
      cancel: this.onCancel,
      confirm: this.onAccept,
      deviceName: this.deviceInfo!.deviceName,
      deviceInfo: $deviceInfo
    }),
    cancel: this.existApp,
    autoCancel: true,
    alignment: deviceInfo.deviceType == 'tablet' ? DialogAlignment.Center : DialogAlignment.Bottom,
    gridCount: 4,
    customStyle: deviceInfo.deviceType == 'tablet' ? false : true
  });

  onCancel() {
    logger.info('Callback when the first button is clicked');
  }

  onAccept() {
    logger.info('[DeviceManager.RemoteDeviceModel] listDeviceView ' + JSON.stringify(this.deviceInfo));
    remoteDeviceModel.unAuthenticateDevice(this.deviceInfo!);
    logger.info('Callback when the second button is clicked');
  }

  existApp() {
    logger.info('Click the callback in the blank area');
  }

  getDeviceTypeIcon(deviceType: deviceManager.DeviceType): Resource {
    if (deviceType == deviceManager.DeviceType.TABLET) {
      return $r('app.media.ic_pad');
    } else if (deviceType == deviceManager.DeviceType.PHONE) {
      return $r('app.media.ic_phone');
    } else if (deviceType == deviceManager.DeviceType.UNKNOWN_TYPE) {
      return $r('app.media.ic_pc');
    } else {
      return $r('app.media.ic_pc');
    }
  }

  build() {
    Column() {
      Row() {
        Image(this.getDeviceTypeIcon(this.deviceInfo!.deviceType))
          .width(24)
          .height(24)
          .align(Alignment.Start)
        Column() {
          Text(this.deviceInfo!.deviceName)
            .fontSize(16)
            .fontColor('#182431')
            .fontFamily('HarmonyHeiTi-Medium')
            .fontWeight(500)
            .margin({ left: 12 })
            .lineHeight(22)
          Text(this.deviceInfo!.deviceId + ', ' + this.deviceInfo!.authForm.toString())
            .fontSize(14)
            .opacity(0.6)
            .margin({ left: 12, top: 2 })
            .fontColor('#182431')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .constraintSize({ maxWidth: '60%' })
        }.alignItems(HorizontalAlign.Start)

        Blank()

        Row() {
          Text($r('app.string.certified'))
            .fontColor('#182431')
            .fontSize(14)
            .opacity(0.6)

          Image($r('app.media.ic_arrow'))
            .width(12)
            .height(24)
            .margin({ left: 6 })
        }
        .margin({ left: 24 })
        .visibility(this.visible)
        .onClick(() => {
          this.dialogController.open();
        })
      }.width('100%')
      .height(64)
    }.width('100%')
  }
}