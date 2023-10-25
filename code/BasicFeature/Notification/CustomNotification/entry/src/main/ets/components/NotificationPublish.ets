/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import NotificationOperations from '../feature/NotificationOperations';
import { notificationManagement } from '@ohos/notification';
import { notificationUtil } from '@ohos/notification';
import { TitleBar } from '../components/TitleBar'

export interface ButtonMsg {
  text: Resource,
  icon: Resource,
  callback?: () => void
}

@Component
export struct NotificationPublish {
  private notificationOperations: NotificationOperations = new NotificationOperations(getContext(this));
  @State isPromptTone: boolean = false;
  @State isVibrationEffect: boolean = false;
  @State buttons: ButtonMsg[] = [
    {
      icon: $r('app.media.ic_notice_jiben'),
      text: $r('app.string.basic_notification'),
      callback: this.notificationOperations.publishBasicNotification
    },
    {
      icon: $r('app.media.ic_notice_changwenben'),
      text: $r('app.string.long_text_notification'),
      callback: this.notificationOperations.publishLongTextNotification
    },
    {
      icon: $r('app.media.ic_notice_duohang'),
      text: $r('app.string.multiline_notification'),
      callback: this.notificationOperations.publishMultiLineNotification
    },
    {
      icon: $r('app.media.ic_notice_tupian'),
      text: $r('app.string.picture_notification'),
      callback: this.notificationOperations.publishPictureNotification
    },
    {
      icon: $r('app.media.ic_notice_anniu'),
      text: $r('app.string.notification_with_buttons'),
      callback: this.notificationOperations.publishNotificationWithButtons
    },
    {
      icon: $r('app.media.ic_notice_tiaozhuan'),
      text: $r('app.string.clickable_notification'),
      callback: this.notificationOperations.publishNotificationWithWantAgent
    }]

  @Builder view(button: ButtonMsg) {
    Column() {
      Image(button.icon).width(40).height(28).objectFit(ImageFit.Contain)
        .margin({ bottom: 10 })
      Text(button.text)
        .fontSize(16)
        .onClick(button.callback)
    }.viewStyle()
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(button.callback)
  }

  @Styles viewStyle(){
    .width('48%')
    .height(100)
    .borderRadius(20)
    .margin({ top: 18 })
    .backgroundColor($r('app.color.start_window_background'))
  }

  @Styles toggleStyle(){
    .width(52)
    .height(26)
    .margin({ right: 24 })
  }

  @Styles rowStyle(){
    .backgroundColor($r('app.color.start_window_background'))
    .borderRadius(20)
    .margin({ top: 18 })
    .height(80)
    .width('90%')
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.mainAbility_label') })
      Row() {
        Image($r('app.media.ic_public_ring')).width(20).height(25).objectFit(ImageFit.Contain)
          .margin({ left: 24, right: 15 })
        Text($r('app.string.sound')).fontSize(17)
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.isPromptTone })
          .toggleStyle()
          .selectedColor($r('app.color.blue'))
          .onChange((isOn: boolean) => {
            this.isPromptTone = isOn;
            notificationUtil.promptTone(isOn);
          })
          .id('promptTone')
      }.rowStyle()
      .alignItems(VerticalAlign.Center)

      Row() {
        Image($r('app.media.ic_public_vibrate')).width(20).height(25).objectFit(ImageFit.Contain)
          .margin({ left: 24, right: 15 })
        Text($r('app.string.vibration_effect')).fontSize(17)
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.isVibrationEffect })
          .toggleStyle()
          .selectedColor($r('app.color.blue'))
          .onChange((isOn: boolean) => {
            this.isVibrationEffect = isOn;
            notificationUtil.vibrationEffect(isOn);
          })
          .id('vibrationEffect')
      }.rowStyle()
      .alignItems(VerticalAlign.Center)

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.SpaceEvenly }) {
        ForEach(this.buttons, (item: ButtonMsg, index: number) => {
          this.view(item)
        }, (item: ButtonMsg) => item.toString())
      }
      .width('90%')

      Button($r('app.string.cancel_all_notifications'))
        .backgroundColor($r('app.color.button_background'))
        .width(230)
        .height(40)
        .margin(10)
        .fontSize(16)
        .margin({ top: 20 })
        .fontColor($r('app.color.button_fontColor'))
        .onClick(() => {
          notificationUtil.cancelAllNotifications();
          notificationManagement.resetTypeNotificationState();
        })
    }
  }

  aboutToAppear() {
    notificationUtil.enableNotification();
    this.isPromptTone = notificationUtil.promptTone();
    this.isVibrationEffect = notificationUtil.vibrationEffect();
  }
}