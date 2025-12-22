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

// [Start custom_draw_canvas]
import { NodeController, UIContext, RenderNode, DrawContext, FrameNode } from '@kit.ArkUI';
import { drawing } from '@kit.ArkGraphics2D';

function drawImage(canvas: DrawingCanvas) {
  let matrix = new drawing.Matrix();
  matrix.setTranslation(100, 100);
  canvas.concatMatrix(matrix);
  const pen = new drawing.Pen();
  pen.setStrokeWidth(5);
  pen.setColor({
    alpha: 255,
    red: 0,
    green: 74,
    blue: 175
  });
  canvas.attachPen(pen);
  const brush = new drawing.Brush();
  brush.setColor({
    alpha: 255,
    red: 0,
    green: 74,
    blue: 175
  });
  canvas.attachBrush(brush);
  canvas.drawRect({
    left: 10,
    top: 10,
    right: 110,
    bottom: 60
  });
  canvas.detachPen();
}

function drawImage1(canvas: DrawingCanvas) {
  let matrix = new drawing.Matrix();
  matrix.setTranslation(100, 100);
  // 1. getTotalMatrix获取的是用来记录绘制指令的临时canvas的变换矩阵
  // 2. 如果开发者希望这个画布进行一个预期的变换，应该使用concatMatrix而不是setMatrix，因为setMatrix会覆盖原本真实canvas上存在的变换矩阵
  canvas.getTotalMatrix();
  canvas.setMatrix(matrix);
  const pen = new drawing.Pen();
  pen.setStrokeWidth(5);
  pen.setColor({
    alpha: 255,
    red: 0,
    green: 74,
    blue: 175
  });
  canvas.attachPen(pen);
  const brush = new drawing.Brush();
  brush.setColor({
    alpha: 255,
    red: 0,
    green: 74,
    blue: 175
  });
  canvas.attachBrush(brush);
  canvas.drawRect({
    left: 10,
    top: 10,
    right: 110,
    bottom: 60
  });
  canvas.detachPen();
}

class MyRenderNode extends RenderNode {
  draw(context: DrawContext): void {
    drawImage(context.canvas);
  }
}

class MyRenderNode1 extends RenderNode {
  draw(context: DrawContext): void {
    drawImage1(context.canvas);
  }
}

class MyNodeController extends NodeController {
  makeNode(uiContext: UIContext): FrameNode | null {
    const rootNode: FrameNode = new FrameNode(uiContext);
    rootNode.commonAttribute.width(300).height(300);
    const theRenderNode: MyRenderNode = new MyRenderNode();
    theRenderNode.frame = {
      x: 10,
      y: 100,
      width: 100,
      height: 50
    };
    theRenderNode.backgroundColor = 0xFF2787D9;
    rootNode.getRenderNode()?.appendChild(theRenderNode);
    return rootNode;
  }
}

class MyNodeController1 extends NodeController {
  makeNode(uiContext: UIContext): FrameNode | null {
    const rootNode: FrameNode = new FrameNode(uiContext);
    rootNode.commonAttribute.width(300).height(300);
    const theRenderNode: MyRenderNode1 = new MyRenderNode1();
    theRenderNode.frame = {
      x: 10,
      y: 100,
      width: 100,
      height: 50
    };
    theRenderNode.backgroundColor = 0xFF2787D9;
    rootNode.getRenderNode()?.appendChild(theRenderNode);
    return rootNode;
  }
}

@Entry
@Component
export struct CustomDrawCanvas {
  myNodeController: MyNodeController = new MyNodeController();
  myNodeController1: MyNodeController1 = new MyNodeController1();

  build() {
    // [StartExclude custom_draw_canvas]
    NavDestination() {
      // [EndExclude custom_draw_canvas]
      Row() {
        Column() {
          NodeContainer(this.myNodeController)
        }
        .height('100%')
        .width('45%');

        Column() {
          NodeContainer(this.myNodeController1)
        }
        .height('100%')
        .width('45%');
      };

      // [StartExclude custom_draw_canvas]
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.CustomDrawCanvas')替换为实际资源文件，在本示例中该资源文件的value值为"调整自定义绘制Canvas的变换矩阵"
    .title($r('app.string.CustomDrawCanvas'));

    // [EndExclude custom_draw_canvas]
  }
}

// [End custom_draw_canvas]