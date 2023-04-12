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

@Entry
@Component
export struct Header {
  @State title: string = ''

  build() {
    Row() {
      Image($r('app.media.left'))
        .key('leftCurrentPageBtn')
        .height(30)
        .width(30)
        .margin({ left: 10, top: 2 })
        .onClick(() => {
          router.back()
        })
      Text(this.title)
        .fontSize(18)

      Text('')
        .fontSize(30)
        .height(40).width(50)
        .padding({ right: 10 })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(60)
    .backgroundColor(0xEEEEEE)
  }
}

@Component
export struct InLine {
  @State name: string = ''

  build() {
    Row() {
      Text(this.name)
        .fontSize(16)
      Image($r('app.media.right'))
        .height(15)
        .width(15)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 20, right: 10, top: 15, bottom: 15 })
    .backgroundColor("#ffffff")
  }
}

@Component
export struct Swit {
  @State name: string = ""
  @State btn: boolean = true
  @State num: number = 1
  @State color: string = "#f0f0f0"

  build() {
    Row() {
      Text(this.name)
        .fontSize(16)
      Row() {
        Button()
          .width(28)
          .height(28)
          .backgroundColor("#ffffff")
          .borderRadius(14)
          .margin({ left: this.num })
      }
      .width(60)
      .height(30)
      .backgroundColor(this.color)
      .borderRadius(15)
      .onClick(() => {
        if (this.btn) {
          this.num = 31
          this.color = "#00cc33"
          this.btn = false
        } else {
          this.num = 1
          this.color = "#f0f0f0"
          this.btn = true
        }
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 20, right: 10, top: 15, bottom: 15 })
    .backgroundColor("#ffffff")
  }
}

@Component
export struct FunctionRow {
  //显示的文字
  @State title: string = ''

  build() {
    Row() {
      Text(this.title)
        .fontSize(16)
      Image($r('app.media.right'))
        .height(15)
        .width(15)
        .opacity(0.5)
        .margin({ left: 10, top: 2 })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .height(70)
    .backgroundColor(0xffffff)
    .padding({ left: 20, right: 20 })
  }
}

@Component
export struct MySearchComponent {
  @State changeValue: string = ''
  @State submitValue: string = ''

  build() {
    Column() {
      Search({ value: '', placeholder: '搜索' })
        .placeholderColor(0x999999)
        .placeholderFont({ size: 18, weight: 10, family: 'serif', style: FontStyle.Normal })
        .onSubmit((value: string) => {
          this.submitValue = value
        })
        .onChange((value: string) => {
          this.changeValue = value
        })
        .backgroundColor(0xffffff)
    }
  }
}

@Component
export struct AddData {
  @State text1: string = ""
  @State img: Resource = $r("app.media.empresa")
  @State text2: string = ""

  build() {
    Row() {
      Image(this.img)
        .height(40)
        .width(40)
        .margin({ top: 10, left: 5, bottom: 20 })
      Column() {
        Row() {
          Column() {
            Text(this.text1)
              .fontSize(16)
              .padding({ top: 10, left: 5, right: 5 })
            Text(this.text2)
              .fontSize(12)
              .padding(5)
              .opacity(0.5)
              .margin({ bottom: 5 })
          }
          .alignItems(HorizontalAlign.Start)

          Image($r('app.media.right'))
            .height(15)
            .width(15)
            .margin({ top: 2 })
            .opacity(0.5)
        }
        .width("90%")
        .justifyContent(FlexAlign.SpaceBetween)

        Divider().vertical(false).color("#ffffff").strokeWidth(1)
      }
    }
    .height(70)
    .backgroundColor("#ffffff")
  }
}

@Component
export struct Prompt {
  @State img: Resource = $r("app.media.empresa")
  @State text: string = ""

  build() {
    Row() {
      Image(this.img)
        .height(20)
        .width(20)
        .margin({ top: 5 })
      Text(this.text)
        .fontSize(16)
        .fontColor("#ffffff")
        .margin({ top: 5 })
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
  }
}

@Component
export struct User {
  @State img: Resource = $r("app.media.empresa")
  @State text: string = ""
  @State text2: string = ""

  build() {
    Row() {
      Row() {
        Text(this.text)
          .fontSize(16)
          .padding({ left: 20 })
      }

      Row() {
        if (this.text === '头像') {
          Image(this.img)
            .width(60)
            .height(60)
            .margin({ right: 20 })
        } else if (this.text === '我的二维码') {
          Image(this.img)
            .width(30)
            .height(30)
            .margin({ right: 20 })
        } else {
          Text(this.text2)
            .fontSize(16)
            .margin({ right: 20 })
        }
        Image($r('app.media.right'))
          .height(15)
          .width(15)
          .opacity(0.5)
          .margin({ right: 10, top: 2 })
      }
    }
    .width('98%')
    .justifyContent(FlexAlign.SpaceBetween)
    .height(80)
    .backgroundColor(0xFFFFFF)
  }
}