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

import { Scene, Camera, Material, SceneResourceFactory, Geometry, EnvironmentBackgroundType,
  PostProcessSettings, ToneMappingType, PlaneGeometry, MeshResource, MaterialType, Vec3, Light, Animation,
  LightType } from '@kit.ArkGraphics3D';
import {lookAt, OrbitCameraHelper } from '../common/utils';

@Entry
@Component
struct material_shadowReceiver {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: Camera | null = null;
  orbitCamera: OrbitCameraHelper = new OrbitCameraHelper();
  material: Material | null = null;
  @State speed: number = 1;
  @State anim: Animation | null = null;

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
      Scene.load($rawfile('gltf/BrainStem/glTF/BrainStem.glb'))
        .then(async (scene: Scene) => {
          this.scene = scene;
          if (!this.scene.root) {
            return;
          }
          let rf: SceneResourceFactory = scene.getResourceFactory();
          // Create a spotlight with shadow enabled
          let light: Light = await rf.createLight({ name: 'MySpotLight' }, LightType.SPOT);
          light.color = { r: 1.0, g: 0.3, b: 1.0, a: 1.0 };
          light.intensity = 100; // required for spotlight
          light.shadowEnabled = true;
          let pos: Vec3 = { x: 0, y: 3, z: 0.6 };
          let targ: Vec3 = { x: 0, y: 0, z: 0.0 };
          let up: Vec3 = { x: 0, y: 0, z: 1 };
          lookAt(light, pos, targ, up);

          // Create a plane that can receive shadows
          let planeGeom: PlaneGeometry = new PlaneGeometry();
          planeGeom.size = {x: 5, y: 5};
          let meshRes: MeshResource = await rf.createMesh({name: 'shadowPlaneMesh'}, planeGeom);
          let plane: Geometry = await rf.createGeometry({name: 'shadowPlane'}, meshRes);

          // Create a material and enable shadow receiving
          this.material = await rf.createMaterial({'name': 'planeMat'}, MaterialType.SHADER);
          plane.mesh.subMeshes[0].material = this.material;
          this.material.shadowReceiver = true;

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
          this.cam = await rf.createCamera({ 'name': 'ShadowCam' });
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
          // Play the animation if available
          if (scene.animations.length > 0) {
            let an: Animation = scene.animations[0];
            this.anim = an;
            an.onFinished(() => {
              an.restart();
            })
            an.start();
          }
        });
    }
  }

  // Toggle the shadow receiving state of the plane
  toggleShadow(): void {
    console.log('Clicked');
    if (this.material) {
      console.log('Toggling');
      this.material.shadowReceiver = !this.material.shadowReceiver;
    }
  }

  // Playback direction of the reverse animation
  toggleAnimSpeed(): void {
    this.speed = -this.speed;
    if (this.anim) {
      this.anim.speed = this.speed;
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

      Text('Shadow receiver demo');
      Button('Toggle shadowReceiver').onClick(() => {
        this.toggleShadow();
      });

      Button('animation speed change').onClick(() => {
        this.toggleAnimSpeed();
      });
      Button('back').onClick(() => {
        router.back();
      });
    }.width('100%').height('70%');
  }
}