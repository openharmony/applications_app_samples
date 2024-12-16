/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import testNapi from 'libentry.so';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { promptAction } from '@kit.ArkUI';
import { buffer } from '@kit.ArkTS';
import Logger from '../common/Logger';

@Entry
@Component
struct Index {
  context = getContext(this) as common.UIAbilityContext;
  pathDir = this.context.filesDir;

  aboutToAppear() {
    try {
      let path = this.pathDir + '/test.gif';
      Logger.info(`image path:`, path);
      if (fs.accessSync(path)) {
        Logger.info('image exists');
        return;
      }
      let uint8Array: Uint8Array = this.context.resourceManager.getRawFileContentSync('test.gif');
      let buf = buffer.from(uint8Array).buffer;
      let file = fs.openSync(path, fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      if (file.fd) {
        fs.writeSync(file.fd, buf);
        fs.closeSync(file);
      }
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      Logger.error('copy image failed, error code: ', code.toString(), ', message: ', message);
    }
  }

  build() {
    Column() {
      Button($r('app.string.Decode_Image'))
        .width(200)
        .height(50)
        .onClick(async () => {
          let path = this.pathDir + '/test.gif';
          await fs.access(path).then((res: boolean) => {
            if (res) {
              Logger.info('image exists');
              let ec = testNapi.sourceTest(path);
              promptAction.showToast({ message: `Decode Image ${ec === 0 ? 'success' : 'fail'}!` });
            } else {
              Logger.info('image not exists');
            }
          }).catch((err: BusinessError) => {
            Logger.error('access failed with error message: ', err.message, ', error code: ', err.code.toString());
          });
        })

      Button($r('app.string.PixelMap_Operation'))
        .width(200)
        .height(50)
        .onClick(() => {
          let ec = testNapi.pixelmapTestJs();
          promptAction.showToast({ message: `PixelMap Operation ${ec === 0 ? 'success' : 'fail'}!` });
        });

      Button($r('app.string.Encode_Image_ImageSource'))
        .width(200)
        .height(50)
        .onClick(async () => {
          let path = this.pathDir + '/test.gif';
          await fs.open(path, fs.OpenMode.READ_WRITE).then((file: fs.File) => {
            if (file.fd) {
              let ec = testNapi.packToFileFromImageSourceTestJs(file.fd);
              fs.close(file);
              promptAction.showToast({ message: `Encode Image From ImageSource ${ec === 0 ? 'success' : 'fail'}!` });
            }
          }).catch((err: BusinessError) => {
            Logger.error('open file failed with error message: ', err.message, ', error code: ', err.code.toString());
          });
        });

      Button($r('app.string.Encode_Image_PixelMap'))
        .width(200)
        .height(50)
        .onClick(async () => {
          let path = this.pathDir + '/packtest01.gif';
          await fs.open(path, fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
            .then((file: fs.File) => {
              if (file.fd) {
                let ec = testNapi.packToFileFromPixelmapTestJs(file.fd);
                fs.close(file);
                promptAction.showToast({ message: `Encode Image From PixelMap ${ec === 0 ? 'success' : 'fail'}!` });
              }
            })
            .catch((err: BusinessError) => {
              Logger.error('open file failed with error message: ', err.message, ', error code: ',
                           err.code.toString());
            });
        });
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}
