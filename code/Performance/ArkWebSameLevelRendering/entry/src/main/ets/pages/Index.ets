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

import { PRODUCT_DATA } from '../viewmodel/GoodsViewModel';
import { ProductDataModel } from '../model/GoodsModel';
import { BuilderNode, FrameNode, NodeController, NodeRenderType } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';

// Margin vertical
const MARGIN_VERTICAL: number = 8;
// Font weight
const FONT_WEIGHT: number = 500;
// Placeholder
const PLACEHOLDER: ResourceStr = $r('app.string.embed_search');

declare class Params {
  width: number;
  height: number;
}

declare class NodeControllerParams {
  surfaceId: string;
  type: string;
  renderType: NodeRenderType;
  embedId: string;
  width: number;
  height: number;
}

class SearchNodeController extends NodeController {
  private rootNode: BuilderNode<[Params]> | undefined | null = null;
  private embedId: string = '';
  private surfaceId: string = '';
  private renderType: NodeRenderType = NodeRenderType.RENDER_TYPE_DISPLAY;
  private componentWidth: number = 0;
  private componentHeight: number = 0;
  private componentType: string = '';

  /**
   * 设置渲染参数
   * 
   * @param params 渲染参数
   */
  setRenderOption(params: NodeControllerParams): void {
    this.surfaceId = params.surfaceId;
    this.renderType = params.renderType;
    this.embedId = params.embedId;
    this.componentWidth = params.width;
    this.componentHeight = params.height;
    this.componentType = params.type;
  }

  /**
   * 创建节点
   *
   * @param uiContext UIContext
   * @returns 节点
   */
  makeNode(uiContext: UIContext): FrameNode | null {
    this.rootNode = new BuilderNode(uiContext, { surfaceId: this.surfaceId, type: this.renderType });
    if (this.componentType === 'native/component') {
      this.rootNode.build(wrapBuilder(searchBuilder), { width: this.componentWidth, height: this.componentHeight });
    }
    return this.rootNode.getFrameNode();
  }

  setBuilderNode(rootNode: BuilderNode<Params[]> | null): void {
    this.rootNode = rootNode;
  }

  getBuilderNode(): BuilderNode<[Params]> | undefined | null {
    return this.rootNode;
  }

  updateNode(arg: Object): void {
    this.rootNode?.update(arg);
  }

  getEmbedId(): string {
    return this.embedId;
  }

  postEvent(event: TouchEvent | undefined): boolean {
    return this.rootNode?.postTouchEvent(event) as boolean;
  }
}

@Component
struct SearchComponent {
  @Prop params: Params;
  controller: SearchController = new SearchController()

  build() {
    Column({ space: MARGIN_VERTICAL }) {
      Text($r('app.string.embed_mall'))
        .fontSize($r('app.string.ohos_id_text_size_body4'))
        .fontWeight(FONT_WEIGHT)
        .fontFamily('HarmonyHeiTi-Medium')
      Row() {
        Search({ placeholder: PLACEHOLDER, controller: this.controller })
          .backgroundColor(Color.White)
      }
      .width($r('app.string.embed_full_percent'))
      .margin($r('app.integer.embed_row_margin'))

      Grid() {
        ForEach(PRODUCT_DATA, (item: ProductDataModel, index: number) => {
          GridItem() {
            Column({ space: MARGIN_VERTICAL }) {
              Image(item.imageRes).width($r('app.integer.embed_image_size'))
              Row({ space: MARGIN_VERTICAL }) {
                Text(item.title)
                  .fontSize($r('app.string.ohos_id_text_size_body1'))
                  .width(100)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(item.price)
                  .fontSize($r('app.string.ohos_id_text_size_body1'))
                  .width(50)
                  .maxLines(1)
              }
            }
            .backgroundColor($r('app.color.ohos_id_color_background'))
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .width($r('app.string.embed_full_percent'))
            .height($r('app.string.embed_full_percent'))
            .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
          }
        }, (item: ProductDataModel, index: number) => index.toString())
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .rowsGap($r('app.string.ohos_id_elements_margin_vertical_m'))
      .columnsGap($r('app.string.ohos_id_elements_margin_vertical_m'))
      .width($r('app.string.embed_full_percent'))
      .height($r('app.string.embed_sixty_percent'))
      .backgroundColor($r('app.color.ohos_id_color_sub_background'))
    }
    .padding($r('app.string.ohos_id_card_margin_start'))
    .width(this.params.width)
    .height(this.params.height)
  }
}

@Builder
function searchBuilder(params: Params) {
  SearchComponent({ params: params })
    .backgroundColor($r('app.color.ohos_id_color_sub_background'))
}

@Entry
@Component
struct Index {
  browserTabController: WebviewController = new webview.WebviewController();
  @State componentIdArr: Array<string> = [];
  private nodeControllerMap: Map<string, SearchNodeController> = new Map();

  build() {
    Stack() {
      ForEach(this.componentIdArr, (componentId: string) => {
        NodeContainer(this.nodeControllerMap.get(componentId));
      }, (embedId: string) => embedId)
      Web({ src: $rawfile('embed_view.html'), controller: this.browserTabController })
        .backgroundColor($r('app.color.ohos_id_color_sub_background'))
        .zoomAccess(false)
        .enableNativeEmbedMode(true)
        .onNativeEmbedLifecycleChange((embed) => {
          const componentId = embed.info?.id?.toString() as string
          if (embed.status === NativeEmbedStatus.CREATE) {
            let nodeController = new SearchNodeController();
            nodeController.setRenderOption({
              surfaceId: embed.surfaceId as string,
              type: embed.info?.type as string,
              renderType: NodeRenderType.RENDER_TYPE_TEXTURE,
              embedId: embed.embedId as string,
              width: this.getUIContext().px2vp(embed.info?.width),
              height: this.getUIContext().px2vp(embed.info?.height)
            });
            nodeController.rebuild();
            this.nodeControllerMap.set(componentId, nodeController);
            this.componentIdArr.push(componentId);
          } else if (embed.status === NativeEmbedStatus.UPDATE) {
            let nodeController = this.nodeControllerMap.get(componentId);
            nodeController?.updateNode({
              text: 'update',
              width: this.getUIContext().px2vp(embed.info?.width),
              height: this.getUIContext().px2vp(embed.info?.height)
            } as ESObject);
            nodeController?.rebuild();
          } else {
            let nodeController = this.nodeControllerMap.get(componentId);
            nodeController?.setBuilderNode(null);
            nodeController?.rebuild();
          }
        })
        .onNativeEmbedGestureEvent((touch) => {
          this.componentIdArr.forEach((componentId: string) => {
            let nodeController = this.nodeControllerMap.get(componentId);
            if (nodeController?.getEmbedId() === touch.embedId) {
              nodeController?.postEvent(touch.touchEvent);
            }
          })
        })
    }
  }
}
