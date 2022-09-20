/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import router from '@ohos.router'
import { CardGenerator } from '../common/Card'
import { CardDataFormat } from '../common/Card'
import { getCardsData } from '../common/Card'
import { BreakpointSystem } from '../common/BreakPointSystem'
import { BreakPointType } from '../common/BreakPointSystem'

class CardsDataSource implements IDataSource {
  private cardsData: Array<CardDataFormat>

  constructor(data: Array<CardDataFormat>) {
    this.cardsData = data
  }

  public totalCount(): number {
    return this.cardsData.length
  }

  public getData(index: number): any {
    return this.cardsData[index]
  }

  public registerDataChangeListener(): void {

  }

  public unregisterDataChangeListener(): void {

  }
}

@Entry
@Component
struct More {
  private dataSource: CardsDataSource = new CardsDataSource(getCardsData(-1))
  private bp = new BreakpointSystem()
  private scroller = new Scroller()
  @StorageProp('currentBreakpoint') currBp: string = 'sm'

  build() {
    Column() {
      Row() {
        Button('Back').fontWeight(FontWeight.Bold).backgroundColor('#60ffa011').fontColor(Color.Black)
          .onClick(() => {
            router.back()
          })
        Blank()
        Text('Back to list top')
          .fontWeight(FontWeight.Bold)
          .fontSize(15)
          .decoration({ type: TextDecorationType.Underline })
          .fontColor(Color.Blue)
          .onClick(() => {
            this.scroller.scrollEdge(Edge.Top)
          })
      }.justifyContent(FlexAlign.Start).width('100%').padding(10)

      Row() {
        Text('Cards List').fontSize(20).fontWeight(FontWeight.Bold)
      }

      Grid(this.scroller) {
        LazyForEach(this.dataSource, (item: CardDataFormat) => {
          GridItem() {
            CardGenerator({ data: item })
          }
        }, item => item)
      }
      .columnsTemplate(new BreakPointType({
        xs: '1fr',
        sm: '1fr 1fr',
        md: '1fr 1fr 1fr',
        lg: '1fr 1fr 1fr 1fr',
        xl: '1fr 1fr 1fr 1fr 1fr',
        xxl: '1fr 1fr 1fr 1fr 1fr 1fr'
      }).getValue(this.currBp))
      .rowsGap(20)
      .columnsGap(20)
      .margin(10)
      .padding({ bottom: 100 })
    }
  }

  aboutToAppear() {
    this.bp.register()
  }

  aboutToDisappear() {
    this.bp.unregister()
  }
}