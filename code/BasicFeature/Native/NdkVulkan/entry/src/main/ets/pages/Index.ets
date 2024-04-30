/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import hilog from '@ohos.hilog';
import fs from '@ohos.file.fs';

@Entry
@Component
struct Index {
  @State message: string = 'Vulkan Triangle';
  xcomponentController: XComponentController = new XComponentController();
  private xComponentContext: Record<string, () => void> = {};

  aboutToAppear(): void { // Copy shader to hap sandbox
    let path = getContext(this).filesDir + '/rawfile';
    if (!fs.accessSync(path)) {
      fs.mkdirSync(path);
    }
    let buffer = getContext(this).resourceManager.getRawFileContentSync('shaders/vert.spv');
    let file = fs.openSync(path + '/vert.spv', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, buffer.buffer);
    buffer = getContext(this).resourceManager.getRawFileContentSync('shaders/frag.spv');
    file = fs.openSync(path + '/frag.spv', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, buffer.buffer);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(this.message)// Title "Vulkan Triangle"
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
        })
      XComponent({ // XComponent surface to present a triangle
        id: 'xcomponentId',
        type: 'surface',
        controller: this.xcomponentController,
        libraryname: 'nativerender'
      })
        .margin({ bottom: '10%' })
        .onLoad((xComponentContext?: object | Record<string, () => void>) => { // Load context when surface is created
          if (xComponentContext) {
            this.xComponentContext = xComponentContext as Record<string, () => void>;
          }
        })
        .onDestroy(() => {
        })
        .width('80%')
        .height('50%')
      Button('stop/start')// click button to control the status of the triangle
        .onClick(() => {
          if (this.xComponentContext) {
            this.xComponentContext.stopOrStart();
          }
        })
    }
    .width('100%')
    .height('100%')
  }
}
