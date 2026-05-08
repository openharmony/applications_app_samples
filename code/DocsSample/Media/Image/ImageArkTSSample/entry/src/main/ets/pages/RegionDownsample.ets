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

import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { ImageInterfaceCalled } from '../tools/CodecUtility';
import { Router } from '@ohos.arkui.UIContext';
import { resourceManager } from '@kit.LocalizationKit';

const router = new Router();

@Entry
@Component
struct RegionDownsample {
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State imageInterfaceCalled: ImageInterfaceCalled = new ImageInterfaceCalled();
  @State srcPixelMap: image.PixelMap | undefined = undefined;
  @State infoLog: string = '';
  @State visible: Visibility = Visibility.Hidden;
  @State imageSource: image.ImageSource | undefined = undefined;

  release() {
    this.srcPixelMap?.release();
    this.srcPixelMap = undefined;
    this.visible = Visibility.None;
  }

  async createImageSource(): Promise<void> {
    const resourceMgr: resourceManager.ResourceManager = this.context.resourceManager;
    const rawFile = await resourceMgr.getRawFileContent('test.jpeg');
    this.imageSource = image.createImageSource(rawFile.buffer as ArrayBuffer);
    this.infoLog = 'ImageSource created successfully.';
  }

  build() {
    Column() {
      Text('区域解码与下采样解码')
        .fontSize(25)
        .margin(10)

      Text('请先创建ImageSource!')
        .fontSize(16)
        .fontColor(Color.Gray)
        .margin({ top: 10, bottom: 10 })

      List({ space: 10 }) {
        ListItem() {
          Button('CreateImageSource').onClick(async() => {
            await this.createImageSource();
          })
            .width('50%')
            .margin(10)
        }
        ListItem() {
          Button('DecodeRegion').onClick(async() => {
            if (!this.imageSource) {
              this.infoLog = 'Please create ImageSource first.';
              return;
            }
            this.visible = Visibility.None;
            this.srcPixelMap = await this.imageInterfaceCalled.DecodeRegion(this.imageSource);
            if(this.srcPixelMap) {
              let info = await this.srcPixelMap.getImageInfo();
              this.infoLog = `DecodeRegion succeeded, size=${info.size.width}x${info.size.height}.`;
            } else {
              this.infoLog = 'DecodeRegion failed.'
            }
            this.visible = Visibility.Visible;
          })
            .width('50%')
            .margin(10)
        }
        ListItem() {
          Button('DownsampleDecode').onClick(async() => {
            if (!this.imageSource) {
              this.infoLog = 'Please create ImageSource first.';
              return;
            }
            this.visible = Visibility.None;
            this.srcPixelMap = await this.imageInterfaceCalled.DownsampleDecode(this.imageSource);
            if(this.srcPixelMap) {
              let info = await this.srcPixelMap.getImageInfo();
              this.infoLog = `DownsampleDecode succeeded, size=${info.size.width}x${info.size.height}.`;
            } else {
              this.infoLog = 'DownsampleDecode failed.'
            }
            this.visible = Visibility.Visible;
          })
            .width('50%')
            .margin(10)
        }
        ListItem() {
          Button('CombinedDecode').onClick(async() => {
            if (!this.imageSource) {
              this.infoLog = 'Please create ImageSource first.';
              return;
            }
            this.visible = Visibility.None;
            this.srcPixelMap = await this.imageInterfaceCalled.CombinedDecode(this.imageSource);
            if(this.srcPixelMap) {
              let info = await this.srcPixelMap.getImageInfo();
              this.infoLog = `CombinedDecode succeeded, size=${info.size.width}x${info.size.height}.`;
            } else {
              this.infoLog = 'CombinedDecode failed.'
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
            this.imageSource?.release();
            this.imageSource = undefined;
            this.visible = Visibility.None;
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
      .height('50%')

      Text(this.infoLog)
        .width('80%')
        .margin(10)

      Image(this.srcPixelMap)
        .width('40%')
        .height('40%')
        .visibility(this.visible)
        .margin(10)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}