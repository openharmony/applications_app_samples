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

let typeFlag: number = 0;
let MapFactorFlag: number = 0;
let radianceImageFlag: boolean = true;
let factorIndex: number = 0;
const ENVIRONMENT_FACTOR: scene3d.Vec4[] = [
  { x: 1, y: 1, z: 1, w: 1 },
  { x: 40, y: 1, z: 1, w: 1 },
  { x: 1, y: 40, z: 1, w: 1 },
  { x: 1, y: 1, z: 40, w: 1 },
];

function GenRandom(): number {
  return Math.random() * 2 - 1;
}

@Entry
@Component
struct sceneEnvironment {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: scene3d.Camera | null = null;
  env: scene3d.Environment | null = null;
  envImg1: scene3d.Image | null = null;
  envImg2: scene3d.Image | null = null;
  envImg3: scene3d.Image | null = null;
  radianceImg1: scene3d.Image | null = null;

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
      scene3d.Scene.load($rawfile("gltf/DamagedHelmet/glTF/DamagedHelmet.gltf"))
        .then(async (result: scene3d.Scene) => {
          this.scene = result;
          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          let rf: scene3d.SceneResourceFactory = this.scene.getResourceFactory();
          this.cam = await rf.createCamera({ "name": "Camera1" });
          this.cam.enabled = true;
          this.cam.position.z = 5;
          this.env = await rf.createEnvironment({ "name": "Env" });

          this.envImg1 = await rf.createImage({ name: "envImg1", uri: $rawfile("gltf/Cube/glTF/Cube_BaseColor.png") });
          this.envImg2 = await rf.createImage({
            name: "envImg2",
            uri: $rawfile("gltf/Environment/glTF/images/quarry_02_2k_skybox.ktx")
          });
          this.envImg3 = await rf.createImage({
            name: "envImg3",
            uri: $rawfile("gltf/DamagedHelmet/glTF/Default_albedo.jpg")
          });
          this.radianceImg1 = await rf.createImage({
            name: "radianceImg1",
            uri: $rawfile("gltf/Environment/glTF/images/quarry_02_2k_radiance(spec).ktx")
          });
        })
        .catch((reason: string) => {
          Logger.error("init error", reason);
        });
    }
  }

  build() {
    Row() {
      Column() {
        Stack() {
          Column() {
          }.height('100%').width('100%')
          .backgroundColor(Color.Green)

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

        Button('change env Img Type').onClick(() => {
          if (!this.scene || !this.env || !this.cam) {
            return;
          }
          const ENV_TYPE_COUNT: number = 4;
          const ENV_TYPE_0: number = 0;
          const ENV_TYPE_1: number = 1;
          const ENV_TYPE_2: number = 2;
          const ENV_TYPE_3: number = 3;
          typeFlag = ++typeFlag  % ENV_TYPE_COUNT;
          if (typeFlag === ENV_TYPE_0) {
            this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_NONE;
            this.cam.clearColor = { r: 0, g: 0, b: 0, a: 0.0 };
          }
          else if (this.envImg1 && typeFlag === ENV_TYPE_1) {
            this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_IMAGE;
            this.scene.environment.environmentImage = this.envImg1;
          }
          else if (this.envImg2 && typeFlag === ENV_TYPE_2) {
            this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_CUBEMAP;
            this.scene.environment.environmentImage = this.envImg2;
          }
          else if (this.envImg3 && typeFlag === ENV_TYPE_3) {
            this.scene.environment.backgroundType = scene3d.EnvironmentBackgroundType.BACKGROUND_EQUIRECTANGULAR;
            this.scene.environment.environmentImage = this.envImg3;
          }
        }).id('change_type_environment');

        Button('change radiance Img').onClick(() => {
          if (!this.scene || !this.env) {
            return;
          }
          radianceImageFlag = !radianceImageFlag;
          if (radianceImageFlag) {
            this.scene.environment.radianceImage = null;
          }
          else if (this.radianceImg1 && !radianceImageFlag) {
            this.scene.environment.radianceImage = this.radianceImg1;
          }
        }).id('change_radiance');

        Button('change indirectDiffuseFactor').onClick(() => {
          if (!this.scene || !this.env) {
            return;
          }
          this.scene.environment.indirectDiffuseFactor =
            ENVIRONMENT_FACTOR[++factorIndex % ENVIRONMENT_FACTOR.length];
        }).id('change_indirectDiffuseFactor');

        Button('change indirectSpecularFactor').onClick(() => {
          if (!this.scene || !this.env) {
            return;
          }
          this.scene.environment.indirectSpecularFactor =
            ENVIRONMENT_FACTOR[++factorIndex % ENVIRONMENT_FACTOR.length];
        }).id('change_indirectSpecularFactor');

        Button('change environmentMapFactor').onClick(() => {
          if (!this.scene || !this.env) {
            return;
          }
          this.scene.environment.environmentMapFactor =
            ENVIRONMENT_FACTOR[++factorIndex % ENVIRONMENT_FACTOR.length];
        }).id('change_environmentMapFactor');

        Button('change irradianceCoefficients').onClick(() => {
          if (!this.scene || !this.env) {
            return;
          }
          MapFactorFlag = (MapFactorFlag + 1) % 4;
          this.scene.environment.irradianceCoefficients =
          [{ x: GenRandom(), y: GenRandom(), z: GenRandom() },
            { x: GenRandom(), y: GenRandom(), z: GenRandom() },
            { x: GenRandom(), y: GenRandom(), z: GenRandom() },
            { x: GenRandom(), y: GenRandom(), z: GenRandom() },
            { x: GenRandom(), y: GenRandom(), z: GenRandom() },
            { x: GenRandom(), y: GenRandom(), z: GenRandom() },
            { x: GenRandom(), y: GenRandom(), z: GenRandom() },
            { x: GenRandom(), y: GenRandom(), z: GenRandom() },
            { x: GenRandom(), y: GenRandom(), z: GenRandom() }];
        }).id('change_irradianceCoefficients');

        Button('back').onClick(() => {
          router.back()
        }).id('back_environment')
      }
      .width('100%')
    }
    .height('100%')
  }
}