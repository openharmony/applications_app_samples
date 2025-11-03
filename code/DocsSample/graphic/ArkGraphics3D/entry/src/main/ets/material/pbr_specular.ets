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

import router from '@ohos.router';

import { Scene, Camera, Material, Node, Image, SceneResourceFactory, Geometry, EnvironmentBackgroundType,
  PostProcessSettings, ToneMappingType, MetallicRoughnessMaterial, Vec4 } from '@kit.ArkGraphics3D';
import {lookAt, OrbitCameraHelper } from '../common/utils';

const RESO: number = 255;
const GAIN: number = 5;
const INIT: number = RESO / GAIN;

@Entry
@Component
struct pbr_specular {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: Camera | null = null;
  orbitCamera: OrbitCameraHelper = new OrbitCameraHelper();
  material: Material | null = null;
  textures: Image[] = [];
  textureInUse: number = 0;
  @State z:number = 0;
  @State x:number = 0;
  @State y:number = 0;

  onPageShow(): void {
    this.Init();
  }

  aboutToDisappear(): void {
    if (this.scene) {
      this.scene.destroy();
    }
    this.cam = null;
    this.scene = null;
  }

  Init(): void {
    if (this.scene == null) {
      // Switched from .gltf to .glb; same content, different format
      Scene.load($rawfile('gltf/CompareMetallic/CompareMetallic.glb'))
        .then(async (scene: Scene) => {
          this.scene = scene;
          if (!this.scene.root) {
            return;
          }
          let rf: SceneResourceFactory = scene.getResourceFactory();
          // Retrieve the geometry node and its material
          let pbrNode: Node | null | undefined = this.scene.root?.getNodeByPath('Unnamed Node 1/GeoSphere001');
          if (pbrNode) {
            this.material = (pbrNode as Geometry).mesh.subMeshes[0].material;
            let mrMaterial = (this.material as MetallicRoughnessMaterial);
            // Load base and alternate textures for specular testing
            let original: Image | null = mrMaterial.specular.image;
            const helmAlbedo: Resource = $rawfile('gltf/DamagedHelmet/glTF/Default_albedo.jpg');
            const roundUri: Resource = $rawfile('image/round_pattern.png');
            let helmet: Image | null = await rf.createImage({name: 'helmetTexture', uri: helmAlbedo });
            let round: Image | null = await rf.createImage({name: 'helmetTexture', uri: roundUri });
            if (original && helmet && round) {
              this.textures.push(original);
              this.textures.push(helmet);
              this.textures.push(round);
            }
          }

          // Create image-based lighting environment
          scene.environment = await rf.createEnvironment({ name: 'env' });
          scene.environment.backgroundType = EnvironmentBackgroundType.BACKGROUND_CUBEMAP;
          scene.environment.environmentImage = await rf.createImage({ name: 'cube', uri: $rawfile('Environment/quarry_02_2k_skybox.ktx') });
          scene.environment.radianceImage = await rf.createImage({ name: 'rad', uri: $rawfile('Environment/quarry_02_2k_radiance.ktx') });
          scene.environment.irradianceCoefficients =
            [{ x: 1.080343842506409, y: 0.936282396316528, z: 0.665518164634705 },
              { x: 0.959947884082794, y: 0.828918874263763, z: 0.569704353809357 },
              { x: 0.848236382007599, y: 0.715092182159424, z: 0.473145037889481 },
              { x: -0.591795265674591, y: -0.501678705215454, z: -0.334018945693970 },
              { x: -0.775423347949982, y: -0.655484378337860, z: -0.437325984239578 },
              { x: 1.053589701652527, y: 0.887459456920624, z: 0.587381422519684 },
              { x: -0.018954016268253, y: -0.014871496707201, z: -0.008891185745597 },
              { x: -0.566255271434784, y: -0.476870059967041, z: -0.314557582139969 },
              { x: -0.239390164613724, y: -0.200478553771973, z: -0.132790848612785 }];
          // Create and set up the camera to view the scene and enable orbit control
          this.cam = await rf.createCamera({ 'name': 'HelmetCamera' });
          this.cam.enabled = true;
          lookAt(this.cam,{x:0,y:0,z:-3},{x:0,y:0,z:0},{x:0,y:1,z:0});
          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          this.orbitCamera.SetOrbitFromEye(this.cam.position, this.scene.root.position, this.cam.rotation);
          // Enable tone mapping for better HDR visualization
          (this.cam.postProcess as PostProcessSettings) = {
            toneMapping: {
              type: ToneMappingType.ACES,
              exposure: 0.7,
            }
          };
          this.setSpecularChannel(0, RESO);
          this.setSpecularChannel(1, RESO);
          this.setSpecularChannel(2, INIT);
          this.setSpecularIntensity(INIT);
        });
    }
  }

  // Switch between the available specular textures
  changeSpecularTex() {
    if (this.textures.length > 0) {
      let i = ++this.textureInUse % this.textures.length;
      (this.material as MetallicRoughnessMaterial).specular.image = this.textures[i];
    }
  }

  // Adjust the individual RGB channels of the specular color
  setSpecularChannel(idx: number, v: number) {
    if (this.material) {
      const f: Vec4 = (this.material as MetallicRoughnessMaterial).specular.factor;
      if (idx === 0) {
        f.x = GAIN * v / RESO;
        this.x = f.x;
      }
      if (idx === 1) {
        f.y = GAIN * v / RESO;
        this.y = f.y;
      }
      if (idx === 2) {
        f.z = GAIN * v / RESO;
        this.z = f.z;
      }
      (this.material as MetallicRoughnessMaterial).specular.factor = f;
    }
  }

  // Adjust the overall specular intensity
  setSpecularIntensity(v: number) {
    if (this.material) {
      const f = (this.material as MetallicRoughnessMaterial).specular.factor;
      const w = 100 * v / RESO;
      (this.material as MetallicRoughnessMaterial).specular.factor = { x: f.x, y: f.y, z: f.z, w: w };
    }
  }

  build() {
    Column() {
      if (this.sceneOpt) {
        // Present 3D scenes through Component3D
        Component3D(this.sceneOpt)
          .onTouch((event: TouchEvent) => {
            // Handle touch input for orbit camera rotation
            this.orbitCamera.HandleTouchEvent(event);
            if (this.cam) {
              this.cam.position = this.orbitCamera.GetCameraPosition();
              this.cam.rotation = this.orbitCamera.GetCameraRotation();
            }
          })
          .gesture(
            PinchGesture({ fingers: 2 })
              .onActionStart((event: GestureEvent) => {
                console.info('Pinch start');
              })
              .onActionUpdate((event: GestureEvent) => {
                // Handle pinch gesture for camera zoom
                this.orbitCamera.HandlePinchGestureActionUpdate(event);
                if (this.cam) {
                  this.cam.position = this.orbitCamera.GetCameraPosition();
                  this.cam.rotation = this.orbitCamera.GetCameraRotation();
                }
              })
              .onActionEnd(() => {
                this.orbitCamera.HandlePinchGestureActionEnd();
              }))
      } else {
        Text('loading ...');
      }

      Button('Change texture').onClick(() => this.changeSpecularTex());
      Text('Specular red');
      Slider({ value: RESO, min: 0, max: RESO }).onChange(v => this.setSpecularChannel(0, v));
      Text('Specular green');
      Slider({ value: RESO, min: 0, max: RESO }).onChange(v => this.setSpecularChannel(1, v));
      Text('Specular blue');
      Slider({ value: INIT, min: 0, max: RESO }).onChange(v => this.setSpecularChannel(2, v));
      Text('Specular intensity');
      Slider({ value: INIT, min: 0, max: RESO }).onChange(v => this.setSpecularIntensity(v));

      Button('back').onClick(() => {
        router.back();
      });
    }.width('100%').height('50%');
  }
}