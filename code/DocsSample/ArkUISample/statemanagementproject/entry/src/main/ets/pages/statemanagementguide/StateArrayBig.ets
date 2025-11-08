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
// [Start StateArrayBig_start]
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_NUMBER: number = 0XFF00;
const TAG: string = '[Sample_StateManagement]';

@Observed
class UiStyle {
  public translateX: number = 0;
  public translateY: number = 0;
  public scaleX: number = 0.3;
  public scaleY: number = 0.3;
  public width: number = 336;
  public height: number = 178;
  public posX: number = 10;
  public posY: number = 50;
  public alpha: number = 0.5;
  public borderRadius: number = 24;
  public imageWidth: number = 78;
  public imageHeight: number = 78;
  public translateImageX: number = 0;
  public translateImageY: number = 0;
  public fontSize: number = 20;
}

@Component
struct SpecialImage {
  @ObjectLink uiStyle: UiStyle;
  private isRenderSpecialImage(): number { // 显示组件是否渲染的函数
    hilog.info(DOMAIN_NUMBER, TAG, 'SpecialImage is rendered');
    return 1;
  }

  build() {
    Image($r('app.media.icon')) // 此处'app.media.icon'仅作示例，请开发者自行替换，否则imageSource创建失败会导致后续无法正常执行。
      .width(this.uiStyle.imageWidth)
      .height(this.uiStyle.imageHeight)
      .margin({ top: 20 })
      .translate({
        x: this.uiStyle.translateImageX,
        y: this.uiStyle.translateImageY
      })
      .opacity(this.isRenderSpecialImage()) // 如果Image重新渲染，该函数将被调用
  }
}

@Component
struct PageChild {
  @ObjectLink uiStyle: UiStyle

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
      SpecialImage({
        uiStyle: this.uiStyle
      })
      Stack() {
        Column() {
          Image($r('app.media.icon')) // 此处'app.media.icon'仅作示例，请开发者自行替换，否则imageSource创建失败会导致后续无法正常执行。
            .opacity(this.uiStyle.alpha)
            .scale({
              x: this.uiStyle.scaleX,
              y: this.uiStyle.scaleY
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
            .fontSize(this.uiStyle.fontSize)
            .opacity(this.isRenderText())
            .margin({ top: 12 })
        }
        .opacity(this.isRenderStack())
        .position({
          x: this.uiStyle.posX,
          y: this.uiStyle.posY
        })
        .width('100%')
        .height('100%')
      }
      .margin({ top: 50 })
      .borderRadius(this.uiStyle.borderRadius)
      .opacity(this.isRenderStack())
      .backgroundColor('#FFFFFF')
      .width(this.uiStyle.width)
      .height(this.uiStyle.height)
      .translate({
        x: this.uiStyle.translateX,
        y: this.uiStyle.translateY
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
              this.uiStyle.translateY = (this.uiStyle.translateY + 180) % 250;
            })
          })
        Button('Scale')
          .borderRadius(20)
          .backgroundColor('#FF007DFF')
          .fontSize(20)
          .width(312)
          .onClick(() => {
            this.uiStyle.scaleX = (this.uiStyle.scaleX + 0.6) % 0.8;
          })
      }
      .position({
        y: 666
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
struct Page {
  @State uiStyle: UiStyle = new UiStyle();

  build() {
    Stack() {
      PageChild({
        uiStyle: this.uiStyle
      })
    }
    .backgroundColor('#F1F3F5')
  }
}
// [End StateArrayBig_start]
const stateArrayBigPage = Page;
export default stateArrayBigPage;