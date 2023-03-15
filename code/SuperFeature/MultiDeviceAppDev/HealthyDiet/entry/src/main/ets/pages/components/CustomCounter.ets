/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

@Preview
@Component
struct DecIcon {
  private click: () => void = undefined

  build() {
    Column() {
      Row()
        .width('100%')
        .height(2)
        .backgroundColor(Color.White)
    }
    .justifyContent(FlexAlign.Center)
    .borderRadius(10)
    .backgroundColor('#35BD6A')
    .padding({ left: 2, right: 2 })
    .width(20)
    .height(20)
    .opacity(0.4)
    .onClick(() => {
      this.click()
    })
  }
}

@Preview
@Component
struct IncIcon {
  private readonly click: () => void = undefined

  build() {
    Column() {
      Column()
        .width(2)
        .height('100%')
        .backgroundColor(Color.White)
    }
    .justifyContent(FlexAlign.Center)
    .borderRadius(10)
    .backgroundColor('#35BD6A')
    .width(20)
    .height(20)
    .padding({ top: 2, bottom: 2 })
    .onClick(() => {
      this.click()
    })
  }
}

@Component
export struct CustomCounter {
  @Prop value: string
  private onDec: () => void = undefined
  private onInc: () => void = undefined

  build() {
    Row() {
      DecIcon({ click: this.onDec })
      Text(this.value).margin({ left: 11, right: 11 })
      IncIcon({ click: this.onInc })
    }
  }
}

@Preview
@Entry
@Component
struct PreviewCustomCounter {
  @State weight: number = 50

  build() {
    Row() {
      CustomCounter({
        value: this.weight + 'g',
        onDec: () => {
          this.weight -= 50
        },
        onInc: () => {
          this.weight += 50
        }
      })
    }
  }
}