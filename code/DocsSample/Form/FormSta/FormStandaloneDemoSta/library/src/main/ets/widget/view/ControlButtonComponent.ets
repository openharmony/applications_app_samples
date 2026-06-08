/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BottomItem, ControlButtonParameter } from '../viewmodel/ControlButtonParameter';

const LAYOUT_WEIGHT = 1;

const LINEAR_START_GRADIENT = 0.0;

const LINEAR_END_GRADIENT = 1.0;

@Component
export struct ControlButtonComponent {
  @Link controlButtonParameter: ControlButtonParameter;
  @State widgetHeight: boolean = true;
  /**
   * The width percentage setting.
   */
  readonly fullWidthPercent: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly fullHeightPercent: string = '100%';
  /**
   * Bottom row height.
   */
  readonly bottomRowHeight: string = '40%';
  /**
   * Critical form height.
   */
  readonly criticalFormHeight: number = 160;
  /**
   * Type of height.
   */
  readonly typeHeight: string = 'number';

  build() {
    Stack() {
      Image(this.controlButtonParameter.backgroundImage)
        .width(this.fullWidthPercent)
        .height(this.fullHeightPercent)

      Column() {
        Column() {
          Row() {
            Column() {
              Text(this.controlButtonParameter.title)
                .fontSize(this.widgetHeight ? $r('app.float.title_font_size_sm') : $r('app.float.title_font_size_lg'))
                .fontWeight(FontWeight.Bold)
                .fontColor(this.controlButtonParameter.titleColor)
                .opacity(this.controlButtonParameter.titleOpacity)
                .shadow(this.controlButtonParameter.titleShadow)
              if (!this.widgetHeight) {
                Text(this.controlButtonParameter.secondaryText)
                  .fontSize($r('app.float.secondary_text_size'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.controlButtonParameter.secondaryTextColor)
                  .opacity(this.controlButtonParameter.secondaryTextOpacity)
                  .shadow(this.controlButtonParameter.secondaryTextShadow)
              }
            }
            .alignItems(HorizontalAlign.Start)

            Image(this.controlButtonParameter.logo)
              .width(this.widgetHeight ? $r('app.float.logo_size_sm') : $r('app.float.logo_size_lg'))
              .height(this.widgetHeight ? $r('app.float.logo_size_sm') : $r('app.float.logo_size_lg'))
          }
          .width(this.fullWidthPercent)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Top)
          .padding({
            top: $r('app.float.title_row_padding_top'),
            left: $r('app.float.title_row_padding_left'),
            right: $r('app.float.title_row_padding_right')
          })

          Row() {
            if (this.widgetHeight) {
              Column() {
                Text(this.controlButtonParameter.secondaryText)
                  .fontSize($r('app.float.secondary_text_size'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.controlButtonParameter.secondaryTextColor)
                  .opacity(this.controlButtonParameter.secondaryTextOpacity)
                  .shadow(this.controlButtonParameter.secondaryTextShadow)
              }
              .alignItems(HorizontalAlign.Start)
              .height(this.fullHeightPercent)
            }
            Column() {
              Row() {
                if (this.controlButtonParameter.buttonIcon !== undefined) {
                  Image(this.controlButtonParameter.buttonIcon)
                    .width($r('app.float.button_icon_size'))
                    .height($r('app.float.button_icon_size'))
                }
                Text(this.controlButtonParameter.buttonText)
                  .fontSize($r('app.float.button_text_size'))
                  .fontWeight(FontWeight.Regular)
                  .fontColor(this.controlButtonParameter.buttonTextColor)
                  .opacity(this.controlButtonParameter.buttonTextOpacity)
                  .shadow(this.controlButtonParameter.buttonTextShadow)
                  .margin({
                    left: $r('app.float.button_text_margin')
                  })
              }
              .borderRadius($r('app.float.button_border_radius'))
              .border(this.controlButtonParameter.buttonBorder)
              .visibility(this.controlButtonParameter.buttonVisible !== undefined &&
              this.controlButtonParameter.buttonVisible ? Visibility.Visible : Visibility.Hidden)
              .padding({
                left: $r('app.float.button_padding_left_right'),
                right: $r('app.float.button_padding_left_right'),
                top: $r('app.float.button_padding_top_bottom'),
                bottom: $r('app.float.button_padding_top_bottom')
              })
            }
            .justifyContent(FlexAlign.End)
            .height(this.fullHeightPercent)
          }
          .layoutWeight(LAYOUT_WEIGHT)
          .justifyContent(this.widgetHeight ? FlexAlign.SpaceBetween : FlexAlign.End)
          .width(this.fullWidthPercent)
          .padding({
            left: $r('app.float.secondary_row_padding_left'),
            right: $r('app.float.secondary_row_padding_right'),
            bottom: $r('app.float.secondary_row_padding_bottom')
          })
        }
        .layoutWeight(LAYOUT_WEIGHT)

        Row() {
          ForEach(this.controlButtonParameter.bottomItemList, (item: BottomItem) => {
            FormLink(item.formLinkParam) {
              Column() {
                Image(item.icon)
                  .width(this.widgetHeight ? $r('app.float.bottom_icon_size_sm') : $r('app.float.bottom_icon_size_lg'))
                  .height(this.widgetHeight ? $r('app.float.bottom_icon_size_sm') : $r('app.float.bottom_icon_size_lg'))
                Text(item.title)
                  .fontSize(this.widgetHeight ? $r('app.float.bottom_title_size_sm') :
                    $r('app.float.bottom_title_size_lg'))
                  .fontWeight(FontWeight.Medium)
                  .margin({ top: $r('app.float.bottom_item_text_margin') })
                  .fontColor(this.controlButtonParameter.auxiliaryTextColor ?? Color.White)
              }
            }
          }, (item: BottomItem, index: number) => index + JSON.stringify(item))
        }
        .width(this.fullWidthPercent)
        .height(this.widgetHeight ? $r('app.float.bottom_row_height') : this.bottomRowHeight)
        .padding({
          bottom: this.widgetHeight ? $r('app.float.bottom_row_padding') : 0,
          left: $r('app.float.bottom_row_padding'),
          right: $r('app.float.bottom_row_padding')
        })
        .justifyContent(FlexAlign.SpaceAround)
        .alignItems(this.widgetHeight ? VerticalAlign.Bottom : VerticalAlign.Center)
        .linearGradient({
          direction: GradientDirection.Bottom,
          repeating: false,
          colors: [[this.controlButtonParameter.linearStartColor ?? '#00000000', LINEAR_START_GRADIENT],
            [this.controlButtonParameter.linearEndColor ?? '#99000000', LINEAR_END_GRADIENT]]
        })
      }
      .height(this.fullHeightPercent)
      .width(this.fullWidthPercent)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Center)
      .onAreaChange((oldArea: Area, newArea: Area) => {
        const height = newArea.height;
        if (typeof height === this.typeHeight) {
          this.widgetHeight = height < this.criticalFormHeight;
        }
      })
      .backgroundColor(this.controlButtonParameter.backgroundColor)
    }
  }
}