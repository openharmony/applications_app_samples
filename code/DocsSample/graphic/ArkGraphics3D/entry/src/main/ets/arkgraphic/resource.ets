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
  ShaderMaterial
} from '@kit.ArkGraphics3D';
import { router } from '@kit.ArkUI';
import logger from '../utils/Logger';

async function createMaterialPromise(): Promise<Material> {
  try {
    logger.info('start to create a new Material.');

    // Loading scene
    const result: Scene = await Scene.load($rawfile('gltf/CubeWithFloor/glTF/AnimatedCube.gltf'));

    let sceneFactory: SceneResourceFactory = result.getResourceFactory();
    let sceneMaterialParameter: SceneResourceParameters = { name: 'material' };

    // Create a material without anything
    let material: Material = await sceneFactory.createMaterial(sceneMaterialParameter, MaterialType.SHADER);

    return material;
  } catch (error) {
    logger.error('Failed to create material: ' + error);
    throw new Error('Failed to create material');
  }
}

async function createShaderPromise(): Promise<Shader> {
  try {
    logger.info('start to create a new shader.');

    let scene: Scene = await Scene.load($rawfile('gltf/CubeWithFloor/glTF/AnimatedCube.gltf'));
    let sceneFactory: SceneResourceFactory = scene.getResourceFactory();

    // Create a variable of the SceneResourceParameters type and use it to create a shader.
    let sceneResourceParameter: SceneResourceParameters = {
      name: 'shaderResource',
      uri: $rawfile('shaders/custom_shader/custom_material_sample.shader')
    };

    // Create a material.
    let shader: Shader = await sceneFactory.createShader(sceneResourceParameter);

    return shader;
  } catch (error) {
    logger.error('Failed to create shader: ' + error);
    throw new Error('Failed to create shader');
  }
}

async function createImagePromise(): Promise<Image> {
  try {
    logger.info('start to create a new image.');

    let scene: Scene = await Scene.load($rawfile('gltf/CubeWithFloor/glTF/AnimatedCube.gltf'));
    let sceneFactory: SceneResourceFactory = scene.getResourceFactory();
    let sceneImageParameter: SceneResourceParameters = { name: 'image', uri: $rawfile('image/Cube_BaseColor.png') };
    // create image
    let image: Image = await sceneFactory.createImage(sceneImageParameter);

    return image;
  } catch (error) {
    logger.error('Failed to creat image: ' + error);
    throw new Error('Failed to create image');
  }
}

async function createEnvrionmentPromise(): Promise<Environment> {
  try {
    logger.info('start to create a new envrionment.');

    let scene: Scene = await Scene.load($rawfile('gltf/CubeWithFloor/glTF/AnimatedCube.gltf'));
    let sceneFactory: SceneResourceFactory = scene.getResourceFactory();

    // create a new environment.
    let env: Environment = await sceneFactory.createEnvironment({
      name: 'env',
      uri: $rawfile('KTX/quarry_02_2k_radiance.ktx')
    });

    let image: Image = await sceneFactory.createImage({
      name: 'Image',
      uri: $rawfile('image/Cube_BaseColor.png')
    });

    env.environmentImage = image;

    env.indirectDiffuseFactor.x = 1;
    env.indirectDiffuseFactor.y = 1;
    env.indirectDiffuseFactor.z = 1;
    env.indirectDiffuseFactor.w = 1;

    return env;
  } catch (error) {
    logger.error('Failed to creat envrionment: ' + error);
    throw new Error('Failed to create envrionment');
  }
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
  }

  init(): void {
    if (this.scene === null) {
      Scene.load($rawfile('gltf/CubeWithFloor/glTF/AnimatedCube.gltf'))
        .then(async (result: Scene) => {
          this.scene = result;
          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
          this.rf = this.scene.getResourceFactory();
          this.cam = await this.rf.createCamera({ 'name': 'Camera1' });
          this.cam.enabled = true;
          this.cam.position.z = 5;

          // create a geometry
          if (!this.geom) {
            this.geom = this.scene.getNodeByPath('rootNode_/Scene/AnimatedCube') as Geometry;
          }

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
            Text('loading ...');
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

            if (!this.geom) {
              this.geom = this.scene.getNodeByPath('rootNode_/Unnamed Node 1/Cube') as Geometry;
            }

            this.geom.mesh.materialOverride = undefined;
            this.geom.mesh.subMeshes[0].material = this.blankMat;
          });

        Button('Replace with a Shader material')
          .id('shader')
          .margin({ top: 20, left: 6 })
          .width('60%')
          .height(40)
          .onClick(async (): Promise<void> => {
            logger.info('Start to replace with a blank material');

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

            if (this.shaderMat) {
              this.shaderMat.colorShader = this.shader;
            }

            if (!this.geom) {
              this.geom = this.scene.getNodeByPath('rootNode_/Unnamed Node 1/Cube') as Geometry;
            }

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
            this.imageMat.colorShader.inputs['BASE_COLOR_Image'] = await createImagePromise();

            if (!this.geom) {
              this.geom = this.scene.getNodeByPath('rootNode_/Unnamed Node 1/Cube') as Geometry;
            }

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

            this.env = await createEnvrionmentPromise();
            this.scene.environment = this.env;
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