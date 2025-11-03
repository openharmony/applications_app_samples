/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start model_header]
import { Camera, Scene, SceneResourceFactory } from '@kit.ArkGraphics3D';
// [End model_header]
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Model {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: Camera | null = null;

  onPageShow(): void {
    this.init();
  }

  onPageHide(): void {
    if (this.scene) {
      this.scene.destroy();
    }
    this.scene = null;
    this.sceneOpt = null;
    this.cam = null;
  }

  init(): void {
    // [Start model_load]
    if (this.scene == null) {
      // Load the model and place the gltf file in the related path. Use the actual path during loading.
      // Switched from .gltf to .glb; same content, different format
      Scene.load($rawfile('gltf/DamagedHelmet/glTF/DamagedHelmet.glb'))
        .then(async (result: Scene) => {
          this.scene = result;
          let rf: SceneResourceFactory = this.scene.getResourceFactory();
          // [StartExclude model_load]
          // [Start camera_scene_params]
          // Create a Camera.
          this.cam = await rf.createCamera({ 'name': 'Camera' });
          // Set proper camera parameters.
          this.cam.enabled = true;
          this.cam.position.z = 5;

          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          // [End camera_scene_params]
          console.info('initialization completely.');
          // [EndExclude model_load]
        })
        .catch((reason: string) => {
          console.log(reason);
      });
    }
    // [End model_load]
  }

  build() {
    Row() {
      Column() {
        // [Start render_model]
        if (this.sceneOpt) {
          // Use Component3D to display the 3D scenario.
          Component3D(this.sceneOpt);
        } else {
          Text('Loading···');
        }
        // [End render_model]

        Button('back')
          .id('back')
          .fontSize(16)
          .fontWeight(500)
          .margin({ top: 20, left: 6 })
          .onClick(() => {
            router.back();
          })
          .width('80%')
          .height(40)
      }.width('100%')
    }.height('60%')
  }
}
