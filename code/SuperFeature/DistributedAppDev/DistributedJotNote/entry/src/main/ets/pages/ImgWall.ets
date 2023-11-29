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
import { WaterFlowDataSource } from '../common/bean/WaterFlowDataSource';
import Logger from '../utils/Logger';
import CommonConstants from '../common/constants/CommonConstants';

@Entry
@Component
struct ImgWall {
  @State minSize: number = 130
  @State maxSize: number = 164
  @State fontSize: number = 24
  scroller: Scroller = new Scroller()
  datasource: WaterFlowDataSource = new WaterFlowDataSource()
  private itemWidthArray: number[] = []
  private itemHeightArray: number[] = []

  // 计算flow item宽/高
  getSize() {
    let ret = Math.floor(Math.random() * this.maxSize)
    return (ret > this.minSize ? ret : this.minSize)
  }

  // 保存flow item宽/高
  getItemSizeArray() {
    for (let i = 0; i < 22; i++) {
      this.itemWidthArray.push(this.getSize())
      this.itemHeightArray.push(this.getSize())
    }
  }

  aboutToAppear() {
    this.getItemSizeArray()
  }

  build() {
    Row() {
      Column() {

        // 顶部导航
        Flex({ direction: FlexDirection.Row }) {

          Row() {
            Image($r('app.media.ic_back'))
              .width(24)
              .height(24)
              .margin({ right: 16 })
              .id('back_arrow_imgWall')

          }
          .width(30)
          .height(30)
          .onClick(() => {
            router.back()
          })

          Text(CommonConstants.IMG_WALL_TITLE)
            .fontSize(20)
            .fontWeight(500)
            .margin({ top: 5, left: 16 })

        }
        .margin({ top: 36, left: 24, bottom: 24 })
        .width(360)

        //瀑布流
        Row({ space: 2 }) {
          WaterFlow({ footer: () => {
          }, scroller: this.scroller }) {
            LazyForEach(this.datasource, (item: number) => {
              FlowItem() {
                Column() {
                  Image('common/img/img_' + item + '.png')
                    .objectFit(ImageFit.Fill)
                    .width('100%')
                    .borderRadius(24)
                    .layoutWeight(1)
                }
              }
              .width('100%')
              .height(this.itemHeightArray[item])
              .borderRadius(8)
            }, (item: string) => item)
          }
          .id('WaterFlow')
          .restoreId(7)
          .columnsTemplate('1fr 1fr')
          .itemConstraintSize({
            minWidth: 0,
            maxWidth: '100%',
            minHeight: 0,
            maxHeight: '100%'
          })
          .friction(0.6)
          .columnsGap(10)
          .rowsGap(12)
          .onReachStart(() => {
            Logger.info('onReachStart')
          })
          .onReachEnd(() => {
            Logger.info('onReachEnd')
          })
          .width('100%')
          .height('88%')
          .layoutDirection(FlexDirection.Column)
          .padding({ left: 10, right: 10 })
        }
        .id('WaterFlow_row')
        .width(360)
      }
      .width('100%')
    }
    .height('100%')
    .alignItems(VerticalAlign.Top)
    .backgroundColor('#f1f3f5')
  }
}
