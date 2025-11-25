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

// 创建NodeController
// common.ets
import { UIContext } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { NodeController, BuilderNode, Size, FrameNode } from '@kit.ArkUI';

// @Builder中为动态组件的具体组件内容
// Data为入参封装类
class Data {
  public url: string = 'https://www.example.com';
  public controller: WebviewController = new webview.WebviewController();
}

@Builder
function webBuilder(data: Data) {
  Column() {
    Web({ src: data.url, controller: data.controller })
      .domStorageAccess(true)
      .zoomAccess(true)
      .fileAccess(true)
      .mixedMode(MixedMode.All)
      .width('100%')
      .height('100%')
      .onPageEnd(() => {
        // 输出Web页面加载完成时间
        console.info('load page end time: ', Date.now());
      })
  }
}

let wrap = wrapBuilder<Data[]>(webBuilder);

// 用于控制和反馈对应的NodeContainer上的节点的行为，需要与NodeContainer一起使用
export class MyNodeController extends NodeController {
  private rootNode: BuilderNode<Data[]> | null = null;
  private root: FrameNode | null = null;
  private rootWebviewController: webview.WebviewController | null = null;

  // 必须要重写的方法，用于构建节点数、返回节点挂载在对应NodeContainer中
  // 在对应NodeContainer创建的时候调用、或者通过rebuild方法调用刷新
  makeNode(uiContext: UIContext): FrameNode | null {
    console.log(' uicontext is undifined : ' + (uiContext === undefined));
    if (this.rootNode !== null) {
      const parent = this.rootNode.getFrameNode()?.getParent();
      if (parent) {
        console.info(JSON.stringify(parent.getInspectorInfo()));
        parent.removeChild(this.rootNode.getFrameNode());
        this.root = null;
      }
      this.root = new FrameNode(uiContext);
      this.root.appendChild(this.rootNode.getFrameNode());
      // 返回FrameNode节点
      return this.root;
    }
    // 返回null控制动态组件脱离绑定节点
    return null;
  }

  // 当布局大小发生变化时进行回调
  aboutToResize(size: Size) {
    console.log('aboutToResize width : ' + size.width + ' height : ' + size.height)
  }

  // 当controller对应的NodeContainer在Appear的时候进行回调
  aboutToAppear() {
    console.log('aboutToAppear')
  }

  // 当controller对应的NodeContainer在Disappear的时候进行回调
  aboutToDisappear() {
    console.log('aboutToDisappear')
  }

  // 此函数为自定义函数，可作为初始化函数使用
  // 通过UIContext初始化BuilderNode，再通过BuilderNode中的build接口初始化@Builder中的内容
  initWeb(url: string, uiContext: UIContext, control: WebviewController) {
    if (this.rootNode !== null) {
      return;
    }
    // 绑定预创建的WebviewController
    this.rootWebviewController = control;
    // 创建节点，需要uiContext
    this.rootNode = new BuilderNode(uiContext)
    // 创建动态Web组件
    this.rootNode.build(wrap, { url: url, controller: control })
  }

  // 此函数为自定义函数，用于重新加载Web页面
  loadUrl(url: string) {
    if (this.rootWebviewController !== null) {
      // 复用预创建组件，重新加载url
      this.rootWebviewController.loadUrl(url);
    }
  }
}

// 创建Map保存所需要的NodeController
let nodeMap: Map<string, MyNodeController | undefined> = new Map();
// 创建Map保存所需要的WebViewController
let controllerMap: Map<string, WebviewController | undefined> = new Map();

// 初始化需要UIContext 需在Ability获取
export const createNWeb = (url: string, uiContext: UIContext) => {
  // 创建NodeController
  let baseNode = new MyNodeController();
  let controller = new webview.WebviewController();
  // 初始化自定义web组件
  baseNode.initWeb(url, uiContext, controller);
  controllerMap.set(url, controller)
  nodeMap.set(url, baseNode);
}

// 自定义获取NodeController接口
export const getNWeb = (url: string): MyNodeController | undefined => {
  if (!nodeMap.get(url) && nodeMap.get('about://blank')) {
    // 获取预创建的空白组件
    let webNode = nodeMap.get('about://blank') as MyNodeController;
    // 重新加载url
    webNode.loadUrl(url);
    return webNode;
  }
  return nodeMap.get(url);
}