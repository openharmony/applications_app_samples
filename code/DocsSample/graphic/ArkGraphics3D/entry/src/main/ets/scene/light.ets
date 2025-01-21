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

import { Camera, Light, LightType, Scene, SceneNodeParameters, SceneResourceFactory } from '@kit.ArkGraphics3D';
import { router } from '@kit.ArkUI';
import logger from '../utils/Logger';

@Entry
@Component
struct LightPage {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: Camera | null = null;
  light: Light | null = null;
  @State red: number = 0;
  @State green: number = 0;
  @State blue: number = 0;

  createLightPromise(): Promise<Light> {
    return new Promise((resolve, reject) => {
      Scene.load($rawfile('gltf/CubeWithFloor/glTF/AnimatedCube.gltf'))
        .then(async (result: Scene) => {
          try {
            this.scene = result;
            this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE };

            let sceneFactory: SceneResourceFactory = this.scene.getResourceFactory();

            // Create a new camera.
            this.cam = await sceneFactory.createCamera({ name: 'camera' });
            this.cam.enabled = true;
            this.cam.position.z = 10;

            let sceneLightParameter: SceneNodeParameters = { name: 'light' };
            // Create directional light.
            let light: Light = await sceneFactory.createLight(sceneLightParameter, LightType.DIRECTIONAL);
            // Set the color of the directional light.
            light.color = {
              r: this.red,
              g: this.green,
              b: this.blue,
              a: 1.0
            };

            // Set other light parameters.
            // ...

            resolve(light);
          } catch (error) {
            logger.error('Error in createLightPromise: ' + error + '.');
            reject(error);
          }
        })
        .catch((error: string) => {
          logger.error('Error loading scene: ' + error + '.');
          reject(error);
        })
    })
  }

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
    this.light = null;
  }

  async init(): Promise<void> {
    this.light = await this.createLightPromise();
  }

  build() {
    Row() {
      Column() {
        if (this.sceneOpt) {
          Component3D(this.sceneOpt);
        } else {
          Text('loading···');
        }

        Column() {
          Text('Red: ' + this.red.toFixed(1)).fontSize(12);
          Slider({
            value: this.red,
            min: 0,
            max: 1,
            step: 0.01,
            style: SliderStyle.OutSet
          })
            .showTips(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.red = value;
              if (mode === SliderChangeMode.End) {
                if (!this.scene || !this.light) {
                  return;
                }
                this.light.color = {
                  r: this.red,
                  g: this.green,
                  b: this.blue,
                  a: 1.0
                }
              }
            })
            .width('100%')
        }
        .width('100%')

        Column() {
          Text('Green: ' + this.green.toFixed(1)).fontSize(12)
          Slider({
            value: this.green,
            min: 0,
            max: 1,
            step: 0.01,
            style: SliderStyle.OutSet
          })
            .showTips(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.green = value;
              if (mode === SliderChangeMode.End) {
                if (!this.scene || !this.light) {
                  return;
                }

                this.light.color = {
                  r: this.red,
                  g: this.green,
                  b: this.blue,
                  a: 1.0
                }
              }
            })
            .width('100%')
        }
        .width('100%')

        Column() {
          Text('Blue: ' + this.blue.toFixed(1)).fontSize(12)
          Slider({
            value: this.blue,
            min: 0,
            max: 1,
            step: 0.01,
            style: SliderStyle.OutSet
          })
            .showTips(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.blue = value;
              if (mode === SliderChangeMode.End) {
                if (!this.scene || !this.light) {
                  return;
                }

                this.light.color = {
                  r: this.red,
                  g: this.green,
                  b: this.blue,
                  a: 1.0
                }
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
      .width('100%')
    }
    .height('60%')
  }
}



