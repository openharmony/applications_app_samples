'use static';
/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { NodeController, BuilderNode, FrameNode, BuildOptions } from '@ohos.arkui.node';
import { WrappedBuilder, CustomBuilder, Resource } from '@ohos.arkui.component';
import { UIContext } from '@ohos.arkui.UIContext';
import { ViewItem } from '../data/ViewItem';
import HashMap from '@ohos.util.HashMap';

export class TextCardNode extends NodeController {
  public builder: WrappedBuilder<CustomBuilder> | null = null;
  public node: BuilderNode<ESValue> | null = null;
  public type: string = '';

  aboutToDisappear(): void {
    NodePool.getInstance().recycleNode(this.type, this);
  }

  // 创建节点
  makeNode( uiContext: UIContext): FrameNode | null {
    if (!this.node) {
      this.node = new BuilderNode<ESValue>(uiContext);
      (this.node as BuilderNode<ESValue>).build(this.builder!);
    }
    return (this.node as BuilderNode<ESValue>).getFrameNode();
  }
}

export class NodePool {
  private static instance: NodePool | null= null;
  private idGen: number;
  private nodePool: HashMap<string, Array<TextCardNode>>;

  private constructor() {
    this.nodePool = new HashMap<string, Array<TextCardNode>>();
    this.idGen=0;
  }

  public static getInstance(): NodePool {
    if (!NodePool.instance) {
      NodePool.instance = new NodePool();
    }
    return NodePool.instance as NodePool;
  }

  //获取组件ID
  public getNextId(): number {
    this.idGen += 1;
    return this.idGen;
  }

  // 获取组件
  public getNode(type: string, builder: WrappedBuilder<CustomBuilder>): TextCardNode {
    let nodeItem: TextCardNode | undefined = this.nodePool.get(type)?.pop();
    if (!nodeItem) {
      nodeItem = new TextCardNode();
      nodeItem!.builder = builder as WrappedBuilder<CustomBuilder>;
      nodeItem.type = type as string;
    }
    return nodeItem;
  }

  // 回收组件
  public recycleNode(type: string, node: TextCardNode): void {
    let nodeArray: Array<TextCardNode> | undefined = this.nodePool.get(type);
    if (!nodeArray) {
      nodeArray = [] as TextCardNode[];
      this.nodePool.set(type, nodeArray);
    }
    nodeArray.push(node);
  }
}