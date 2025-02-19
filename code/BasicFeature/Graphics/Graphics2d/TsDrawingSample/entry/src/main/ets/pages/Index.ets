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

import { NodeController, FrameNode, RenderNode } from "@ohos.arkui.node";
import { UIContext } from '@ohos.arkui.UIContext';
import drawing from "@ohos.graphics.drawing";
import display from '@ohos.display';
import image from '@ohos.multimedia.image';
import hilog from '@ohos.hilog';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import {CanvasRenderNodeCropping, CanvasRenderNodeMatrix, CanvasRenderNodeCombination} from "../common/CanvasRenderNode";
import {ShapeRenderNodeCanvasPen, ShapeRenderNodeCanvasBrush} from "../common/ShapeRenderNode";
import {PathRenderNode} from "../common/PathRenderNode";
import { MyRenderNodePathBrush, MyRenderNodePathShader, MyRenderNodePathPen } from '../common/MyRenderNodePath';
import {ImageRenderNode, ImageRectRenderNode} from '../common/ImageRenderNode';
import {TextBlobRenderNode} from '../common/TextBlobRenderNode';
import {ComplexRenderNode} from '../common/ComplexRenderNode';

const TAG = 'tsdrawingsample';
let screen = display.getDefaultDisplaySync();
let screenWidth: number = screen.width;
let screenHeight: number = screen.height;

let canvas_: drawing.Canvas;
let pixelMap_: image.PixelMap | undefined;

function func(node: RenderNode) {
  node.frame = {
    x: 0,
    y: 0,
    width: screenWidth,
    height: screenHeight
  }
}

const canvasCroppingNode = new CanvasRenderNodeCropping();
func(canvasCroppingNode);

const canvasMatrixNode = new CanvasRenderNodeMatrix();
func(canvasMatrixNode);

const canvasCombinationNode = new CanvasRenderNodeCombination();
func(canvasCombinationNode);

const shapePenNode = new ShapeRenderNodeCanvasPen();
func(shapePenNode);

const shapeBrushNode = new ShapeRenderNodeCanvasBrush();
func(shapeBrushNode);

const pathNode = new PathRenderNode();
func(pathNode);

const pathBrushNode = new MyRenderNodePathBrush();
func(pathBrushNode);

const pathPenNode = new MyRenderNodePathPen();
func(pathPenNode);

const pathShaderNode = new MyRenderNodePathShader();
func(pathShaderNode);

const imagePixmapNode = new ImageRenderNode();
func(imagePixmapNode);

const imageRectNode = new ImageRectRenderNode();
func(imageRectNode);

const textblobNode = new TextBlobRenderNode();
func(textblobNode);

const complexNode = new ComplexRenderNode();
func(complexNode);


class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode === null) {
      return this.rootNode;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      renderNode.frame = {
        x: 0,
        y: 0,
        width: 10,
        height: 500
      };
      renderNode.pivot = { x: 50, y: 50 };
    }
    return this.rootNode;
  }

  addNode(node: RenderNode): void {
    if (this.rootNode === null) {
      return;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      renderNode.appendChild(node);
    }
  }

  clearNodes(): void {
    if (this.rootNode === null) {
      return;
    }
    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      renderNode.clearChildren();
    }
  }
}


@Entry
@Component
struct RenderTest {
  private myNodeController: MyNodeController = new MyNodeController();

  aboutToAppear() {
    const imageContext: Context = getContext(this);
    const resourceMgr: resourceManager.ResourceManager = imageContext.resourceManager;
    resourceMgr.getRawFileContent('startIcon.png').then((fileData: Uint8Array) => {
      hilog.info(0x0001, TAG, 'Succeeded in getting RawFileContent');
      const buffer = fileData.buffer.slice(0);
      const imageSource: image.ImageSource = image.createImageSource(buffer);
      imageSource.createPixelMap().then((pMap: image.PixelMap) => {
        imagePixmapNode.setPixelMap(pMap);
        imageRectNode.setPixelMap(pMap);
      }).catch((err: BusinessError) => {
        hilog.error(0x0001, TAG, 'Failed to creating PixelMap');
      });
    }).catch((err: BusinessError) => {
      hilog.error(0x0001, TAG, 'Failed to get RawFileContent');
    });
  }

  build() {
    Column() {
      Row() {
        NodeContainer(this.myNodeController)
          .height('100%')
      }
      .width('100%')
      .height('80%')
      GridRow({
        columns: 1,
        gutter: {x: 5, y: 10},
      }) {
        GridCol({ span: { xs: 1, sm: 2, md: 3, lg: 4 }, offset: 0, order: 0 }){
          Row() {
            Button("Canvas")
              .margin({ top: 10, right: 10 })
              .onClick(() => {
                this.myNodeController.clearNodes();
                this.myNodeController.addNode(canvasCroppingNode);
                this.myNodeController.addNode(canvasMatrixNode);
                this.myNodeController.addNode(canvasCombinationNode);
              })
            Button("Geometric shape")
              .margin({ top: 10, right: 10 })
              .onClick(() => {
                this.myNodeController.clearNodes();
                this.myNodeController.addNode(shapePenNode);
                this.myNodeController.addNode(shapeBrushNode);
              })
            Button("Path")
              .margin({ top: 10, right: 10 })
              .onClick(() => {
                this.myNodeController.clearNodes();
                this.myNodeController.addNode(pathNode);
                this.myNodeController.addNode(pathBrushNode);
                this.myNodeController.addNode(pathPenNode);
                this.myNodeController.addNode(pathShaderNode);
              })
        }
      }
        GridCol({ span: { xs: 1, sm: 2, md: 3, lg: 4 }, offset: 0, order: 0 }){
          Row(){
            Button("Image and Font")
              .margin({ right: 8 })
              .onClick(() => {
                this.myNodeController.clearNodes();
                this.myNodeController.addNode(imageRectNode);
                this.myNodeController.addNode(imagePixmapNode);
                this.myNodeController.addNode(textblobNode);
              })
            Button("Complex")
              .margin({ right: 8 })
              .onClick(() => {
                this.myNodeController.clearNodes();
                this.myNodeController.addNode(complexNode);
              })
          }
        }
      }
      .width('100%')
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .layoutWeight(1)
    }
  }

  public async CreateBitmapCanvas() {
    const color: ArrayBuffer = new ArrayBuffer(screenWidth * screenHeight * 4);
    let opts: image.InitializationOptions =
      { editable: true, pixelFormat: 3, size: { height: screenHeight, width: screenWidth } };
    pixelMap_ = await image.createPixelMap(color, opts);
    if (pixelMap_ === null || pixelMap_ === undefined) {
      hilog.info(0x0001, TAG, 'create pixelMap error');
      return;
    }

    // 创建离屏canvas，与pixelMap绑定
    canvas_ = new drawing.Canvas(pixelMap_);
    if (canvas_ === null || canvas_ === undefined) {
      hilog.info(0x0001, TAG, 'create canvas_ error');
      return;
    }
    hilog.info(0x0001, TAG, 'create canvas_ success');
  }
}
