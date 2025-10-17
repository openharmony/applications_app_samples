/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import AnimatorNapi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  private nodeContent: Content = new NodeContent();
  @State styleOption: string = '';
  @State imageWidth: number = 100;
  @State imageHeight: number = 100;
  @State imageTop: number = 100;
  @State imageLeft: number = 100;
  @State imageDuration: number = 1000;
  @Builder
  SubMenuMode() {
    Menu() {
      MenuItem({ content: 'createImageAnimatorFromString'})
        .width('50%')
        .onChange(()=> {
          AnimatorNapi.createImageAnimatorFromString(this.imageWidth, this.imageHeight,
            this.imageTop, this.imageLeft, this.imageDuration);
        })
      MenuItem({ content: 'createImageAnimatorFromDrawableDescriptor'})
        .width('50%')
        .onChange(()=> {
          AnimatorNapi.createImageAnimatorFromDrawableDescriptor(this.imageWidth, this.imageHeight,
            this.imageTop, this.imageLeft, this.imageDuration);

        })
    }
  }

  build() {
    Row() {
      Column() {
        Row() {
          Column() {
            Row() {
              Text($r('app.string.ImageAnimator_width'))
              TextInput()
                .type(InputType.Number)
                .onChange((value) => {
                  this.imageWidth = parseInt(value);
                })
                .width(100)
            }
            .padding({bottom: 5})
            Row() {
              Text($r('app.string.ImageAnimator_height'))
              TextInput()
                .type(InputType.Number)
                .onChange((value) => {
                  this.imageHeight = parseInt(value);
                })
                .width(100)
            }
            .padding({bottom: 5})
            Row() {
              Text($r('app.string.ImageAnimator_top'))
              TextInput()
                .type(InputType.Number)
                .onChange((value) => {
                  this.imageTop = parseInt(value);
                })
                .width(100)
            }
            .padding({bottom: 5})
            Row() {
              Text($r('app.string.ImageAnimator_left'))
              TextInput()
                .type(InputType.Number)
                .onChange((value) => {
                  this.imageLeft = parseInt(value);
                })
                .width(100)
            }
            .padding({bottom: 5})
            Row() {
              Text($r('app.string.ImageAnimator_duration'))
              TextInput()
                .type(InputType.Number)
                .onChange((value) => {
                  this.imageDuration = parseInt(value);
                })
                .width(100)
            }
            .padding({bottom: 5})
            Row() {
              Button($r('app.string.Creat_imageAnimator'))
                .height(50)
                .width('50%')
                .bindMenu(this.SubMenuMode())
              Button($r('app.string.Get_frameInfo'))
                .height(50)
                .width('50%')
                .onClick(() => {
                  this.styleOption = AnimatorNapi.getImageAnimatorFrameInfo();
                })
            }
          }
        }
        Text(this.styleOption)
          .margin({ top: 5, bottom: 5 })
        Button($r('app.string.Back'))
          .height(50)
          .width('50%')
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
          .margin({ bottom: 5 })
        ContentSlot(this.nodeContent)
      }
      .width('100%')
    }
    .height('100%')
  }
  async aboutToAppear() {
    AnimatorNapi.setContentHandle(this.nodeContent);
  }
  async aboutToDisappear() {
    AnimatorNapi.clearNodes();
  }
}
