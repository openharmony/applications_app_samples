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
import { obtainImgVertical, obtainImgV, obtainImgVs } from '../model/ImageList'

interface ImageList {
  image: Resource
  value: string
}

@Component
export struct ButtonComponent {
  private onInputValue: (result: string) => void = () => {
  }

  build() {
    Row() {
      Grid() {
        ForEach(obtainImgV(), (item: ImageList, index: number | undefined) => {
          GridItem() {
            Button({ type: ButtonType.Normal }) {
              Image(item.image)
                .width('45%')
                .height('35%')
                .objectFit(ImageFit.Cover)
            }
            .id(item.value)
            .width('100%')
            .height('100%')
            .borderRadius('16px')
            .backgroundColor(index !== undefined && index < 2 ? '#33007DFF' : '#FF006CDE')
            .onClick(() => {
              this.onInputValue(item.value)
            })
          }
          .rowStart(index !== undefined ? index : 0)
          .rowEnd(index !== undefined && index === 2 ? (index !== undefined ? index + 1 : 0) : (index !== undefined ? index : 0))
          .columnStart(4)
          .columnEnd(4)
        })
        ForEach(obtainImgVs(), (item: ImageList, index) => {
          GridItem() {
            Button({ type: ButtonType.Normal }) {
              Image(item.image)
                .width('45%')
                .height('35%')
                .objectFit(ImageFit.Cover)
            }
            .id(item.value)
            .width('100%')
            .height('100%')
            .borderRadius('16px')
            .backgroundColor('#33007DFF')
            .onClick(() => {
              this.onInputValue(item.value)
            })
          }
          .rowStart(index !== undefined ? index : 0)
          .rowEnd(index !== undefined ? index : 0)
          .columnStart(3)
          .columnEnd(3)
        })
        ForEach(obtainImgVertical(), (item: ImageList, index) => {
          GridItem() {
            Button({ type: ButtonType.Normal }) {
              Image(item.image)
                .width('55%')
                .height('55%')
                .objectFit(ImageFit.Cover)
            }
            .id(item.value)
            .width('100%')
            .height('100%')
            .borderRadius('16px')
            .backgroundColor('#F0F0F0')
            .onClick(() => {
              this.onInputValue(item.value)
            })
          }
          .columnStart(index === undefined ? 0 : index % 3)
          .columnEnd(index !== undefined && item.value === '0' ? (index % 3 + 1) : index !== undefined ? index % 3 : 0)
        })
      }
      .columnsGap(5)
      .rowsGap(5)
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr ')
    }
    .padding(10)
    .size({ width: '100%', height: '56%' })
  }
}