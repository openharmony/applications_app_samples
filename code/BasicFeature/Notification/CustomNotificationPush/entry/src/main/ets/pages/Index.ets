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

import { notificationFilter, ContentCallBackType } from '../feature/NotificationFilterUtil';

interface checkBoxesMsg {
  text: Resource,
  enable: boolean,
  contentType: ContentCallBackType
}

@Extend(Text) function listTitleStyle() {
  .textAlign(TextAlign.Start)
  .fontWeight(500)
  .fontSize(22)
  .fontFamily('HarmonyHeiTi-Medium')
  .opacity(1)
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .margin({ top: 0 })
  .padding(15)
}

@Entry
@Component
struct Index {
  context = getContext(this);
  @State isNotificationOn: boolean = false;
  @State isStaticSubscribeEnable: boolean = false;
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
        .fontWeight(700)
        .fontSize(24)
        .margin({ left: 12 })
    }
    .width('100%')
    .height(56)
    .backgroundColor($r('app.color.title_bar_background'))

  }

  @Builder viewCheckBox(checkBox: checkBoxesMsg, index: number) {
    Row() {
      Text(checkBox.text)
        .fontSize(16)
        .margin({ left: 36 });
      Blank();
      Checkbox({
        name: this.context.resourceManager.getStringSync(checkBox.text),
      })
        .select(checkBox.enable)
        .margin({ right: 20 })
        .height(20)
        .width(20)
        .borderRadius(4)
        .id('checkbox' + index)
        .selectedColor(0x007DFF)
        .onChange((value: boolean) => {
          notificationFilter.setContentTypeDisable(checkBox.contentType, value);
        });
    }.width('100%')
    .height(48)
    .margin({ top: 0 });
  }

  @Styles toggleStyle(){
    .width(36)
    .height(20)
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
            .selectedColor(0x007DFF)
            .id('toggle')
            .onChange((value: boolean) => {
              this.isNotificationOn = value;
              notificationFilter.setNotificationEnableFilter(value);
            })
        }
        .height(48)
        .width('100%');

        if (this.isNotificationOn) {
          ForEach(this.checkBoxes, (item: checkBoxesMsg, index: number) => {
            this.viewCheckBox(item, index);
          }, (item: checkBoxesMsg) => item.toString());
        }
      }
      .cardStyle()
    }.width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({ left: 20, right: 20 })
  }
}
