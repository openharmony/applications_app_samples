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

let LOG_TAG: string = "Sample_Graphics3D";
let colorFlag: number = 0;
let intensityFlag: number = 0;
let shadowFlag: number = 0;

const colors: scene3d.Color[] = [
  { r: 0.8, g: 0.1, b: 0.2, a: 1.0 },
  { r: 0.1, g: 0.8, b: 0.2, a: 1.0 },
  { r: 0.2, g: 0.1, b: 0.8, a: 1.0 },
];

const intensities: number[] = [
  100.0, 500.0, 1000.0, 1500.0, 2000.0,
]

function Sub(l: scene3d.Vec3, r: scene3d.Vec3): scene3d.Vec3 {
  return { x: l.x - r.x, y: l.y - r.y, z: l.z - r.z };
}

function Dot(l: scene3d.Vec3, r: scene3d.Vec3): number {
  return l.x * r.x + l.y * r.y + r.z * l.z;
}

function Normalize(l: scene3d.Vec3): scene3d.Vec3 {
  let d = Math.sqrt(Dot(l, l));
  return { x: l.x / d, y: l.y / d, z: l.z / d };
}

function Cross(l: scene3d.Vec3, r: scene3d.Vec3): scene3d.Vec3 {
  return { x: (l.y * r.z - l.z * r.y), y: (l.z * r.x - l.x * r.z), z: (l.x * r.y - l.y * r.x) };
}

function Mul(l: scene3d.Quaternion, d: number): scene3d.Quaternion {
  return { x: l.x * d, y: l.y * d, z: l.z * d, w: l.w * d };
}

function lookAt(cam: scene3d.Node, eye: scene3d.Vec3, center: scene3d.Vec3, up: scene3d.Vec3) {

  let t: number;

  let q: scene3d.Quaternion = { x: 0.0, y: 0.0, z: 0.0, w: 0.0 };
  let f = Normalize(Sub(center, eye));
  let m0 = Normalize(Cross(f, up));
  let m1 = Cross(m0, f);
  let m2: scene3d.Vec3 = { x: -f.x, y: -f.y, z: -f.z };
  if (m2.z < 0) {
    if (m0.x > m1.y) {
      t = 1.0 + m0.x - m1.y - m2.z;
      q = { x: t, y: m0.y + m1.x, z: m2.x + m0.z, w: m1.z - m2.y };
    }
    else {
      t = 1.0 - m0.x + m1.y - m2.z;
      q = { x: m0.y + m1.x, y: t, z: m1.z + m2.y, w: m2.x - m0.z };
    }
  }
  else {
    if (m0.x < -m1.y) {
      t = 1.0 - m0.x - m1.y + m2.z;
      q = { x: m2.x + m0.z, y: m1.z + m2.y, z: t, w: m0.y - m1.x };
    }
    else {
      t = 1.0 + m0.x + m1.y + m2.z;
      q = { x: m1.z - m2.y, y: m2.x - m0.z, z: m0.y - m1.x, w: t };
    }
  }
  cam.position = eye;
  cam.rotation = Mul(q, 0.5 / Math.sqrt(t));
}

@Entry
@Component
struct node_geometry {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: scene3d.Camera | null = null;
  directionalLight: scene3d.DirectionalLight | null | undefined = null;
  spotLight: scene3d.SpotLight | null = null;
  @State lgt: scene3d.Light | null = null;
  @State nearPlaneValue: number = 0.1;
  radianceImg1: scene3d.Image | null = null;

  onPageShow(): void {
    this.Init();
  }

  PrintLight(light: scene3d.Light): void {
    if (!light) {
      return;
    }
    console.log(LOG_TAG + "Light name: " + light.name);
    console.log(LOG_TAG + "Light type: " + light.lightType);
    console.log(LOG_TAG + "Light color: [" + light.color.r + ", " + light.color.g + ", " + light.color.b + ", " + light.color.a + "]");
    console.log(LOG_TAG + "Light intensity: ", light.intensity);
    console.log(LOG_TAG + "Light shadowEnabled: " + light.shadowEnabled);
    if (light.lightType === scene3d.LightType.DIRECTIONAL) {
      let l: scene3d.DirectionalLight = light as scene3d.DirectionalLight;
      console.log(LOG_TAG + "Light near plane: " + l.nearPlane);
    }
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
      scene3d.Scene.load($rawfile("gltf/CubeWithFloor/glTF/AnimatedCube.gltf"))
        .then(async (result: scene3d.Scene) => {
          this.scene = result;
          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          let rf: scene3d.SceneResourceFactory = this.scene.getResourceFactory();
          this.cam = await rf.createCamera({ "name": "Camera1" });
          this.cam.position.z = 5;
          this.cam.enabled = true;

          lookAt(this.cam, { x: 10, y: 5, z: 15 }, { x: 0, y: 0.0, z: 0.0 }, { x: 0, y: 1, z: 0 });

          this.radianceImg1 = await rf.createImage({
            name: "radianceImg1",
            uri: $rawfile("gltf/Environment/glTF/images/quarry_02_2k_radiance(spec).ktx")
          });

          this.scene.environment.radianceImage = this.radianceImg1;

          this.directionalLight =
          await this.scene?.getResourceFactory().createLight({
            "name": "DirectionalLight1"
          }, scene3d.LightType.DIRECTIONAL) as scene3d.DirectionalLight;
          if (!this.directionalLight) {
            console.log(LOG_TAG + 'create directional light fail')
          }
          lookAt(this.directionalLight, { x: 10.0, y: 10.0, z: 10.0 }, { x: 0.0, y: 0.0, z: 0.0 }, {
            x: 0.0,
            y: 1.0,
            z: 0.0
          });

          this.directionalLight.enabled = false;

          this.spotLight =
          await this.scene?.getResourceFactory().createLight({
            "name": "SpotLight1"
          }, scene3d.LightType.SPOT) as scene3d.SpotLight;

          if (!this.spotLight) {
            console.log(LOG_TAG + 'create spot light fail')
          }

          let targ: scene3d.Vec3 = { x: 0, y: 0.0, z: 0.0 };
          let pos: scene3d.Vec3 = { x: 6, y: 6, z: -6 };
          let up: scene3d.Vec3 = { x: 0, y: 1, z: 0 };

          lookAt(this.spotLight, pos, targ, up);

          this.spotLight.enabled = true;

          this.lgt = this.spotLight;
          this.UpdateLights();
        })
        .catch((reason: string) => {
          console.log(LOG_TAG + " error: " + reason)
        });
    }
  }

  UpdateLights(): void {
    if (this.lgt) {

      this.lgt.color = colors[colorFlag];
      this.lgt.intensity = intensities[intensityFlag];
      if (this.lgt.lightType === scene3d.LightType.DIRECTIONAL) {
        this.lgt.intensity = intensities[intensityFlag] / 50.0;
      }
      this.lgt.shadowEnabled = shadowFlag == 0;
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

        if (this.lgt) {
          Button('Switch light type (' + (this.lgt.lightType === scene3d.LightType.DIRECTIONAL ? 'DIRECTIONAL' : 'SPOT') + ')')
            .onClick(() => {
              if (this.lgt) {
                this.lgt.enabled = false;

                if (this.lgt.lightType === scene3d.LightType.DIRECTIONAL) {
                  this.lgt = this.spotLight;
                } else if (this.directionalLight) {
                  this.lgt = this.directionalLight;
                }
              }

              if (this.lgt) {
                this.lgt.enabled = true;
                this.UpdateLights();
                this.PrintLight(this.lgt);
              }
            })
        }

        if (this.lgt) {
          Button(this.lgt.enabled ? 'Disable' : 'Enable').onClick(() => {
            if (!this.scene || !this.lgt) {
              return;
            }

            this.lgt.enabled = !this.lgt.enabled;

            console.log(LOG_TAG + "Light enabled: " + this.lgt.enabled);
          });

          if (this.lgt.enabled) {
            Button('change color').onClick(() => {
              if (!this.scene || !this.lgt) {
                return;
              }

              colorFlag = (colorFlag + 1) % colors.length;
              this.UpdateLights();

              console.log(LOG_TAG + "Light color: [" + this.lgt.color.r + ", " + this.lgt.color.g + ", " + this.lgt.color.b + ", " + this.lgt.color.a + "]");
            });

            Button('Change intensity (' + this.lgt.intensity + ')').onClick(() => {
              if (!this.scene || !this.lgt) {
                return;
              }

              intensityFlag = (intensityFlag + 1) % intensities.length;
              this.UpdateLights();
              console.log(LOG_TAG + "Light intensity: " + this.lgt.intensity);
            });

            Button('Shadows (' + (this.lgt.shadowEnabled ? 'enabled' : 'disabled') + ')').onClick(() => {
              if (!this.scene || !this.lgt) {
                return;
              }
              shadowFlag = (shadowFlag + 1) % 2;
              this.UpdateLights();
              console.log(LOG_TAG + "Light shadowEnabled: " + this.lgt.shadowEnabled);
            });
          }
        }

        Button('back').onClick(() => {
          router.back()
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}