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

import { requestUpload, logger, TOAST_BOTTOM, requestDownload } from 'uploadanddownload';
import { common } from '@kit.AbilityKit';

const TAG: string = 'UploadSample';

@Entry
@Component
struct Upload {
  @StorageLink('downloadServer') downloadServerStr: string = './';
  @State isApi9Begin: boolean = false;
  @State isApi10Begin: boolean = false;
  @State api9Progress: number = 0;
  @State api10Progress: number = 0;

  build() {
    Navigation() {
      Column() {
        Button() {
          if (this.isApi9Begin) {
            Row() {
              Progress({ value: this.api9Progress, type: ProgressType.Ring })
                .width(20)
                .height(20)
                .backgroundColor('#FFFFFF')
                .color('#558DFF')
                .style({ strokeWidth: 2, scaleCount: 100, scaleWidth: 2 })
              Text(`${this.getResourceString($r('app.string.uploading'))}${this.api9Progress}%`)
                .fontSize(16)
                .fontColor(0xffffff)
                .fontWeight(500)
                .margin({ left: 12 })
            }.alignItems(VerticalAlign.Center)
          } else {
            Text($r('app.string.uploadFile'))
              .fontSize(16)
              .fontWeight(500)
              .fontColor($r('app.color.white'))
          }
        }
        .id('publish1')
        .width('100%')
        .height(40)
        .margin({ bottom: this.isApi9Begin ? 16 : 24 })
        .backgroundColor($r('app.color.button_blue'))
        .onClick(() => {
          this.uploadApi9();
        })

        Button() {
          if (this.isApi10Begin) {
            Row() {
              Progress({ value: this.api10Progress, type: ProgressType.Ring })
                .width(20)
                .height(20)
                .backgroundColor('#FFFFFF')
                .color('#558DFF')
                .style({ strokeWidth: 2, scaleCount: 100, scaleWidth: 2 })
              Text(`${this.getResourceString($r('app.string.uploading'))}${this.api10Progress}%`)
                .fontSize(16)
                .fontColor(0xffffff)
                .fontWeight(500)
                .margin({ left: 12 })
            }.alignItems(VerticalAlign.Center)
          } else {
            Text($r('app.string.agentTask'))
              .fontSize(16)
              .fontWeight(500)
              .fontColor($r('app.color.white'))
          }
        }
        .id('publish2')
        .width('100%')
        .height(40)
        .margin({ bottom: this.isApi10Begin ? 16 : 24 })
        .backgroundColor($r('app.color.button_blue'))
        .onClick(() => {
          this.uploadApi10();
        })
      }
      .width('100%')
      .padding({ left: 24, right: 24 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.light_gray'))
    .title($r('app.string.upload'))
    .hideBackButton(false)
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
  }

  async uploadApi9() {
    this.isApi9Begin = true;
    this.api9Progress = 0;
    let fileName = 'test.txt';
    let url = this.downloadServerStr + fileName;
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    await requestDownload.requestAgentDownload(url, fileName, (progress, isSucceed) => {
      if (progress === 100 && isSucceed) {
        requestUpload.requestUploadFile(fileName, this.uploadApi9Callback, context);
      }
    }, context);
  }

  async uploadApi10() {
    this.isApi10Begin = true;
    this.api10Progress = 0;
    let fileName = 'audio_test.mp3';
    let url = this.downloadServerStr + fileName;
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    await requestDownload.requestAgentDownload(url, fileName, (progress, isSucceed) => {
      if (progress === 100 && isSucceed) {
        requestUpload.requestAgentUpload(fileName, this.uploadApi10Callback, context);
      }
    }, context);
  }

  getResourceString(resource: Resource) {
    let res = this.getUIContext().getHostContext()?.resourceManager.getStringSync(resource.id);
    logger.debug(TAG + ':****' + res);
    return res;
  }

  uploadApi9Callback = (progress: number, isSucceed: boolean) => {
    this.api9Progress = progress;
    if (this.api9Progress === 100 && isSucceed) {
      this.isApi9Begin = false;
      this.getUIContext()
        .getPromptAction()
        .showToast({ message: $r('app.string.upload_success'), bottom: TOAST_BOTTOM });
    }
    if (this.api9Progress === 100 && isSucceed === false) {
      this.isApi9Begin = false;
      this.getUIContext().getPromptAction().showToast({ message: $r('app.string.upload_fail'), bottom: TOAST_BOTTOM });
    }
  }
  uploadApi10Callback = (progress: number, isSucceed: boolean) => {
    this.api10Progress = progress;
    if (this.api10Progress === 100 && isSucceed) {
      this.isApi10Begin = false;
      this.getUIContext()
        .getPromptAction()
        .showToast({ message: $r('app.string.upload_success'), bottom: TOAST_BOTTOM });
    }
    if (this.api10Progress === 100 && isSucceed === false) {
      this.isApi10Begin = false;
      this.getUIContext().getPromptAction().showToast({ message: $r('app.string.upload_fail'), bottom: TOAST_BOTTOM });
    }
  }
}