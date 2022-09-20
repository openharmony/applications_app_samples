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

import { cardsMockData } from '../mock/Data'

export class CardDataFormat {
  constructor(title: string, detail: string) {
    this.title = title
    this.detail = detail
  }

  getValue(name: string) {
    if (name === 'title') {
      return this.title
    } else if (name === 'detail') {
      return this.detail
    }
  }

  private title: string
  private detail: string
}

export function getCardsData(count: number): Array<CardDataFormat> {
  let data: Array<CardDataFormat> = []
  if (count === -1) {
    cardsMockData.forEach((item) => {
      data.push(new CardDataFormat(item.title, item.detail))
    })
    return data
  }
  try {
    cardsMockData.forEach((item, idx) => {
      if (idx === count) {
        throw new Error('break')
      }
      data.push(new CardDataFormat(item.title, item.detail))
    })
  } catch (e) {
    return data
  }
}

@Component
export struct CardGenerator {
  private data: CardDataFormat

  build() {
    Column() {
      Text(this.data.getValue('title'))
        .fontWeight(FontWeight.Bold)
        .fontSize(16)
        .textAlign(TextAlign.Start)
        .width('100%')
      Scroll() {
        Text(this.data.getValue('detail')).textAlign(TextAlign.Start).width('100%')
      }.height('70%').scrollBar(BarState.Off).align(Alignment.TopStart)
    }.borderWidth(1).height(100)
  }
}