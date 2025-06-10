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

import { Camera, Scene, SceneNodeParameters, SceneResourceFactory } from '@kit.ArkGraphics3D';
import { router } from '@kit.ArkUI';
import logger from '../utils/Logger';

let globalScene: Scene | null = null;

function createCameraPromise(): Promise<Camera> {
  return new Promise((resolve, reject) => {
    // Switched from .gltf to .glb; same content, different format
    let scene: Promise<Scene> = Scene.load($rawfile('gltf/CubeWithFloor/glTF/AnimatedCube.glb'));
    scene.then(async (result: Scene) => {
      // Save loaded scene globally for reuse (e.g., in CameraPage)
      globalScene = result;
      let sceneFactory: SceneResourceFactory = result.getResourceFactory();
      let sceneCameraParameter: SceneNodeParameters = { name: 'camera' };
      // Create a Camera.
      let camera: Promise<Camera> = sceneFactory.createCamera(sceneCameraParameter);
      camera.then(async (cameraEntity: Camera) => {
        // Enable the camera node.
        cameraEntity.enabled = true;

        // Set the camera position.
        cameraEntity.position.z = 5;

        // Set the FoV.
        cameraEntity.fov = 60 * Math.PI / 180;

        // Set other camera parameters.
        // ...
        resolve(cameraEntity);
      }).catch((error: string) => {
        logger.error('Camera create failed: ' + error + '.');
        reject(error);
      });
    }).catch((error: string) => {
        logger.error('Scene load failed: ' + error);
        reject(error);
      });
  });
}

@Entry
@Component
struct CameraPage {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  camera: Camera | null = null;
  @State positionX: number = 0;
  @State positionY: number = 0;
  @State positionZ: number = 5;

  onPageShow(): void {
    this.init();
  }

  onPageHide(): void {
    if (this.scene) {
      this.scene.destroy();
    }
    this.scene = null;
    this.sceneOpt = null;
    this.camera = null;
    globalScene = null;
  }

  async init(): Promise<void> {
    this.camera = await createCameraPromise();
    if (globalScene && this.camera) {
      this.scene = globalScene;
      this.positionX = this.camera.position.x;
      this.positionY = this.camera.position.y;
      this.positionZ = this.camera.position.z;
      this.sceneOpt = { scene: globalScene, modelType: ModelType.SURFACE } as SceneOptions;
    }
  }

  build() {
    Row() {
      Column() {
        Column() {
          if (this.sceneOpt) {
            // Use Component3D to display the 3D scenario.
            Component3D(this.sceneOpt);
          } else {
            Text('Loading···');
          }
        }

        Column() {
          Text('X-axis: ' + this.positionX.toFixed(1)).fontSize(12);
          Slider({
            value: this.positionX,
            min: 0,
            max: 5,
            step: 0.1,
            style: SliderStyle.OutSet
          })
            .id('xAxis')
            .showTips(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.positionX = value;
              if (mode === SliderChangeMode.End) {
                if (!this.scene || !this.camera) {
                  return;
                }
                this.camera.position.x = value;
              }
            })
            .width('100%')
        }
        .width('100%')

        Column() {
          Text('Y-axis: ' + this.positionY.toFixed(1)).fontSize(12);
          Slider({
            value: this.positionY,
            min: 0,
            max: 5,
            step: 0.1,
            style: SliderStyle.OutSet
          })
            .showTips(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.positionY = value;
              if (mode === SliderChangeMode.End) {
                if (!this.scene || !this.camera) {
                  return;
                }
                this.camera.position.y = value;
              }
            })
            .width('100%')
        }
        .width('100%')

        Column() {
          Text('Z-axis: ' + this.positionZ.toFixed(1)).fontSize(12)
          Slider({
            value: this.positionZ,
            min: 5,
            max: 10,
            step: 0.1,
            style: SliderStyle.OutSet
          })
            .showTips(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.positionZ = value;
              if (mode === SliderChangeMode.End) {
                if (!this.scene || !this.camera) {
                  return;
                }
                this.camera.position.z = value;
              }
            })
            .width('100%')
        }
        .width('100%')

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
      }
    }.height('60%')
  }
}
