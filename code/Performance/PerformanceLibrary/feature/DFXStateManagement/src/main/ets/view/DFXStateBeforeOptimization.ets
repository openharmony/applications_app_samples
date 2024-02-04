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

// 样式属性类
class UIStyle {
  public translateX: number = 0;
  public translateY: number = 0;
  public scaleX: number = 0.3;
  public scaleY: number = 0.3;
}

@Component
struct SpecialImage {
  @Link specialImageUiStyle: UIStyle;
  private opacityNum: number = 0.5; // 默认透明度

  private isRenderSpecialImage(): number {
    // Image每次渲染时透明度增加0.1, 在0-1之间循环
    this.opacityNum = (this.opacityNum + opacityChangeValue) % opacityChangeRange;
    return this.opacityNum;
  }

  build() {
    Column() {
      Image($r('app.media.icon'))
        .width($r('app.integer.special_image_width'))
        .height($r('app.integer.special_image_width'))
        .margin({ top: $r('app.integer.image_margin_top') })
        .scale({
          x: this.specialImageUiStyle.scaleX,
          y: this.specialImageUiStyle.scaleY
        })
        .opacity(this.isRenderSpecialImage())
      Text("SpecialImage")
        .fontColor($r('app.color.text_color'))
        .fontWeight(FontWeight.Medium)
        .fontSize($r('app.integer.button_font_size'))
        .margin({ top: $r('app.integer.text_margin_top') })
    }
    .backgroundColor($r('app.color.stack_color'))
    .width($r('app.integer.stack_width'))
    .height($r('app.integer.stack_height'))
    .margin({ top: $r('app.integer.stack_margin_top') })
    .borderRadius($r('app.integer.stack_border_radius'))
  }
}

@Component
struct ComponentA {
  @Link uiStyle: UIStyle; // uiStyle的属性被多个组件使用

  build() {
    Column() {
      // 使用状态变量的组件
      SpecialImage({
        specialImageUiStyle: this.uiStyle
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