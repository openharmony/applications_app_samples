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

@Entry
@Component
struct pbr_ao {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: Camera | null = null;
  orbitCamera: OrbitCameraHelper = new OrbitCameraHelper();
  @State materials: Material[] = [];
  @State images: (Image | null)[] = [];
  @State originImages: (Image | null)[] = [];
  @State label: boolean = true;

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
      Scene.load($rawfile('gltf/CompareAmbientOcclusion/CompareAmbientOcclusion.glb'))
        .then(async (scene: Scene) => {
          this.scene = scene;
          if (!this.scene.root) {
            return;
          }
          let rf: SceneResourceFactory = scene.getResourceFactory();
          // Retrieve nodes containing basket and fruit objects
          let basket: Node | null | undefined = this.scene.root?.getNodeByPath('Unnamed Node 1/BasketRight');
          let fruits: Node | null | undefined = this.scene.root?.getNodeByPath('Unnamed Node 1/FruitRight');
          // Store materials and prepare AO textures
          if (basket && fruits) {
            // Collect materials
            this.materials.push((basket as Geometry).mesh.subMeshes[0].material);
            this.materials.push((fruits as Geometry).mesh.subMeshes[0].material);
            // Default AO image (simulated here using bricks.png)
            let defaultAo : Image | null = await rf.createImage({name: 'defaultAo', uri: $rawfile('image/bricks.png')});
            this.originImages.push(defaultAo);
            this.originImages.push(defaultAo);
            // Alternative AO image for comparison
            let altAo: Image | null = await rf.createImage({name: 'altAo', uri: $rawfile('image/cloth_bumpmap.png')});
            this.images.push(altAo);
            this.images.push(altAo);
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
          this.cam = await rf.createCamera({ 'name': 'AOCam' });
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
          this.setAoFactor(RESO / 2);
        });
    }
  }

  // Toggle between the original AO texture and the alternative AO texture
  toggleAoTexture() {
    if (this.label) {
      (this.materials[0] as MetallicRoughnessMaterial).ambientOcclusion.image = this.images[0];
      (this.materials[1] as MetallicRoughnessMaterial).ambientOcclusion.image = this.images[1];
    } else {
      (this.materials[0] as MetallicRoughnessMaterial).ambientOcclusion.image = this.originImages[0];
      (this.materials[1] as MetallicRoughnessMaterial).ambientOcclusion.image = this.originImages[1];
    }
    this.label = !this.label;
  }

  // Adjust AO strength with a slider
  setAoFactor(v: number) {
    this.materials.forEach((material: Material) => {
      const f: Vec4 = (material as MetallicRoughnessMaterial).ambientOcclusion.factor;
      f.x = 2 * v / RESO;
      (material as MetallicRoughnessMaterial).ambientOcclusion.factor = f;
    });
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

      Button('Change ao texture').onClick(() => this.toggleAoTexture());
      Text('Ambient occlusion factor');
      Slider({ value: RESO / 2, min: 0, max: RESO }).onChange(v => this.setAoFactor(v));

      Button('back').onClick(() => {
        router.back();
      });

    }.width('100%').height('70%');
  }
}