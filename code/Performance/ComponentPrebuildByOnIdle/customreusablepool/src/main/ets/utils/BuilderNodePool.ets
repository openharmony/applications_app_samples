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

import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { HashMap } from '@kit.ArkTS';

// 继承NodeController，创建可以复用的子组件
export class NodeItem extends NodeController {
  public builder: WrappedBuilder<ESObject> | null = null;
  public node: BuilderNode<ESObject> | null = null;
  public data: ESObject = {};
  // 子组件类型，复用时会根据type查找对应的子组件使用
  public type: string = '';
  public id: number = 0;

  aboutToDisappear(): void {
    // 当页面销毁时回收组件到复用池中
    NodePool.getInstance().recycleNode(this.type, this);
  }

  update(data: ESObject) {
    this.data = data;
    this.node?.reuse(data);
  }

  // 创建节点
  makeNode(uiContext: UIContext): FrameNode | null {
    if (!this.node) {
      this.node = new BuilderNode(uiContext);
      this.node.build(this.builder, this.data);
    } else {
      this.update(this.data);
    }
    return this.node.getFrameNode();
  }

  prebuild(uiContext: UIContext) {
    this.node = new BuilderNode(uiContext);
    this.node.build(this.builder, this.data);
  }
}

// 全局组件复用池
export class NodePool {
  private static instance: NodePool;
  private idGen: number;
  private nodePool: HashMap<string, Array<NodeItem>>;

  private constructor() {
    this.nodePool = new HashMap();
    this.idGen = 0;
  }

  // 使用单例模式，用于全局管理组件复用池
  public static getInstance() {
    if (!NodePool.instance) {
      NodePool.instance = new NodePool();
    }
    return NodePool.instance;
  }

  // 获取组件ID
  public getNextId(): number {
    this.idGen += 1;
    return this.idGen;
  }

  // 根据type获取子组件，如果有则直接复用，如果没有则创建新的子组件
  public getNode(type: string, item: ESObject, itemColor: Color,
    builder: WrappedBuilder<ESObject>): NodeItem | undefined {
    let nodeItem: NodeItem | undefined = this.nodePool.get(type)?.pop();
    if (!nodeItem) {
      nodeItem = new NodeItem();
      nodeItem.builder = builder;
      nodeItem.data.data = item;
      nodeItem.type = type;
      nodeItem.data.itemColor = itemColor;
    } else {
      nodeItem.data.data = item;
      nodeItem.data.itemColor = itemColor;
    }
    return nodeItem;
  }

  public preBuild(type: string, item: ESObject, builder: WrappedBuilder<ESObject>, uiContext: UIContext) {
    if (type) {
      let nodeItem: NodeItem | undefined = new NodeItem();
      nodeItem.builder = builder;
      nodeItem.data.data = item;
      nodeItem.type = type;
      nodeItem.prebuild(uiContext);
      this.recycleNode(type, nodeItem);
    }
  }

  // 回收子组件到复用池中
  public recycleNode(type: string, node: NodeItem) {
    let nodeArray: NodeItem[] = this.nodePool.get(type);
    if (!nodeArray) {
      nodeArray = [];
      this.nodePool.set(type, nodeArray);
    }
    nodeArray.push(node);
  }
}