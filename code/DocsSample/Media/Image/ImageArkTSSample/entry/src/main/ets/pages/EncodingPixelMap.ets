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

// [Start encodingPixelMap_import]
// 导入相关模块包。
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { resourceManager } from '@kit.LocalizationKit';
// [End encodingPixelMap_import]
import { ImageInterfaceCalled } from '../tools/CodecUtility';
import { Router } from '@ohos.arkui.UIContext';

const router = new Router();
let fileName: string = 'test.jpeg'; // 根据解码需求选择不同的解码资源进行解码

@Entry
@Component
struct EncodingPixelMap {
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State pixelMap: image.PixelMap | undefined = undefined;
  @State imageSource: image.ImageSource | undefined = undefined;
  @State packedPixelMap: image.PixelMap | undefined = undefined;
  @State infoLog: string = '';
  @State imageInterfaceCalled: ImageInterfaceCalled = new ImageInterfaceCalled();
  @State packVisible: Visibility = Visibility.Hidden;

  releaseResource() {
    this.imageSource?.release();
    this.imageSource = undefined;
    this.pixelMap?.release();
    this.pixelMap = undefined;
    this.packedPixelMap?.release();
    this.packedPixelMap = undefined;
  }

  build() {
    Column() {
      Text('选择创建待编码的对象')
        .fontSize(25)
        .margin(10)
      Button('packPixelMapToData').onClick(async() => {
        this.packVisible = Visibility.None;
        this.releaseResource();
        this.imageSource = await this.imageInterfaceCalled.createImageSourceByRawFd(this.context, fileName);
        this.pixelMap = await this.imageInterfaceCalled.createPixelMap(this.imageSource);
        if (this.pixelMap!= undefined) {
          this.packedPixelMap = await this.imageInterfaceCalled.showPixelMapFromData(
            this.pixelMap.getImageInfoSync(), this.pixelMap);
          if (this.packedPixelMap) {
            this.infoLog = `packPixelMapToData: 对编码的图片重新解码后如下!`;
          } else {
            this.infoLog = `Pack pixelMap to data failed!`;
          }
          this.packVisible = Visibility.Visible;
        }
      })
        .width('50%')
        .margin(10)
      Button('packImageSourceToData').onClick(async() => {
        this.packVisible = Visibility.None;
        this.releaseResource();
        this.imageSource = await this.imageInterfaceCalled.createImageSourceByRawFd(this.context, fileName);
        if (this.imageSource!= undefined) {
          this.packedPixelMap = await this.imageInterfaceCalled.showPixelMapFromData(
            this.imageSource.getImageInfoSync(), undefined, this.imageSource);
          if (this.packedPixelMap) {
            this.infoLog = `packImageSourceToData: 对编码的图片重新解码后如下!`;
          } else {
            this.infoLog = `Pack imageSource to data failed!`;
          }
          this.packVisible = Visibility.Visible;
        }
      })
        .width('50%')
        .margin(10)
      Button('packPixelMapToFile').onClick(async() => {
        this.packVisible = Visibility.None;
        this.releaseResource();
        this.imageSource = await this.imageInterfaceCalled.createImageSourceByRawFd(this.context, fileName);
        this.pixelMap = await this.imageInterfaceCalled.createPixelMap(this.imageSource);
        if (this.pixelMap!= undefined) {
          this.packedPixelMap = await this.imageInterfaceCalled.showPixelMapFromFile(this.context, this.pixelMap);
          if (this.packedPixelMap) {
            this.infoLog = `packPixelMapToFile: 对编码的图片重新解码后如下!`;
          } else {
            this.infoLog = `Pack pixelMap to file failed!`;
          }
          this.packVisible = Visibility.Visible;
        }
      })
        .width('50%')
        .margin(10)
      Button('packImageSourceToFile').onClick(async() => {
        this.packVisible = Visibility.None;
        this.releaseResource();
        this.imageSource = await this.imageInterfaceCalled.createImageSourceByRawFd(this.context, fileName);
        if (this.imageSource!= undefined) {
          this.packedPixelMap = await this.imageInterfaceCalled.showPixelMapFromFile(
            this.context, undefined, this.imageSource);
          if (this.packedPixelMap) {
            this.infoLog = `packImageSourceToFile: 对编码的图片重新解码后如下!`;
          } else {
            this.infoLog = `Pack imageSource to file failed!`;
          }
          this.packVisible= Visibility.Visible;
        }
      })
        .width('50%')
        .margin(10)
      Button('释放编码资源').onClick(async() => {
        this.packVisible = Visibility.None;
        this.releaseResource();
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
      Row() {
        Text(this.infoLog)
          .width('50%')
          .margin(10)
          .visibility(this.packVisible)
        Image(this.packedPixelMap)
          .width('40%')
          .height('50%')
          .margin(10)
          .visibility(this.packVisible)
      }
      .width('80%')
      .height('50%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
