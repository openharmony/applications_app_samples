/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
// [Start StateArrayPrecise_start]
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_NUMBER: number = 0XFF00;
const TAG: string = '[EvtryAblity]';

@Observed
class NeedRenderImage { // 在同一组件中使用的属性可以划分为相同的类
  public translateImageX: number = 0;
  public translateImageY: number = 0;
  public imageWidth: number = 78;
  public imageHeight: number = 78;
}

@Observed
class NeedRenderScale { // 在一起使用的属性可以划分为相同的类
  public scaleX: number = 0.3;
  public scaleY: number = 0.3;
}

@Observed
class NeedRenderAlpha { // 在不同地方使用的属性可以划分为相同的类
  public alpha: number = 0.5;
}

@Observed
class NeedRenderSize { // 在一起使用的属性可以划分为相同的类
  public width: number = 336;
  public height: number = 178;
}

@Observed
class NeedRenderPos { // 在一起使用的属性可以划分为相同的类
  public posX: number = 10;
  public posY: number = 50;
}

@Observed
class NeedRenderBorderRadius { // 在不同地方使用的属性可以划分为相同的类
  public borderRadius: number = 24;
}

@Observed
class NeedRenderFontSize { // 在不同地方使用的属性可以划分为相同的类
  public fontSize: number = 20;
}

@Observed
class NeedRenderTranslate { // 在一起使用的属性可以划分为相同的类
  public translateX: number = 0;
  public translateY: number = 0;
}

@Observed
class UiStyle4 {
  // 使用NeedRenderxxx类
  public needRenderTranslate: NeedRenderTranslate = new NeedRenderTranslate();
  public needRenderFontSize: NeedRenderFontSize = new NeedRenderFontSize();
  public needRenderBorderRadius: NeedRenderBorderRadius = new NeedRenderBorderRadius();
  public needRenderPos: NeedRenderPos = new NeedRenderPos();
  public needRenderSize: NeedRenderSize = new NeedRenderSize();
  public needRenderAlpha: NeedRenderAlpha = new NeedRenderAlpha();
  public needRenderScale: NeedRenderScale = new NeedRenderScale();
  public needRenderImage: NeedRenderImage = new NeedRenderImage();
}

@Component
struct SpecialImage4 {
  @ObjectLink uiStyle: UiStyle4;
  @ObjectLink needRenderImage: NeedRenderImage // 从其父组件接收新类

  private isRenderSpecialImage(): number { // 显示组件是否渲染的函数
    hilog.info(DOMAIN_NUMBER, TAG, 'SpecialImage is rendered');
    return 1;
  }

  build() {
    Image($r('app.media.background')) // 此处'app.media.icon'仅作示例，请开发者自行替换，否则imageSource创建失败会导致后续无法正常执行。
      .width(this.needRenderImage.imageWidth) // 使用this.needRenderImage.xxx
      .height(this.needRenderImage.imageHeight)
      .margin({ top: 20 })
      .translate({
        x: this.needRenderImage.translateImageX,
        y: this.needRenderImage.translateImageY
      })
      .opacity(this.isRenderSpecialImage()) // 如果Image重新渲染，该函数将被调用
  }
}

@Component
struct PageChild4 {
  @ObjectLink uiStyle: UiStyle4;
  @ObjectLink needRenderTranslate: NeedRenderTranslate; // 从其父组件接收新定义的NeedRenderxxx类的实例
  @ObjectLink needRenderFontSize: NeedRenderFontSize;
  @ObjectLink needRenderBorderRadius: NeedRenderBorderRadius;
  @ObjectLink needRenderPos: NeedRenderPos;
  @ObjectLink needRenderSize: NeedRenderSize;
  @ObjectLink needRenderAlpha: NeedRenderAlpha;
  @ObjectLink needRenderScale: NeedRenderScale;

  // 下面的函数用于显示组件是否被渲染
  private isRenderColumn(): number {
    hilog.info(DOMAIN_NUMBER, TAG, 'Column is rendered');
    return 1;
  }

  private isRenderStack(): number {
    hilog.info(DOMAIN_NUMBER, TAG, 'Stack is rendered');
    return 1;
  }

  private isRenderImage(): number {
    hilog.info(DOMAIN_NUMBER, TAG, 'Image is rendered');
    return 1;
  }

  private isRenderText(): number {
    hilog.info(DOMAIN_NUMBER, TAG, 'Text is rendered');
    return 1;
  }

  build() {
    Column() {
      SpecialImage4({
        uiStyle: this.uiStyle,
        needRenderImage: this.uiStyle.needRenderImage // 传递给子组件
      })
      Stack() {
        Column() {
          Image($r('app.media.background')) // 此处'app.media.icon'仅作示例，请开发者自行替换，否则imageSource创建失败会导致后续无法正常执行。
            .opacity(this.needRenderAlpha.alpha)
            .scale({
              x: this.needRenderScale.scaleX, // 使用this.needRenderXxx.xxx
              y: this.needRenderScale.scaleY
            })
            .padding(this.isRenderImage())
            .width(300)
            .height(300)
        }
        .width('100%')
        .position({ y: -80 })

        Stack() {
          Text('Hello World')
            .fontColor('#182431')
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
      .backgroundColor('#FFFFFF')
      .width(this.needRenderSize.width)
      .height(this.needRenderSize.height)
      .translate({
        x: this.needRenderTranslate.translateX,
        y: this.needRenderTranslate.translateY
      })

      Column() {
        Button('Move')
          .width(312)
          .fontSize(20)
          .backgroundColor('#FF007DFF')
          .margin({ bottom: 10 })
          .onClick(() => {
            this.getUIContext().animateTo({
              duration: 500
            }, () => {
              this.needRenderTranslate.translateY = (this.needRenderTranslate.translateY + 180) % 250;
            })
          })
        Button('Scale')
          .borderRadius(20)
          .backgroundColor('#FF007DFF')
          .fontSize(20)
          .width(312)
          .margin({ bottom: 10 })
          .onClick(() => {
            this.needRenderScale.scaleX = (this.needRenderScale.scaleX + 0.6) % 0.8;
          })
        Button('Change Image')
          .borderRadius(20)
          .backgroundColor('#FF007DFF')
          .fontSize(20)
          .width(312)
          .onClick(() => { // 在父组件中，仍使用 this.uiStyle.endRenderXxx.xxx 更改属性
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

@Entry
@Component
struct Page4 {
  @State uiStyle: UiStyle4 = new UiStyle4();

  build() {
    Stack() {
      PageChild4({
        uiStyle: this.uiStyle,
        needRenderTranslate: this.uiStyle.needRenderTranslate, // 传递needRenderxxx类给子组件
        needRenderFontSize: this.uiStyle.needRenderFontSize,
        needRenderBorderRadius: this.uiStyle.needRenderBorderRadius,
        needRenderPos: this.uiStyle.needRenderPos,
        needRenderSize: this.uiStyle.needRenderSize,
        needRenderAlpha: this.uiStyle.needRenderAlpha,
        needRenderScale: this.uiStyle.needRenderScale
      })
    }
    .backgroundColor('#F1F3F5')
  }
}

// [End StateArrayPrecise_start]