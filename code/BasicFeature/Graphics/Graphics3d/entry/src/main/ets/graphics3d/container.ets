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
import Logger from '../util/Logger';

@Entry
@Component
struct container {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: scene3d.Camera | null = null;
  private node: scene3d.Node | null | undefined = undefined;
  private sceneNode: scene3d.Node | null = null;
  @State hierarchy: string = '';

  traversal(node: scene3d.Node | null): void {
    if (!node) {
      return;
    }

    this.hierarchy += node.path + '/' + node.name + '\n';
    let container: scene3d.Container<scene3d.Node> = node.children;
    let count: number = container.count();

    this.hierarchy += '  ';
    for (let i = 0; i < count; i++) {
      this.traversal(container.get(i));
    }
  }

  onPageShow(): void {
    this.init();
  }

  onPageHide(): void {
    if (this.scene) {
      this.scene.destroy();
    }

    this.cam = null;
    this.scene = null;
  }

  init(): void {
    if (this.scene === null) {
      scene3d.Scene.load($rawfile("gltf/DamagedHelmet/glTF/DamagedHelmet.glb")).then(async (result: scene3d.Scene) => {
        this.scene = result;
        this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
        let rf: scene3d.SceneResourceFactory = this.scene.getResourceFactory();
        this.cam = await rf.createCamera({ "name": "Camera1" });
        this.cam.enabled = true;
        this.cam.position.z = 5; // move camera to position 5 on z

        this.node = this.scene.getNodeByPath('rootNode_/Scene/node_damagedHelmet_-6514');
        this.traversal(this.scene.root);
        this.sceneNode = this.scene.getNodeByPath('rootNode_/Scene');
      }).catch((reason: string) => {
        Logger.error("init error", reason);
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
          }).id('remove_node')

        Button('append node').onClick(() => {
          this.scene?.root?.children.get(0)?.children.append(this.node);
        }).id('append_node')

        Button('insert node').onClick(() => {
          this.scene?.root?.children.get(0)?.children.insertAfter(this.node, null);
        }).id('insert_node')

        Button('clear').onClick(() => {
          this.scene?.root?.children.clear();
        }).id('clear_node')

        Text(this.hierarchy)
        Button('back').onClick(() => {
          router.back()
        }).id('container_back')
      }
      .width('100%')
    }
    .height('100%')
  }
}