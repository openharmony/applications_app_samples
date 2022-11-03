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
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Text)
function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({left: 12, top: 12})
}

@Extend(Column)
function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(Circle)
function colorPicker(color: Color | string, callback: ()=>void) {
  .fill(color)
  .height(20)
  .width(20)
  .onClick(() => {
    callback()
  })
}

@Styles
function pressedStyle() {
  .opacity(0.7)
  .borderWidth(1)
  .borderRadius(20)
}

@Entry
@Component
struct RichTextSample {
  @State data: string = '<h1 style="text-align: center;">h1标题</h1>' +
  '<h1 style="text-align: center;"><i>h1斜体</i></h1>' +
  '<h1 style="text-align: center;"><u>h1下划线</u></h1>' +
  '<h2 style="text-align: center;">h2标题</h2>' +
  '<h3 style="text-align: center;">h3标题</h3>' +
  '<p style="text-align: center;">p常规</p><hr/>' +
  '<div style="width: 500px;height: 500px;border: 1px solid;margin: 0auto;">' +
  '<p style="font-size: 35px;text-align: center;font-weight: bold; color: rgb(24,78,228)">字体大小35px,行高45px</p>' +
  '<p style="background-color: #e5e5e5;line-height: 45px;font-size: 35px;text-indent: 2em;">' +
  '<p>这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字这是一段文字</p>';

  build() {
    Column() {
      TitleBar({title: $r('app.string.rich_text')})
      Text("Display")
        .leftTitleStyle()
      Column() {
        Stack() {
          RichText(this.data)
          Image($r('app.media.banner'))
            .width('100%')
            .height(80)
            .objectFit(ImageFit.Contain)
            .position({y: 0})
        }
      }
      .cardStyle()
      .width('100%')
      .height('80%')
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({left: 20, right: 20})
  }
}
