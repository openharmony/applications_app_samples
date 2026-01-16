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
import image from '@ohos.multimedia.image';
import hilog from '@ohos.hilog';
import napiAgent from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

const TAG = 'DrawableDemo';

@Entry
@Component
struct DrawablePage {
  @State imagePixelMap: image.PixelMap | null = null;
  @State imagePixelMapId: number = -1; // 用于存储图片描述符的引用ID

  @State imagePixelMapArray: image.PixelMap | null = null;
  @State imagePixelMapArrayId: number = -1; // 用于存储图片描述符的引用ID
  @State animationDuration: number = 0;
  @State newDuration: number = 1000;
  @State animationIteration: number = 0;
  @State newIteration: number = 10;
  private nodeContent = new NodeContent();

  loadPixelMapArray() {
    if (!this.getUIContext() || !this.getUIContext().getHostContext()) {
      hilog.error(0x0000, TAG, `getUIContext fail.`);
      return;
    }
    const context = this.getUIContext().getHostContext();
    const resMgr = context!.resourceManager;

    this.imagePixelMapArrayId = napiAgent.createNodePage(this.nodeContent, resMgr);

    if (this.imagePixelMapArrayId >= 0) {
      hilog.error(0x0000, TAG, '---test loadPixelMapArray创建成功, imagePixelMapArrayId:%d', this.imagePixelMapArrayId);
    } else {
      hilog.error(0x0000, TAG, '---test loadPixelMapArray创建失败');
    }
  }

  async loadPixelMapArrayAsync() {
    this.loadPixelMapArray()
  }

  async aboutToAppear() {
    // 从资源加载图片并转换为PixelMap
    await this.loadImageFromResource();
    await this.loadImageArrayFromResource();
    await this.loadPixelMapArrayAsync();
  }

  // 从资源加载图片并转换为PixelMap
  async loadImageFromResource() {
    try {
      if (!this.getUIContext() || !this.getUIContext().getHostContext()) {
        return;
      }
      const context = this.getUIContext().getHostContext();
      const resMgr = context!.resourceManager;
      const imageData = await resMgr.getRawFileContent('startIcon.png');

      // 创建图像解码器
      const imageSource = image.createImageSource(imageData.buffer);
      const pixelMap = await imageSource.createPixelMap({});

      this.imagePixelMap = pixelMap;
      hilog.info(0x0000, TAG, '图片startIcon加载成功');

      // 从PixelMap创建Drawable描述符
      this.createPixelMap();
    } catch (err) {
      hilog.error(0x0000, TAG, `图片startIcon加载失败: ${JSON.stringify(err)}`);
    }
  }

  async loadImageArrayFromResource() {
    try {
      if (!this.getUIContext() || !this.getUIContext().getHostContext()) {
        return;
      }
      const context = this.getUIContext().getHostContext();
      const resMgr = context!.resourceManager;
      const imageData = await resMgr.getRawFileContent('test.jpg');

      // 创建图像解码器
      const imageSource = image.createImageSource(imageData.buffer);
      const pixelMap = await imageSource.createPixelMap({});

      this.imagePixelMapArray = pixelMap;
      hilog.info(0x0000, TAG, '图片test加载成功');

      this.createPixelMapArray();
    } catch (err) {
      hilog.error(0x0000, TAG, `图片test加载失败: ${JSON.stringify(err)}`);
    }
  }

  // 从PixelMap创建DrawableDescriptor
  createPixelMap() {
    if (!this.imagePixelMap) {
      return;
    }

    // 调用Native方法创建DrawableDescriptor
    this.imagePixelMapId = napiAgent.createFromPixelMap(this.imagePixelMap);

    if (this.imagePixelMapId >= 0) {
      hilog.error(0x0000, TAG, 'imagePixelMap创建成功');
    } else {
      hilog.error(0x0000, TAG, 'imagePixelMap创建失败');
    }
  }

  createPixelMapArray() {
    // 调用Native方法,测试相关接口
    napiAgent.createFromAnimatedPixelMap(this.imagePixelMapArray, 1);
  }

  // 设置输入的duration
  setNewDuration() {
    if (this.imagePixelMapArrayId >= 0) {
      napiAgent.disposeDrawable(this.imagePixelMapArrayId);
      this.imagePixelMapArrayId = -1;
    }

    this.loadPixelMapArray();
    napiAgent.setAnimationDuration(this.imagePixelMapArrayId, this.newDuration);
    this.animationDuration = napiAgent.getAnimationDuration(this.imagePixelMapArrayId);
    if (this.animationIteration > 0) {
      napiAgent.setAnimationIteration(this.imagePixelMapArrayId, this.animationIteration);
    }
  }

  // 设置输入的iteration
  setNewIteration() {
    if (this.imagePixelMapArrayId < 0) {
      hilog.error(0x0000, TAG, 'imagePixelMapArrayId < 0, return');
      return;
    }
    this.loadPixelMapArray();
    napiAgent.setAnimationIteration(this.imagePixelMapArrayId, this.newIteration);
    this.animationIteration = napiAgent.getAnimationIteration(this.imagePixelMapArrayId);
    if (this.animationDuration > 0) {
      napiAgent.setAnimationDuration(this.imagePixelMapArrayId, this.animationDuration);
    }
  }

  // 页面销毁时释放资源
  aboutToDisappear() {
    if (this.imagePixelMapId >= 0) {
      napiAgent.disposeDrawable(this.imagePixelMapId);
      this.imagePixelMapId = -1;
    }
    if (this.imagePixelMap) {
      this.imagePixelMap.release();
      this.imagePixelMap = null;
    }

    if (this.imagePixelMapArrayId >= 0) {
      napiAgent.disposeDrawable(this.imagePixelMapArrayId);
      this.imagePixelMapArrayId = -1;
    }
    if (this.imagePixelMapArray) {
      this.imagePixelMapArray.release();
      this.imagePixelMapArray = null;
    }
  }

  onBackPress() {
    hilog.error(0x0000, TAG, 'onBackPress');

    // 先清理老的节点，再重新设置一个新的
    hilog.error(0x0000, TAG, 'onBackPress begin, ---test imagePixelMapArrayId:%d', this.imagePixelMapArrayId);
    napiAgent.disposeDrawable(this.imagePixelMapArrayId);
    this.imagePixelMapArrayId = -1;

    this.loadPixelMapArray();
  }

  build() {
    Column() {
      Text($r('app.string.Index_label_func_sample'))
        .fontSize(24)
        .margin(20)
        .fontWeight(FontWeight.Bold)

      if (this.imagePixelMap) {
        Image(this.imagePixelMap)
          .width(100)
          .height(100)
          .margin(10)
          .objectFit(ImageFit.Auto)
      } else {
        Text($r('app.string.Index_label_load_fail'))
          .fontSize(16)
          .margin(10)
      }

      Column() {
        ContentSlot(this.nodeContent)
      }

      Column() {
        Text(`duration: ${this.animationDuration}ms`)
          .fontSize(18)
          .margin(10)
        Text(`iteration: ${this.animationIteration}`)
          .fontSize(18)
          .margin(10)

        Row() {
          Text($r('app.string.Index_label_set_duration'))
            .fontSize(16)
            .margin({ right: 10 })

          TextInput({
            text: this.newDuration.toString()
          })
            .width(100)
            .onChange((value) => {
              this.newDuration = parseInt(value) || 0;
            })

          Button($r('app.string.Index_button_setting'))
            .margin({ left: 10 })
            .onClick(() => this.setNewDuration())
        }
        .margin(10)

        Row() {
          Text($r('app.string.Index_label_set_iteration'))
            .fontSize(16)
            .margin({ right: 10 })

          TextInput({
            text: this.newIteration.toString()
          })
            .width(100)
            .onChange((value) => {
              this.newIteration = parseInt(value) || 0;
            })

            Button($r('app.string.Index_button_setting'))
            .margin({ left: 10 })
            .onClick(() => this.setNewIteration())
        }
        .margin(10)
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#f5f5f5')
      .borderRadius(10)

      Button($r('app.string.Index_button_back'))
        .fontSize(18)
        .width(240)
        .onClick(() => {
          this.getUIContext().getRouter().back();
        })
        .margin({ top: 20, bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#ffffff')
  }
}
