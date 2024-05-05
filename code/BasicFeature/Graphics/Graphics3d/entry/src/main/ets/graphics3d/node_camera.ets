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

let fovFlag: number = 0;
let enabledFlag: number = 0;
let TonemapTypeFlag: number = 0;
let clearColorFlag: number = 0;

let LOG_TAG: string = "Sample_Graphics3D";

@Entry
@Component
struct node_geometry {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: scene3d.Camera | null = null;
  @State nearPlaneValue: number = 0.1;
  @State farPlaneValue: number = 100;
  @State tonemapExposure: number = 1;

  //  scene:Nullable<scene3D.Scene>;
  onPageShow(): void {
    this.init();
  }

  onPageHide(): void {
    console.log(LOG_TAG + ' onPageHide')
    if (this.scene) {
      this.scene.destroy();
    }

    this.cam = null;
    this.scene = null;
  }

  init(): void {
    if (this.scene == null) {
      scene3d.Scene.load($rawfile("gltf/DamagedHelmet/glTF/DamagedHelmet.gltf"))
        .then(async (result: scene3d.Scene) => {
          this.scene = result;
          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          let rf: scene3d.SceneResourceFactory = this.scene.getResourceFactory();
          this.cam = await rf.createCamera({ "name": "Camera1" });
          this.cam.position.z = 5;  // move camera to position 5 on z
          this.cam.enabled = true;
          this.cam.postProcess = {
            toneMapping: {
              type: scene3d.ToneMappingType.ACES,
              exposure: 1.0,
            } as scene3d.ToneMappingSettings
          }
          let env = await rf.createEnvironment({ "name": "Env" });
          this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_NONE;
        })
        .catch((reason: string) => {
          console.log(LOG_TAG + " error: " + reason)
        });
    }
  }

  build() {
    Row() {
      Column() {
        Stack() {
          Text('HELLO WORLD').height('100%').width('100%').backgroundColor(Color.Green)

          if (this.sceneOpt) {
            Component3D(this.sceneOpt)
              .renderWidth('60%')
              .renderHeight('60%')
              .backgroundColor(Color.Transparent)
              .width("90%")
              .height('100%')
          }
          else {
            Text("loading 1...");
          }
        }
        .height('30%')

        Button('change fov').onClick(() => {
          if (!this.scene || !this.cam) {
            return;
          }
          fovFlag = (fovFlag + 1) % 3;
          if (fovFlag == 0) {
            let degree = 60;
            this.cam.fov = degree * Math.PI / 180;
            console.log(LOG_TAG + "Camera fov: " + this.cam.fov + ", degree: " + degree);
          }
          else if (fovFlag == 1) {
            let degree = 90;
            this.cam.fov = degree * Math.PI / 180;
            console.log(LOG_TAG + "Camera fov: " + this.cam.fov + ", degree: " + degree);
          }
          else if (fovFlag == 2) {
            let degree = 45;
            this.cam.fov = degree * Math.PI / 180;
            console.log(LOG_TAG + "Camera fov: " + this.cam.fov + ", degree: " + degree);
          }
        }).id('change_fov');

        Column() {
          Text("nearPlane: " + this.nearPlaneValue.toFixed(1)).fontSize(12)
          Slider({
            value: this.nearPlaneValue,
            min: 0.1,
            max: 10,
            step: 0.1,
            style: SliderStyle.OutSet
          })
            .showTips(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.nearPlaneValue = value;
              if (mode == SliderChangeMode.End) {
                if (!this.scene || !this.cam) {
                  return;
                }
                this.cam.nearPlane = value;
                console.log(LOG_TAG + "Camera near Plane: " + this.cam.nearPlane);
              }
            })
            .width("100%")
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Column() {
          Text("farPlane: " + this.farPlaneValue.toFixed(1)).fontSize(12)
          Slider({
            value: this.farPlaneValue,
            min: 0,
            max: 100,
            step: 1,
            style: SliderStyle.OutSet
          })
            .showTips(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.farPlaneValue = value;
              if (mode == SliderChangeMode.End) {
                if (!this.scene || !this.cam) {
                  return;
                }
                this.cam.farPlane = value;
                console.log(LOG_TAG + "Camera far Plane: " + this.cam.farPlane);
              }
            })
            .width("100%")
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Button('enabled').onClick(() => {
          if (!this.scene || !this.cam) {
            return;
          }
          enabledFlag = (enabledFlag + 1) % 2;
          if (enabledFlag == 0) {
            this.cam.enabled = true;
            console.log(LOG_TAG + "Camera enabled: " + this.cam.enabled);
          }
          else if (enabledFlag == 1) {
            this.cam.enabled = false;
            console.log(LOG_TAG + "Camera enabled: " + this.cam.enabled);
          }
        }).id('camera_enabled');

        Button('Change Tonemap Type').onClick(() => {
          if (!this.scene || !this.cam || !this.cam.postProcess || !this.cam.postProcess.toneMapping) {
            return;
          }
          let type: scene3d.ToneMappingType = scene3d.ToneMappingType.ACES;

          TonemapTypeFlag = (TonemapTypeFlag + 1) % 3;
          if (TonemapTypeFlag == 0) {
            type = scene3d.ToneMappingType.ACES;
          } else if (TonemapTypeFlag == 1) {
            type = scene3d.ToneMappingType.ACES_2020;
          } else if (TonemapTypeFlag == 2) {
            type = scene3d.ToneMappingType.FILMIC;
          }

          this.cam.postProcess = {
            toneMapping: {
              exposure: this.cam.postProcess.toneMapping.exposure,
              type: type
            }
          };

          console.log(LOG_TAG + "Camera Tonemap Type:" + this.cam.postProcess.toneMapping?.type);
        }).id('change_tonemapping');

        Column() {
          Text("Tonemap Exposure: " + this.tonemapExposure.toFixed(1)).fontSize(12)
          Slider({
            value: this.tonemapExposure,
            min: 0,
            max: 10,
            step: 0.1,
            style: SliderStyle.OutSet
          })
            .showTips(false)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.tonemapExposure = value;
              if (mode == SliderChangeMode.End) {
                if (!this.scene || !this.cam || !this.cam.postProcess || !this.cam.postProcess.toneMapping) {
                  return;
                }
                //this.cam.postProcess.toneMapping.exposure = value;
                this.cam.postProcess = {
                  toneMapping: {
                    exposure: value,
                    type: this.cam.postProcess.toneMapping.type
                  }
                }
                if (this.cam.postProcess.toneMapping?.exposure) {
                  console.log(LOG_TAG + "Camera Tonemap exposure: " + this.cam.postProcess.toneMapping.exposure);
                }
              }
            })
            .width("100%")
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        Button('set clearColor').onClick(() => {
          if (!this.scene || !this.cam) {
            return;
          }
          clearColorFlag = (clearColorFlag + 1) % 4;
          if (clearColorFlag == 0) {
            this.cam.clearColor = null;
            console.log(LOG_TAG + "Camera clearColor: " + this.cam.clearColor);
          }
          else if (clearColorFlag == 1) {
            this.cam.clearColor = { r: 0, g: 0, b: 0, a: 0.0 };
            console.log(LOG_TAG + "Camera clearColor: [" + this.cam.clearColor.r + ", " + this.cam.clearColor.g + ", " + this.cam.clearColor.b + ", " + this.cam.clearColor.a + "]");
          }
          else if (clearColorFlag == 2) {
            this.cam.clearColor = { r: 1, g: 0, b: 0, a: 0.1 };
            console.log(LOG_TAG + "Camera clearColor: [" + this.cam.clearColor.r + ", " + this.cam.clearColor.g + ", " + this.cam.clearColor.b + ", " + this.cam.clearColor.a + "]");
          }
          else if (clearColorFlag == 3) {
            this.cam.clearColor = { r: 1, g: 0, b: 0, a: 1.0 };
            console.log(LOG_TAG + "Camera clearColor: [" + this.cam.clearColor.r + ", " + this.cam.clearColor.g + ", " + this.cam.clearColor.b + ", " + this.cam.clearColor.a + "]");
          }
        }).id('clear_color');

        Button('back').onClick(() => {
          router.back()
        }).id('camera_back')
      }
      .width('100%')
    }
    .height('100%')
  }
}