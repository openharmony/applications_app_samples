/*
 * Copyright (c) 2023-2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import router from '@ohos.router';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import uniformTypeDescriptor from '@ohos.data.uniformTypeDescriptor';
import { BusinessError } from '@ohos.base';

// 获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;
let baseDir = context.filesDir;
let filesDir = baseDir + '/udmf_test';
let precastFiles: string[] = [
  "imagePng1.png",
  "imagePng2.png",
  "imageJpg1.jpg",
  "imageJpg2.jpg",
  "imageTiff1.tiff",
  "imageTiff2.tiff",
  "imageMyImage1.myImage",
  "imageMyImage2.myImage",

  "audioMp31.mp3",
  "audioMp32.mp3",
  "audioWav1.wav",
  "audioWav2.wav",
  "audioOgg1.ogg",
  "audioOgg2.ogg",
  "audioMyAudio1.myAudio",
  "audioMyAudio2.myAudio",

  "videoMp41.mp4",
  "videoMp42.mp4",
  "videoMpeg1.mpeg",
  "videoMpeg2.mpeg",
  "videoAvi1.avi",
  "videoAvi2.avi",
  "videoMyVideo1.myVideo",
  "videoMyVideo2.myVideo",
];

// 预制文件
function CreatePrecastFile(): void {
  try {
    let res = fs.accessSync(filesDir);
    if (res) {
      console.info(`file path: ${filesDir} exists`);
    } else {
      console.info(`file path: ${filesDir} not exists`);
      fs.mkdirSync(filesDir);
    }
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error("accessSync failed with error message: " + err.message + ", error code: " + err.code);
  }

  for (let i = 0; i < precastFiles.length; i++) {
    let fileName = filesDir + "/" + precastFiles[i];
    console.info(`The file name: ${fileName}`);
    try {
      let res = fs.accessSync(fileName);
      if (res) {
        console.info(`file: ${fileName} exists!.`);
      } else {
        console.info(`file: ${fileName} not exists, will create it!.`);
        let file = fs.openSync(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        console.info("file fd: " + file.fd);
        fs.closeSync(file);
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error("accessSync failed with error message: " + err.message + ", error code: " + err.code);
    }
  }
}

@Entry
@Component
struct Index {
  private routerUrl: string = 'pages/selectMediaType'

  aboutToAppear() {
    console.info('filesDir: ' + filesDir);
    CreatePrecastFile();
  }

  build() {
    Column() {
      Row() {
        Button($r('app.string.buttonPrompt'))
          .backgroundColor(0x317aff)
          .fontSize(16)
          .height(40)
          .width('100%')
          .visibility(Visibility.Visible)
          .id('EnterMainPage')
          .onClick(() => {
            router.pushUrl({
              url: this.routerUrl
            });
          })
      }
      .margin({ left: 24, right: 24 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
