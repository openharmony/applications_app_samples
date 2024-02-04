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

import { TitleBar } from '../../../../common/TitleBar';
import { Title } from './Title';

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(5)
}

@Entry
@Component
struct RichEditorSample {
  @State setStyle: Boolean = false;
  @State setStyle1: Boolean = false;
  @State setStyle2: Boolean = false;
  @State setStyle3: Boolean = false;
  @State setStyle4: Boolean = false;
  @State setStyle5: Boolean = false;
  @State setStyle6: Boolean = false;
  @State styleDialog: Visibility = Visibility.None;
  @State fontWeightSet: FontWeight = FontWeight.Normal;
  @State fontStyleSet: FontStyle = FontStyle.Normal;
  @State fontDecorationSet: TextDecorationType = TextDecorationType.None;
  @State fontAlignLeftSet: TextAlign = TextAlign.Start;
  @State fontAlignMiddleSet: TextAlign = TextAlign.Center;
  @State fontAlignRightSet: TextAlign = TextAlign.End;
  @State tipsValue: number = 32;
  private start: number = -1;
  private end: number = -1;
  private fontColors: string[] = ["#FA2A2D","#FFBF00","#41BA41","#00AAEE","#3F56EA","#8A2BE2","#000000"];

  controller: RichEditorController = new RichEditorController();

  updateVisible(){
    this.setStyle = !this.setStyle;
    if(this.setStyle){
      this.styleDialog = Visibility.Visible;
    }else{
      this.styleDialog = Visibility.None;
    }
  }

  updateFontWeight(){
    this.setStyle1 = !this.setStyle1;
    if(this.setStyle1){
      this.fontWeightSet = FontWeight.Bolder;
    }else{
      this.fontWeightSet = FontWeight.Normal;
    }
  }

  updateFontStyle(){
    this.setStyle2 = !this.setStyle2;
    if(this.setStyle2){
      this.fontStyleSet = FontStyle.Italic;
    }else{
      this.fontStyleSet = FontStyle.Normal;
    }
  }

  updateFontDecoration(){
    this.setStyle3 = !this.setStyle3;
    if(this.setStyle3){
      this.fontDecorationSet = TextDecorationType.Underline;
    }else{
      this.fontDecorationSet = TextDecorationType.None;
    }
  }

  updateFontAlignLeft(){
    this.setStyle4 = !this.setStyle4;
    if(this.setStyle4){
      this.fontAlignLeftSet = TextAlign.Start;
    }else{
      this.fontAlignLeftSet = TextAlign.JUSTIFY;
    }
  }

  updateFontAlignMiddle(){
    this.setStyle5 = !this.setStyle5;
    if(this.setStyle5){
      this.fontAlignMiddleSet = TextAlign.Center;
    }else{
      this.fontAlignMiddleSet = TextAlign.JUSTIFY;
    }
  }

  updateFontAlignRight(){
    this.setStyle6 = !this.setStyle6;
    if(this.setStyle6){
      this.fontAlignRightSet = TextAlign.End;
    }else{
      this.fontAlignRightSet = TextAlign.JUSTIFY;
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
              this.controller.addImageSpan($r("app.media.addPhoto"),
                {
                  imageStyle:
                  {
                    size: ["100px", "54px"]
                  }
                })
            })
            .onSelect((value: RichEditorSelection) => {
              this.start = value.selection[0];
              this.end = value.selection[1];
            })
            .height("50%")
            .width("100%")
          Stack() {
            Column() {
              Row({ space: 250 }) {
                Text($r('app.string.rich_editor_style'))
                  .fontSize(14)
                  .padding({top:5})
                Image($r('app.media.ic_close'))
                  .width(25)
                  .height(25)
                  .onClick(() => {
                    this.styleDialog = Visibility.None
                  })
              }.height(25)
              .margin({bottom:10})

              Row({ space: 38 }) {
                Image($r('app.media.ic_B_normal'))
                  .width(15)
                  .height(15)
                  .onClick(() => {
                    this.updateFontWeight()
                    if(this.end!=this.start){
                      this.controller.updateSpanStyle({
                        start: this.start,
                        end: this.end,
                        textStyle:
                        {
                          fontWeight: this.fontWeightSet
                        }
                      })
                    }
                  })
                Image($r('app.media.ic_I_normal'))
                  .width(15)
                  .height(15)
                  .onClick(() => {
                    this.updateFontStyle()
                    if(this.end!=this.start) {
                      this.controller.updateSpanStyle({
                        start: this.start,
                        end: this.end,
                        textStyle:
                        {
                          fontStyle: this.fontStyleSet
                        }
                      })
                    }
                  })
                Image($r('app.media.ic_U_normal'))
                  .width(15)
                  .height(15)
                  .onClick(() => {
                    this.updateFontDecoration()
                    if(this.end!=this.start) {
                      this.controller.updateSpanStyle({
                        start: this.start,
                        end: this.end,
                        textStyle:
                        {
                          decoration: {
                            type: this.fontDecorationSet
                          }
                        }
                      })
                    }
                  })
                Image($r('app.media.ic_left_normal'))
                  .width(15)
                  .height(15)
                  .onClick(() => {
                    this.updateFontAlignLeft()
                    if(this.end!=this.start) {
                      this.controller.updateParagraphStyle({
                        start: this.start,
                        end: this.end,
                        style:
                        {
                          textAlign:this.fontAlignLeftSet
                        }
                      })
                    }
                  })
                Image($r('app.media.ic_middle_normal'))
                  .width(15)
                  .height(15)
                  .onClick(() => {
                    this.updateFontAlignMiddle()
                    if(this.end!=this.start) {
                      this.controller.updateParagraphStyle({
                        start: this.start,
                        end: this.end,
                        style:
                        {
                          textAlign:this.fontAlignMiddleSet
                        }
                      })
                    }
                  })
                Image($r('app.media.ic_right_normal'))
                  .width(15)
                  .height(15)
                  .onClick(() => {
                    this.updateFontAlignRight()
                    if(this.end!=this.start) {
                      this.controller.updateParagraphStyle({
                        start: this.start,
                        end: this.end,
                        style:
                        {
                          textAlign:this.fontAlignRightSet
                        }
                      })
                    }
                  })
              }
              .height(25)
              .margin({bottom:10})

              Row({ space: 30 }) {
                ForEach(this.fontColors,(item: string) => {
                  Circle({ width: 15, height: 15 }).fill(item)
                    .onClick(() => {
                      if(this.end!=this.start){
                        this.controller.updateSpanStyle({
                          start: this.start,
                          end: this.end,
                          textStyle:
                          {
                            fontColor: item
                          }
                        })
                      }
                    })
                })
              }.height(25)
              .margin({bottom:10})

              Row({ space: 30 }) {
                Text("Aa")
                  .width(24)
                  .height(24)
                  .fontSize(11)
                  .fontWeight(400)
                  .onClick(() => {
                    this.tipsValue = this.tipsValue - 2
                    if(this.end!=this.start){
                      this.controller.updateSpanStyle({
                        start: this.start,
                        end: this.end,
                        textStyle:
                        {
                          fontSize: this.tipsValue/2
                        }
                      })
                    }
                  })
                Slider({ style: SliderStyle.InSet, value: this.tipsValue })
                  .width(210)
                  .showTips(true, 'Size:' + this.tipsValue.toFixed())
                  .onChange(value => {
                    this.tipsValue = value
                    if(this.end!=this.start){
                      this.controller.updateSpanStyle({
                        start: this.start,
                        end: this.end,
                        textStyle:
                        {
                          fontSize: this.tipsValue/2
                        }
                      })
                    }
                  })
                Text("Aa")
                  .width(24)
                  .height(24)
                  .fontSize(17)
                  .fontWeight(400)
                  .onClick(() => {
                    this.tipsValue = this.tipsValue + 2
                    if(this.end!=this.start){
                      this.controller.updateSpanStyle({
                        start: this.start,
                        end: this.end,
                        textStyle:
                        {
                          fontSize: this.tipsValue/2
                        }
                      })
                    }
                  })
              }.height(25).margin({bottom:60})

            }.visibility(this.styleDialog)
            .width("100%")
            .height("85%")
            .margin({bottom:"85%"})
            .zIndex(1)
            .border({
              radius: { topLeft: 15, topRight: 15 },
            })
            .backgroundColor($r('app.color.background_light_gray'))

            Row({ space: 150 }) {
              Image($r('app.media.ic_textstyle_normal'))
                .width(40)
                .height(40)
                .onClick(() => {
                  this.updateVisible()
                })
              Image($r('app.media.ic_picture_normal'))
                .width(35)
                .height(35)
                .onClick(() => {
                  this.controller.addImageSpan($r("app.media.addPhoto"),
                    {
                      imageStyle:
                      {
                        size: ["100px", "54px"]
                      }
                    })
                })
            }
            .padding({top:"50%"})
            .justifyContent(FlexAlign.Center)
            .width("100%")
            .height("15%")
            .zIndex(3)
          }.height("30%")
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
