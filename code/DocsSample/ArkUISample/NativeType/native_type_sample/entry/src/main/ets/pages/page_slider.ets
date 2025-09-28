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
import Napi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

enum ArkUISliderBlockStyle {
  ARKUI_SLIDER_BLOCK_STYLE_DEFAULT = 0,
  ARKUI_SLIDER_BLOCK_STYLE_IMAGE,
  ARKUI_SLIDER_BLOCK_STYLE_SHAPE,
}

enum ArkUISliderDirection {
  ARKUI_SLIDER_DIRECTION_VERTICAL = 0,
  ARKUI_SLIDER_DIRECTION_HORIZONTAL,
}

enum ArkUISliderStyle {
  ARKUI_SLIDER_STYLE_OUT_SET = 0,
  ARKUI_SLIDER_STYLE_IN_SET,
  ARKUI_SLIDER_STYLE_NONE,
}

@Entry
@Component
struct thirdIndex {
  @State sliderBlockStyle: number = ArkUISliderBlockStyle.ARKUI_SLIDER_BLOCK_STYLE_DEFAULT;
  @State sliderDirection: number = ArkUISliderDirection.ARKUI_SLIDER_DIRECTION_HORIZONTAL;
  @State sliderStyle: number = ArkUISliderStyle.ARKUI_SLIDER_STYLE_OUT_SET;
  @State nodeContent: NodeContent = new NodeContent();

  @Builder
  SubMenuSliderBlockStyle() {
    Menu() {
      MenuItem({ content: 'ARKUI_SLIDER_BLOCK_STYLE_DEFAULT' }).width('50%').onChange(() => {
        this.sliderBlockStyle = ArkUISliderBlockStyle.ARKUI_SLIDER_BLOCK_STYLE_DEFAULT;
        this.nodeContent = new NodeContent();
        Napi.createNativeSliderNode(this.nodeContent, this.sliderBlockStyle, this.sliderDirection, this.sliderStyle)
      })
      MenuItem({ content: 'ARKUI_SLIDER_BLOCK_STYLE_IMAGE' }).width('50%').onChange(() => {
        this.sliderBlockStyle = ArkUISliderBlockStyle.ARKUI_SLIDER_BLOCK_STYLE_IMAGE;
        this.nodeContent = new NodeContent();
        Napi.createNativeSliderNode(this.nodeContent, this.sliderBlockStyle, this.sliderDirection, this.sliderStyle)
      })
      MenuItem({ content: 'ARKUI_SLIDER_BLOCK_STYLE_SHAPE' }).width('50%').onChange(() => {
        this.sliderBlockStyle = ArkUISliderBlockStyle.ARKUI_SLIDER_BLOCK_STYLE_SHAPE;
        this.nodeContent = new NodeContent();
        Napi.createNativeSliderNode(this.nodeContent, this.sliderBlockStyle, this.sliderDirection, this.sliderStyle)
      })
    }
  }

  @Builder
  SubMenuSliderDirection() {
    Menu() {
      MenuItem({ content: 'ARKUI_SLIDER_DIRECTION_VERTICAL' }).width('50%').onChange(() => {
        this.sliderDirection = ArkUISliderDirection.ARKUI_SLIDER_DIRECTION_VERTICAL;
        this.nodeContent = new NodeContent();
        Napi.createNativeSliderNode(this.nodeContent, this.sliderBlockStyle, this.sliderDirection, this.sliderStyle)
      })
      MenuItem({ content: 'ARKUI_SLIDER_DIRECTION_HORIZONTAL' }).width('50%').onChange(() => {
        this.sliderDirection = ArkUISliderDirection.ARKUI_SLIDER_DIRECTION_HORIZONTAL;
        this.nodeContent = new NodeContent();
        Napi.createNativeSliderNode(this.nodeContent, this.sliderBlockStyle, this.sliderDirection, this.sliderStyle)
      })
    }
  }

  @Builder
  SubMenuSliderStyle() {
    Menu() {
      MenuItem({ content: 'ARKUI_SLIDER_STYLE_OUT_SET' }).width('50%').onChange(() => {
        this.sliderStyle = ArkUISliderStyle.ARKUI_SLIDER_STYLE_OUT_SET;
        this.nodeContent = new NodeContent();
        Napi.createNativeSliderNode(this.nodeContent, this.sliderBlockStyle, this.sliderDirection, this.sliderStyle)
      })
      MenuItem({ content: 'ARKUI_SLIDER_STYLE_IN_SET' }).width('50%').onChange(() => {
        this.sliderStyle = ArkUISliderStyle.ARKUI_SLIDER_STYLE_IN_SET;
        this.nodeContent = new NodeContent();
        Napi.createNativeSliderNode(this.nodeContent, this.sliderBlockStyle, this.sliderDirection, this.sliderStyle)
      })
      MenuItem({ content: 'ARKUI_SLIDER_STYLE_NONE' }).width('50%').onChange(() => {
        this.sliderStyle = ArkUISliderStyle.ARKUI_SLIDER_STYLE_NONE;
        this.nodeContent = new NodeContent();
        Napi.createNativeSliderNode(this.nodeContent, this.sliderBlockStyle, this.sliderDirection, this.sliderStyle)
      })
    }
  }

  build() {
    Column() {
      Column() {
        Button('SliderBlockStyle')
          .height(50)
          .width('40%')
          .bindMenu(this.SubMenuSliderBlockStyle)
          .margin({ top: 20, bottom: 10 })
        Button('SliderDirection')
          .height(50)
          .width('40%')
          .bindMenu(this.SubMenuSliderDirection)
          .margin({ top: 20, bottom: 10 })
        Button('SliderStyle')
          .height(50)
          .width('40%')
          .bindMenu(this.SubMenuSliderStyle)
          .margin({ top: 20, bottom: 10 })
        ContentSlot(this.nodeContent)
      }
      .width('100%')
    }
    .height('100%')
  }
}