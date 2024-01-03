/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

class NeedRenderImage {
  public translateImageX: number = 0;
  public translateImageY: number = 0;
  public imageWidth: number = 78;
  public imageHeight: number = 78;
}

class NeedRenderScale {
  public scaleX: number = 0.3;
  public scaleY: number = 0.3;
}

class NeedRenderAlpha {
  public alpha: number = 0.5;
}

class NeedRenderSize {
  public width: number = 336;
  public height: number = 178;
}

class NeedRenderPos {
  public posX: number = 10;
  public posY: number = 50;
}

class NeedRenderBorderRadius {
  public borderRadius: number = 24;
}

class NeedRenderFontSize {
  public fontSize: number = 20;
}

class NeedRenderTranslate {
  public translateX: number = 0;
  public translateY: number = 0;
}

class UIStyle {
  needRenderTranslate: NeedRenderTranslate = new NeedRenderTranslate();
  needRenderFontSize: NeedRenderFontSize = new NeedRenderFontSize();
  needRenderBorderRadius: NeedRenderBorderRadius = new NeedRenderBorderRadius();
  needRenderPos: NeedRenderPos = new NeedRenderPos();
  needRenderSize: NeedRenderSize = new NeedRenderSize();
  needRenderAlpha: NeedRenderAlpha = new NeedRenderAlpha();
  needRenderScale: NeedRenderScale = new NeedRenderScale();
  needRenderImage: NeedRenderImage = new NeedRenderImage();

  constructor() {
  }
}

@Component
struct SpecialImage {
  @Link uiStyle: UIStyle;

  private isRenderSpecialImage(): number {
    console.log("SpecialImage is rendered");
    return 1;
  }

  build() {
    Image($r('app.media.icon'))
      .width(this.uiStyle.needRenderImage.imageWidth)
      .height(this.uiStyle.needRenderImage.imageHeight)
      .margin({ top: 20 })
      .translate({
        x: this.uiStyle.needRenderImage.translateImageX,
        y: this.uiStyle.needRenderImage.translateImageY
      })
      .opacity(this.isRenderSpecialImage())
  }
}

@Component
struct CompA {
  @Prop uiStyle: UIStyle;
  @Prop needRenderTranslate: NeedRenderTranslate;
  @Prop needRenderFontSize: NeedRenderFontSize;
  @Prop needRenderBorderRadius: NeedRenderBorderRadius;
  @Prop needRenderPos: NeedRenderPos;
  @Prop needRenderSize: NeedRenderSize;
  @Prop needRenderAlpha: NeedRenderAlpha;
  @Prop needRenderScale: NeedRenderScale;

  private isRenderColumn(): number {
    console.log("Column is rendered");
    return 1;
  }

  private isRenderStack(): number {
    console.log("Stack is rendered");
    return 1;
  }

  private isRenderImage(): number {
    console.log("Image is rendered");
    return 1;
  }

  private isRenderText(): number {
    console.log("Text is rendered");
    return 1;
  }

  build() {
    Column() {
      SpecialImage({
        uiStyle: this.uiStyle
      })
      Stack() {
        Column() {
          Image($r('app.media.icon'))
            .opacity(this.needRenderAlpha.alpha)
            .scale({
              x: this.needRenderScale.scaleX,
              y: this.needRenderScale.scaleY
            })
            .padding(this.isRenderImage())
            .width(300)
            .height(300)
        }
        .width('100%')
        .position({ y: -80 })

        Stack() {
          Text("Hello World")
            .fontColor($r('app.color.text_color'))
            .fontWeight(FontWeight.Medium)
            .fontSize(this.needRenderFontSize.fontSize)
            .opacity(this.isRenderText())
            .margin({ top: 12 })
        }
        .opacity(this.isRenderStack())
        .position({
          x: this.needRenderPos.posX,
          y: this.needRenderPos.posY
        })
        .width('100%')
        .height('100%')
      }
      .margin({ top: 50 })
      .borderRadius(this.needRenderBorderRadius.borderRadius)
      .opacity(this.isRenderStack())
      .backgroundColor($r('app.color.stack_color'))
      .width(this.needRenderSize.width)
      .height(this.needRenderSize.height)
      .translate({
        x: this.needRenderTranslate.translateX,
        y: this.needRenderTranslate.translateY
      })

      Column() {
        Button("Move")
          .width(312)
          .fontSize(20)
          .backgroundColor($r('app.color.button_color'))
          .margin({ bottom: 10 })
          .onClick(() => {
            animateTo({
              duration: 500
            }, () => {
              this.needRenderTranslate.translateY = (this.needRenderTranslate.translateY + 180) % 250;
            })
          })
        Button("Scale")
          .borderRadius(20)
          .backgroundColor($r('app.color.button_color'))
          .fontSize(20)
          .width(312)
          .margin({ bottom: 10 })
          .onClick(() => {
            this.needRenderScale.scaleX = (this.needRenderScale.scaleX + 0.6) % 0.8;
          })
        Button("Change Image")
          .borderRadius(20)
          .backgroundColor($r('app.color.button_color'))
          .fontSize(20)
          .width(312)
          .onClick(() => {
            this.uiStyle.needRenderImage.imageWidth = (this.uiStyle.needRenderImage.imageWidth + 30) % 160;
            this.uiStyle.needRenderImage.imageHeight = (this.uiStyle.needRenderImage.imageHeight + 30) % 160;
          })
      }
      .position({
        y: 616
      })
      .height('100%')
      .width('100%')
    }
    .opacity(this.isRenderColumn())
    .width('100%')
    .height('100%')
  }
}

@Component
export struct DFXStateBeforeOptimization {
  @State uiStyle: UIStyle = new UIStyle();

  build() {
    Stack() {
      CompA({
        uiStyle: this.uiStyle,
        needRenderTranslate: this.uiStyle.needRenderTranslate,
        needRenderFontSize: this.uiStyle.needRenderFontSize,
        needRenderBorderRadius: this.uiStyle.needRenderBorderRadius,
        needRenderPos: this.uiStyle.needRenderPos,
        needRenderSize: this.uiStyle.needRenderSize,
        needRenderAlpha: this.uiStyle.needRenderAlpha,
        needRenderScale: this.uiStyle.needRenderScale
      })
    }
    .backgroundColor($r('app.color.stack_background'))
  }
}


