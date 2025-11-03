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

import { Scene, Camera, Material, Image, SceneResourceFactory, Geometry, EnvironmentBackgroundType,
  PostProcessSettings, ToneMappingType, PlaneGeometry, MeshResource, MaterialType, MetallicRoughnessMaterial,
  Vec3, CullMode } from '@kit.ArkGraphics3D';
import {lookAt, OrbitCameraHelper } from '../common/utils';

const RESO: number = 63;

@Entry
@Component
struct material_render_slot {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: Camera | null = null;
  orbitCamera: OrbitCameraHelper = new OrbitCameraHelper();
  material: Material | null = null;

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
      // Load an empty scene (used to host the generated plane)
      Scene.load()
        .then(async (scene: Scene) => {
          this.scene = scene;
          if (!this.scene.root) {
            return;
          }
          let rf: SceneResourceFactory = scene.getResourceFactory();
          // Create a plane geometry
          let planeGeom: PlaneGeometry = new PlaneGeometry();
          planeGeom.size = {x: 1.3, y: 1};
          let meshRes: MeshResource = await rf.createMesh({name: 'planeMesh'}, planeGeom);
          // Create the first plane (semi-transparent red)
          {
            let plane1: Geometry = await rf.createGeometry({ name: 'plane1' }, meshRes);
            this.material = await rf.createMaterial({ 'name': 'material' }, MaterialType.SHADER);
            const helmAlbedo: Resource = $rawfile('gltf/DamagedHelmet/glTF/Default_albedo.jpg');
            let helmTexture: Image | null = await rf.createImage({ name: 'helmTexture', uri: helmAlbedo });
            (this.material as MetallicRoughnessMaterial).baseColor.image = helmTexture;
            (this.material as MetallicRoughnessMaterial).baseColor.factor = {x:1, y: 0, z:0, w:0.5};
            plane1.mesh.subMeshes[0].material = this.material;
            this.material.blend = { enabled: true };
            this.material.cullMode = CullMode.NONE;
          }
          // Create the second plane (semi-transparent white)
          {
            let plane2: Geometry = await rf.createGeometry({ name: 'plane2' }, meshRes);
            let material2: Material | null =
              await rf.createMaterial({ 'name': 'material2' }, MaterialType.SHADER);
            material2.blend = { enabled: true };
            material2.cullMode = CullMode.NONE;
            (material2 as MetallicRoughnessMaterial).baseColor.factor = {x:1, y: 1, z:1, w:0.9};
            plane2.mesh.subMeshes[0].material = material2;
            let pos: Vec3 = plane2.position;
            pos.x += 0.5; // offset position for visual separation
            plane2.position = pos;
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
        });
    }
  }

  // Update the render sort layer to adjust the drawing priority between transparent objects
  updateRenderSort(layer: number) {
    if (this.material) {
      this.material.renderSort = { renderSortLayer: layer };
    }
  }
  // Switch the render sort order (layer and order index) to change which object is rendered first
  switchOrder() {
    if (this.material) {
      this.material.renderSort = { renderSortLayer: 32, renderSortLayerOrder: 1 };
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

      Text('Render sort layer');
      Slider({
        value: RESO / 2,
        min: 0,
        max: RESO,
        style: SliderStyle.OutSet,
      }).onChange((value: number) => {
        this.updateRenderSort(Math.round(value));
      });
      Button('switch render sort layer order').onClick(() => this.switchOrder());

      Button('back').onClick(() => {
        router.back();
      });
    }.width('100%').height('70%');
  }
}