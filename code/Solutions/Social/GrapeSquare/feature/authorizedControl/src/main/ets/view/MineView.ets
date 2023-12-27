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

import { TitleBar } from './TitleBar'

@Observed
  //设置条目信息构造
class SettingMenu {
  public id: string; // 唯一id
  public image: Resource; // 菜单图标
  public text: Resource; // 菜单文本
  public des: Resource; //后缀文本

  constructor(id: string, image: Resource, text: Resource, des: Resource) {
    this.id = id;
    this.image = image;
    this.text = text;
    this.des = des;
  }
}

@Component
export struct MineView {
  //会员中心数组
  @State vipCenter: SettingMenu[] = [
    new SettingMenu('vipcenter', $r('app.media.mine_vip'), $r('app.string.vipcenter'), $r('app.string.after_vipcenter'))
  ];
  //设置条目信息数组
  @State menuGroup: SettingMenu[] = [
    new SettingMenu('setting', $r('app.media.mine_settings'), $r('app.string.setting'), $r('app.string.void')),
    new SettingMenu('vipownsetting', $r('app.media.mine_vipsettings'), $r('app.string.vipownsetting'), $r('app.string.void')),
    new SettingMenu('mycollection', $r('app.media.ic_collect'), $r('app.string.mycollection'), $r('app.string.void')),
    new SettingMenu('mylike', $r('app.media.mine_like'), $r('app.string.mylike'), $r('app.string.void')),
    new SettingMenu('browsinghistory', $r('app.media.mine_time'), $r('app.string.browsinghistory'), $r('app.string.void')),
    new SettingMenu('followinghypertalk', $r('app.media.mine_favor'), $r('app.string.followinghypertalk'), $r('app.string.void')),
    new SettingMenu('shieldsetting', $r('app.media.mine_forbid'), $r('app.string.shieldsetting'), $r('app.string.void')),
    new SettingMenu('backgroundsetting', $r('app.media.mine_bg'), $r('app.string.settingbackground'), $r('app.string.after_settingBackground')),
  ];

  build() {
    Column() {
      //“我的”标题
      TitleBar({ title: $r('app.string.my'), image: $r('app.media.scan') })
      List() {

        //用户头像、昵称信息
        ListItem() {
          Column() {
            Stack() {
              Row() {
                Image($r('app.media.photo15'))
                  .width($r('app.integer.layout_size_48'))
                  .height($r('app.integer.layout_size_48'))
                  .borderRadius($r('app.integer.layout_size_26'))
                Column() {
                  Text($r('app.string.user_name'))
                    .fontSize($r('app.integer.layout_size_16'))
                    .fontColor($r('app.color.font_color_182431'))
                    .lineHeight($r('app.integer.layout_size_22'))
                    .fontWeight(500)
                  Row() {
                    Text($r('app.string.following'))
                      .fontSize($r('app.integer.layout_size_14'))
                      .fontColor($r('app.color.font_color_182431'))
                      .lineHeight($r('app.integer.layout_size_19'))
                      .fontWeight(400)
                      .margin({ top: $r('app.integer.layout_size_4') })
                      .fontFamily('HarmonyHeiTi')
                    Text($r('app.string.fans'))
                      .fontSize($r('app.integer.layout_size_14'))
                      .fontColor($r('app.color.font_color_182431'))
                      .lineHeight($r('app.integer.layout_size_19'))
                      .fontWeight(400)
                      .margin({ left: $r('app.integer.layout_size_10'), top: $r('app.integer.layout_size_4') })
                      .fontFamily('HarmonyHeiTi')
                  }
                  .opacity($r('app.float.opacity'))
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: $r('app.integer.layout_size_16') })
              }
              .width('100%')

              Row() {
                Image($r('app.media.right_arrow'))
                  .height($r('app.integer.layout_size_20'))
                  .width($r('app.integer.layout_size_10'))
                  .opacity($r('app.float.opacity_3'))
                  .objectFit(ImageFit.Contain)
              }
              .width('100%')
              .justifyContent(FlexAlign.End)
            }
          }
          .borderRadius($r('app.integer.layout_size_24'))
          .backgroundColor($r('app.color.font_color_FFFFFF'))
          .width('90%')
          .height($r('app.integer.layout_size_87'))
          .margin({ bottom: $r('app.integer.layout_size_12') })
          .justifyContent(FlexAlign.Center)
          .padding({
            left: $r('app.integer.layout_size_22'),
            right: $r('app.integer.layout_size_12')
          })
        }
        .width('100%')

        //会员中心设置
        ListItem() {
          Row() {
            List() {
              ForEach(this.vipCenter,
                (item: SettingMenu) => {
                  ListItem() {
                    SettingItemView({ image: item.image, text: item.text, des: item.des })
                  }
                },
                (item: SettingMenu) => item.id.toString())
            }
          }
          .height($r('app.integer.tabbar_height'))
          .borderRadius($r('app.integer.layout_size_24'))
          .width('90%')
          .margin({ bottom: $r('app.integer.layout_size_12') })
          .backgroundColor($r('app.color.font_color_FFFFFF'))
        }
        .width('100%')

        //设置具体条目
        ListItem() {
          Row() {
            List() {
              ForEach(this.menuGroup,
                (item: SettingMenu) => {
                  ListItem() {
                    SettingItemView({ image: item.image, text: item.text, des: item.des })
                  }
                  .width('100%')
                },
                (item: SettingMenu) => item.id.toString())
            }
            .divider({
              strokeWidth: $r('app.float.stroke_width'),
              color: $r('app.color.font_color_00000'),
              startMargin: $r('app.integer.layout_size_46'),
              endMargin: $r('app.integer.layout_size_24')
            })
          }
          .padding({ bottom: $r('app.integer.layout_size_5'), top: $r('app.integer.layout_size_5') })
          .width('90%')
          .borderRadius($r('app.integer.layout_size_24'))
          .alignItems(VerticalAlign.Center)
          .margin({ bottom: $r('app.integer.layout_size_12') })
          .backgroundColor($r('app.color.font_color_FFFFFF'))
        }
        .width('100%')


        //深色模式+toggle
        ListItem() {
          Row() {
            Image($r('app.media.mine_dark'))
              .width($r('app.integer.layout_size_22'))
              .height($r('app.integer.layout_size_32'))
              .objectFit(ImageFit.Contain)

            Text($r('app.string.deppcolormode'))
              .fontSize($r('app.integer.layout_size_16'))
              .fontWeight(400)
              .fontFamily('HarmonyHeiTi')
              .fontColor($r('app.color.font_color_182431'))
              .margin({ left: $r('app.integer.layout_size_12') })
              .layoutWeight(1)
              .lineHeight($r('app.integer.layout_size_22'))
            Column() {
              Toggle({ type: ToggleType.Switch, isOn: false })
            }
            .justifyContent(FlexAlign.End)
          }
          .width('90%')
          .borderRadius($r('app.integer.layout_size_24'))
          .backgroundColor($r('app.color.font_color_FFFFFF'))
          .height($r('app.integer.tabbar_height'))
          .padding({
            left: $r('app.integer.layout_size_22'),
            right: $r('app.integer.layout_size_12')
          })
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .borderRadius($r('app.integer.layout_size_24'))
      }
    }
    .height('100%')
    .backgroundColor($r('app.color.tabbar_background'))
  }
}

@Component
  //设置条目布局
export struct SettingItemView {
  private image: string | Resource = ''; // 图标
  private text: string | Resource = ''; // 设置名称
  private des: string | Resource = ''; //后面的文本

  build() {
    Row() {
      Row() {
        Image(this.image)
          .width($r('app.integer.layout_size_22'))
          .height($r('app.integer.layout_size_32'))
          .objectFit(ImageFit.Contain)
        Text(this.text)
          .fontSize($r('app.integer.layout_size_16'))
          .fontWeight(400)
          .fontFamily('HarmonyHeiTi')
          .fontColor($r('app.color.font_color_182431'))
          .margin({ left: $r('app.integer.layout_size_12') })
          .layoutWeight(1)
          .lineHeight($r('app.integer.layout_size_22'))

        Text(this.des)
          .opacity($r('app.float.opacity'))
          .fontSize($r('app.integer.layout_size_14'))
          .fontWeight(400)
          .fontFamily('HarmonyHeiTi')
          .fontColor($r('app.color.font_color_182431'))
          .lineHeight($r('app.integer.layout_size_19'))
      }
      .width('100%')
      .height($r('app.integer.tabbar_height'))
      .padding({
        left: $r('app.integer.layout_size_22'),
        right: $r('app.integer.layout_size_12')
      })
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height($r('app.integer.layout_size_48'))
    .alignSelf(ItemAlign.Center)
  }
}