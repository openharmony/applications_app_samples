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

import { Animation, Camera, Scene, SceneResourceFactory } from '@kit.ArkGraphics3D';
import { router } from '@kit.ArkUI';
import logger from '../utils/Logger';

async function createAnimationPromise(): Promise<Animation> {
  let scene: Scene = await Scene.load($rawfile('gltf/BrainStem/glTF/BrainStem.gltf'));

  // create animation
  let anim: Animation = scene.animations[0];

  logger.info('ready to create a new animation.');

  return anim;
}

@Entry
@Component
struct sceneAnimation {
  scene: Scene | null = null;
  @State sceneOpt: SceneOptions | null = null;
  cam: Camera | null = null;
  anim: Animation | null = null;
  @State animationCallbackInvoked: string = 'no invoked callback';

  onPageShow(): void {
    this.init();
  }

  onPageHide(): void {
    if (this.scene) {
      this.scene.destroy();
    }
    this.scene = null;
    this.sceneOpt = null;
    this.cam = null;
    this.anim = null;
  }

  init(): void {
    if (this.scene == null) {
      // Loading scene.
      Scene.load($rawfile('gltf/BrainStem/glTF/BrainStem.gltf'))
        .then(async (result: Scene) => {
          this.scene = result;
          let rf: SceneResourceFactory = this.scene.getResourceFactory();
          // create a new camera.
          this.cam = await rf.createCamera({ 'name': 'Camera' });
          // set the camera.
          this.cam.enabled = true;
          this.cam.position.z = 5;

          this.scene.animations[0] = await createAnimationPromise();

          this.scene.animations[0].enabled = true;

          this.sceneOpt = { scene: this.scene, modelType: ModelType.SURFACE } as SceneOptions;
        }).catch((err: string) => {
          logger.error(err);
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
              .renderHeight('60%')
              .onAppear(() => {
                if (!this.scene || !this.scene.animations[0]) {
                  return;
                }

                let anim: Animation = this.scene.animations[0];

                anim.onStarted(() => {
                  this.animationCallbackInvoked = 'animation on start';
                });

                anim.onFinished(() => {
                  this.animationCallbackInvoked = 'animation on finish';
                });
              });
          } else {
            Text('loading 1...');
          }
        }
        .height('30%');

        Text('animation invoked callback:' + this.animationCallbackInvoked)
          .fontSize(16)
          .fontWeight(500);

        Button('start')
          .id('start')
          .margin({ top: 50, left: 6 })
          .width('30%')
          .height(40)
          .onClick(async () => {
            if (!this.scene || !this.scene.animations[0]) {
              return;
            }
            this.anim = this.scene?.animations[0];
            this.anim.start();
          });

        Button('pause')
          .id('pause')
          .margin({ top: 10, left: 6 })
          .width('30%')
          .height(40)
          .onClick(async () => {
            if (!this.scene || !this.scene.animations[0]) {
              return;
            }
            this.anim = this.scene.animations[0];
            this.anim.pause();
          });

        Button('stop')
          .id('stop')
          .margin({ top: 10, left: 6 })
          .width('30%')
          .height(40)
          .onClick(async () => {
            if (!this.scene || !this.scene.animations[0]) {
              return;
            }
            this.anim = this.scene.animations[0];
            this.anim.stop();
          });

        Button('finish')
          .margin({ top: 10, left: 6 })
          .width('30%')
          .height(40)
          .onClick(async () => {
            if (!this.scene || !this.scene.animations[0]) {
              return;
            }
            this.anim = this.scene.animations[0];
            this.anim.finish();
          })
          .id('finish');

        Button('restart')
          .margin({ top: 10, left: 6 })
          .width('30%')
          .height(40)
          .onClick(async () => {
            if (!this.scene || !this.scene.animations[0]) {
              return;
            }
            this.anim = this.scene.animations[0];
            this.anim.restart();
          })
          .id('restart');

        Button('seek to 30% progress')
          .margin({ top: 10, left: 6 })
          .width('30%')
          .height(40)
          .onClick(async () => {
            if (!this.scene || !this.scene.animations[0]) {
              return;
            }
            this.anim = this.scene.animations[0];
            // seek to 30%
            this.anim.seek(0.3);
          })
          .id('seek');

        Button('back')
          .margin({ top: 10, left: 6 })
          .width('30%')
          .height(40)
          .onClick(() => {
            router.back();
          })
          .id('back');
      }
      .width('100%');
    }
    .height('100%');
  }
}