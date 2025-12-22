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

// [Start rendering_properties]
import { RenderNode, FrameNode, NodeController, ShapeMask, ShapeClip } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

const TEST_TAG: string = 'RenderNode';
const mask = new ShapeMask();
mask.setRectShape({
  left: 0,
  right: 150,
  top: 0,
  bottom: 150
});
mask.fillColor = 0X55FF0000;
mask.strokeColor = 0XFFFF0000;
mask.strokeWidth = 24;

const clip = new ShapeClip();
clip.setCommandPath({ commands: 'M100 0 L0 100 L50 200 L150 200 L200 100 Z' });

const renderNode = new RenderNode();
renderNode.backgroundColor = 0xffff0000;
renderNode.size = { width: 100, height: 100 };

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
export struct RenderingProperties {
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    // [StartExclude rendering_properties]
    NavDestination() {
      // [EndExclude rendering_properties]
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
        Column() {
          NodeContainer(this.myNodeController);
        };

        // 设置RenderNode的位置
        Button('position')
          .width(300)
          .onClick(() => {
            renderNode.position = { x: 10, y: 10 };
            hilog.info(DOMAIN, TEST_TAG, ' position:' + JSON.stringify(renderNode.position));
          });

        // 设置RenderNode的轴心
        Button('pivot')
          .width(300)
          .onClick(() => {
            renderNode.pivot = { x: 0.5, y: 0.6 };
            hilog.info(DOMAIN, TEST_TAG, ' pivot:' + JSON.stringify(renderNode.pivot));
          });

        // 修改RenderNode的缩放比例
        Button('scale')
          .width(300)
          .onClick(() => {
            renderNode.scale = { x: 0.5, y: 1 };
            hilog.info(DOMAIN, TEST_TAG, ' scale:' + JSON.stringify(renderNode.scale));
          });

        // 设置RenderNode的平移量
        Button('translation')
          .width(300)
          .onClick(() => {
            renderNode.translation = { x: 100, y: 0 };
            hilog.info(DOMAIN, TEST_TAG, ' translation:' + JSON.stringify(renderNode.translation));
          });

        // 设置RenderNode的旋转角度
        Button('rotation')
          .width(300)
          .onClick(() => {
            renderNode.rotation = { x: 45, y: 0, z: 0 };
            hilog.info(DOMAIN, TEST_TAG, ' rotation:' + JSON.stringify(renderNode.rotation));
          });

        // 设置RenderNode的变换矩阵
        Button('transform')
          .width(300)
          .onClick(() => {
            renderNode.transform = [
              1, 0, 0, 0,
              0, 2, 0, 0,
              0, 0, 1, 0,
              0, 0, 0, 1
            ];
            hilog.info(DOMAIN, TEST_TAG, ' transform:' + JSON.stringify(renderNode.transform));
          });

        // 设置RenderNode的阴影属性
        Button('shadow')
          .width(300)
          .onClick(() => {
            renderNode.shadowElevation = 10; // 设置阴影的光照高度
            renderNode.shadowColor = 0XFF00FF00;
            renderNode.shadowOffset = { x: 10, y: 10 };
            renderNode.shadowAlpha = 0.1;
            hilog.info(DOMAIN, TEST_TAG, ' shadowElevation:' + JSON.stringify(renderNode.shadowElevation));
            hilog.info(DOMAIN, TEST_TAG, ' shadowColor:' + JSON.stringify(renderNode.shadowColor));
            hilog.info(DOMAIN, TEST_TAG, ' shadowOffset:' + JSON.stringify(renderNode.shadowOffset));
            hilog.info(DOMAIN, TEST_TAG, ' shadowAlpha:' + JSON.stringify(renderNode.shadowAlpha));
          });

        // 设置RenderNode的阴影模糊半径
        Button('shadowRadius')
          .width(300)
          .onClick(() => {
            renderNode.shadowOffset = { x: 10, y: 10 };
            renderNode.shadowAlpha = 0.7;
            renderNode.shadowRadius = 30;
            hilog.info(DOMAIN, TEST_TAG, ' shadowOffset:' + JSON.stringify(renderNode.shadowOffset));
            hilog.info(DOMAIN, TEST_TAG, ' shadowAlpha:' + JSON.stringify(renderNode.shadowAlpha));
            hilog.info(DOMAIN, TEST_TAG, ' shadowRadius:' + JSON.stringify(renderNode.shadowRadius));
          });

        // 设置RenderNode的边框样式
        Button('border')
          .width(300)
          .onClick(() => {
            renderNode.borderWidth = {
              left: 8,
              top: 8,
              right: 8,
              bottom: 8
            };
            renderNode.borderStyle = {
              left: BorderStyle.Solid,
              top: BorderStyle.Dotted,
              right: BorderStyle.Dashed,
              bottom: BorderStyle.Solid
            }
            renderNode.borderColor = {
              left: 0xFF0000FF,
              top: 0xFF0000FF,
              right: 0xFF0000FF,
              bottom: 0xFF0000FF
            };
            renderNode.borderRadius = {
              topLeft: 32,
              topRight: 32,
              bottomLeft: 32,
              bottomRight: 32
            };
            hilog.info(DOMAIN, TEST_TAG, ' borderWidth:' + JSON.stringify(renderNode.borderWidth));
            hilog.info(DOMAIN, TEST_TAG, ' borderStyle:' + JSON.stringify(renderNode.borderStyle));
            hilog.info(DOMAIN, TEST_TAG, ' borderColor:' + JSON.stringify(renderNode.borderColor));
            hilog.info(DOMAIN, TEST_TAG, ' borderRadius:' + JSON.stringify(renderNode.borderRadius));
          })

        // 设置RenderNode的遮罩
        Button('shapeMask')
          .width(300)
          .onClick(() => {
            renderNode.shapeMask = mask;
            hilog.info(DOMAIN, TEST_TAG, ' shapeMask:' + JSON.stringify(renderNode.shapeMask));
          });

        // 设置RenderNode的剪裁形状
        Button('shapeClip')
          .width(300)
          .onClick(() => {
            renderNode.shapeClip = clip;
            hilog.info(DOMAIN, TEST_TAG, ' shapeClip:' + JSON.stringify(renderNode.shapeClip));
          });
      }
      .padding({
        left: 35,
        right: 35,
        top: 35,
        bottom: 35
      })
      .width('100%')
      .height('100%');

      // [StartExclude rendering_properties]
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.RenderingProperties')替换为实际资源文件，在本示例中该资源文件的value值为"设置和获取渲染相关属性"
    .title($r('app.string.RenderingProperties'));

    // [EndExclude rendering_properties]
  }
}

// [End rendering_properties]