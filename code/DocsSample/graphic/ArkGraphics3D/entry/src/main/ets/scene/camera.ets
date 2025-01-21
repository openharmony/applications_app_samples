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

@Entry
@Component
struct CameraPage {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  camera: Camera | null = null;
  @State positionX: number = 0;
  @State positionY: number = 0;
  @State positionZ: number = 5;

  async onPageShow(): Promise<void> {
    this.init();
  }

  onPageHide(): void {
    if (this.scene) {
      this.scene.destroy();
    }
    this.scene = null;
    this.sceneOpt = null;
    this.camera = null;
  }

  createCameraPromise(): Promise<Camera> {
    return new Promise((resolve, reject) => {
      Scene.load($rawfile('gltf/CubeWithFloor/glTF/AnimatedCube.gltf'))
        .then(async (result: Scene) => {
          try {
            this.scene = result;
            const sceneFactory: SceneResourceFactory = result.getResourceFactory();
            let sceneCameraParameter: SceneNodeParameters = { name: 'camera' };
            // Create a Camera.
            let camera: Promise<Camera> = sceneFactory.createCamera(sceneCameraParameter);
            camera.then(async (cameraEntity: Camera) => {
              // Enable the camera node.
              cameraEntity.enabled = true;

              // Set the camera position.
              cameraEntity.position.x = this.positionX;
              cameraEntity.position.y = this.positionY;
              cameraEntity.position.z = this.positionZ;

              // Set the FoV.
              cameraEntity.fov = 60 * Math.PI / 180;
              // Set other camera parameters.
              // ...
            });
            this.sceneOpt = { scene: result, modelType: ModelType.SURFACE } as SceneOptions;

            resolve(camera);
          } catch (error) {
            logger.error('Error in createCameraPromise: ' + error + '.');
            reject(error);
          }
        })
        .catch((error: string) => {
          logger.error('Error loading scene: ' + error + '.');
          reject(error);
        });
    });
  }

  async init(): Promise<void> {
    this.camera = await this.createCameraPromise();
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



