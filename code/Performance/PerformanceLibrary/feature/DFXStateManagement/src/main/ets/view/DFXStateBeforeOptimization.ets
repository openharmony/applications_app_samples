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

const animationDuration: number = 500; // move动画时长
const opacityChangeValue: number = 0.1; // opacity每次变化的值
const opacityChangeRange: number = 1; // opacity变化的范围
const translateYChangeValue: number = 180; // translateY每次变化的值
const translateYChangeRange: number = 250; // translateY变化的范围
const scaleXChangeValue: number = 0.6; // scaleX每次变化的值
const scaleXChangeRange: number = 0.8; // scaleX每次变化的值
const imageWidthChangeValue: number = 30; // imageWidth每次变化的值
const imageWidthChangeRange: number = 160; // imageWidth每次变化的值
const imageHeightChangeValue: number = 30; // imageHeight每次变化的值
const imageHeightChangeRange: number = 160; // imageHeight每次变化的值

// 图片样式类
class ImageStyle {
  public translateImageX: number = 0;
  public translateImageY: number = 0;
  public imageWidth: number = 78;
  public imageHeight: number = 78;
}

// 嵌套ImageStyle类
class ImageStyleContainer {
  imageStyle: ImageStyle = new ImageStyle();
}

// 样式属性类
class UIStyle {
  imageStyle: ImageStyle = new ImageStyle();
  public translateX: number = 0;
  public translateY: number = 0;
  public scaleX: number = 0.3;
  public scaleY: number = 0.3;
}

@Component
struct SpecialImageA {
  @Link specialImageAUiStyle: UIStyle;
  private opacityNum: number = 1; // 默认透明度

  private isRenderSpecialImage(): number {
    // Image每次渲染时透明度增加0.1, 在0-1之间循环
    this.opacityNum = (this.opacityNum + opacityChangeValue) % opacityChangeRange;
    return this.opacityNum;
  }

  build() {
    Image($r('app.media.icon'))
      .width($r('app.integer.special_image_width'))
      .height($r('app.integer.special_image_width'))
      .margin({ top: $r('app.integer.image_margin_top') })
      .scale({
        x: this.specialImageAUiStyle.scaleX,
        y: this.specialImageAUiStyle.scaleY
      })
      .opacity(this.isRenderSpecialImage())
  }
}

@Component
struct SpecialImageB {
  @Link specialImageBStyleContainer: ImageStyleContainer;
  private opacityNum: number = 1; // 默认透明度

  private isRenderSpecialImage(): number {
    // Image每次渲染时透明度增加0.1, 在0-1之间循环
    this.opacityNum = (this.opacityNum + opacityChangeValue) % opacityChangeRange;
    return this.opacityNum;
  }

  build() {
    Image($r('app.media.icon'))
      .width(this.specialImageBStyleContainer.imageStyle.imageWidth)
      .height(this.specialImageBStyleContainer.imageStyle.imageHeight)
      .margin({ top: $r('app.integer.image_margin_top') })
      .translate({
        x: this.specialImageBStyleContainer.imageStyle.translateImageX,
        y: this.specialImageBStyleContainer.imageStyle.translateImageY
      })
      .opacity(this.isRenderSpecialImage())
  }
}

@Component
struct ComponentA {
  @Prop uiStyle: UIStyle; // uiStyle的属性被多个组件使用
  @State imageStyleContainer: ImageStyleContainer = new ImageStyleContainer(); // 传递给SpecialImageB中的Image使用

  build() {
    Column() {
      // 使用状态变量的组件
      SpecialImageA({
        specialImageAUiStyle: this.uiStyle
      })
      SpecialImageB({
        specialImageBStyleContainer: this.imageStyleContainer
      })
      Stack() {
        Column() {
          Image($r('app.media.icon'))
            .opacity($r('app.float.icon_opacity'))
            .scale({
              x: this.uiStyle.scaleX,
              y: this.uiStyle.scaleY
            })
            .width($r('app.integer.stack_icon_width'))
            .height($r('app.integer.stack_icon_height'))
        }
        .width('100%')
        .position({ y: $r('app.integer.stack_column_position_y') })

        Stack() {
          Text("Hello World")
            .fontColor($r('app.color.text_color'))
            .fontWeight(FontWeight.Medium)
            .fontSize($r('app.integer.button_font_size'))
            .margin({ top: $r('app.integer.text_margin_top') })
        }
        .position({
          x: $r('app.integer.text_position_x'),
          y: $r('app.integer.text_position_y')
        })
        .width('100%')
        .height('100%')
      }
      .margin({ top: $r('app.integer.stack_margin_top') })
      .borderRadius($r('app.integer.stack_border_radius'))
      .backgroundColor($r('app.color.stack_color'))
      .width($r('app.integer.stack_width'))
      .height($r('app.integer.stack_height'))
      .translate({
        x: this.uiStyle.translateX,
        y: this.uiStyle.translateY
      })

      // 通过按钮点击回调修改状态变量的值，引起相应的组件刷新
      Column() {
        Button('Move')
          .width($r('app.integer.button_width'))
          .fontSize($r('app.integer.button_font_size'))
          .backgroundColor($r('app.color.button_color'))
          .margin({ bottom: $r('app.integer.button_margin_bottom') })
          .onClick(() => {
            animateTo({
              duration: animationDuration
            }, () => {
              this.uiStyle.translateY = (this.uiStyle.translateY + translateYChangeValue) % translateYChangeRange;
            })
          })
        Button('Scale')
          .backgroundColor($r('app.color.button_color'))
          .fontSize($r('app.integer.button_font_size'))
          .width($r('app.integer.button_width'))
          .margin({ bottom: $r('app.integer.button_margin_bottom') })
          .onClick(() => {
            this.uiStyle.scaleX = (this.uiStyle.scaleX + scaleXChangeValue) % scaleXChangeRange;
          })
        Button('Change Image')
          .backgroundColor($r('app.color.button_color'))
          .fontSize($r('app.integer.button_font_size'))
          .width($r('app.integer.button_width'))
          .onClick(() => {
            this.imageStyleContainer.imageStyle.imageWidth =
              (this.imageStyleContainer.imageStyle.imageWidth + imageWidthChangeValue) % imageWidthChangeRange;
            this.imageStyleContainer.imageStyle.imageHeight =
              (this.imageStyleContainer.imageStyle.imageHeight + imageHeightChangeValue) % imageHeightChangeRange;
          })
      }
      .position({
        y: $r('app.integer.button_column_position_y')
      })
      .height('100%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}

@Component
export struct DFXStateBeforeOptimization {
  @State uiStyle: UIStyle = new UIStyle();

  build() {
    Stack() {
      ComponentA({
        uiStyle: this.uiStyle
      })
    }
    .backgroundColor($r('app.color.stack_background'))
  }
}