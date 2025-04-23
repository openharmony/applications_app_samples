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
    name: "SetImageZoomType",
    description: "Scale the image to a box with a determined height and width using the objectFit attribute",
    router: "pages/SetImageZoomType",
  },
  {
    name: "ImageInterpolation",
    description: "Interpolate the image using the interpolation property to make it appear clearer",
    router: "pages/ImageInterpolation",
  },
  {
    name: "SetImageRepetitionStyle",
    description: "Set the repetition style of the image through the objectRepeat property",
    router: "pages/SetImageRepetitionStyle",
  },
  {
    name: "SetImageRenderingMode",
    description: "primary color or black and white through the renderMode property",
    router: "pages/SetImageRenderingMode",
  },
  {
    name: "SetImageDecodingSize",
    description: "Set image decoding size to reduce image resolution",
    router: "pages/SetImageDecodingSize",
  },
  {
    name: "AddFilterEffectsToImages",
    description: "Modify the pixel color of the image and add filters to the image",
    router: "pages/AddFilterEffectsToImages",
  },
  {
    name: "EventCall",
    description: "After the image is successfully loaded, necessary information about the image can be obtained",
    router: "pages/EventCall",
  },
  {
    name: "LoadImageResources",
    description: "Supports file://path prefix, used to access the image path provided through the selector.",
    router: "pages/LoadImageResources",
  },
  {
    name: "DisplayVectorDiagram",
    description: "SVG format images can use the fillColor property to change the drawing color of the image.",
    router: "pages/DisplayVectorDiagram",
  },
]

@Entry
@Component
struct Index {
  @State bgColor: ResourceColor = "#39b5fa";

  build() {
    Column() {
      Text($r('app.string.ImageShow'))
        .height('8.00%')
        .width("100%")
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.bgColor)
        .fontColor(Color.White)

      Column() {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(demandList, (listitem: listItem, index: number) => {
            ListItem() {
              Column({ space: 10 }) {
                Text(listitem.name)
                  .fontSize(20)
                  .fontColor(this.bgColor)
                  .maxLines(1)

                Text(listitem.description)
                  .width("100%")
              }
              .margin({ bottom: index >= demandList.length - 1 ? 100 : 0 })
              .padding({
                top: '3%',
                right: '10.00%',
                bottom: '5%',
                left: '10.00%'
              })
              .width('100%')
              .constraintSize({ minHeight: 100 })
              .borderRadius(10)
              .backgroundColor(0xFFFFFF)
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