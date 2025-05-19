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

import { Camera, Scene, SceneResourceFactory } from '@kit.ArkGraphics3D';
import { router } from '@kit.ArkUI';
import logger from '../utils/Logger';

@Entry
@Component
struct Init {
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
    if (this.scene == null) {
      // Load the model and place the gltf file in the related path. Use the actual path during loading.
      Scene.load($rawfile('gltf/DamagedHelmet/glTF/DamagedHelmet.glb'))
        .then(async (result: Scene) => {
          this.scene = result;
          let rf: SceneResourceFactory = this.scene.getResourceFactory();
          // Create a Camera.
          this.cam = await rf.createCamera({ 'name': 'Camera' });
          // Set proper camera parameters.
          this.cam.enabled = true;
          this.cam.position.z = 5;

          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          logger.info('initialization completely.');
        }).catch((err: string) => {
        logger.error('Error: ' + err + '.');
      });
    }
  }

  build() {
    Row() {
      Column() {
        if (this.sceneOpt) {
          // Use Component3D to display the 3D scenario.
          Component3D(this.sceneOpt);
        } else {
          Text('Loading···');
        }

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
