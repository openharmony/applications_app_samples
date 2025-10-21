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
    name: "RelativeContainerParentComponentId",
    router: "pages/relativecontainerlayout/RelativeContainerParentComponentId",
  },
  {
    name: "RelativeContainerSiblingComponentId",
    router: "pages/relativecontainerlayout/RelativeContainerSiblingComponentId",
  },
  {
    name: "RelativeContainerChildComponentId",
    router: "pages/relativecontainerlayout/RelativeContainerChildComponentId",
  },
  {
    name: "RelativeContainerChildComponentOffset",
    router: "pages/relativecontainerlayout/RelativeContainerChildComponentOffset",
  },
  {
    name: "RelativeContainerDifferentComponentId",
    router: "pages/relativecontainerlayout/RelativeContainerDifferentComponentId",
  },
  {
    name: "RelativeContainerComponentSize",
    router: "pages/relativecontainerlayout/RelativeContainerComponentSize",
  },
  {
    name: "RelativeContainerMultipleComponentsChainMode",
    router: "pages/relativecontainerlayout/RelativeContainerMultipleComponentsChainMode",
  },
  {
    name: "RelativeContainerComponentGuideLine",
    router: "pages/relativecontainerlayout/RelativeContainerComponentGuideLine",
  },
  {
    name: "RelativeContainerComponentBarrier",
    router: "pages/relativecontainerlayout/RelativeContainerComponentBarrier",
  },
  {
    name: "StackLayoutExample",
    router: "pages/stacklayout/StackLayoutExample",
  },
  {
    name: "StackLayoutAlignContent",
    router: "pages/stacklayout/StackLayoutAlignContent",
  },
  {
    name: "StackLayoutNozIndex",
    router: "pages/stacklayout/StackLayoutNozIndex",
  },
  {
    name: "StackLayoutzIndex",
    router: "pages/stacklayout/StackLayoutzIndex",
  },
  {
    name: "StackLayoutSceneExample",
    router: "pages/stacklayout/StackLayoutSceneExample",
  },
  {
    name: "ColumnLayoutExample",
    router: "pages/linearlayout/ColumnLayoutExample",
  },
  {
    name: "RowLayoutExample",
    router: "pages/linearlayout/RowLayoutExample",
  },
  {
    name: "ColumnLayoutJustifyContentStart",
    router: "pages/linearlayout/ColumnLayoutJustifyContentStart",
  },
  {
    name: "ColumnLayoutJustifyContentCenter",
    router: "pages/linearlayout/ColumnLayoutJustifyContentCenter",
  },
  {
    name: "ColumnLayoutJustifyContentEnd",
    router: "pages/linearlayout/ColumnLayoutJustifyContentEnd",
  },
  {
    name: "ColumnLayoutJustifyContentSpaceBetween",
    router: "pages/linearlayout/ColumnLayoutJustifyContentSpaceBetween",
  },
  {
    name: "ColumnLayoutJustifyContentSpaceAround",
    router: "pages/linearlayout/ColumnLayoutJustifyContentSpaceAround",
  },
  {
    name: "ColumnLayoutJustifyContentSpaceEvenly",
    router: "pages/linearlayout/ColumnLayoutJustifyContentSpaceEvenly",
  },
  {
    name: "RowLayoutJustifyContentStart",
    router: "pages/linearlayout/RowLayoutJustifyContentStart",
  },
  {
    name: "RowLayoutJustifyContentCenter",
    router: "pages/linearlayout/RowLayoutJustifyContentCenter",
  },
  {
    name: "RowLayoutJustifyContentEnd",
    router: "pages/linearlayout/RowLayoutJustifyContentEnd",
  },
  {
    name: "RowLayoutJustifyContentSpaceBetween",
    router: "pages/linearlayout/RowLayoutJustifyContentSpaceBetween",
  },
  {
    name: "RowLayoutJustifyContentSpaceAround",
    router: "pages/linearlayout/RowLayoutJustifyContentSpaceAround",
  },
  {
    name: "RowLayoutJustifyContentSpaceEvenly",
    router: "pages/linearlayout/RowLayoutJustifyContentSpaceEvenly",
  },
  {
    name: "RowLayoutHorizontalAlignStart",
    router: "pages/linearlayout/RowLayoutHorizontalAlignStart",
  },
  {
    name: "RowLayoutHorizontalAlignCenter",
    router: "pages/linearlayout/RowLayoutHorizontalAlignCenter",
  },
  {
    name: "RowLayoutHorizontalAlignEnd",
    router: "pages/linearlayout/RowLayoutHorizontalAlignEnd",
  },
  {
    name: "RowLayoutVerticalAlignTop",
    router: "pages/linearlayout/RowLayoutVerticalAlignTop",
  },
  {
    name: "RowLayoutVerticalAlignCenter",
    router: "pages/linearlayout/RowLayoutVerticalAlignCenter",
  },
  {
    name: "RowLayoutVerticalAlignBottom",
    router: "pages/linearlayout/RowLayoutVerticalAlignBottom",
  },
  {
    name: "BlankExample",
    router: "pages/linearlayout/BlankExample",
  },
  {
    name: "LayoutWeightExample",
    router: "pages/linearlayout/LayoutWeightExample",
  },
  {
    name: "WidthExample",
    router: "pages/linearlayout/WidthExample",
  },
  {
    name: "ScrollVerticalExample",
    router: "pages/linearlayout/ScrollVerticalExample",
  },
  {
    name: "ScrollHorizontalExample",
    router: "pages/linearlayout/ScrollHorizontalExample",
  },
]

@Entry
@Component
struct Index {
  @State bgColor: ResourceColor = "#39b5fa";

  build() {
    Column() {
      Text($r('app.string.build_layout'))
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
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({
          strokeWidth: 2,
          color: 0xFFFFFF,
          startMargin: 20,
          endMargin: 20
        })
        .edgeEffect(EdgeEffect.Spring)
        .contentEndOffset(50)
        .width('90%')
      }
      .width('100%')
      //  .height('100%')
      .backgroundColor('#fff4f3f3')
      .padding({ top: 5 })
    }
  }
}