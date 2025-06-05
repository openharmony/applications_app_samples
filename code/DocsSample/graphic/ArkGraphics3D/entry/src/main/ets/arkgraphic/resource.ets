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

import {
  Camera,
  Environment,
  Geometry,
  Image,
  Material,
  MaterialType,
  Scene,
  SceneResourceFactory,
  SceneResourceParameters,
  Shader,
  ShaderMaterial,
  EnvironmentBackgroundType
} from '@kit.ArkGraphics3D';
import { router } from '@kit.ArkUI';
import logger from '../utils/Logger';

let globalScene: Scene | null = null;

function createMaterialPromise(): Promise<Material> {
  return new Promise((resolve, reject) => {
    // Ensure the scene is loaded before accessing sceneFactory
    if (globalScene) {
      let sceneFactory: SceneResourceFactory = globalScene.getResourceFactory();
      let sceneMaterialParameter: SceneResourceParameters = { name: 'material' };
      // Create Material
      let material: Promise<Material> = sceneFactory.createMaterial(sceneMaterialParameter, MaterialType.SHADER);
      material.then(resolve)
      .catch((err: string) => {
        logger.error('Blank material create failed: ' + err);
        reject(err);
      });
    } else {
      reject('Scene is not loaded yet.');
    }
  });
}

function createShaderPromise(): Promise<Shader> {
  return new Promise((resolve, reject) => {
    // Ensure the scene is loaded before accessing sceneFactory
    if (globalScene) {
      let sceneFactory: SceneResourceFactory = globalScene.getResourceFactory();

      // Create a SceneResourceParameters object and use it to create a shader
      let sceneResourceParameter: SceneResourceParameters = {
        name: 'shaderResource',
        uri: $rawfile('shaders/custom_shader/custom_material_sample.shader')
      };
      let shader: Promise<Shader> = sceneFactory.createShader(sceneResourceParameter);
      shader.then(async (shaderEntity: Shader) => {
        let sceneMaterialParameter: SceneResourceParameters = { name: 'material' };
        // Create material
        let material: Promise<Material> = sceneFactory.createMaterial(sceneMaterialParameter, MaterialType.SHADER);
        material.then(async (materialEntity: ShaderMaterial) => {
          // Bind material with shader
          materialEntity.colorShader = shaderEntity;
          resolve(shaderEntity);
        }).catch((err: string) => {
          logger.error('Custom ShaderMaterial create failed: ' + err + '.');
          reject(err);
        });
      }).catch((err: string) => {
        logger.error('Shader load failed: ' + err + '.');
        reject(err);
      });
    } else {
      reject('Scene is not loaded yet.');
    }
  });
}

function createImagePromise(): Promise<Image> {
  return new Promise((resolve, reject) => {
    // Ensure the scene is loaded before accessing sceneFactory
    if (globalScene) {
      let sceneFactory: SceneResourceFactory = globalScene.getResourceFactory();
      let sceneImageParameter: SceneResourceParameters = { name: 'image', uri: $rawfile('image/Cube_BaseColor.png') };
      // Create image
      let image: Promise<Image> = sceneFactory.createImage(sceneImageParameter);
      image.then(async (imageEntity: Image) => {
        let sceneMaterialParameter: SceneResourceParameters = { name: 'material' };
        // Create material
        let material: Promise<Material> = sceneFactory.createMaterial(sceneMaterialParameter, MaterialType.SHADER);
        material.then(async (materialEntity: ShaderMaterial) => {
          // Use the created image resource to set texture property
          if (materialEntity && materialEntity.colorShader) {
            materialEntity.colorShader.inputs['BASE_COLOR_Image'] = imageEntity;
          }
          resolve(imageEntity);
        }).catch((err: string) => {
          logger.error('Shader material of image texture create failed: ' + err + '.');
          reject(err);
        });
      }).catch((err: string) => {
        logger.error('ImageTexture load failed: ' + err + '.');
        reject(err);
      });
    } else {
      reject('Scene is not loaded yet.');
    }
  });
}

function createEnvironmentPromise() : Promise<Environment> {
  return new Promise((resolve, reject) => {
    // Ensure the scene is loaded before accessing sceneFactory
    if (globalScene) {
      let sceneFactory: SceneResourceFactory = globalScene.getResourceFactory();

      // Manually load environment maps (.ktx/.jpg/.png etc.)
      let sceneImageParameter: SceneResourceParameters = { name: 'image', uri: $rawfile('image/Cube_BaseColor.png') };
      let image: Promise<Image> = sceneFactory.createImage(sceneImageParameter);
      image.then(async (imageEntity: Image) => {
        // Create Environment
        let sceneEnvironmentParameter: SceneResourceParameters = { name: 'env' };
        let env: Promise<Environment> = sceneFactory.createEnvironment(sceneEnvironmentParameter);
        env.then(async (envEntity: Environment) => {
          envEntity.backgroundType = EnvironmentBackgroundType.BACKGROUND_EQUIRECTANGULAR;
          envEntity.environmentImage  = imageEntity;
          // Set environment related properties
          envEntity.indirectDiffuseFactor.x = 1;
          envEntity.indirectDiffuseFactor.y = 1;
          envEntity.indirectDiffuseFactor.z = 1;
          envEntity.indirectDiffuseFactor.w = 1;
          resolve(envEntity);
        }).catch((err: string) => {
          logger.error('Environment mapping material create failed: ' + err + '.');
          reject(err);
        });
      }).catch((err: string) => {
        logger.error('Image load failed: ' + err);
        reject(err);
      });
    } else {
      reject('Scene is not loaded yet.');
    }
  });
}

@Entry
@Component
struct materialPage {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  rf: SceneResourceFactory | null = null;
  cam: Camera | null = null;
  shader: Shader | null = null;
  material: ShaderMaterial | null = null;
  geom: Geometry | null = null;
  image: Image | null = null;
  originalMat: ShaderMaterial | null = null;
  blankMat: Material | null = null;
  shaderMat: ShaderMaterial | null = null;
  imageMat: ShaderMaterial | null = null;
  env: Environment | null = null;

  onPageShow(): void {
    this.init();
  }

  onPageHide(): void {
    if (this.scene) {
      this.scene.destroy();
    }
    this.scene = null;
    this.sceneOpt = null;
    this.rf = null;
    this.cam = null;
    this.shader = null;
    this.material = null;
    this.geom = null;
    this.image = null;
    this.originalMat = null;
    this.blankMat = null;
    this.shaderMat = null;
    this.imageMat = null;
    this.env = null;
    globalScene = null;
  }

  init(): void {
    if (this.scene === null) {
      // Switched from .gltf to .glb; same content, different format
      Scene.load($rawfile('gltf/CubeWithFloor/glTF/AnimatedCube.glb'))
        .then(async (result: Scene) => {
          // Assign loaded scene to globalScene for unified resource creation
          globalScene = result;
          this.scene = result;
          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          this.rf = this.scene.getResourceFactory();
          this.cam = await this.rf.createCamera({ 'name': 'Camera1' });
          this.cam.enabled = true;
          this.cam.position.z = 5;

          // create a geometry
          this.geom = this.scene.getNodeByPath('rootNode_/Unnamed Node 1/AnimatedCube') as Geometry;

          // record original material
          this.originalMat = this.geom.mesh.subMeshes[0].material;
        })
        .catch((error: string) => {
          logger.error('init error: ' + error + '.');
        });
    }
  }

  build() {
    Row() {
      Column() {
        Column() {
          if (this.sceneOpt) {
            Component3D(this.sceneOpt);
          } else {
            Text('Loading···');
          }
        }
        .height('30%');

        Button('Replace with a blank material')
          .id('material')
          .margin({ top: 80, left: 6 })
          .width('60%')
          .height(40)
          .onClick(async (): Promise<void> => {
            logger.info('Start to replace with a blank material');

            if (!this.blankMat) {
              this.blankMat = await createMaterialPromise();
            }

            if (!this.scene || !this.rf) {
              return;
            }

            this.geom = this.scene.getNodeByPath('rootNode_/Unnamed Node 1/AnimatedCube') as Geometry;

            this.geom.mesh.materialOverride = undefined;
            if (this.blankMat) {
              this.geom.mesh.subMeshes[0].material = this.blankMat;
            }

          });

        Button('Replace with a Shader material')
          .id('shader')
          .margin({ top: 20, left: 6 })
          .width('60%')
          .height(40)
          .onClick(async (): Promise<void> => {
            logger.info('Start to replace with a shader material');

            if (!this.shader) {
              this.shader = await createShaderPromise();
            }

            if (!this.scene || !this.rf) {
              return;
            }

            if (!this.shaderMat) {
              let rf = this.scene.getResourceFactory();
              this.shaderMat = await rf.createMaterial({ name: 'shaderMat' }, MaterialType.SHADER);
            }

            if (this.shader) {
              this.shaderMat.colorShader = this.shader;
            }

            this.geom = this.scene.getNodeByPath('rootNode_/Unnamed Node 1/AnimatedCube') as Geometry;

            this.geom.mesh.materialOverride = undefined;

            if (this.shaderMat) {
              this.geom.mesh.subMeshes[0].material = this.shaderMat;
            }
          })

        Button('Replace with a Image material')
          .id('image')
          .margin({ top: 20, left: 6 })
          .width('60%')
          .height(40)
          .onClick(async (): Promise<void> => {
            logger.info('Start to replace with a material of image');

            if (!this.scene || !this.cam || !this.rf) {
              return;
            }

            // create shader
            this.shader = await this.rf.createShader({
              name: 'shaderResource',
              uri: $rawfile('shaders/custom_shader/custom_material_sample.shader')
            });

            // create imageMat
            this.imageMat = await this.rf.createMaterial({ name: 'imageMat' }, MaterialType.SHADER) as ShaderMaterial;

            // bind between shader and imageMat
            this.imageMat.colorShader = this.shader;
            let createdImage =  await createImagePromise();
            if (createdImage) {
              this.imageMat.colorShader.inputs['BASE_COLOR_Image'] = createdImage;
            }

            this.geom = this.scene.getNodeByPath('rootNode_/Unnamed Node 1/AnimatedCube') as Geometry;

            this.geom.mesh.materialOverride = undefined;
            this.geom.mesh.subMeshes[0].material = this.imageMat;
          })

        Button('Add to Environment')
          .id('env')
          .margin({ top: 20, left: 6 })
          .width('60%')
          .height(40)
          .onClick(async (): Promise<void> => {
            logger.info('Start to replace with a material of image');

            if (!this.scene || !this.cam) {
              return;
            }

            this.env = await createEnvironmentPromise();
            if (this.env) {
              this.scene.environment = this.env;
            }
          });

        Button('back')
          .id('back')
          .margin({ top: 20, left: 6 })
          .width('60%')
          .height(40)
          .onClick(() => {
            router.back();
          })
      }
      .width('100%');
    }
    .height('100%');
  }
}