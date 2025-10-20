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

import router from '@ohos.router'

interface listItem {
  router?: string;
  name: string;
  description?: string;
}

let demandList: listItem[] = [
  {
    name: "CanvasRenderingContext2D",
    router: "pages/canvas/CanvasRenderingContext2D",
  },
  {
    name: "OffScreenDrawing",
    router: "pages/canvas/OffScreenDrawing",
  },
  {
    name: "InitCanvasComponent",
    router: "pages/canvas/InitCanvasComponent",
  },
  {
    name: "CanvasComponentDrawingMethod",
    router: "pages/canvas/CanvasComponentDrawingMethod",
  },
  {
    name: "CanvasComponentBasicShapes",
    router: "pages/canvas/CanvasComponentBasicShapes",
  },
  {
    name: "CanvasComponentText",
    router: "pages/canvas/CanvasComponentText",
  },
  {
    name: "CanvasComponentTextBorder",
    router: "pages/canvas/CanvasComponentTextBorder",
  },
  {
    name: "CanvasComponentCustomFontsDrawText",
    router: "pages/canvas/CanvasComponentCustomFontsDrawText",
  },
  {
    name: "CanvasComponentDrawingPictureAndImagePixel",
    router: "pages/canvas/CanvasComponentDrawingPictureAndImagePixel",
  },
  {
    name: "CanvasComponentOtherMethods",
    router: "pages/canvas/CanvasComponentOtherMethods",
  },
  {
    name: "CanvasContentUpdate",
    router: "pages/canvas/CanvasContentUpdate",
  },
  {
    name: "DrawingRegularBaseShape",
    router: "pages/canvas/DrawingRegularBaseShape",
  },
  {
    name: "DrawIrregularFigures",
    router: "pages/canvas/DrawIrregularFigures",
  },
  {
    name: "DrawDraggableCursor",
    router: "pages/canvas/DrawDraggableCursor",
  },
]

@Entry
@Component
struct Index {
  @State bgColor: ResourceColor = "#39b5fa";

  build() {
    Column() {
      Text('使用画布绘制自定义图形')
        .height('5%')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.bgColor)
        .fontColor(Color.White)

      Column() {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(demandList, (listitem: listItem, index: number) => {
            ListItem() {
              Column() {
                Text(listitem.name)
                  .fontSize(15)
                  .fontColor(this.bgColor)
                  .maxLines(1)
              }
              .onClick(() => {
                if (!!listitem.router) {
                  router.pushUrl({ url: listitem.router })
                }
              })
            }
          })
        }
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({
          strokeWidth: 2,
          color: 0xFFFFFF,
          startMargin: 20,
          endMargin: 20
        }) // 每行之间的分界线
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .width('90%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff4f3f3')
      .padding({ top: 5 })
    }
  }
}