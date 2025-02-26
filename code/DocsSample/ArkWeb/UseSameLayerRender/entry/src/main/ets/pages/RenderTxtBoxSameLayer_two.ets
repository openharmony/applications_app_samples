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

import webview from '@ohos.web.webview';
import { UIContext } from '@ohos.arkui.UIContext';
import { NodeController, BuilderNode, NodeRenderType, FrameNode } from '@ohos.arkui.node';

@Observed
declare class Params{
  public elementId: string
  public textOne: string
  public textTwo: string
  public width: number
  public height: number
}

declare class NodeControllerParams {
  public surfaceId: string
  public type: string
  public renderType: NodeRenderType
  public embedId: string
  public width: number
  public height: number
}

// 用于控制和反馈对应的NodeContainer上的节点的行为，需要与NodeContainer一起使用。
class MyNodeController extends NodeController {
  private rootNode: BuilderNode<[Params]> | undefined | null;
  private embedId_: string = '';
  private surfaceId_: string = '';
  private renderType_: NodeRenderType = NodeRenderType.RENDER_TYPE_DISPLAY;
  private width_: number = 0;
  private height_: number = 0;
  private type_: string = '';
  private isDestroy_: boolean = false;

  setRenderOption(params: NodeControllerParams) {
    this.surfaceId_ = params.surfaceId;
    this.renderType_ = params.renderType;
    this.embedId_ = params.embedId;
    this.width_ = params.width;
    this.height_ = params.height;
    this.type_ = params.type;
  }

  // 必须要重写的方法，用于构建节点数、返回节点数挂载在对应NodeContainer中。
  // 在对应NodeContainer创建的时候调用、或者通过rebuild方法调用刷新。
  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.isDestroy_) { // rootNode为null
      return null;
    }
    if (!this.rootNode) {// rootNode 为undefined时
      this.rootNode = new BuilderNode(uiContext, { surfaceId: this.surfaceId_, type: this.renderType_ });
      if(this.rootNode) {
        this.rootNode.build(
          wrapBuilder(textInputBuilder), {  textOne: 'myTextInput', width: this.width_, height: this.height_  });
        return this.rootNode.getFrameNode();
      }else{
        return null;
      }
    }
    // 返回FrameNode节点。
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
    return this.embedId_;
  }

  setDestroy(isDestroy: boolean): void {
    this.isDestroy_ = isDestroy;
    if (this.isDestroy_) {
      this.rootNode = null;
    }
  }

  postEvent(event: TouchEvent | undefined): boolean {
    return this.rootNode?.postTouchEvent(event) as boolean;
  }
}

@Component
struct TextInputComponent {
  @Prop params: Params;
  @State bkColor: Color = Color.White;

  build() {
    Column() {
      TextInput({text: '', placeholder: 'please input your word...'})
        .placeholderColor(Color.Gray)
        .id(this.params?.elementId)
        .placeholderFont({size: 13, weight: 400})
        .caretColor(Color.Gray)
        .fontSize(14)
        .fontColor(Color.Black)
    }
    //自定义组件中的最外层容器组件宽高应该为同层标签的宽高
    .width(this.params.width)
    .height(this.params.height)
  }
}

// @Builder中为动态组件的具体组件内容。
@Builder
function textInputBuilder(params:Params) {
  TextInputComponent({params: params})
    .width(params.width)
    .height(params.height)
    .backgroundColor(Color.White)
}

@Entry
@Component
struct Page{
  browserTabController: WebviewController = new webview.WebviewController()
  private nodeControllerMap: Map<string, MyNodeController> = new Map();
  @State componentIdArr: Array<string> = [];
  @State posMap: Map<string, Position | undefined> = new Map();
  @State widthMap: Map<string, number> = new Map();
  @State heightMap: Map<string, number> = new Map();
  @State positionMap: Map<string, Edges> = new Map();
  @State edges: Edges = {};

  build() {
    Row() {
      Column() {
        Stack() {
          ForEach(this.componentIdArr, (componentId: string) => {
            NodeContainer(this.nodeControllerMap.get(componentId))
              .position(this.positionMap.get(componentId))
              .width(this.widthMap.get(componentId))
              .height(this.heightMap.get(componentId))
          }, (embedId: string) => embedId)
          // Web组件加载本地test2.html页面。
          Web({src: $rawfile('test2.html'), controller: this.browserTabController})
            // 注册同层标签为'object'，类型为'test'前缀
            .registerNativeEmbedRule('object', 'test')
              // 配置同层渲染开关开启。
            .enableNativeEmbedMode(true)
              // 获取embed标签的生命周期变化数据。
            .onNativeEmbedLifecycleChange((embed) => {
              console.log('NativeEmbed surfaceId' + embed.surfaceId);
              // 如果使用embed.info.id作为映射nodeController的key，请在h5页面显式指定id
              const componentId = embed.info?.id?.toString() as string;
              if (embed.status == NativeEmbedStatus.CREATE) {
                console.log('NativeEmbed create' + JSON.stringify(embed.info));
                // 创建节点控制器、设置参数并rebuild
                let nodeController = new MyNodeController();
                // embed.info.width和embed.info.height单位是px格式，需要转换成ets侧的默认单位vp
                nodeController.setRenderOption({surfaceId : embed.surfaceId as string,
                  type : embed.info?.type as string,
                  renderType : NodeRenderType.RENDER_TYPE_TEXTURE,
                  embedId : embed.embedId as string,
                  width : px2vp(embed.info?.width),
                  height : px2vp(embed.info?.height)})
                this.edges = {
                  left: `${embed.info?.position?.x as number}px`,
                  top: `${embed.info?.position?.y as number}px`
                };
                nodeController.setDestroy(false);
                //根据web传入的embed的id属性作为key，将nodeController存入Map
                this.nodeControllerMap.set(componentId, nodeController);
                this.widthMap.set(componentId, px2vp(embed.info?.width));
                this.heightMap.set(componentId, px2vp(embed.info?.height));
                this.positionMap.set(componentId, this.edges);
                // 将web传入的embed的id属性存入@State状态数组变量中，用于动态创建nodeContainer节点容器,需要将push动作放在set之后
                this.componentIdArr.push(componentId);
              } else if (embed.status == NativeEmbedStatus.UPDATE) {
                let nodeController = this.nodeControllerMap.get(componentId);
                console.log('NativeEmbed update' + JSON.stringify(embed));
                this.edges = {
                  left: `${embed.info?.position?.x as number}px`,
                  top: `${embed.info?.position?.y as number}px`
                };
                this.positionMap.set(componentId, this.edges);
                this.widthMap.set(componentId, px2vp(embed.info?.width));
                this.heightMap.set(componentId, px2vp(embed.info?.height));
                nodeController?.updateNode(
                  {textOne: 'update', width: px2vp(embed.info?.width), height: px2vp(embed.info?.height)} as ESObject);
              } else if (embed.status == NativeEmbedStatus.DESTROY) {
                console.log('NativeEmbed destroy' + JSON.stringify(embed));
                let nodeController = this.nodeControllerMap.get(componentId);
                nodeController?.setDestroy(true);
                this.nodeControllerMap.clear();
                this.positionMap.delete(componentId);
                this.widthMap.delete(componentId);
                this.heightMap.delete(componentId);
                this.componentIdArr.filter((value: string) => value != componentId);
              } else {
                console.log('NativeEmbed status' + embed.status);
              }
            })// 获取同层渲染组件触摸事件信息。
            .onNativeEmbedGestureEvent((touch) => {
              console.log('NativeEmbed onNativeEmbedGestureEvent' + JSON.stringify(touch.touchEvent));
              this.componentIdArr.forEach((componentId: string) => {
                let nodeController = this.nodeControllerMap.get(componentId);
                // 将获取到的同层区域的事件发送到该区域embedId对应的nodeController上
                if(nodeController?.getEmbedId() == touch.embedId) {
                  let ret = nodeController?.postEvent(touch.touchEvent);
                  if(ret) {
                    console.log('onNativeEmbedGestureEvent success ' + componentId);
                  } else {
                    console.log('onNativeEmbedGestureEvent fail ' + componentId);
                  }
                  if(touch.result) {
                    // 通知Web组件手势事件消费结果
                    touch.result.setGestureEventResult(ret);
                  }
                }
              })
            })
        }
      }
    }
  }
}
