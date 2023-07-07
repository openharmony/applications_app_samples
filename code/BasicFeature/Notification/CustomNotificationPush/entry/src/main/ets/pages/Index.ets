/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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

import { notificationFilter, ContentCallBackType } from '../feature/NotificationFilterUtil'


type checkBoxesMsg = {
  text: Resource,
  enable: boolean
  contentType: ContentCallBackType
}

@Extend(Text) function listTitleStyle() {
  .textAlign(TextAlign.Start)
  .fontWeight(500)
  .fontSize(20)
  .fontFamily('HarmonyHeiTi-Medium')
  .opacity(1)
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .margin({ top: 18 })
  .padding(15)
}

@Entry
@Component
struct Index {
  context = getContext(this)
  @State isNotificationOn: boolean = false
  @State isStaticSubscribeEnable: boolean = false
  @State checkBoxes: checkBoxesMsg[] = [
    {
      text: $r('app.string.basic_notification'),
      enable: false,
      contentType: ContentCallBackType.CALLBACK_NOTIFICATION_CONTENT_BASIC_TEXT
    },
    {
      text: $r('app.string.long_text_notification'),
      enable: false,
      contentType: ContentCallBackType.CALLBACK_NOTIFICATION_CONTENT_LONG_TEXT
    },
    {
      text: $r('app.string.multiline_notification'),
      enable: false,
      contentType: ContentCallBackType.CALLBACK_NOTIFICATION_CONTENT_MULTILINE
    },
    {
      text: $r('app.string.picture_notification'),
      enable: false,
      contentType: ContentCallBackType.CALLBACK_NOTIFICATION_CONTENT_PICTURE
    }]

  @Builder TitleBar(title: Resource) {
    Row() {
      Text(title)
        .fontWeight(500)
        .fontSize(32)
        .margin({ left: 12 })
    }
    .width('100%')
    .height(80)
    .backgroundColor($r('app.color.title_bar_background'))
  }

  @Builder viewCheckBox(checkBox: checkBoxesMsg) {
    Row() {
      Text(checkBox.text)
        .fontSize(20)
        .margin({ left: 40 })
      Blank()
      Checkbox({
        name: this.context.resourceManager.getStringSync(checkBox.text),
      })
        .select(checkBox.enable)
        .margin({ right: 20 })
        .selectedColor(0x39a2db)
        .onChange((value: boolean) => {
          notificationFilter.setContentTypeDisable(checkBox.contentType, value)
        })
    }.width('100%')
    .margin({ top: 10 })
  }

  @Styles toggleStyle(){
    .width(52)
    .height(26)
    .margin({ right: 12 })
  }

  build() {
    Column() {
      this.TitleBar($r('app.string.EntryAbility_label'))
      Column() {
        Row() {
          Text($r('app.string.notification_filter_text'))
            .listTitleStyle()
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.isNotificationOn })
            .toggleStyle()
            .onChange((value: boolean) => {
              this.isNotificationOn = value
              notificationFilter.setNotificationEnableFilter(value)
            })
        }.width('100%')

        if (this.isNotificationOn) {
          ForEach(this.checkBoxes, (item: checkBoxesMsg, index: number) => {
            this.viewCheckBox(item)
          }, (item: checkBoxesMsg) => item.toString())
        }
      }
      .cardStyle()
    }.width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({ left: 20, right: 20 })
  }
}
