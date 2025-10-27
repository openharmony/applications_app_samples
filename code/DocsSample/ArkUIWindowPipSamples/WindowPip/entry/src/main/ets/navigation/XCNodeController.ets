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

// [Start navigation_implement_node_controller]
// navigation/XCNodeController.ets
import { FrameNode, NodeController, typeNode } from '@kit.ArkUI';
import { PipManager } from './PipManager';
import { Logger } from '../util/LogUtil';

const TAG = 'XCNodeController';

// 创建自定义NodeController
export class XCNodeController extends NodeController {
  public xComponent: typeNode.XComponent| null = null;
  private node: FrameNode | null = null;
  private canAddNode: boolean = true;

  // 设置是否可以添加节点
  setCanAddNode(canAddNode: boolean) {
    this.canAddNode = canAddNode;
  }

  // 实现makeNode方法，当自定义NodeController被添加到布局时，该方法会被调用
  makeNode(context: UIContext): FrameNode | null {
    Logger.info(TAG, 'makeNode');
    this.node = new FrameNode(context);
    if (this.xComponent === null || this.xComponent === undefined) {
      // 创建XComponent类型的typeNode
      this.xComponent = typeNode.createNode(context, 'XComponent', {
        type: XComponentType.SURFACE, // 类型设置为SURFACE
        controller: PipManager.getInstance().getXComponentController(), // 设置XComponentController
      });
    }
    if (this.canAddNode) {

      try {
        this.xComponent.getParent()?.removeChild(this.xComponent);
      } catch (error) {
        Logger.error(TAG, 'Failed to removeChild');
      }
      try {
        this.node.appendChild(this.xComponent);
      } catch (error) {
        Logger.error(TAG, 'Failed to appendChild');
      }
    }
    return this.node;
  }

  // 重新添加typeNode节点
  addNode() {
    if (this.node !== null && this.node !== undefined) {
      Logger.info(TAG, 'addNode id:'+(this.node?.getUniqueId())+' '+this.xComponent?.getUniqueId());
      try {
        this.node.appendChild(this.xComponent);
      } catch (error) {
        Logger.error(TAG, 'Failed to appendChild');
      }
    }
  }

  // 移除typeNode节点
  removeNode() {
    if (this.node !== null && this.node !== undefined) {
      Logger.info(TAG, 'removeNode');

      try {
        this.node.removeChild(this.xComponent);
      } catch (error) {
        Logger.error(TAG, 'Failed to removeChild');
      }
    }
  }

  getNode(): typeNode.XComponent | null {
    Logger.info(TAG, 'getNode is null:'+ (this.xComponent === null || this.xComponent === undefined))
    return this.xComponent;
  }
}
// [End navigation_implement_node_controller]