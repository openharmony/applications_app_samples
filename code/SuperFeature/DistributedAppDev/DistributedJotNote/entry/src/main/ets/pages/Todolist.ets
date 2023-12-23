/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';
import CommonConstants from '../common/constants/CommonConstants';
import Logger from '../utils/Logger';

@Entry
@Component
struct Todolist {
  scroller: Scroller = new Scroller()

  build() {
    Row() {
      Column() {

        // 顶部标题
        Flex({ direction: FlexDirection.Row }) {

          Row() {
            Image($r('app.media.ic_back'))
              .width(24)
              .height(24)
              .margin({ right: 16 })
              .id('back_arrow_todolist')
          }
          .width(30)
          .height(30)
          .onClick(() => {
            router.back()
          })

          Text(CommonConstants.TO_DO_LIST)
            .fontSize(20)
            .fontWeight(500)
            .margin({ top: 5, left: 16 })

        }
        .margin({ top: 36, left: 24, bottom: 24 })
        .width(360)

        // 待办list
        Stack({ alignContent: Alignment.TopStart }) {
          Scroll(this.scroller) {
            Column() {

              ForEach(CommonConstants.LIST_ARRAY, (item: Resource, index: number | undefined) => {

                if (index != undefined) {
                  Row() {
                    Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                      Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
                        .restoreId(10 + index)
                        .onChange((value: boolean) => {
                          Logger.info('Checkbox1 change is' + value)
                        })
                        .id('Checkbox')
                        .selectedColor(0x39a2db)
                        .unselectedColor('rgba(24,36,49,0.40);')
                        .width(30)
                        .height(30)
                        .margin({ top: '14.00px', right: '18.00vp', bottom: '14.00px', left: '6.00vp' })

                      Text(item).fontSize(16).fontWeight(500)

                    }
                  }
                  .width(336)
                  .padding({ left: 10 })
                  .height('64')
                  .backgroundColor(Color.White)
                  .borderRadius(24)
                  .margin({ bottom: 12 })
                }

              }, (item: string) => item)

            }

          }
          .id('Scroll_List')
          .width(360)
          .restoreId(8)
          .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
          .scrollBar(BarState.On) // 滚动条常驻显示
          .scrollBarColor(Color.Gray) // 滚动条颜色
          .scrollBarWidth(4) // 滚动条宽度
          .friction(0.6)
          .edgeEffect(EdgeEffect.None)
          .onScroll((xOffset: number, yOffset: number) => {
            Logger.info(xOffset + ' ' + yOffset)
          })
          .onScrollEdge((side: Edge) => {
            Logger.info('To the edge')
          })
          .onScrollStop(() => {
            Logger.info('Scroll Stop')
          })
          .enableScrollInteraction(true)
        }
        .width(360)

      }
      .width('100%')
      .height('90%')

    }
    .height('100%')
    .alignItems(VerticalAlign.Top)
    .backgroundColor('#f1f3f5')

  }
}
