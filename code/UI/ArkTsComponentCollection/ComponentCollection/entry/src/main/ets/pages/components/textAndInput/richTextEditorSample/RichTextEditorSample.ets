/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { Title } from './Title'

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(5)
}

@Entry
@Component
struct RichTextSample {
  @State setStyle: Boolean = false
  @State styleDialog: Visibility = Visibility.None

  controller: RichEditorController = new RichEditorController()

  updateSet(){
    this.setStyle = !this.setStyle
    if(this.setStyle){
      this.styleDialog = Visibility.Visible
    }else{
      this.styleDialog = Visibility.None
    }
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.rich_editor_title') })
      Scroll() {
        Column() {
          Title({title:$r('app.string.rich_editor_title')})
            .height("10%")
          RichEditor({ controller: this.controller })
            .onReady(() => {
              this.controller.addTextSpan("Hello World。\n" +
                "Familiar images automatically give people a sense of calm and nostalgia. " +
                "Early web designers liked the elements of the 1980s, but today, the aesthetics of the 1990s.\n",
                {
                  style:
                  {
                    fontColor: Color.Black,
                    fontSize: 16
                  }
                })
              this.controller.addImageSpan($r("app.media.icon"),
                {
                  imageStyle:
                  {
                    size: ["57px", "57px"]
                  }
                })
            })
            .height("50%")
            .width("100%")
          Stack() {
            Column() {
              Row({ space: 250 }) {
                Text($r('app.string.rich_editor_style'))
                  .fontSize(14)
                Text('X')
                  .width(25)
                  .height(25)
                  .fontSize(14)
                  .onClick(() => {
                    this.styleDialog = Visibility.None
                  })
              }.height(25)

              Row() {

              }.height(25).margin({bottom:60})
            }.visibility(this.styleDialog)
            .width("100%")
            .height("80%")
            .margin({bottom:"70%"})
            .zIndex(1)
            .border({
              radius: { topLeft: 15, topRight: 15 },
            })
            .backgroundColor($r('app.color.background_light_gray'))

            Row({ space: 150 }) {
              Image($r('app.media.menu'))
                .width(40)
                .height(40)
                .onClick(() => {
                  this.updateSet()
                })
              Image($r('app.media.addPhoto'))
                .width(35)
                .height(35)
                .onClick(() => {
                  this.controller.addImageSpan($r("app.media.icon"),
                    {
                      imageStyle:
                      {
                        size: ["57px", "57px"]
                      }
                    })
                })
            }
            .margin({bottom:-50})
            .justifyContent(FlexAlign.Center)
            .width("100%")
            .height("20%")
            .zIndex(3)
          }.height("40%")
        }
        .alignItems(HorizontalAlign.Start)
        .cardStyle()
        .constraintSize({ minHeight: '100%' })
      }
      .width('95%')
      .height('80%')
      .backgroundColor($r('app.color.divider_block_color'))
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.divider_block_color'))
    .padding({ left: 20, right: 20 })
  }
}
