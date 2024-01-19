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

// 缩放属性类
@Observed
class ScaleStyle {
  public scaleX: number = 0.3;
  public scaleY: number = 0.3;
}

// 位移属性类
@Observed
class TranslateStyle {
  public translateX: number = 0;
  public translateY: number = 0;
}

// 样式属性类，嵌套ImageStyle, ScaleStyle, TranslateStyle
@Observed
class UIStyle {
  translateStyle: TranslateStyle = new TranslateStyle();
  scaleStyle: ScaleStyle = new ScaleStyle();
  imageStyle: ImageStyle = new ImageStyle();
}

@Component
struct SpecialImageA {
  @Link specialImageAScaleStyle: ScaleStyle;
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
        x: this.specialImageAScaleStyle.scaleX,
        y: this.specialImageAScaleStyle.scaleY
      })
      .opacity(this.isRenderSpecialImage())
  }
}

@Component
struct SpecialImageB {
  @Link specialImageBStyle: ImageStyle;
  private opacityNum: number = 1; // 默认透明度

  private isRenderSpecialImage(): number {
    // Image每次渲染时透明度增加0.1, 在0-1之间循环
    this.opacityNum = (this.opacityNum + opacityChangeValue) % opacityChangeRange;
    return this.opacityNum;
  }

  build() {
    Image($r('app.media.icon'))
      .width(this.specialImageBStyle.imageWidth)
      .height(this.specialImageBStyle.imageHeight)
      .margin({ top: $r('app.integer.image_margin_top') })
      .translate({
        x: this.specialImageBStyle.translateImageX,
        y: this.specialImageBStyle.translateImageY
      })
      .opacity(this.isRenderSpecialImage())
  }
}

@Component
struct ComponentA {
  @Prop uiStyle: UIStyle; // 样式属性类，实例属性被多个组件使用
  @State scaleStyle: ScaleStyle = this.uiStyle.scaleStyle;
  @State translateStyle: TranslateStyle = this.uiStyle.translateStyle;
  @State imageStyle: ImageStyle = this.uiStyle.imageStyle;

  build() {
    Column() {
      // 受状态变量影响的组件
      SpecialImageA({
        specialImageAScaleStyle: this.scaleStyle
      })
      SpecialImageB({
        specialImageBStyle: this.imageStyle
      })
      Stack() {
        Column() {
          Image($r('app.media.icon'))
            .opacity($r('app.float.icon_opacity'))
            .scale({
              x: this.scaleStyle.scaleX,
              y: this.scaleStyle.scaleY
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
        x: this.translateStyle.translateX,
        y: this.translateStyle.translateY
      })

      // 通过按钮点击回调修改状态变量的值，引起相应的组件刷新
      Column() {
        Button("Move")
          .width($r('app.integer.button_width'))
          .fontSize($r('app.integer.button_font_size'))
          .backgroundColor($r('app.color.button_color'))
          .margin({ bottom: $r('app.integer.button_margin_bottom') })
          .onClick(() => {
            animateTo({
              duration: animationDuration
            }, () => {
              this.translateStyle.translateY = (this.translateStyle.translateY + translateYChangeValue) % translateYChangeRange;
            })
          })
        Button("Scale")
          .backgroundColor($r('app.color.button_color'))
          .fontSize($r('app.integer.button_font_size'))
          .width($r('app.integer.button_width'))
          .margin({ bottom: $r('app.integer.button_margin_bottom') })
          .onClick(() => {
            this.scaleStyle.scaleX = (this.scaleStyle.scaleX + scaleXChangeValue) % scaleXChangeRange;
          })
        Button("Change Image")
          .backgroundColor($r('app.color.button_color'))
          .fontSize($r('app.integer.button_font_size'))
          .width($r('app.integer.button_width'))
          .onClick(() => {
            this.imageStyle.imageWidth =
              (this.imageStyle.imageWidth + imageWidthChangeValue) % imageWidthChangeRange;
            this.imageStyle.imageHeight =
              (this.imageStyle.imageHeight + imageHeightChangeValue) % imageHeightChangeRange;
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
export struct DFXStateAfterOptimization {
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