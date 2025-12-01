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

// [Start decodingPicture_import]
// 导入相关模块包。
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { resourceManager } from '@kit.LocalizationKit';
// [End decodingPicture_import]
import { ImageInterfaceCalled } from '../tools/CodecUtility';
import { UIComponentsBuilder } from '../tools/components';
import {Router} from '@ohos.arkui.UIContext';

const router = new Router();
// 创建 UIComponentsBuilder 实例
const uiComponents = new UIComponentsBuilder();
let fileName: string = 'allAux.jpg';

@Entry
@Component
struct DecodingPicture {
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State pixelMap: image.PixelMap | undefined | image.Picture = undefined;
  @State infoLog: string = '';
  @State imageSource: image.ImageSource | undefined = undefined;
  @State imageInterfaceCalled: ImageInterfaceCalled = new ImageInterfaceCalled();
  @State infoVisible: Visibility = Visibility.Hidden;
  @State visible: Visibility = Visibility.Hidden;

  async release() {
    this.pixelMap?.release();
    this.pixelMap = undefined;
    this.imageSource?.release();
    this.imageSource = undefined;
  }

  build() {
    Column() {
      Row() {
        Column() {
          Row() {
            Button('JPEG').onClick(async () => {
              let name = 'HDR';
              fileName = await uiComponents.switchFileName(this.context, name);
            })
              .width('40%')
              .margin(10)
            Button('HEIF').onClick(async () => {
              let name = 'HEIF';
              fileName = await uiComponents.switchFileName(this.context, name);
            })
              .width('40%')
              .margin(10)
          }
          Text('根据不同方式创建的ImageSource进行解码')
            .fontSize(15)
            .margin(10)
          Button('沙箱路径').onClick(async () => {
            this.visible = Visibility.None;
            this.infoVisible = Visibility.None;
            if (uiComponents.isFileNameValid(fileName)) {
              this.imageSource = this.imageInterfaceCalled.createImageSourceByFilePath(this.context, fileName);
              this.pixelMap = await this.imageInterfaceCalled.createPicture(this.imageSource, true);
              if (this.pixelMap) {
                this.infoLog = `解码${fileName}获取到的辅助图如下：`
              } else {
                this.infoLog = `解码${fileName}获取辅助图失败!`
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
              this.pixelMap = await this.imageInterfaceCalled.createPicture(this.imageSource, true);
              if (this.pixelMap) {
                this.infoLog = `解码${fileName}获取到的辅助图如下：`
              } else {
                this.infoLog = `解码${fileName}获取辅助图失败!`
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
              this.pixelMap = await this.imageInterfaceCalled.createPicture(this.imageSource, true);
              if (this.pixelMap) {
                this.infoLog = `解码${fileName}获取到的辅助图如下：`
              } else {
                this.infoLog = `解码${fileName}获取辅助图失败!`
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
              this.pixelMap = await this.imageInterfaceCalled.createPicture(this.imageSource, true);
              if (this.pixelMap) {
                this.infoLog = `解码${fileName}获取到的辅助图如下：`
              } else {
                this.infoLog = `解码${fileName}获取辅助图失败!`
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
          Row() {
            Button('资源释放').onClick(async () => {
              this.release();
              this.visible = Visibility.None;
              this.infoVisible = Visibility.None;
            })
              .width('40%')
              .margin(10)
            Button('back')
              .width('50%')
              .margin(10)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Index' });
              })
              .width('40%')
              .margin(10)
          }
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('50%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      Text(this.infoLog)
        .width('80%')
        .height('10%')
        .visibility(this.infoVisible)
      Image(this.pixelMap as image.PixelMap)
        .width('100%')
        .height('50%')
        .visibility(this.visible)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
