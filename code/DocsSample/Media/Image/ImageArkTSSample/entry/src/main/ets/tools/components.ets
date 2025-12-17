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

import {Router} from '@ohos.arkui.UIContext';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import hdrCapability from '@ohos.graphics.hdrCapability';
import display from '@ohos.display';
import fs from '@ohos.file.fs';

const router = new Router();

@Component
export struct UIComponentsBuilder {
  // 构建Text组件的方法。
  @Builder
  textComponent(name: string) {
    Text(name)
      .fontSize($r('app.float.index_text_font_size'))
      .size({ width: '100%', height: $r('app.float.index_button_height_size') })
  }

  @Builder
  buttonComponent(name: string, dstUri: string) {
    Button(name)
      .margin({ top: $r('app.float.index_margin_size') } as Margin)
      .fontSize($r('app.float.index_button_font_size'))
      .fontColor($r('app.color.white'))
      .borderRadius($r('app.float.index_button_borderRadius_size'))
      .backgroundColor($r('app.color.blue'))
      .size({ width: '100%', height: $r('app.float.index_button_height_size') })
      .onClick((e: ClickEvent) => {
        router.pushUrl({ url: dstUri });
      })
  }

  async switchFileName(context: common.UIAbilityContext, name: string): Promise<string> {
    let fileName = '';
    switch(name) {
      case 'JPEG':
        fileName = 'test.jpeg';
        await this.pushSourceToBox(context, fileName);
        break;
      case 'PNG':
        fileName = 'test.png';
        await this.pushSourceToBox(context, fileName);
        break;
      case 'GIF':
        fileName = 'test.gif';
        await this.pushSourceToBox(context, fileName);
        break;
      case 'WebP':
        fileName = 'test.webp';
        await this.pushSourceToBox(context, fileName);
        break;
      case 'BMP':
        fileName = 'test.bmp';
        await this.pushSourceToBox(context, fileName);
        break;
      case 'SVG':
        fileName = 'test.svg';
        await this.pushSourceToBox(context, fileName);
        break;
      case 'ICO':
        fileName = 'test.ico';
        await this.pushSourceToBox(context, fileName);
        break;
      case 'DNG':
        fileName = 'test.dng';
        await this.pushSourceToBox(context, fileName);
        break;
      case 'HEIF':
        let resourceMgr = context.resourceManager;
        let rawFile = await resourceMgr.getRawFileContent('allAux.heic');
        let isSupportHEIFDecode: Boolean = image.createImageSource(rawFile.buffer as ArrayBuffer)
          .supportedFormats
          .includes('image/heic');
        if (!isSupportHEIFDecode) {
          console.log(`device is not support heif decode`);
          fileName = 'unknown';
        } else {
          fileName = 'allAux.heic';
          await this.pushSourceToBox(context, fileName);
        }
        break;
      case 'HDR':
        let isSupportHdr = !display.getDefaultDisplaySync().hdrFormats.includes(hdrCapability.HDRFormat.NONE) &&
          display.getDefaultDisplaySync().hdrFormats.length != 0;
        if (isSupportHdr) {
          fileName = 'allAux.jpg';
          await this.pushSourceToBox(context, fileName);
        } else {
          console.log(`device is not support hdr decode`);
          fileName = 'unknown';
        }
        break;
      default:
        fileName = 'unknown';
        break;
    }
    return fileName;
  }

  // 将rawFile中的文件写到沙箱里。
  async pushSourceToBox(context: common.UIAbilityContext, fileName: string) {
    let value = await context.resourceManager.getRawFileContent(fileName);
    let myBuffer: ArrayBufferLike = value.buffer;
    let filePath = context.cacheDir + '/' + fileName;
    let file = await fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let writLen = await fs.write(file.fd, myBuffer);
    console.log(`Push ${fileName} to box's writLen is ${writLen}.`);
    fs.closeSync(file);
  }

  // 获取文件fd。
  getFileFd(context: Context, fileName: string): number {
    const filePath: string = context.cacheDir + '/' + fileName;
    const file: fs.File = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    const fd: number = file?.fd;
    return fd;
  }

  isFileNameValid(fileName: string): boolean {
    if (fileName == 'unknown') {
      return false;
    } else {
      return true;
    }
  }

  build(){}
}
