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

// [Start mesh]
import { FrameNode, NodeController, RenderNode } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { drawing } from '@kit.ArkGraphics2D';

let offCanvas: OffscreenCanvas = new OffscreenCanvas(150, 150);
let ctx = offCanvas.getContext('2d');

class DrawingRenderNode extends RenderNode {
  private verts_: Array<number> = [0, 0, 50, 0, 410, 0, 0, 180, 50, 180, 410, 180, 0, 360, 50, 360, 410, 360];

  setVerts(verts: Array<number>): void {
    this.verts_ = verts
  }

  async draw(context: DrawContext) {
    const canvas = context.canvas;
    let pixelMap = ctx.getPixelMap(0, 0, 150, 150);
    const brush = new drawing.Brush(); // 只支持brush，使用pen没有绘制效果。
    canvas.attachBrush(brush);
    let verts: number[] = [0, 0, 410, 0, 50, 0, 0, 180, 50, 180, 410, 180, 0, 360, 410, 360, 50, 360];
    ; // 18
    canvas.drawPixelMapMesh(pixelMap, 2, 2, verts, 0, null, 0);
    canvas.detachBrush();
  }
}

const renderNode = new DrawingRenderNode();
renderNode.frame = {
  x: 0,
  y: 0,
  width: 150,
  height: 150
};

class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode | null {
    this.rootNode = new FrameNode(uiContext);

    const rootRenderNode = this.rootNode.getRenderNode();
    if (rootRenderNode !== null) {
      rootRenderNode.appendChild(renderNode);
    }
    return this.rootNode;
  }
}

@Entry
@Component
struct Mesh {
  private myNodeController: MyNodeController = new MyNodeController();
  @State showShape: boolean = false;
  @State pixelMap: image.PixelMap | undefined = undefined;
  @State shapeWidth: number = 150;
  @State strokeWidth: number = 1;
  @State meshArray: Array<number> = [0, 0, 50, 0, 410, 0, 0, 180, 50, 180, 410, 180, 0, 360, 50, 360, 410, 360];

  aboutToAppear(): void {
    // 'common/image/startIcon.png'需要替换为开发者所需的图像资源文件
    let img: ImageBitmap = new ImageBitmap('common/image/startIcon.png');
    ctx.drawImage(img, 0, 0, 100, 100);
    this.pixelMap = ctx.getPixelMap(0, 0, 150, 150);
  }

  build() {
    Column() {
      Image(this.pixelMap)
        .backgroundColor(Color.Red)
        .width(150)
        .height(150)
        .onClick(() => {
          // 'common/image/startIcon.png'需要替换为开发者所需的图像资源文件
          let img: ImageBitmap = new ImageBitmap('common/image/startIcon.png');
          ctx.drawImage(img, 0, 0, 100, 100);
          this.pixelMap = ctx.getPixelMap(1, 1, 150, 150);
          this.myNodeController.rebuild();
          this.strokeWidth += 1;
        })

      NodeContainer(this.myNodeController)
        .width(150)
        .height(150)
        .backgroundColor(Color.Grey)
        .onClick(() => {
          this.meshArray = [0, 0, 50, 0, 410, 0, 0, 180, 50, 180, 410, 180, 0, 360, 50, 360, 410, 360, 0];
        })
      Button('change mesh')
        .margin(5)
        .onClick(() => {
          this.meshArray = [0, 0, 410, 0, 50, 0, 0, 180, 50, 180, 410, 180, 0, 360, 410, 360, 50, 360];
        })
      Button('Show Shape')
        .margin(5)
        .onClick(() => {
          this.showShape = !this.showShape;
        })

      if (this.showShape) {
        Shape(this.pixelMap) {
          Path().width(150).height(60).commands('M0 0 L400 0 L400 150 Z')
        }
        .fillOpacity(0.2)
        .backgroundColor(Color.Grey)
        .width(this.shapeWidth)
        .height(150)
        .mesh(this.meshArray, 2, 2)
        .fill(0x317AF7)
        .stroke(0xEE8443)
        .strokeWidth(this.strokeWidth)
        .strokeLineJoin(LineJoinStyle.Miter)
        .strokeMiterLimit(5)

        Shape(this.pixelMap) {
          Path().width(150).height(60).commands('M0 0 L400 0 L400 150 Z')
        }
        .fillOpacity(0.2)
        .backgroundColor(Color.Grey)
        .width(this.shapeWidth)
        .height(150)
        .fill(0x317AF7)
        .stroke(0xEE8443)
        .strokeWidth(this.strokeWidth)
        .strokeLineJoin(LineJoinStyle.Miter)
        .strokeMiterLimit(5)
        .onDragStart(() => {
        })

        // mesh只对shape传入pixelMap时生效，此处不生效
        Shape() {
          Path().width(150).height(60).commands('M0 0 L400 0 L400 150 Z')
        }
        .fillOpacity(0.2)
        .backgroundColor(Color.Grey)
        .width(this.shapeWidth)
        .height(150)
        .mesh(this.meshArray, 2, 2)
        .fill(0x317AF7)
        .stroke(0xEE8443)
        .strokeWidth(this.strokeWidth)
        .strokeLineJoin(LineJoinStyle.Miter)
        .strokeMiterLimit(5)
        .onClick(() => {
          this.pixelMap = undefined;
        })
      }
    }
  }
}
// [End mesh]