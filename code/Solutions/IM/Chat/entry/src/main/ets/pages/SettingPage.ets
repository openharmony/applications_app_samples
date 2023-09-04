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

@Observed
class SettingMenu {
  public id: string;
  public image: Resource;
  public text: Resource;

  constructor(id: string, image: Resource, text: Resource) {
    this.id = id;
    this.image = image;
    this.text = text;
  }
}

@Preview
@Component
export struct SettingPage {
  @State basicMenuGroup: SettingMenu[] = [
    new SettingMenu('album', $r('app.media.icon_me_photo'), $r('app.string.album')),
    new SettingMenu('collection', $r('app.media.icon_me_collect'), $r('app.string.collection')),
    new SettingMenu('wallet', $r('app.media.icon_me_money'), $r('app.string.wallet')),
    new SettingMenu('card', $r('app.media.icon_me_card'), $r('app.string.card'))
  ];
  @State otherMenuGroup: SettingMenu[] = [
    new SettingMenu('expression', $r('app.media.icon_me_smail'), $r('app.string.expression')),
    new SettingMenu('setting', $r('app.media.icon_me_setting'), $r('app.string.setting')),
    new SettingMenu('chat_history', $r('app.media.icon_me_setting'), $r('app.string.chat_list'))
  ];

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.head_image'))
            .width($r('app.integer.setting_head_image_width'))
            .height($r('app.integer.setting_head_image_width'))
          Column() {
            Row() {
              Text($r('app.string.myself'))
                .fontSize($r('app.integer.setting_name_font_size'))
                .fontColor(Color.Black)
            }
            Text($r('app.string.chat_number'))
              .fontSize($r('app.integer.setting_name_font_size'))
              .fontColor(Color.Black)
          }
          .alignItems(HorizontalAlign.Start)
          .padding({ left: $r('app.integer.setting_name_padding_left') })
        }
        .backgroundColor(Color.White)
        .padding($r('app.integer.setting_head_padding_left'))
        .backgroundColor(Color.White)
        .width($r('app.string.layout_100'))
      }
      .backgroundColor(Color.White)
      .height($r('app.integer.setting_head_column_height'))
      .margin({ bottom: $r('app.integer.setting_head_column_margin_bottom') })

      List() {
        ForEach(this.basicMenuGroup,
          (item: SettingMenu) => {
            ListItem() {
              SettingItemView({ image: item.image, text: item.text })
            }
          },
          (item: SettingMenu) => item.id.toString())
      }
      .margin({ bottom: $r('app.integer.setting_head_column_margin_bottom') })

      List() {
        ForEach(this.otherMenuGroup,
          (item: SettingMenu) => {
            ListItem() {
              SettingItemView({ image: item.image, text: item.text })
                .margin({ bottom: $r('app.integer.setting_head_column_margin_bottom') })
            }
          },
          (item: SettingMenu) => item.id.toString())
      }
    }
    .backgroundColor($r('app.color.setting_column_color'))
    .width($r('app.string.layout_100'))
    .height($r('app.string.layout_100'))
  }

}

@Component
export struct SettingItemView {
  private image: string | Resource;
  private text: string | Resource;

  build() {
    Stack({ alignContent: Alignment.End }) {
      Row() {
        Image(this.image)
          .width($r('app.integer.setting_menu_width'))
          .height($r('app.integer.setting_menu_width'))
        Text(this.text)
          .fontSize($r('app.integer.setting_menu_font_size'))
          .fontColor($r('app.color.setting_text_color'))
          .margin({ left: $r('app.integer.setting_menu_margin_left') })
      }
      .width($r('app.string.layout_100'))
      .height($r('app.integer.setting_menu_height'))
      .padding({ left: $r('app.integer.setting_menu_padding_left'),
        right: $r('app.integer.setting_menu_padding_left') })
      .backgroundColor(Color.White)

      Image($r('app.media.right_arrow'))
        .height($r('app.integer.setting_menu_arrow_height'))
        .width($r('app.integer.setting_menu_arrow_width'))
        .align(Alignment.End)
        .margin({ right: $r('app.integer.setting_menu_padding_left') })
    }
    .width($r('app.string.layout_100'))
    .height($r('app.integer.setting_menu_height'))
  }
}