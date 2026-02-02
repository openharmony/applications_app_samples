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
// [Start pbr_clearcoat_header]
import { Scene, Camera, Material, Node, Image, SceneResourceFactory, Geometry, EnvironmentBackgroundType,
  PostProcessSettings, ToneMappingType, MetallicRoughnessMaterial, Vec4 } from '@kit.ArkGraphics3D';
import {lookAt, OrbitCameraHelper } from '../common/utils';
// [End pbr_clearcoat_header]

const RESO: number = 255;

@Entry
@Component
struct pbr_clearcoat {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: Camera | null = null;
  orbitCamera: OrbitCameraHelper = new OrbitCameraHelper();
  material: Material | null = null;
  textures: Image[] = [];
  textureInUse: number = 0;

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
    // [Start pbr_clearcoat_loadScene]
    if (this.scene == null) {
      // Switched from .gltf to .glb; same content, different format
      Scene.load($rawfile('gltf/CompareClearcoat/CompareClearcoat.glb'))
        .then(async (scene: Scene) => {
          this.scene = scene;
          if (!this.scene.root) {
            return;
          }
          let rf: SceneResourceFactory = scene.getResourceFactory();

          // [StartExclude pbr_clearcoat_loadScene]
          // Obtain the target node and its material, then preload several clearcoat textures
          // [Start pbr_clearcoat_getMaterialAndTextures]
          let pbrNode: Node | null | undefined = this.scene.root?.getNodeByPath('Unnamed Node 1/GeoSphere003');
          if (pbrNode) {
            this.material = (pbrNode as Geometry).mesh.subMeshes[0].material;
            let mrMaterial = (this.material as MetallicRoughnessMaterial);
            let original: Image | null = mrMaterial.clearCoat.image;
            const helmAlbedo: Resource = $rawfile('image/round_pattern.png');
            const irregularUri: Resource = $rawfile('image/irregular_pattern.png');
            let round: Image | null = await rf.createImage({name: 'round', uri: helmAlbedo });
            let irregular: Image | null = await rf.createImage({name: 'irregular', uri: irregularUri });
            if (original && round && irregular ) {
              this.textures.push(original);
              this.textures.push(round);
              this.textures.push(irregular);
            }
          }
          // [End pbr_clearcoat_getMaterialAndTextures]

          // Create image-based lighting environment
          // [Start pbr_clearcoat_createIBL]
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
          // [End pbr_clearcoat_createIBL]
          // Create and set up the camera to view the scene and enable orbit control
          // [Start pbr_clearcoat_createCamera]
          this.cam = await rf.createCamera({ 'name': 'ClearcoatCam' });
          this.cam.enabled = true;
          lookAt(this.cam,{x:0,y:0,z:-3},{x:0,y:0,z:0},{x:0,y:1,z:0});
          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          this.orbitCamera.SetOrbitFromEye(this.cam.position, this.scene.root.position, this.cam.rotation);
          // [End pbr_clearcoat_createCamera]
          // Enable tone mapping for better HDR visualization
          (this.cam.postProcess as PostProcessSettings) = {
            toneMapping: {
              type: ToneMappingType.ACES,
              exposure: 1.0,
            }
          };
          this.setClearcoat(RESO / 2);
          this.setClearcoatRoughness(RESO / 2);
          // [EndExclude pbr_clearcoat_loadScene]
        });
    }
    // [End pbr_clearcoat_loadScene]
  }

  // Switch between available textures for the clearcoat layer
  // [Start pbr_clearcoat_changeClearcoatTexture]
  changeClearcoatTex() {
    if (this.textures.length > 0) {
      let i = ++this.textureInUse % this.textures.length;
      (this.material as MetallicRoughnessMaterial).clearCoat.image = this.textures[i];
    }
  }
  // [End pbr_clearcoat_changeClearcoatTexture]

  // Adjust clearcoat intensity
  // [Start pbr_clearcoat_setClearcoat]
  setClearcoat(v: number) {
    if (this.material) {
      const f: Vec4 = (this.material as MetallicRoughnessMaterial).clearCoat.factor;
      f.x = v / RESO;
      (this.material as MetallicRoughnessMaterial).clearCoat.factor = f;
    }
  }
  // [End pbr_clearcoat_setClearcoat]

  // Switch between available textures for clearcoat roughness
  // [Start pbr_clearcoat_changeRoughnessTexture]
  changeClearcoatRoughTex() {
    if (this.textures.length > 0) {
      let i = ++this.textureInUse % this.textures.length;
      (this.material as MetallicRoughnessMaterial).clearCoatRoughness.image = this.textures[i];
    }
  }
  // [End pbr_clearcoat_changeRoughnessTexture]

  // Adjust clearcoat roughness intensity
  // [Start pbr_clearcoat_setClearcoatRoughness]
  setClearcoatRoughness(v: number) {
    if (this.material) {
      const f: Vec4 = (this.material as MetallicRoughnessMaterial).clearCoatRoughness.factor;
      f.y = v / RESO;
      (this.material as MetallicRoughnessMaterial).clearCoatRoughness.factor = f;
    }
  }
  // [End pbr_clearcoat_setClearcoatRoughness]

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

      Text('Clearcoat intensity');
      Slider({ value: RESO / 2, min: 0, max: RESO }).onChange(v => this.setClearcoat(v));
      Button('Change clearcoat texture').onClick(() => this.changeClearcoatTex());
      Text('Clearcoat roughness');
      Slider({ value: RESO / 2, min: 0, max: RESO }).onChange(v => this.setClearcoatRoughness(v));
      Button('Change roughness texture').onClick(() => this.changeClearcoatRoughTex());

      Button('back').onClick(() => {
        router.back();
      });
    }.width('100%').height('50%');
  }
}