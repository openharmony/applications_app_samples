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
import animator, { AnimatorResult } from '@ohos.animator';
import router from '@ohos.router';
import Logger from '../util/Logger';

@Entry
@Component
struct sceneShader {
  scene: scene3d.Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  rf: scene3d.SceneResourceFactory | null = null;
  cam: scene3d.Camera | null = null;
  shader: scene3d.Shader | null = null;
  material: scene3d.ShaderMaterial | null = null;
  geom: scene3d.Geometry | null = null;
  image: scene3d.Image | null = null;
  materialOrg: scene3d.Material | null = null;
  backAnimator: AnimatorResult | undefined = undefined;
  step: number = 0;
  @State hierarchy: string = '';
  @State meshInfo: string = '';

  traversal(node: scene3d.Node | null): void {
    if (!node) {
      return;
    }
    this.hierarchy += node.path + '/' + node.name + '\n';
    let container: scene3d.Container<scene3d.Node> = node.children;
    let count: number = container.count();
    this.hierarchy += '  ';
    for (let i = 0; i < count; i++) {
      this.traversal(container.get(i));
    }
  }

  onPageShow(): void {
    this.init();
  }

  PrintAabb(aabb: scene3d.Aabb, append: string): string {
    let info: string = ''
    info += append + " max aabb [ " + aabb.aabbMax.x + " "+ aabb.aabbMax.y + " "+ aabb.aabbMax.z + " ]";
    info += "\n" + append + " min aabb [ " + aabb.aabbMin.x + " "+ aabb.aabbMin.y + " "+ aabb.aabbMin.z + " ]";
    return info;
  }

  onPageHide(): void {
    if (this.scene) {
      this.scene.destroy();
    }

    this.cam = null;
    this.scene = null;
  }

  init(): void {
    this.backAnimator = animator.create({
      duration: 2000, // duration
      easing: "ease",
      delay: 0,
      fill: "none",
      direction: "normal",
      iterations: -1, // endless loop
      begin: 100, // begin
      end: 200 // end
    })
    this.backAnimator.onframe = value => {
      this.step++;
      if (this.material && this.material.colorShader) {
        // just give a random effect
        (this.material.colorShader.inputs["vec_1"] as scene3d.Vec4) = { x: Math.abs(Math.sin(this.step) + 0.5),
          y: Math.abs(Math.sin(this.step * 0.86) + 0.5),
               z: Math.abs(Math.sin(this.step * 0.91) + 0.5), w: 1.0 };
        (this.material.colorShader.inputs["time"] as number) = this.step;
      }
    }
    if (this.scene === null) {
      scene3d.Scene.load($rawfile("gltf/Cube/glTF/Cube.glb"))
        .then(async (result: scene3d.Scene) => {
          this.scene = result;
          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          this.rf = this.scene.getResourceFactory();
          this.cam = await this.rf.createCamera({ "name": "Camera1" });
          this.cam.enabled = true;
          this.cam.position.z = 5; // put camera to 5 at z

          this.image = await this.rf.createImage({ name: "envImg3", uri: $rawfile("gltf/DamagedHelmet/glTF/Default_AO.jpg") });
          this.traversal(this.scene?.root);
          if (!this.geom) {
            this.geom = this.scene.getNodeByPath("rootNode_/Unnamed Node 1/Cube") as scene3d.Geometry;
            this.meshInfo += this.PrintAabb(this.geom.mesh.aabb, 'Mesh ');
            let i = 0;
            for (let M of this.geom.mesh.subMeshes) {
              this.meshInfo += '\n';
              this.meshInfo += this.PrintAabb(this.geom.mesh.aabb, 'Submesh[' + i + "]");
              i++;
            }

          }
          this.materialOrg = this.geom.mesh.subMeshes[0].material;

        })
        .catch((reason: string) => {
          Logger.error("init error", reason);
        });
    }
  }

  build() {
    Row() {
      Column() {
        Column() {
          if (this.sceneOpt) {
            Component3D(this.sceneOpt)
              .renderWidth('60%')
              .renderHeight('60%').onAppear(()=>{
               this.backAnimator?.play()
            })
          }
          else {
            Text("loading 1...");
          }
        }
        .height('30%')

        Button('create shader and change material').onClick(async () => {
          if (!this.scene || !this.rf) {
            return;
          }
          if (!this.material) {
            this.material = await this.rf.createMaterial({ name: "CustomMaterial" }, scene3d.MaterialType.SHADER);
          }
          if (!this.shader) {
            this.shader = await this.rf.createShader({ name: "CustomShader", uri: $rawfile("shaders/custom_shader/custom_material_sample.shader") });
          }

          if (this.material) {
            this.material.colorShader = this.shader;
          }

          if (!this.geom) {
            this.geom = this.scene.getNodeByPath("rootNode_/Unnamed Node 1/Cube") as scene3d.Geometry;
          }

           this.geom.mesh.materialOverride = undefined;
           this.geom.mesh.subMeshes[0].material = this.material;

          if (this.material && this.material.colorShader && this.image) {
            (this.material.colorShader.inputs["BASE_COLOR_Image"] as scene3d.Image) = this.image;
          }
        }).id('create_shader_change_material');

        Button('recovery original material').onClick(async () => {
          if (this.geom) {
            this.geom.mesh.materialOverride = undefined;
            this.geom.mesh.subMeshes[0].material = this.materialOrg as scene3d.ShaderMaterial;
          }
        }).id('recovery_original')

        Button('material override').onClick(async () => {
          if (this.geom) {
            this.geom.mesh.subMeshes[0].material = this.materialOrg as scene3d.ShaderMaterial;
          }
          if (this.geom && this.material) {
            this.geom.mesh.materialOverride = this.material as scene3d.ShaderMaterial;
          }
        }).id('material_override')

        Text(this.meshInfo);
        Text(this.hierarchy);
        Button('back').onClick(() => {
          this.backAnimator?.cancel();
          router.back()
        }).id('back_shader')
      }
      .width('100%')
    }
    .height('100%')
  }
}
