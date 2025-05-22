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

import { UIContext, NodeController, FrameNode, RenderNode, DrawContext} from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { taskpool } from '@kit.ArkTS';
import { drawing } from '@kit.ArkGraphics2D';

// [Start arkts_graphics_draw_direct_canvas_api]
// 1. 自定义 RenderNode
class MyRenderNodeDirectDisplay extends RenderNode {
  async draw(context: DrawContext) {
    const canvas = context.canvas;
    if (canvas === null) {
      console.error('Canvas is null.');
      return;
    }
    // 3. 自定义的绘制相关操作
    const brush = new drawing.Brush();
    if (brush === null) {
      console.error('Brush is null.');
      return;
    } else {
      brush.setColor({red: 255, blue: 0, green: 0, alpha: 255});
      canvas.attachBrush(brush);
      canvas.drawRect({left: 0, right: 300, top: 0, bottom: 300});
    }
  }
}

// 2. 自定义 NodeController
class MyNodeControllerDirectDisplay extends NodeController {
  private rootNode: FrameNode | null = null;
  private myRenderNode = new MyRenderNodeDirectDisplay();

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode === null) {
      return this.rootNode;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      this.myRenderNode.backgroundColor = 0xffffffff;
      this.myRenderNode.frame = { x: 0, y: 0, width: 4800, height: 4800 };
      this.myRenderNode.pivot = { x: 0.2, y: 0.8 };
      this.myRenderNode.scale = { x: 1, y: 1 };
      renderNode.appendChild(this.myRenderNode);
      renderNode.clipToFrame = true;
    }
    return this.rootNode;
  }
}
// [End arkts_graphics_draw_direct_canvas_api]

// [Start arkts_graphics_draw_indirect_canvas_api]
// 1. 自定义RenderNode
export class MyRenderNodeIndirectDisplay extends RenderNode {
  private pixelMap: image.PixelMap | null = null;
  setPixelMap(pixelMap: image.PixelMap) {
    this.pixelMap = pixelMap;
  }

  async draw(context: DrawContext) {
    const canvas = context.canvas;
    if (this.pixelMap != null) {
      // 4.1 利用3中创建的PixelMap构造离屏Canvas
      const canvas_ = new drawing.Canvas(this.pixelMap);

      // 4.2 离屏绘制
      const brush = new drawing.Brush();
      brush.setColor({ alpha: 255, red: 0, green: 0, blue: 255 });
      canvas_.attachBrush(brush);
      canvas_.drawRect({ left: 150, right: 575, top: 0, bottom: 600 });

      // 4.3 将离屏Canvas的绘制结果交给RenderNode
      canvas.drawImage(this.pixelMap, 0, 0);
    }
  }
}

@Concurrent
async function createPixelMapAsync() {
  const color : ArrayBuffer = new ArrayBuffer(4000000);  // 40000为需要创建的像素buffer大小，取值为：height * width *4
  let opts : image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: 1000, width: 1000 } };
  const pixel = await image.createPixelMap(color, opts);
  return pixel;
}

// 2. 自定义NodeController
export class MyNodeControllerIndirectDisplay extends NodeController {
  private rootNode: FrameNode | null = null;
  private myRenderNode = new MyRenderNodeIndirectDisplay();

  // 3. 在MyNodeController的aboutToAppear中创建PixeMap
  aboutToAppear(): void {
    let task = new taskpool.Task(createPixelMapAsync);
    taskpool.execute(task).then((pixel:Object)=>{
      this.myRenderNode.setPixelMap(pixel as image.PixelMap);
      this.myRenderNode.invalidate();
    })
  }

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode === null) {
      return this.rootNode;
    }

    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      this.myRenderNode.backgroundColor = 0xffffffff;
      this.myRenderNode.frame = { x: 0, y: 0, width: 4800, height: 4800 };
      this.myRenderNode.pivot = { x: 0.2, y: 0.8 };
      this.myRenderNode.scale = { x: 1, y: 1 };
      renderNode.appendChild(this.myRenderNode);
      renderNode.clipToFrame = true;
    }
    return this.rootNode;
  }
}
// [End arkts_graphics_draw_indirect_canvas_api]

// [Start arkts_graphics_draw_direct_and_indirect_canvas]
@Entry
@Component
struct CanvasGetResult {
  myNodeController_1 = new MyNodeControllerDirectDisplay();
  myNodeController_2 = new MyNodeControllerIndirectDisplay();

  build() {
    Row() {
      Column() {
        Column(){
          Text($r('app.string.DirectCanvas'))
          // 直接画布
          NodeContainer(this.myNodeController_1)
            .width('100%')
            .height('40%')
        }
        Column(){
          Text($r('app.string.OffScreenCanvas'))
          // 离屏画布
          NodeContainer(this.myNodeController_2)
            .width('100%')
            .height('40%')
            .margin({ top: 20 })
        }
      }
    }
  }
}
// [End arkts_graphics_draw_direct_and_indirect_canvas]