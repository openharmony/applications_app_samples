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
 
import { NodeController, BuilderNode, FrameNode, UIContext } from '@kit.ArkUI';

export interface BuilderData {
  url: string;
  controller: WebviewController;
}

const storage = LocalStorage.getShared();

export class NodeControllerImpl extends NodeController {
  private rootNode: BuilderNode<BuilderData[]> | null = null;
  private wrappedBuilder: WrappedBuilder<BuilderData[]> | null = null;

  constructor(wrappedBuilder: WrappedBuilder<BuilderData[]>) {
    super();
    this.wrappedBuilder = wrappedBuilder;
  }

  makeNode(): FrameNode | null {
    if (this.rootNode != null) {
      return this.rootNode.getFrameNode();
    }
    return null;
  }

  initWeb(url: string, controller: WebviewController) {
    if(this.rootNode != null) {
      return;
    }

    const uiContext: UIContext = storage.get<UIContext>('uiContext') as UIContext;
    if (!uiContext) {
      return;
    }
    this.rootNode = new BuilderNode(uiContext);
    this.rootNode.build(this.wrappedBuilder, { url: url, controller: controller });
  }
}

export const createNode = (wrappedBuilder: WrappedBuilder<BuilderData[]>, data: BuilderData) => {
  const baseNode = new NodeControllerImpl(wrappedBuilder);
  baseNode.initWeb(data.url, data.controller);
  return baseNode;
}
