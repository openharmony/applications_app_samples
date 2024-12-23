/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import data from '../jsonpage/foo.json';
import { typeNode } from '@ohos.arkui.node';

/**
 * 定义数据结构接收UI描述数据
 */
class VM {
  public type?: string;
  public content?: string;
  public css?: ESObject;
  public children?: VM[];
  public id?: string;
}

// 存储图片节点，方便后续直接操作节点
let carouselNodes: typeNode.Image[] = [];

/**
 * 自定义DSL解析逻辑，将UI描述数据解析为组件
 *
 * @param vm
 * @param context
 * @returns
 */
function frameNodeFactory(vm: VM, context: UIContext): FrameNode | null {
  if (vm.type === 'Column') {
    let node = typeNode.createNode(context, 'Column');
    setColumnNodeAttr(node, vm.css);
    vm.children?.forEach(kid => {
      let child = frameNodeFactory(kid, context);
      node.appendChild(child);
    });
    return node;
  } else if (vm.type === 'Row') {
    let node = typeNode.createNode(context, 'Row');
    setRowNodeAttr(node, vm.css);
    vm.children?.forEach(kid => {
      let child = frameNodeFactory(kid, context);
      node.appendChild(child);
    });
    return node;
  } else if (vm.type === 'Swiper') {
    let node = typeNode.createNode(context, 'Swiper');
    node.attribute.width(vm.css.width);
    node.attribute.height(vm.css.height);
    vm.children?.forEach(kid => {
      let child = frameNodeFactory(kid, context);
      node.appendChild(child);
    });
    return node;
  } else if (vm.type === 'Image') {
    let node = typeNode.createNode(context, 'Image');
    node.attribute.width(vm.css.width);
    node.attribute.height(vm.css.height);
    node.attribute.borderRadius(vm.css.borderRadius);
    node.attribute.objectFit(ImageFit.Fill);
    node.initialize($r(vm.content));
    carouselNodes.push(node);
    return node;
  } else if (vm.type === 'Text') {
    let node = typeNode.createNode(context, 'Text');
    node.attribute.fontSize(vm.css.fontSize);
    node.attribute.width(vm.css.width);
    node.attribute.height(vm.css.height);
    node.attribute.width(vm.css.width);
    node.attribute.borderRadius(vm.css.borderRadius);
    node.attribute.backgroundColor(vm.css.backgroundColor);
    node.attribute.fontColor(vm.css.fontColor);
    node.attribute.opacity(vm.css.opacity);
    node.attribute.textAlign(TextAlign.Center);
    // 使用id来标识特殊节点，方便抽出来单独操作
    if (vm.id === 'refreshImage') {
      // 因为frameNode暂时没有Button组件，因此使用Text代替，给该组件绑定点击事件
      node.attribute.onClick(() => {
        carouselNodes[1].initialize($r('app.media.movie6'));
        carouselNodes[2].initialize($r('app.media.movie7'));
        carouselNodes[3].initialize($r('app.media.movie8'));
        carouselNodes[4].initialize($r('app.media.movie9'));
        carouselNodes[5].initialize($r('app.media.movie10'));
        node.attribute.enabled(false);
      })
    }
    node.initialize(vm.content);
    return node;
  }
  return null;
}

function setColumnNodeAttr(node: typeNode.Column, css: ESObject) {
  node.attribute.width(css.width);
  node.attribute.height(css.height);
  node.attribute.backgroundColor(css.backgroundColor);
  if (css.alignItems === 'HorizontalAlign.Start') {
    node.attribute.alignItems(HorizontalAlign.Start);
  }
}

function setRowNodeAttr(node: typeNode.Row, css: ESObject) {
  node.attribute.width(css.width);
  if (css.padding !== undefined) {
    node.attribute.padding(css.padding as Padding);
  }
  if (css.margin !== undefined) {
    node.attribute.margin(css.margin as Padding);
  }
  node.attribute.justifyContent(FlexAlign.SpaceBetween);
}

/**
 * 继承NodeController，用于绘制组件树
 */
class ImperativeController extends NodeController {
  makeNode(uiContext: UIContext): FrameNode | null {
    carouselNodes = [];
    return frameNodeFactory(data, uiContext);
  }
}

/**
 * 功能描述: 本实例主要讲解如何使用ArkUI的FrameNode扩展实现动态布局类框架。
 *
 * 推荐场景: 需要使用动态布局的场景
 *
 * 核心组件:
 * 1. FrameNode
 * 2. NodeContainer组件
 *
 * 实现步骤:
 * 1. 定义DSL，DSL一般会使用JSON、XML等数据交换格式来描述UI。
 * 2. 定义相应数据结构用于接收UI描述数据。
 * 3. 自定义DSL解析逻辑，且使用carouselNodes保存轮播图节点，方便后续操作节点更新
 * 4. 使用NodeContainer组件占位，将创建的组件加载到页面中。
 */
@Component
export struct ImperativeViewComponent {
  controller: ImperativeController = new ImperativeController();

  build() {
    Column() {
      NodeContainer(this.controller)
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Black)
  }
}