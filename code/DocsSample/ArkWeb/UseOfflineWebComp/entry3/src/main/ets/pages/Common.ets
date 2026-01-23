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

// [Start manage_dynamic_webview_components_functions]
// Common.ets
// 创建NodeController
import { UIContext, NodeController, BuilderNode, Size, FrameNode } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';

// @Builder中为动态组件的具体组件内容
// Data为入参封装类
class Data {
  public url: ResourceStr = 'www.example.com';
  public controller: WebviewController = new webview.WebviewController();
  public node: MyNodeController | undefined = undefined;
}

@Builder
function webBuilder(data: Data) {
  Column() {
    Web({ src: data.url, controller: data.controller })
      .width('100%')
      .height('100%')
      // FirstMeaningfulPaint的时候
      .onFirstMeaningfulPaint(() => {
        console.info('onFirstMeaningfulPaint, url = ' + data.url + ', isUsing = ' + data.node?.isBound());
        data.node?.stopPreload();
      })
  }
}

let wrap = wrapBuilder<Data[]>(webBuilder);

// 用于控制和反馈对应的NodeContainer上的节点的行为，需要与NodeContainer一起使用
export class MyNodeController extends NodeController {
  private bindCount: number = 0;
  public rootNode: BuilderNode<Data[]> | null = null;
  private webController: WebviewController = new webview.WebviewController();
  private originUrl: ResourceStr | undefined = undefined;

  // 必须要重写的方法，用于构建节点数、返回节点挂载在对应NodeContainer中
  // 在对应NodeContainer创建的时候调用、或者通过rebuild方法调用刷新
  makeNode(uiContext: UIContext): FrameNode | null {
    console.info('makeNode, uiContext is undefined? : ' + (uiContext === undefined));
    if (this.rootNode !== null) {
      // 返回FrameNode节点
      return this.rootNode.getFrameNode();
    }
    // 返回null控制动态组件脱离绑定节点
    return null;
  }

  // 当布局大小发生变化时进行回调
  aboutToResize(size: Size) {
    console.info('MyNodeController aboutToResize width : ' + size.width + ' height : ' + size.height);
  }

  // 当controller对应的NodeContainer在Appear的时候进行回调
  aboutToAppear() {
    console.info('MyNodeController aboutToAppear');
  }

  // 当controller对应的NodeContainer在Disappear的时候进行回调
  aboutToDisappear() {
    console.info('MyNodeController aboutToDisappear');
  }

  // 在 controller 与 NodeContainer 绑定后执行。
  onBind(containerId: number) {
    this.bindCount += 1;
    console.info('offlineNWeb: ' + this.originUrl + ', onBind, id:' + containerId + ', count: ' + this.bindCount);
  }

  // 在 controller 与 NodeContainer 解除绑定后执行。
  onUnbind(containerId: number) {
    this.bindCount -= 1;
    console.info('offlineNWeb: ' + this.originUrl + ', onUnbind, id:' + containerId + ', count: ' + this.bindCount);
  }

  // 此函数为自定义函数，可作为初始化函数使用
  // 通过UIContext初始化BuilderNode，再通过BuilderNode中的build接口初始化@Builder中的内容
  initWeb(url: ResourceStr, uiContext: UIContext) {
    if (this.rootNode !== null) {
      return;
    }
    this.originUrl = url;
    // 创建节点，需要uiContext
    this.rootNode = new BuilderNode(uiContext);
    // 创建动态Web组件
    this.rootNode.build(wrap, { url: url, controller: this.webController, node: this });
  }

  // 此函数为自定义函数，获取对应的webController
  getWebController(): WebviewController {
    return this.webController;
  }

  // 此函数为自定义函数，判断离线组件是否已被绑定
  isBound(): boolean {
    return this.bindCount > 0;
  }

  // 此函数为自定义函数，加载网页
  loadUrl(url: ResourceStr | undefined) {
    if (url === undefined) {
      return;
    }
    try {
      this.webController.loadUrl(url);
    } catch (error) {
      console.info('load url error, ' + error);
    }
  }

  // 此函数为自定义函数，开始离线Web组件预加载网页，通过设置webController为Active状态
  startPreLoad(url: ResourceStr | undefined = undefined) {
    if (url) {
      this.loadUrl(url);
    }
    this.webController.onActive();
  }

  // 此函数为自定义函数，停止预加载，仅在离线组件没有被绑定时，调用webController的onInactive接口
  stopPreload() {
    if (!this.isBound()) {
      // 在预渲染完成时触发，并且没有被绑定时，停止渲染
      this.webController.onInactive();
    }
  }
}

// [Start manage_dynamic_webview_components_core_functions]
// 创建Map保存所需要的NodeController
let nodeMap: Map<ResourceStr, MyNodeController | undefined> = new Map();

// 创建保存uiContext的全局变量
let globalUiContext: UIContext | undefined = undefined;

// 创建Set保存已释放的离线组件url信息
let recycledNWebs: Set<ResourceStr> = new Set()

// 初始化需要UIContext 需在Ability获取
export const createNWeb = (url: ResourceStr, uiContext: UIContext) => {
  // 创建NodeController
  console.info('createNWeb, url = ' + url);
  if (!globalUiContext) {
    globalUiContext = uiContext;
  }
  if (getNWeb(url)) {
    console.info('createNWeb, already exit this node, url:' + url);
    return;
  }

  let baseNode = new MyNodeController();
  // 初始化自定义Web组件
  baseNode.initWeb(url, uiContext);
  nodeMap.set(url, baseNode);
  recycledNWebs.delete(url);
}

// 自定义释放/回收离线Web组件的接口，可作为释放离线Web组件函数使用，释放成功返回true
// 当离线组件没有被NodeContainer绑定时，允许安全释放，否则节点在不重绘时会显示空白
export const recycleNWeb = (url: ResourceStr, force: boolean = false): boolean => {
  console.info('recycleNWeb, url = ' + url);
  let baseNode = nodeMap.get(url);
  if (!baseNode) {
    console.info('no such node, url = ' + url);
    return false;
  }
  if (!force && baseNode.isBound()) {
    console.info('the node is in bound and not force, can not delete');
    return false;
  }
  baseNode.rootNode?.dispose();
  baseNode.rebuild();
  nodeMap.delete(url);
  recycledNWebs.add(url);
  return true;
}

// 自定义释放所有离线Web组件的接口
export const recycleNWebs = (force: boolean = false) => {
  nodeMap.forEach((_node: MyNodeController | undefined, url: ResourceStr) => {
    recycleNWeb(url, force);
  });
}

// 自定义恢复之前释放离线Web组件的接口
export const restoreNWebs = (uiContext: UIContext | undefined = undefined) => {
  if (!uiContext) {
    uiContext = globalUiContext;
  }
  for (let url of recycledNWebs) {
    if (uiContext) {
      createNWeb(url, uiContext);
    }
  }
  recycledNWebs.clear()
}

// [End manage_dynamic_webview_components_core_functions]

// 自定义获取NodeController接口
export const getNWeb = (url: ResourceStr | undefined): MyNodeController | undefined => {
  if (url === undefined) {
    return undefined;
  }
  console.info('getNWeb, url = ' + url);
  let node = nodeMap.get(url);
  if (node) {
    if (node?.isBound()) {
      console.warn('warning, the node is in Using, url = ', url);
    }
  }
  return node;
}

// 获取空闲的NWebNode接口
export const getFreeWebNode = (): MyNodeController | undefined => {
  for (let url of nodeMap.keys()) {
    let node = nodeMap.get(url);
    if (node && !node.isBound() && String(url).startsWith('about:blank')) {
      console.info('getFreeWebNode url = ' + url);
      return node;
    }
  }
  console.warn('getFreeWebNode, no offline web node returned')
  return undefined;
}

// 自定义获取NodeController接口
export const getWebController = (url: ResourceStr): WebviewController | undefined => {
  let controller = nodeMap.get(url)?.getWebController();
  return controller;
}

// 自定义获取离线组件统计信息的接口，用于调试
export const gerOfflineNWebsInfo = (): string => {
  let info = '[offlineNWebs]\n';
  let index = 1;
  for (let url of nodeMap.keys()) {
    info += '[' + index + ']' + url + '\n     isBound : ' + nodeMap.get(url)?.isBound() + '\n';
    index += 1;
  }
  info += '[recycledNWebs]\n';
  for (let url of recycledNWebs) {
    info += '[' + index + ']' + url + '\n';
    index += 1;
  }
  return info;
}

// [End manage_dynamic_webview_components_functions]