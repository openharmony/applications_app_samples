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

const LIST_SPACE: number = 16; // 列表默认间隔
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间

@Observed
class SettingMenu {
  public id: string; // 唯一id
  public image: Resource; // 菜单图标
  public text: Resource; // 菜单文本

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
    new SettingMenu('album', $r('app.media.ic_album'), $r('app.string.album')),
    new SettingMenu('collection', $r('app.media.ic_collect'), $r('app.string.collection')),
    new SettingMenu('wallet', $r('app.media.ic_wallet'), $r('app.string.wallet')),
    new SettingMenu('card', $r('app.media.ic_cards'), $r('app.string.card'))
  ]; // 基础功能分组
  @State otherMenuGroup: SettingMenu[] = [
    new SettingMenu('expression', $r('app.media.ic_emoji'), $r('app.string.expression')),
    new SettingMenu('setting', $r('app.media.ic_settings'), $r('app.string.setting')),
    new SettingMenu('chat_history', $r('app.media.ic_record'), $r('app.string.chat_list'))
  ]; // 其他功能分组

  build() {
    Column() {
      Row() {
        Text($r('app.string.my'))
          .fontSize($r('app.integer.setting_title_font_size'))
          .fontWeight(FontWeight.Bold)
          .lineHeight($r('app.integer.setting_title_height'))
          .fontColor($r('app.color.title_font_color'))
          .fontFamily($r('app.string.harmony_hei_ti'))
          .margin({ left: $r('app.integer.setting_title_margin_left') })
          .height($r('app.integer.setting_title_height'))
      }
      .width($r('app.string.layout_100'))
      .height($r('app.integer.friends_page_title_bar_height'))
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      List() {
        ListItem() {
          Column() {
            Row() {
              Image($r('app.media.head_image'))
                .width($r('app.integer.setting_head_image_width'))
                .height($r('app.integer.setting_head_image_width'))
                .borderRadius($r('app.integer.setting_my_icon_border_radius'))
              Column() {
                Text($r('app.string.myself'))
                  .fontSize($r('app.integer.setting_name_font_size'))
                  .fontColor($r('app.color.setting_text_color'))
                  .fontFamily($r('app.string.harmony_hei_ti'))
                  .fontWeight(FontWeight.Medium)
                  .lineHeight($r('app.integer.setting_name_line_height'))

                Text($r('app.string.chat_number'))
                  .fontSize($r('app.integer.setting_chat_num_font_size'))
                  .fontFamily($r('app.string.harmony_hei_ti'))
                  .fontColor($r('app.color.setting_text_color'))
                  .lineHeight($r('app.integer.setting_chat_num_line_height'))
                  .margin({ top: $r('app.integer.setting_chat_num_margin_top') })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: $r('app.integer.setting_name_margin_left') })
            }
            .width($r('app.string.layout_100'))
          }
          .backgroundImage($r('app.media.my_top_bg'))
          .backgroundImageSize({
            width: $r('app.string.layout_100'),
            height: $r('app.integer.setting_head_column_height')
          })
          .width($r('app.string.layout_100'))
          .height($r('app.integer.setting_head_column_height'))
          .margin({ bottom: $r('app.integer.setting_head_column_margin_bottom') })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .padding({
            left: $r('app.integer.setting_profile_padding'),
            right: $r('app.integer.setting_profile_padding')
          })
        }

        ListItem() {
          // 创建基础功能分组
          Row() {
            List() {
              ForEach(this.basicMenuGroup,
                (item: SettingMenu) => {
                  ListItem() {
                    SettingItemView({ image: item.image, text: item.text })
                  }
                },
                (item: SettingMenu) => item.id.toString())
            }
            .height($r('app.integer.setting_basic_menu_list_height'))
            .divider({
              strokeWidth: $r('app.integer.setting_list_divider_width'),
              color: $r('app.color.setting_divider_color'),
              startMargin: $r('app.integer.setting_search_divider_start_margin'),
              endMargin: $r('app.integer.setting_search_divider_end_margin')
            })
          }
          .height($r('app.integer.setting_basic_menu_height'))
          .alignItems(VerticalAlign.Center)
          .margin({ bottom: $r('app.integer.setting_list_margin_bottom') })
          .borderRadius($r('app.integer.setting_menu_border_radius'))
          .backgroundColor($r('app.color.setting_text_background'))
        }

        ListItem() {
          // 创建其他功能分组
          List({ space: LIST_SPACE }) {
            ForEach(this.otherMenuGroup,
              (item: SettingMenu) => {
                ListItem() {
                  SettingItemView({ image: item.image, text: item.text })
                }
                .height($r('app.integer.setting_other_menu_list_height'))
                .borderRadius($r('app.integer.setting_menu_border_radius'))
                .backgroundColor($r('app.color.setting_text_background'))
              },
              (item: SettingMenu) => item.id.toString())
          }
        }
      }
      .layoutWeight(LAYOUT_WEIGHT)
      .margin({ top: $r('app.integer.discovery_list_margin_top') })
    }
    .backgroundColor('#F1F3F5')
    .width($r('app.string.layout_100'))
    .height($r('app.string.layout_100'))
    .padding({
      left: $r('app.integer.setting_padding_left'),
      right: $r('app.integer.setting_padding_left')
    })
    .alignItems(HorizontalAlign.Center)
  }
}

@Component
export struct SettingItemView {
  private image: string | Resource = ''; // 功能菜单图标
  private text: string | Resource = ''; // 功能菜单文本

  build() {
    Row() {
      Row() {
        Image(this.image)
          .width($r('app.integer.setting_menu_width'))
          .height($r('app.integer.setting_menu_width'))
          .objectFit(ImageFit.Contain)
        Text(this.text)
          .fontSize($r('app.integer.setting_menu_font_size'))
          .fontColor($r('app.color.setting_text_color'))
          .margin({ left: $r('app.integer.setting_menu_margin_left') })
          .layoutWeight(LAYOUT_WEIGHT)
          .lineHeight($r('app.integer.setting_menu_width'))
        Image($r('app.media.right_arrow'))
          .height($r('app.integer.setting_menu_arrow_height'))
          .width($r('app.integer.setting_menu_arrow_width'))
          .align(Alignment.End)
          .opacity($r('app.float.setting_menu_arrow_opacity'))
          .objectFit(ImageFit.Contain)
      }
      .width($r('app.string.layout_100'))
      .height($r('app.integer.settingPage_menu_height'))
      .padding({
        left: $r('app.integer.setting_menu_padding_left'),
        right: $r('app.integer.setting_menu_padding_left')
      })
      .alignItems(VerticalAlign.Center)
    }
    .width($r('app.string.layout_100'))
    .height($r('app.integer.settingPage_menu_height'))
    .alignSelf(ItemAlign.Center)
  }
}