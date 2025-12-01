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

import { fileIo as fs } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { httpRequest } from '../utils/NetRequest';
import Logger from '../utils/Logger';

// Obtain the path of the application file
const uiContext: UIContext | undefined = AppStorage.get('uiContext');
let context: common.UIAbilityContext = uiContext?.getHostContext() as common.UIAbilityContext;
let filesDir: string = context.filesDir;
let fileUrl: string = filesDir + '/abc.png'; // The image's network address suffix needs to be replaced by the real url.
let para: Record<string, PixelMap | undefined> = { 'imageData': undefined };
let localStorage: LocalStorage = new LocalStorage(para);
const TAG: string = '[GetPixMapFunc]';

@Entry(localStorage)
@Component
struct MainPage {
  @State childNavStack: NavPathStack = new NavPathStack();
  @LocalStorageLink('imageData') imageData: PixelMap | undefined = undefined;

  getPixMap() { // Read files from the application sandbox
    try {
      let file: fs.File = fs.openSync(fileUrl, fs.OpenMode.READ_WRITE); // Open the file in a synchronous manner
      const imageSource: image.ImageSource = image.createImageSource(file.fd);
      const options: image.InitializationOptions = {
        'alphaType': 0, // transparency
        'editable': false, // Editable or not
        'pixelFormat': 3, // Pixel format
        'scaleMode': 1, // Abbreviated value
        'size': { height: 100, width: 100 }
      };
      fs.close(file).catch((error: BusinessError) => {
        Logger.error(TAG, `close file failed with error message: ${error.message},error code: ${error.code}`);
      })
      imageSource.createPixelMap(options).then((pixelMap: PixelMap) => {
        this.imageData = pixelMap;
      });
    } catch (error) {
      Logger.error(TAG, 'Resource loading error, file or does not exist!');
    }
  }

  aboutToAppear(): void {
    httpRequest(); // Initiate a network request ahead of the parent component
  }

  build() {
    Navigation(this.childNavStack) {
      Column() {
        Button('push Path to pageOne', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin({ bottom: '36vp' })
          .onClick(() => {
            // Do not call getPixMap() repeatedly except for the first click to avoid reading files from the sandbox with each click.
            if (!localStorage.get('imageData')) {
              this.getPixMap();
            }
            this.childNavStack.pushPath({ name: 'pageOne' });
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.End)
    }
    .backgroundColor(Color.Transparent)
    .title('ParentNavigation')
  }
}