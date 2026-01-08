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

// [Start decodingPixelMap_import]
// 导入相关模块包。
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { resourceManager } from '@kit.LocalizationKit';
// [End decodingPixelMap_import]
import { ImageInterfaceCalled } from '../tools/CodecUtility';
import { UIComponentsBuilder } from '../tools/components';
import { Router } from '@ohos.arkui.UIContext';

const router = new Router();
// 创建 UIComponentsBuilder 实例
const uiComponents = new UIComponentsBuilder();
let fileName: string = 'test.jpeg'; // 根据解码需求选择不同的解码资源进行解码

@Entry
@Component
struct DecodingPixelmap {
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State imageSource: image.ImageSource | undefined = undefined;
  @State pixelMap: image.PixelMap | undefined = undefined;;
  @State imageInterfaceCalled: ImageInterfaceCalled = new ImageInterfaceCalled();
  @State infoLog: string = '';
  @State infoVisible: Visibility = Visibility.Hidden;
  @State visible: Visibility = Visibility.Hidden;

  // [Start release_pixelMapDecoder]
  async release(pixelMap: image.PixelMap | undefined, imageSource: image.ImageSource | undefined) {
    pixelMap?.release();
    pixelMap = undefined;
    imageSource?.release();
    imageSource = undefined;
  }
  // [End release_pixelMapDecoder]

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center}) {
        Text('选择解码图片资源')
            .fontSize(15)
            .margin(10)
        Row(){
          this.chooseFileSource('JPEG');
          this.chooseFileSource('PNG');
          this.chooseFileSource('WebP');
          this.chooseFileSource('BMP');
        }.margin(10)
        Row(){
          this.chooseFileSource('SVG');
          this.chooseFileSource('ICO');
          this.chooseFileSource('HEIF');
          this.chooseFileSource('HDR');
        }.margin(10)
      Text('根据不同方式创建的ImageSource进行解码')
        .fontSize(15)
        .margin(10)
        Button('沙箱路径').onClick(async () => {
          this.visible = Visibility.None;
          this.infoVisible = Visibility.None;
          if (uiComponents.isFileNameValid(fileName)) {
            this.imageSource = this.imageInterfaceCalled.createImageSourceByFilePath(this.context, fileName);
            this.pixelMap = await this.imageInterfaceCalled.createPixelMap(this.imageSource);
            if (this.pixelMap) {
              this.infoLog = `解码${fileName}成功!`;
            } else {
              this.infoLog = `解码${fileName}失败!`;
            }
            this.infoVisible = Visibility.Visible;
            this.visible = Visibility.Visible;
          } else {
            this.infoLog = `当前设备不支持解码该类型图片!`;
            this.infoVisible = Visibility.Visible;
          }
        })
          .width('50%')
          .margin(10)
        Button('文件描述符fd').onClick(async () => {
          this.visible = Visibility.None;
          this.infoVisible = Visibility.None;
          if (uiComponents.isFileNameValid(fileName)) {
            this.imageSource = this.imageInterfaceCalled.createImageSourceByFd(this.context, fileName);
            this.pixelMap = await this.imageInterfaceCalled.createPixelMap(this.imageSource);
            if (this.pixelMap) {
              this.infoLog = `解码${fileName}成功!`;
            } else {
              this.infoLog = `解码${fileName}失败!`;
            }
            this.infoVisible = Visibility.Visible;
            this.visible = Visibility.Visible;
          } else {
            this.infoLog = `当前设备不支持解码该类型图片!`;
            this.infoVisible = Visibility.Visible;
          }
        })
          .width('50%')
          .margin(10)
        Button('缓冲区数组').onClick(async () => {
          this.visible = Visibility.None;
          this.infoVisible = Visibility.None;
          if (uiComponents.isFileNameValid(fileName)) {
            this.imageSource = await this.imageInterfaceCalled.createImageSourceByBuffer(this.context, fileName);
            this.pixelMap = await this.imageInterfaceCalled.createPixelMap(this.imageSource);
            if (this.pixelMap) {
              this.infoLog = `解码${fileName}成功!`;
            } else {
              this.infoLog = `解码${fileName}失败!`;
            }
            this.infoVisible = Visibility.Visible;
            this.visible = Visibility.Visible;
          } else {
            this.infoLog = `当前设备不支持解码该类型图片!`;
            this.infoVisible = Visibility.Visible;
          }
        })
          .width('50%')
          .margin(10)
        Button('资源文件的RawFd').onClick(async () => {
          this.visible = Visibility.None;
          this.infoVisible = Visibility.None;
          if (uiComponents.isFileNameValid(fileName)) {
            this.imageSource = await this.imageInterfaceCalled.createImageSourceByRawFd(this.context, fileName);
            this.pixelMap = await this.imageInterfaceCalled.createPixelMap(this.imageSource);
            if (this.pixelMap) {
              this.infoLog = `解码${fileName}成功!`;
            } else {
              this.infoLog = `解码${fileName}失败!`;
            }
            this.infoVisible = Visibility.Visible;
            this.visible = Visibility.Visible;
          } else {
            this.infoLog = `当前设备不支持解码该类型图片!`;
            this.infoVisible = Visibility.Visible;
          }
        })
          .width('50%')
          .margin(10)
        Button('资源释放').onClick(async () => {
          this.release(this.pixelMap, this.imageSource);
          this.visible = Visibility.None;
          this.infoVisible = Visibility.None;
        })
          .width('50%')
          .margin(10)
        Button('back')
          .width('50%')
          .margin(10)
          .onClick(() => {
            router.pushUrl({ url: 'pages/Index' });
          })
          .width('50%')
          .margin(10)
    }
      .size({ width: '100%', height: '50%' })
      Text(this.infoLog)
        .width('80%')
        .height('10%')
        .margin(10)
        .visibility(this.infoVisible)
      Image(this.pixelMap)
        .width('40%')
        .height('40%')
        .objectFit(ImageFit.Contain)
        .visibility(this.visible)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  chooseFileSource(name: string) {
    Button(name)
      .onClick(async () => {
        fileName = await uiComponents.switchFileName(this.context, name);
      })
  }
}
