/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import scene3d from '@ohos.graphics.scene'
import router from '@ohos.router';
import animator, { AnimatorResult } from '@ohos.animator'

let LOG_TAG: string = 'Sample_Graphics3D';

@Entry
@Component
struct container {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: scene3d.Camera | null = null;
  private node: scene3d.Node | null | undefined = undefined;
  private sceneNode: scene3d.Node | null = null;
  @State hierarchy: string = '';

  private printNode: Function = (node: scene3d.Node, tag?: string) => {
    let msg: string = LOG_TAG + tag;
    if (!node) {
      console.log(msg + ' error node null');
      return;
    }
    console.log(msg + ' name', node.name);
    console.log(msg + ' path', node.path);
    console.log(msg + ' nodeType', node.nodeType);
    console.log(msg + ' node resource type', node.resourceType);
    console.log(msg + ' parent name', node.parent?.name);
  }

  Traversal(node: scene3d.Node | null): void {
    if (!node) {
      return;
    }
    this.printNode(node, " node print");
    this.hierarchy += node.path + '/' + node.name + '\n';
    let container: scene3d.Container<scene3d.Node> = node.children;
    let count: number = container.count();
    console.log(LOG_TAG + " node child count", count);
    this.hierarchy += '  ';
    for (let i = 0; i < count; i++) {
      this.Traversal(container.get(i));
    }
  }

  onPageShow(): void {
    this.Init();
  }

  onPageHide(): void {
    console.log(LOG_TAG + ' onPageHide')
    if (this.scene) {
      this.scene.destroy();
    }

    this.cam = null;
    this.scene = null;
  }

  Init(): void {
    if (this.scene == null) {
      scene3d.Scene.load($rawfile("gltf/DamagedHelmet/glTF/DamagedHelmet.gltf")).then(async (result: scene3d.Scene) => {
        this.scene = result;
        this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
        let rf: scene3d.SceneResourceFactory = this.scene.getResourceFactory();
        this.cam = await rf.createCamera({ "name": "Camera1" });
        this.cam.enabled = true;
        this.cam.position.z = 5; // move camera to position 5 on z

        this.node = this.scene.getNodeByPath('rootNode_/Scene/node_damagedHelmet_-6514');
        this.printNode(this.node, 'node_damagedHelmet_-6514');
        this.printNode(this.cam, 'camera');
        this.Traversal(this.scene.root);
        this.sceneNode = this.scene.getNodeByPath('rootNode_/Scene');
      }).catch((reason: string) => {
        console.log(LOG_TAG + " error: " + reason)
      });
    }
  }

  build() {
    Row() {
      Column() {
        Column() {
          if (this.sceneOpt) {
            Component3D(this.sceneOpt)
              .renderWidth('60%')
              .renderHeight('60%')
          }
          else {
            Text("loading 1...");
          }
        }
        .height('30%')

        Button('remove node').onClick(() => {
          this.scene?.root?.children.remove(this.node);
        })
        Button('append node').onClick(() => {
          this.scene?.root?.children.get(0)?.children.append(this.node);
        })
        Button('insert node').onClick(() => {
          this.scene?.root?.children.get(0)?.children.insertAfter(this.node, null);
        })
        Button('clear').onClick(() => {
          this.scene?.root?.children.clear();
        })
        Text(this.hierarchy)
        Button('back').onClick(() => {
          router.back()
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}