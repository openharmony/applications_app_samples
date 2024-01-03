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

import router from '@ohos.router';
import { LocationControl } from '../authorizedControl/LocationControl'
import { promptActionFn } from '../model/DataFactory';

@Observed
  //热搜榜数据构造类
class hotSearchItem {
  public id: string; //唯一ID
  public des: string | Resource; //热搜描述
  public image: Resource | undefined; //后缀图标

  constructor(id: string, des: string | Resource, image: Resource | undefined) {
    this.id = id;
    this.des = des;
    this.image = image;
  }
}

@Component
export struct TrendsDetailView {
  private scroller: Scroller = new Scroller()
  //微博热搜榜数据数组
  @State hotSearchGroup: hotSearchItem[] = [
    new hotSearchItem('hotfirstitem', $r('app.string.hot_first_item'), $r('app.media.label_hot')),
    new hotSearchItem('hotseconditem', $r('app.string.hot_second_item'), undefined),
    new hotSearchItem('hotthirditem', $r('app.string.hot_third_item'), undefined),
    new hotSearchItem('hotfourthitem', $r('app.string.hot_fourth_item'), $r('app.media.label_hot')),
    new hotSearchItem('hotfifthitem', $r('app.string.hot_fifth_item'), $r('app.media.label_hot')),
    new hotSearchItem('hotsixthitem', $r('app.string.hot_sixth_item'), undefined),
    new hotSearchItem('hotseventhitem', $r('app.string.hot_seventh_item'), $r('app.media.label_new')),
    new hotSearchItem('hoteighthitem', $r('app.string.hot_eighth_item'), $r('app.media.label_new')),
    new hotSearchItem('honinthitem', $r('app.string.hot_ninth_item'), $r('app.media.label_hot')),
    new hotSearchItem('hottenthitem', $r('app.string.hot_tenth_item'), $r('app.media.label_new')),];
  @StorageLink('location') location: string = '';

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          //同城榜、超话社区、尊享会员、榜单
          Grid() {
            GridItem() {
              gird({ image: $r('app.media.discover_vip'), message: $r('app.string.honorable_vip') })
            }
            .backgroundColor($r('app.color.font_color_FFFFFF'))

            GridItem() {
              gird({ image: $r('app.media.discover_bangdan'), message: $r('app.string.list') })
            }
            .backgroundColor($r('app.color.font_color_FFFFFF'))

            GridItem() {
              Column() {
                LocationControl();
                Text($r('app.string.same_city'))
                  .margin({ top: $r('app.integer.layout_size_6') })
                  .fontFamily('HarmonyHeiTi')
                  .fontSize($r('app.integer.layout_size_12'))
                  .fontColor($r('app.color.font_color_182431'))
                  .fontWeight(400)
                  .lineHeight($r('app.integer.layout_size_22'))
              }
            }
            .backgroundColor($r('app.color.font_color_FFFFFF'))

            GridItem() {
              gird({ image: $r('app.media.discover_shequ'), message: $r('app.string.super_talk') })
            }
            .backgroundColor($r('app.color.font_color_FFFFFF'))
          }
          .width('90%')
          .borderRadius($r('app.integer.layout_size_24'))
          .rowsTemplate('1fr')
          .columnsTemplate('1fr 1fr 1fr 1fr')
          .height($r('app.integer.layout_size_95'))

          //热搜榜标题
          Row() {
            RelativeContainer() {
              Text($r('app.string.hot_search'))
                .opacity($r('app.float.opacity'))
                .fontFamily('HarmonyHeiTi-Medium')
                .fontSize($r('app.integer.layout_size_14'))
                .fontColor($r('app.color.font_color_182431'))
                .fontWeight(500)
                .lineHeight($r('app.integer.layout_size_19'))
                .margin({ left: $r('app.integer.layout_size_22') })
                .alignRules({
                  left: { anchor: '__container__', align: HorizontalAlign.Start },
                  middle: { anchor: '__container__', align: HorizontalAlign.Center }
                })
                .id('text1')

              Text($r('app.string.all'))
                .alignRules({
                  right: { anchor: '__container__', align: HorizontalAlign.End },
                })
                .id('text2')
                .lineHeight($r('app.integer.layout_size_19'))
                .margin({ right: $r('app.integer.layout_size_12') })
                .fontFamily('HarmonyHeiTi-Medium')
                .fontSize($r('app.integer.layout_size_14'))
                .fontColor('#007DFF')
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/SameCityListPage',
                    params: {
                      currentIndex: 0
                    }
                  })
                })
            }
            .width('100%')
          }
          .width('90%')
          .margin({
            top: $r('app.integer.layout_size_18'),
          })
          .height($r('app.integer.layout_size_30'))


          //热搜榜
          Column() {
            List() {
              //微博热搜榜的条目
              ForEach(this.hotSearchGroup, (item: hotSearchItem) => {
                ListItem() {
                  hotSearchView({ text: item.des, image: item.image })
                }
                .margin({ left: $r('app.integer.layout_size_10'),right:$r('app.integer.layout_size_5')})
                .height($r('app.integer.layout_size_48'))
              }, (item: hotSearchItem) => item.id.toString())
            }
            .margin({
              top: $r('app.integer.layout_size_4'),
              bottom: $r('app.integer.layout_size_4'),
            })
            .width('100%')
            .lanes(2)
          }
          .width('90%')
          .borderRadius($r('app.integer.layout_size_24'))
          .backgroundColor($r('app.color.font_color_FFFFFF'))


          //微博VIP的广告
          Row() {
            Image($r('app.media.tp'))
              .objectFit(ImageFit.Fill)
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius($r('app.integer.layout_size_24'))
          .width('90%')
          .height($r('app.integer.layout_size_147'))
          .margin({ top: $r('app.integer.layout_size_15') })
          .backgroundColor($r('app.color.font_color_FFFFFF'))

          Row() {
            Text($r('app.string.anonymous_story'))
              .opacity($r('app.float.opacity'))
              .fontFamily('HarmonyHeiTi-Medium')
              .fontSize($r('app.integer.layout_size_14'))
              .fontColor($r('app.color.font_color_182431'))
              .fontWeight(500)
              .lineHeight($r('app.integer.layout_size_19'))
              .margin({ left: $r('app.integer.layout_size_22') })
          }
          .borderRadius($r('app.integer.layout_size_24'))
          .width('90%')
          .margin({ top: $r('app.integer.layout_size_20'), bottom: $r('app.integer.layout_size_10') })

          Row() {
            //匿名故事板块
            List() {
              ListItem() {
                Row() {
                  Image($r('app.media.photo10'))
                    .width($r('app.integer.layout_size_48'))
                    .height($r('app.integer.layout_size_48'))
                    .borderRadius($r('app.integer.layout_size_10'))
                  Text($r('app.string.story_des'))
                    .fontFamily('HarmonyHeiTi-Medium')
                    .fontSize($r('app.integer.layout_size_16'))
                    .fontColor($r('app.color.font_color_182431'))
                    .fontWeight(500)
                    .lineHeight($r('app.integer.layout_size_22'))
                    .margin({ left: $r('app.integer.layout_size_16') })
                }
              }
              .height($r('app.integer.layout_size_64'))

              ListItem() {
                Row() {
                  Image($r('app.media.photo110'))
                    .width($r('app.integer.layout_size_48'))
                    .height($r('app.integer.layout_size_48'))
                    .borderRadius($r('app.integer.layout_size_10'))
                  Text($r('app.string.story_dess'))
                    .fontFamily('HarmonyHeiTi-Medium')
                    .fontSize($r('app.integer.layout_size_16'))
                    .fontColor($r('app.color.font_color_182431'))
                    .fontWeight(500)
                    .lineHeight($r('app.integer.layout_size_22'))
                    .margin({ left: $r('app.integer.layout_size_16') })
                }
              }
              .height($r('app.integer.layout_size_64'))
            }
            .divider({
              strokeWidth: $r('app.float.stroke_width'),
              color: $r('app.color.font_color_00000'),
              startMargin: $r('app.integer.layout_size_64'),
              endMargin: $r('app.integer.layout_size_24')
            })
            .margin({
              top: $r('app.integer.layout_size_4'),
              bottom: $r('app.integer.layout_size_4'),
              left: $r('app.integer.layout_size_12'),
              right: $r('app.integer.layout_size_12')
            })
          }
          .margin({ bottom: $r('app.integer.layout_size_50') })
          .width('90%')
          .borderRadius($r('app.integer.layout_size_24'))
          .backgroundColor($r('app.color.font_color_FFFFFF'))

        }
        .width('100%')
        .backgroundColor($r('app.color.tabbar_background'))
      }
      .scrollable(ScrollDirection.Vertical)
    }
  }
}

@Component
  //同城榜、超话社区、尊享会员、榜单
export struct gird {
  @StorageLink('location') Location: string = '';
  image: Resource = $r('app.media.photo93');
  message: Resource = $r('app.string.same_city')

  build() {
    Column() {
      Button({ type: ButtonType.Circle }) {
        Image(this.image)
          .width($r('app.integer.layout_size_46'))
          .height($r('app.integer.layout_size_46'))
          .borderRadius($r('app.integer.layout_size_26'))
      }
      .margin({ bottom: $r('app.integer.layout_size_5') })
      .onClick(() => {
        promptActionFn($r('app.string.feature_development'));
      })

      Text(this.message)
        .fontFamily('HarmonyHeiTi')
        .fontSize($r('app.integer.layout_size_12'))
        .fontColor($r('app.color.font_color_182431'))
        .fontWeight(400)
        .lineHeight($r('app.integer.layout_size_22'))
    }
  }
}


@Component
  //热搜榜条目的布局
struct hotSearchView {
  private text: string | Resource = '';
  private image: Resource | string = '';

  build() {
    Row() {
      Text(this.text)
        .fontFamily('HarmonyHeiTi')
        .fontSize($r('app.integer.layout_size_14'))
        .fontColor($r('app.color.font_color_182431'))
        .fontWeight(400)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width($r('app.integer.layout_size_120'))
        .margin({ left: $r('app.integer.layout_size_12'), right: $r('app.integer.layout_size_12') })

      Image(this.image)
        .objectFit(ImageFit.Contain)
        .width($r('app.integer.layout_size_18'))
        .height($r('app.integer.layout_size_16'))
        .margin({ right: $r('app.integer.layout_size_12') })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}