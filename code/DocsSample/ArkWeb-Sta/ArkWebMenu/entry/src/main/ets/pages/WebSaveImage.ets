'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start web_Save_Image]
import webview from '@ohos.web.webview';
import { Entry, Column, Component, ClickEvent, Web, Context, Row, ResponseType, FlexAlign, SaveButton, Padding,
  SaveButtonOnClickResult, SaveButtonOptions, SaveIconStyle, SaveDescription, ButtonType, $rawfile, Color } from '@ohos.arkui.component';
import { State } from '@ohos.arkui.stateManagement';
import { BusinessError } from '@ohos.base';
import { common } from '@kit.AbilityKit';
import { fileIo as fs, ReadOptions, WriteOptions } from '@kit.CoreFileKit';
import { http } from '@kit.NetworkKit';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import systemDateTime from '@ohos.systemDateTime';

@Entry
@Component
struct WebComponent {
  saveButtonOptions: SaveButtonOptions = {
    icon: SaveIconStyle.FULL_FILLED,
    text: SaveDescription.SAVE_IMAGE,
    buttonType: ButtonType.Capsule
  }
  controller: webview.WebviewController = new webview.WebviewController(undefined);
  @State showMenu: boolean = false;
  @State imgUrl: string = '';
  context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  async saveImage(): Promise<void> {
    try {
      let context = this.context;
      let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      let uri = '';
      if (this.imgUrl?.includes('rawfile')) {
        let rawFileName: string = this.imgUrl.substring(this.imgUrl.lastIndexOf('/') + 1);
        uri = await this.copyLocalPicToDir(rawFileName, 'copyFile.png');
      } else if (this.imgUrl?.includes('http') || this.imgUrl?.includes('https')) {
        uri = await this.copyUrlPicToDir(this.imgUrl, `onlinePic${systemDateTime.getTime()}.png`);
      }
      if (uri) {
        let assetChangeRequest = photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(context, 'file://' + uri);
        if (assetChangeRequest != null && phAccessHelper != null) {
          await phAccessHelper.applyChanges(assetChangeRequest);
        }
      }
    } catch (err) {
      console.error(`create asset failed with error: ${err.code}, ${err.message}`);
    }
  }

  async copyLocalPicToDir(rawfilePath: string, newFileName: string): Promise<string> {
    let srcFileDes = this.context.resourceManager.getRawFdSync(rawfilePath);
    let dstPath = this.context.cacheDir + '/' + newFileName;
    let dest: fs.File = fs.openSync(dstPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    let bufsize: number = 4096;
    let buf = new ArrayBuffer(bufsize);
    let off: number = 0;
    let len: number = 0;
    let readLen: number = 0;
    let srcFd: int = Number(srcFileDes.fd) as int;
    let srcOffset: number = srcFileDes.offset;
    let srcLength: number = srcFileDes.length;
    while (true) {
      let readOptions: ReadOptions = { offset: srcOffset + off as long, length: bufsize as long};
      len = fs.readSync(srcFd, buf, readOptions);
      if (len <= 0) {
        break;
      }
      readLen += len;
      let writeOptions: WriteOptions = { offset: off as long, length: len as long};
      fs.writeSync(dest.fd, buf, writeOptions);
      off += len;
      if ((srcLength - readLen) < bufsize) {
        bufsize = srcLength - readLen;
      }
      if (bufsize <= 0) {
        break;
      }
    }
    fs.close(dest.fd);
    return dstPath;
  }

  async copyUrlPicToDir(picUrl: string, newFileName: string): Promise<string> {
    let filePath = '';
    let httpRequest = http.createHttp();
    let data: http.HttpResponse = await (httpRequest.request(picUrl));
    if (data?.responseCode == http.ResponseCode.OK) {
      let dstPath = this.context.cacheDir + '/' + newFileName;
      let dest: fs.File = fs.openSync(dstPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
      fs.writeSync(dest.fd, data.result as ArrayBuffer);
      fs.close(dest.fd);
      filePath = dest.path;
    }
    return filePath;
  }

  @Builder
  MenuBuilder() {
    Column() {
      Row() {
        SaveButton(this.saveButtonOptions)
          .onClick((event: ClickEvent, result: SaveButtonOnClickResult, error?: BusinessError<void>) => {
            if (result == SaveButtonOnClickResult.SUCCESS) {
              this.saveImage();
            } else {
              console.error(`SaveButtonOnClickResult create asset failed`);
            }
            this.showMenu = false;
          })
      }
      .margin({ top: 20, bottom: 20 } as Padding)
      .justifyContent(FlexAlign.Center)
    }
    .width('80')
    .backgroundColor(Color.White)
    .borderRadius(10)
  }

  build() {
    Column() {
      Web({ src: $rawfile('index4.html'), controller: this.controller })
        .onContextMenuShow((event) => {
          if (event) {
            let hitValue = this.controller.getLastHitTest();
            this.imgUrl = hitValue.extra;
          }
          this.showMenu = true;
          return true;
        })
        .bindContextMenu(this.MenuBuilder, ResponseType.LongPress)
        .fileAccess(true)
        .javaScriptAccess(true)
        .domStorageAccess(true)
    }
  }
}
// [End web_Save_Image]