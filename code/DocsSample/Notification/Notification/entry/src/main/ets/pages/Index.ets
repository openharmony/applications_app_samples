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

import PublishOperation from '../publish/PublishOperation';

export interface GroupMsg {
  title: Resource | string,
  list: ButtonMsg[]
}

export interface ButtonMsg {
  text: Resource,
  callback?: () => void
}

@Entry
@Component
struct Index {
  private publishOperation: PublishOperation = new PublishOperation(getContext(this));
  @State buttons: GroupMsg[] = [
    {
      title: '',
      list: [
        {
          text: $r('app.string.enable_notification'),
          callback: this.publishOperation.enableNotification
        }
      ]
    },
    {
      title: $r('app.string.kong_wu'),
      list: [
        {
          text: $r('app.string.set_badge_number'),
          callback: this.publishOperation.setBadgeNumberForBasic
        },
      ]
    },
    {
      title: $r('app.string.webfont_text'),
      list: [
        {
          text: $r('app.string.basic_notification'),
          callback: this.publishOperation.publishBasic
        },
        {
          text: $r('app.string.long_notification'),
          callback: this.publishOperation.publishLong
        },
        {
          text: $r('app.string.multi_line_notification'),
          callback: this.publishOperation.publishMultiLine
        },
      ]
    },
    {
      title: $r('app.string.kong_wu'),
      list: [
        {
          text: $r('app.string.picture_notification'),
          callback: this.publishOperation.publishPicture
        },
      ]
    },
    {
      title: $r('app.string.kong_wu'),
      list: [
        {
          text: $r('app.string.progress_bar_notification'),
          callback: this.publishOperation.publishProgressBar
        },
      ]
    },
    {
      title: $r('app.string.kong_wu'),
      list: [
        {
          text: $r('app.string.want_agent_start_ability'),
          callback: this.publishOperation.publishWantAgentStartAbility
        },
      ]
    },
    {
      title: $r('app.string.kong_wu'),
      list: [
        {
          text: $r('app.string.want_agent_common_event'),
          callback: this.publishOperation.publishWantAgentCommonEvent,
        }
      ]
    }
  ]

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.development_guide_example'))
            .width('100%')
            .height(64)
            .fontSize(24)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .padding({ left: 24 })
        }
      }
      .backgroundColor($r('app.color.backGrounding'))

      Column() {
        List({ space: 0, initialIndex: 0 }) {
          ForEach(this.buttons, (groupItem: GroupMsg, groupIndex: Number) => {
            if (groupItem.list.length > 1 && groupIndex == 2) {
              ListItem() {
                Text($r('app.string.webfont_text')) {
                }
                .borderRadius(0)
                .backgroundColor($r('app.color.backGrounding'))
                .padding({ left: 12, right: 12 ,top:8})
                .width('100%')
                .height(25)
              }
            }
            ListItemGroup() {
              ForEach(groupItem.list, (item: ButtonMsg, index: Number) => {
                ListItem() {
                  Flex({ direction: FlexDirection.Column }) {
                    Row() {
                      Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
                        Text(item.text) {
                        }.fontSize(18)
                        .textAlign(TextAlign.Start)
                        .fontWeight(700)

                        if (groupItem.list.length > 1) {
                          Image($r('app.media.ic_arrow'))
                            .width(24).height(24).padding({ left: 12 })
                        }
                      }
                    }
                    .width('100%')
                    .height('99%')

                    if (groupIndex == 2 && index < 2) {
                      Row() {
                      }
                      .width('100%')
                      .height('1%')
                      .backgroundColor($r('app.color.backGrounding'))
                    }
                  }
                }
                .height(48)
                .onClick(item.callback)
              })
            }
            .width('100%')
            .borderRadius(24)
            .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
            .padding({ left: 12, right: 12, top: 4, bottom: 4 })
            .margin({ top: 10, bottom: 10 })
          })
        }
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Off)
        .friction(0.6)
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
          console.info('first' + firstIndex)
          console.info('last' + lastIndex)
          console.info('center' + centerIndex)
        })
        .onScroll((scrollOffset: number, scrollState: ScrollState) => {
          console.info(`onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset)
        })
        .height('100%')
        .padding({ left: 12, right: 12 })
      }
      .width('100%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .width('100%')
    .height('100%')
  }
}