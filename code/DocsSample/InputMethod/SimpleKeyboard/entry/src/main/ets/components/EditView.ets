'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF InputStyle KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  Component,
  StorageLink,
  State,
  Column,
  Stack,
  Button,
  ButtonType,
  Text,
  Image,
  ImageFit,
  $r,
  Row,
  HorizontalAlign,
  Alignment,
  Color,
  ImageAttribute,
  FlexAlign,
  StackOptions,
  SizeOptions,
  Padding,
  Rectangle,
  Resource,
  ClickEvent
} from '@kit.ArkUI';
import { inputMethodEngine } from '@kit.IMEKit';
import { InputHandler } from '../InputMethodExtensionAbility/model/KeyboardController';
import { KeyStyle, StyleConfiguration } from '../common/StyleConfiguration';

@Component
export struct EditView {
  @State isSelection: boolean = false;
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();

  build(): void {
    Column() {
      Stack({ alignContent: Alignment.Center } as StackOptions) {
        Button() {
          Text($r('app.string.selection'))
            .fontColor(this.isSelection ? $r('app.color.edit_blue') : $r('app.color.text_normal'))
            .fontSize(14)
        }
        .size({ width: this.inputStyle.editSmallCircle, height: this.inputStyle.editSmallCircle } as SizeOptions)
        .type(ButtonType.Circle)
        .border({ width: 1, color: $r('app.color.circle_black'), radius: 90 })
        .backgroundColor(Color.White)
        .id('btn_selection')
        .onClick(() => {
          this.isSelection = !this.isSelection;
        })

        Image($r('app.media.ic_arrow_up'))
          .size({ width: this.inputStyle.editImageSize, height: this.inputStyle.editImageSize } as SizeOptions)
          .objectFit(ImageFit.Contain)
          .responseRegion({
            x: -20,
            y: -20,
            width: 64,
            height: 64
          } as Rectangle)
          .backgroundColor(Color.White)
          .borderRadius(20)
          .colorBlend(this.isSelection ? $r('app.color.edit_blue') : $r('app.color.edit_black'))
          .margin({ bottom: this.inputStyle.editSmallCircleMargin })
          .id('arrow_up')
          .onClick((e: ClickEvent) => {
            this.moveOrSelect(inputMethodEngine.CURSOR_UP);
          })
        Image($r('app.media.ic_arrow_left'))
          .size({ width: this.inputStyle.editImageSize, height: this.inputStyle.editImageSize } as SizeOptions)
          .objectFit(ImageFit.Contain)
          .responseRegion({
            x: -20,
            y: -20,
            width: 64,
            height: 64
          } as Rectangle)
          .backgroundColor(Color.White)
          .borderRadius(20)
          .colorBlend(this.isSelection ? $r('app.color.edit_blue') : $r('app.color.edit_black'))
          .margin({ right: this.inputStyle.editSmallCircleMargin })
          .id('arrow_left')
          .onClick(() => {
            this.moveOrSelect(inputMethodEngine.CURSOR_LEFT);
          })
        Image($r('app.media.ic_arrow_right'))
          .size({ width: this.inputStyle.editImageSize, height: this.inputStyle.editImageSize } as SizeOptions)
          .objectFit(ImageFit.Contain)
          .responseRegion({
            x: -20,
            y: -20,
            width: 64,
            height: 64
          } as Rectangle)
          .backgroundColor(Color.White)
          .borderRadius(20)
          .colorBlend(this.isSelection ? $r('app.color.edit_blue') : $r('app.color.edit_black'))
          .id('arrow_right')
          .margin({ left: this.inputStyle.editSmallCircleMargin } as Padding)
          .onClick(() => {
            this.moveOrSelect(inputMethodEngine.CURSOR_RIGHT);
          })
        Image($r('app.media.ic_arrow_down'))
          .size({ width: this.inputStyle.editImageSize, height: this.inputStyle.editImageSize } as SizeOptions)
          .objectFit(ImageFit.Contain)
          .responseRegion({
            x: -20,
            y: -20,
            width: 64,
            height: 64
          } as Rectangle)
          .backgroundColor(Color.White)
          .borderRadius(20)
          .colorBlend(this.isSelection ? $r('app.color.edit_blue') : $r('app.color.edit_black'))
          .margin({ top: this.inputStyle.editSmallCircleMargin } as Padding)
          .id('arrow_down')
          .onClick(() => {
            this.moveOrSelect(inputMethodEngine.CURSOR_DOWN);
          })
      }
      .width(this.inputStyle.editCircleSize)
      .aspectRatio(1)
      .borderRadius(100)
      .backgroundColor(Color.White)

      Row() {
        Button() {
          Image($r('app.media.ic_cursor_left'))
            .size({ width: this.inputStyle.editImageSize, height: this.inputStyle.editImageSize } as SizeOptions)
            .objectFit(ImageFit.Contain)
            .responseRegion({
              x: -20,
              y: -20,
              width: 64,
              height: 64
            } as Rectangle)
            .backgroundColor(Color.White)
            .borderRadius(20)
            .colorBlend(this.isSelection ? $r('app.color.edit_blue') : $r('app.color.edit_black'))
        }
        .size({ width: this.inputStyle.editButtonSize, height: this.inputStyle.editButtonSize } as SizeOptions)
        .type(ButtonType.Circle)
        .backgroundColor(Color.White)
        .borderRadius(90)
        .id('cursor_left')
        .onClick(() => {
          this.moveOrSelectBegin();
        })

        if (this.isSelection) {
          Button() {
            Image($r('app.media.ic_cursor_all'))
              .size({ width: this.inputStyle.editImageSize, height: this.inputStyle.editImageSize } as SizeOptions)
              .objectFit(ImageFit.Contain)
              .responseRegion({
                x: -20,
                y: -20,
                width: 64,
                height: 64
              } as Rectangle)
              .backgroundColor(Color.White)
              .borderRadius(20)
              .colorBlend(this.isSelection ? $r('app.color.edit_blue') : $r('app.color.edit_black'))
          }
          .size({ width: this.inputStyle.editButtonSize, height: this.inputStyle.editButtonSize } as SizeOptions)
          .type(ButtonType.Circle)
          .backgroundColor(Color.White)
          .borderRadius(90)
          .margin({ left: 74 })
          .id('cursor_all')
          .onClick(() => {
            InputHandler.getInstance().sendExtendAction(inputMethodEngine.ExtendAction.SELECT_ALL);
          })
        }

        Button() {
          Image($r('app.media.ic_cursor_right'))
            .size({ width: this.inputStyle.editImageSize, height: this.inputStyle.editImageSize } as SizeOptions)
            .objectFit(ImageFit.Contain)
            .responseRegion({
              x: -20,
              y: -20,
              width: 64,
              height: 64
            } as Rectangle)
            .backgroundColor(Color.White)
            .borderRadius(20)
            .colorBlend(this.isSelection ? $r('app.color.edit_blue') : $r('app.color.edit_black'))
        }
        .size({ width: this.inputStyle.editButtonSize, height: this.inputStyle.editButtonSize } as SizeOptions)
        .margin({ left: 74 })
        .type(ButtonType.Circle)
        .backgroundColor(Color.White)
        .borderRadius(90)
        .id('cursor_right')
        .onClick(() => {
          this.moveOrSelectEnd();
        })
      }
      .margin({ top: 8 })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .align(Alignment.Center)
    .backgroundColor('#F1F3F5')
  }

  moveOrSelect(direction: int): void {
    if (this.isSelection) {
      InputHandler.getInstance().selectByMovement(inputMethodEngine.Direction.fromValue(direction));
    } else {
      InputHandler.getInstance().moveCursor(inputMethodEngine.Direction.fromValue(direction));
    }
  }

  moveOrSelectBegin(): void {
    if (this.isSelection) {
      InputHandler.getInstance().selectToBegin();
    } else {
      InputHandler.getInstance().moveCursorToBegin();
    }
  }

  moveOrSelectEnd(): void {
    if (this.isSelection) {
      InputHandler.getInstance().selectToEnd();
    } else {
      InputHandler.getInstance().moveCursorToEnd();
    }
  }
}