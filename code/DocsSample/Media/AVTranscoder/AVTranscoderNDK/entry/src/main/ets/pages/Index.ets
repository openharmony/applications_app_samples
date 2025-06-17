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

import testNapi from 'libentry.so';
import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
import resourceManager from '@ohos.resourceManager';

@Entry
@Component
struct Index {
  @State message: string = '启动转码';
  @State progress: number = 0;
  private context: Context | undefined = this.getUIContext().getHostContext();
  private src: resourceManager.RawFileDescriptor | undefined = undefined;
  private dst: fs.File | undefined = undefined;

  getFileFd(fileName: string) {
    let pathName = getContext().filesDir + '/' + fileName;
    console.log('pathName is ' + pathName)
    let file: fs.File = fs.openSync(pathName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    return file;
  }

  async start() {
    if (!this.context) {
      console.log('context is null')
      return;
    }
    this.src = this.context.resourceManager.getRawFdSync('src.mp4');
    this.dst = this.getFileFd('out.mp4');
    try {
      let errCode = testNapi.AvTranscoderNdkPlay(this.src.fd, this.src.offset, this.src.length, this.dst.fd)
      console.log('AvTranscoderNdkPlay success: ' + JSON.stringify(errCode));
    } catch (err) {
      let error = err as BusinessError;
      console.log('AvTranscoderNdkPlay err:' + error);
      return;
    }
  }

  aboutToDisappear(): void {
    testNapi.AvTranscoderNdkRelease(); // 释放转码实例。
    if (this.src) {
      fs.closeSync(this.src.fd);
    }
    if (this.dst) {
      fs.closeSync(this.dst.fd);
    }
  }

  build() {
    Row() {
      Column({ space: 12 }) {
        Button($r('app.string.AVTranscoder_start'))
          .id('AVTranscoderStart')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.start(); // 开始转码。
          })
        Button($r('app.string.AVTranscoder_pause'))
          .id('AVTranscoderPause')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            testNapi.AvTranscoderNdkPause(); //暂停转码。
          })
        Button($r('app.string.AVTranscoder_resume'))
          .id('AVTranscoderResume')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            testNapi.AvTranscoderNdkResume(); // 恢复转码。
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
