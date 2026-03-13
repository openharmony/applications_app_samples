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

// [Start light_header]
import { Camera, Light, LightType, Scene, SceneNodeParameters, SceneResourceFactory } from '@kit.ArkGraphics3D';
// [End light_header]
import { router } from '@kit.ArkUI';

let globalScene: Scene | null = null;

function createLightPromise(): Promise<Light> {
  return new Promise((resolve, reject) => {
    // Switched from .gltf to .glb; same content, different format
    // [Start light_load_and_factory]
    let scene: Promise<Scene> = Scene.load($rawfile('gltf/CubeWithFloor/glTF/AnimatedCube.glb'));
    scene.then(async (result: Scene) => {
      // [StartExclude light_load_and_factory]
      // Save loaded scene globally for reuse (e.g., in LightPage)
      globalScene = result;
      // [EndExclude light_load_and_factory]
      let sceneFactory: SceneResourceFactory = result.getResourceFactory();
      let lightParameter: SceneNodeParameters = { name: 'light' };
      // [StartExclude light_load_and_factory]
      // Create directional light.
      // [Start light_create_and_config]
      let light: Promise<Light> = sceneFactory.createLight(lightParameter, LightType.DIRECTIONAL);
      light.then(async (lightEntity: Light) => {
        // Set the color of the directional light.
        lightEntity.color = { r: 0.8, g: 0.1, b: 0.2, a: 1.0 };

        // Set other light parameters.
        // ...
        // [StartExclude light_create_and_config]
        resolve(lightEntity);
        // [EndExclude light_create_and_config]
      }).catch((err: string) => {
        console.error('Light create failed: ' + err + '.');
        // [StartExclude light_create_and_config]
        reject(err);
        // [EndExclude light_create_and_config]
      });
      // [End light_create_and_config]
      // [EndExclude light_load_and_factory]
    }).catch((error: string) => {
      console.error('Scene load failed: ' + error);
      // [StartExclude light_load_and_factory]
      reject(error);
      // [EndExclude light_load_and_factory]
    });
    // [End light_load_and_factory]
  });
}

@Entry
@Component
struct LightPage {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: Camera | null = null;
  light: Light | null = null;
  rf: SceneResourceFactory | null = null;
  @State red: number = 0;
  @State green: number = 0;
  @State blue: number = 0;

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
    this.rf = null;
    globalScene = null;
  }

  async init(): Promise<void> {
    // [Start light_init_bind]
    this.light = await createLightPromise();
    if (globalScene && this.light) {
      this.scene = globalScene;
      this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
      this.rf = this.scene.getResourceFactory();
      this.cam = await this.rf.createCamera({ 'name': 'Camera1' });
      this.cam.enabled = true;
      this.cam.position.z = 5;
      // Initialize color value
      this.red = this.light.color.r;
      this.green = this.light.color.g;
      this.blue = this.light.color.b;
    }
    // [End light_init_bind]
  }

  build() {
    Row() {
      Column() {
        if (this.sceneOpt) {
          Component3D(this.sceneOpt);
        } else {
          Text('Loading···');
        }

        Column() {
          Text('Red: ' + this.red.toFixed(1)).fontSize(12);
          // [Start light_ui_sliders]
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
          // [End light_ui_sliders]
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
