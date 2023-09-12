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
import { obtainImgLevel, obtainImg, obtainImgL } from '../model/ImageList'

interface ImageList {
  image: Resource
  value: string
}

@Component
export struct ButtonComponentHorizontal {
  private onInputValue: (result: string) => void = () => {
  }

  build() {
    Column() {
      Grid() {
        ForEach(obtainImg(), (item: ImageList, index) => {
          GridItem() {
            Button({ type: ButtonType.Normal }) {
              Image(item.image)
                .height('100%')
                .aspectRatio(index !== undefined && index < 2 ? 1 : 0.5)
                .objectFit(ImageFit.Contain)
            }
            .id(item.value)
            .width('100%')
            .height('100%')
            .borderRadius(20)
            .backgroundColor(index !== undefined && index < 2 ? '#33007DFF' : '#007DFF')
            .onClick(() => {
              this.onInputValue(item.value)
            })
          }
          .rowStart(index !== undefined ? index : 0)
          .rowEnd(index !== undefined && index === 2 ? (index !== undefined ? index + 1 : 0) : (index !== undefined ? index : 0))
          .columnStart(4)
          .columnEnd(4)
        })
        ForEach(obtainImgLevel(), (item:ImageList, index) => {
          GridItem() {
            Button({ type: ButtonType.Normal }) {
              Image(item.image)
                .height('100%')
                .aspectRatio(item.value === '0' ? 2.5 : 1)
                .objectFit(ImageFit.Contain)
            }
            .id(item.value)
            .width('100%')
            .height('100%')
            .borderRadius(20)
            .backgroundColor((index !== undefined && index % 4 >= 3) || item.value === '+' ? '#33007DFF' : '#F0F0F0')
            .onClick(() => {
              this.onInputValue(item.value)
            })
          }
          .columnStart(index !== undefined ? index % 4 : 0)
          .columnEnd(item.value === '0' ? (index !== undefined ? index % 4 + 1 : 0) : index !== undefined ? index % 4 : 0)
        })
      }
      .width('80%')
      .columnsGap(10)
      .rowsGap(10)
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr')
    }
    .padding(10)
    .size({ width: '70%', height: '90%' })
  }
}