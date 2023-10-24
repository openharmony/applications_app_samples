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
@Component
export struct InputComponent {
  @Link result: string
  @Link expression: string
  private isLand: boolean = false

  build() {
    Stack({ alignContent: this.isLand ? Alignment.BottomStart : Alignment.TopEnd }) {
      Column() {
        Row() {
          Text(this.expression)
            .margin({ top: '3%' })
            .height('100%')
            .width('100%')
            .id('expression')
            .opacity(0.9)
            .fontWeight(400)
            .textAlign(TextAlign.Start)
            .fontSize(this.isLand ? '50px' : '35px')
        }
        .height('48%')
        .width('90%')
        .align(this.isLand ? Alignment.End : Alignment.Start)
        Row() {
          Text(this.result)
            .margin({ top: '1%' })
            .height('100%')
            .width('100%')
            .id('result')
            .opacity(0.38)
            .textAlign(TextAlign.Start)
            .fontSize(this.isLand ? '50px' : '31px')
            .margin(this.isLand ? { bottom: 64 } : {})
        }
        .height('46%')
        .width('90%')
        .align(this.isLand ? Alignment.End : Alignment.Start)
      }
      .width('100%')
      .align(Alignment.Center)
    }
    .width(this.isLand ? '34%' : '100%')
    .height(this.isLand ? '100%' : '34%')
  }
}