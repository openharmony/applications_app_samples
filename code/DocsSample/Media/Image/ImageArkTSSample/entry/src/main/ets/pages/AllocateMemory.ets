/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

// [Start allocator_import]
// 导入相关模块。
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
// [End allocator_import]
import { ImageInterfaceCalled } from '../tools/CodecUtility';
import { Router } from '@ohos.arkui.UIContext';

const router = new Router();

@Entry
@Component
struct AllocateMemory {
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State imageInterfaceCalled: ImageInterfaceCalled = new ImageInterfaceCalled();
  @State pixelMapArr: Array<image.PixelMap | undefined> = [];
  @State srcPixelMap: image.PixelMap | undefined = undefined;
  @State cropPixelMap: image.PixelMap | undefined = undefined;
  @State infoLog: string = '';
  @State visible: Visibility = Visibility.Hidden;
  @State cropVisible: Visibility = Visibility.Hidden;

  release() {
    this.srcPixelMap?.release();
    this.srcPixelMap = undefined;
    this.cropPixelMap?.release();
    this.cropPixelMap = undefined;
    this.visible = Visibility.None;
    this.cropVisible = Visibility.None;
  }

  build() {
    Column() {
      Text('申请图片解码内存')
        .fontSize(25)
        .margin(10)

      List({ space: 10 }) {
        ListItem() {
          Button('DMA').onClick(async() => {
            this.visible = Visibility.None;
            this.cropVisible = Visibility.None;
            this.srcPixelMap = await this.imageInterfaceCalled.CreatePixelMapUsingAllocator(
              this.context, image.AllocatorType.DMA);
            if(this.srcPixelMap) {
              let info = await this.srcPixelMap.getImageInfo();
              console.info('stride = ' + info.stride);
              this.infoLog = `The stride of PixelMap obtained through DMA memory allocation is ${info.stride}.`;
            } else {
              this.infoLog = 'Create pixelMap failed.'
            }
            this.visible = Visibility.Visible;
          })
            .width('50%')
            .margin(10)
        }
        ListItem() {
          Button('SHARE').onClick(async() => {
            this.visible = Visibility.None;
            this.cropVisible = Visibility.None;
            this.srcPixelMap = await this.imageInterfaceCalled.CreatePixelMapUsingAllocator(
              this.context, image.AllocatorType.SHARE_MEMORY);
            if(this.srcPixelMap) {
              let info = await this.srcPixelMap.getImageInfo();
              console.info('stride = ' + info.stride);
              this.infoLog = `The stride of PixelMap obtained through SHARE memory allocation is ${info.stride}.`;
            } else {
              this.infoLog = 'Create pixelMap failed.'
            }
            this.visible = Visibility.Visible;
          })
            .width('50%')
            .margin(10)
        }
        ListItem() {
          Button('AUTO').onClick(async() => {
            this.visible = Visibility.None;
            this.cropVisible = Visibility.None;
            this.srcPixelMap = await this.imageInterfaceCalled.CreatePixelMapUsingAllocator(
              this.context, image.AllocatorType.AUTO);
            if(this.srcPixelMap) {
              let info = await this.srcPixelMap.getImageInfo();
              console.info('stride = ' + info.stride);
              this.infoLog = `The stride of PixelMap obtained through AUTO memory allocation is ${info.stride}.`;
            } else {
              this.infoLog = 'Create pixelMap failed.'
            }
            this.visible = Visibility.Visible;
          })
            .width('50%')
            .margin(10)
        }
        ListItem() {
          Button('YUV+DMA').onClick(async() => {
            this.visible = Visibility.None;
            this.cropVisible = Visibility.None;
            this.srcPixelMap = await this.imageInterfaceCalled.CreatePixelMapWithYUV(this.context);
            if(this.srcPixelMap) {
              let info = await this.srcPixelMap.getImageInfo();
              this.infoLog = `YUV PixelMap created, stride=${info.stride}, format=${info.pixelFormat}.`;
            } else {
              this.infoLog = 'Create YUV PixelMap failed.'
            }
            this.visible = Visibility.Visible;
          })
            .width('50%')
            .margin(10)
        }
        ListItem() {
          Text('资源释放后再进行其他操作会引起崩溃，请重新创建后再进行具体操作!')
            .fontSize(14)
            .fontColor(Color.Red)
        }
        ListItem() {
          Button('释放').onClick(async() => {
            this.release();
            this.visible = Visibility.None;
            this.cropVisible = Visibility.None;
          })
            .width('50%')
            .margin(10)
        }
        ListItem() {
          Button('返回')
            .width('50%')
            .margin(10)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Index' });
            })
        }
      }
      .width('100%')
      .height('60%')

      Text(this.infoLog)
        .width('80%')
        .margin(10)
        .visibility(this.visible & this.cropVisible)
      Row() {
        Image(this.srcPixelMap)
          .width('40%')
          .height('40%')
          .visibility(this.visible)
          .margin(10)
        Image(this.cropPixelMap)
          .width('40%')
          .height('40%')
          .visibility(this.cropVisible)
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}