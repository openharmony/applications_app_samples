/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import MyNodeController from '../common/MyNodeController'
import PathRenderNode from '../common/PathRenderNode'
import RectRenderNode from '../common/RectRenderNode'
import TextRenderNode from '../common/TextRenderNode'

// 创建一个PathRenderNode对象
const PathNode = new PathRenderNode();
// 定义PathNode的像素格式
PathNode.frame = {
  x: 100,
  y: 100,
  width: 200,
  height: 800
}
PathNode.pivot = { x: 0.2, y: 0.8 }
PathNode.scale = { x: 1, y: 1 }

// 创建一个RectRenderNode对象
const rectNode = new RectRenderNode();
// 定义rectNode的像素格式
rectNode.frame = {
  x: 90,
  y: 100,
  width: 200,
  height: 800
}
rectNode.pivot = { x: 0.2, y: 0.8 }
rectNode.scale = { x: 1, y: 1 }

// 创建一个TextRenderNode对象
const textNode = new TextRenderNode();
// 定义textNode的像素格式
textNode.frame = {
  x: 90,
  y: 100,
  width: 200,
  height: 800
}
textNode.pivot = { x: 0.2, y: 0.8 }
textNode.scale = { x: 1, y: 1 }

@Entry
@Component
struct RenderTest {
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    Column() {
      Row() {
        NodeContainer(this.myNodeController)
          .height('100%')
        Button("Draw Path")
          .margin({ bottom: 200, right: 12 })
          .onClick(() => {
            this.myNodeController.clearNodes()
            this.myNodeController.addNode(PathNode)
          })
        Button("Draw Rect")
          .margin({ bottom: 200, right: 12 })
          .onClick(() => {
            this.myNodeController.clearNodes()
            this.myNodeController.addNode(rectNode)
          })
        Button("Draw Text")
          .margin({ bottom: 200, right: 12 })
          .onClick(() => {
            this.myNodeController.clearNodes()
            this.myNodeController.addNode(textNode)
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
  }
}