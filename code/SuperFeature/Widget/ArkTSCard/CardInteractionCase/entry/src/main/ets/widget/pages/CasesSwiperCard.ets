/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// 自定义卡片对象格式
interface CASES {
  name: string,
  url: string,
  describe: string,
  img: string
}

const ACTION_TYPE_ROUTER: string = 'router';
const ACTION_TYPE_MESSAGE: string = 'message';
const ABILITY_NAME: string = 'EntryAbility';

let casesCardInfo = new LocalStorage();

@Entry(casesCardInfo)
@Component
struct Widget_DynamicCard {
  @LocalStorageProp('detail') detail: CASES[] = []; // 卡片对象集合
  private swiperController: SwiperController = new SwiperController();

  aboutToAppear(): void {
    postCardAction(this, {
      action: ACTION_TYPE_MESSAGE,
      params: {
        method: $r('app.string.widget_message_content')
      }
    })
  }

  build() {
    Column() {
      Stack() {
        if (this.detail.length) {
          Swiper(this.swiperController) {
            ForEach(this.detail, (item: CASES) => {
              Stack() {
                Image($r(`app.media.${item.img}`))// 案例图片
                  .width('100%')
                  .height('100%')
                Stack() {
                  Column()
                    .width('100%')
                    .height(50)
                    .backgroundColor(Color.Black)
                    .opacity(0.6)
                  Text(item.name) // 案例名称
                    .width('100%')
                    .fontSize($r('app.integer.widget_name_fontsize'))
                    .fontColor(Color.White)
                    .fontWeight(FontWeight.Medium)
                    .textAlign(TextAlign.Center)
                }
              }
              .alignContent(Alignment.Bottom)
              .width($r('app.string.widget_display_full_width_percent'))
              .height($r('app.string.widget_display_full_height_percent'))
              .onClick(() => {
                // 点击卡片进入对应案例
                postCardAction(this, {
                  action: ACTION_TYPE_ROUTER,
                  abilityName: ABILITY_NAME,
                  params: { targetPage: item.url }
                });
              })
            })
          }
          .autoPlay(true)
        } else {
          Image($r('app.media.share_button'))
            .width('100%')
            .height('100%')
        }
      }
      .width($r('app.string.widget_display_full_width_percent'))
      .height($r('app.string.widget_display_full_height_percent'))
    }
  }
}