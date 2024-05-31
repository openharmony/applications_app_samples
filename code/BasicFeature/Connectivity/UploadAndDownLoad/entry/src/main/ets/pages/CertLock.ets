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

import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import request from '@ohos.request';
import connection from '@ohos.net.connection';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import { logger, TOAST_BOTTOM } from '@ohos/uploaddownload';

const TAG: string = 'CertLockSample';

@Entry
@Component
struct CertLock {
  @State message: string = ''
  @State taskId: string = '';
  @State progress: string = '0%';

  build() {
    Navigation() {
      Text(this.message)
        .fontSize(16)
        .fontColor($r('app.color.text_message'))
        .textAlign(TextAlign.Start)
        .id('http_response')
        .width('90%')
        .height('80%')
        .maxLines(30)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Button($r('app.string.upload'))
        .id('upload')
        .width('90%')
        .fontSize(16)
        .height(40)
        .margin({ top: 10, bottom: 20 })
        .enabled(true)
        .backgroundColor($r('app.color.button_blue'))
        .onClick(() => {
          this.uploadTask();
        })

      Button($r('app.string.download'))
        .id('download')
        .type(ButtonType.Capsule)
        .width('90%')
        .fontSize(16)
        .fontColor($r('app.color.btn_text_blue'))
        .height(40)
        .margin({ bottom: 10 })
        .enabled(true)
        .backgroundColor($r('app.color.button_light_gray'))
        .onClick(() => {
          this.DownloadTask();
        })
    }
    .width('100%')
    .height('100%')
    .hideBackButton(false)
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.light_gray'))
    .hideToolBar(false)
    .title($r('app.string.cert_lock'))
  }

  static task: request.agent.Task;
  static netConnection = connection.createNetConnection();

  async DownloadTask() {
    logger.debug(TAG, 'DownloadTask');
    let config: request.agent.Config = {
      action: request.agent.Action.DOWNLOAD,
      url: 'https://www.baidu.com',
      gauge: true,
      overwrite: true,
      method: 'GET',
      network: request.agent.Network.ANY,
    };
    let task: request.agent.Task = await request.agent.create(getContext(), config);
    CertLock.task = task;
    task.on('progress', async (progress) => {
      logger.debug(TAG, `/Request download status ${progress.state}, downloaded ${progress.processed}`);
      promptAction.showToast({
        message: $r('app.string.download_finish'),
        bottom: TOAST_BOTTOM,
        offset: { dx: 10, dy: 96 }
      });
      this.taskId = task.tid;
    })
    let responseOnCallback = (response: request.agent.HttpResponse) => {
      logger.debug(TAG, `response : ${response.version} ${response.statusCode} ${response.reason} ${response.headers}  ${response.headers.size}`)
      let headers: string = '';
      for (let k of response.headers.keys()) {
        headers = headers + k + ":" + response.headers.get(k) + '\r\n';
        ;
        logger.debug(TAG, `response 1 ${k}, ${response.headers.get(k)}`)
      }
      this.message = headers;
    };
    task.on('response', responseOnCallback);

    task.on('failed', async (progress) => {
      this.message = JSON.stringify(progress);
      logger.debug(TAG, `/Request download failed ${(JSON.stringify(progress))}`);
      promptAction.showToast({ message: $r('app.string.download_fail'), bottom: TOAST_BOTTOM });
    })
    logger.debug(TAG, 'Downloading before');
    await task.start();
    logger.debug(TAG, 'Downloading started');
  }

  async uploadTask() {
    logger.debug(TAG, 'uploadTask');
    let attachments: Array<request.agent.FormItem> = [];
    let attachment: request.agent.FormItem = {
      name: 'test',
      value: [
        {
          filename: 'testUpload.txt',
          path: './testUpload.txt',
        },
      ]
    };
    attachments.push(attachment);
    let config: request.agent.Config = {
      action: request.agent.Action.UPLOAD,
      url: 'https://www.baidu.com',
      title: 'taskOnTest',
      mode: request.agent.Mode.FOREGROUND,
      overwrite: true,
      method: 'POST',
      data: attachments,
      saveas: './'
    };
    let createOnCallback = (progress: request.agent.Progress) => {
      let txt: string = $r('app.string.upload_fail').bundleName;
      this.progress = txt + ((progress.processed / 1024 / 1024));
      promptAction.showToast({ message: $r('app.string.upload_success'), bottom: TOAST_BOTTOM });
    };
    request.agent.create(getContext(), config).then((task: request.agent.Task) => {
      task.start((err: BusinessError) => {
        if (err) {
          this.progress = `Failed to start the upload task, Code: ${err.code}  message: ${err.message}`;
          return;
        }
      });
      task.on('progress', createOnCallback);
      let responseOnCallback = (response: request.agent.HttpResponse) => {
        logger.debug(TAG, `response : ${response.version} ${response.statusCode} ${response.reason} ${response.headers}  ${response.headers.size}`)
        let headers: string = '';
        for (let k of response.headers.keys()) {
          headers = headers + k + ':' + response.headers.get(k) + '\r\n';
          ;
          logger.debug(TAG, `response 1 ${k}, ${response.headers.get(k)}`)
        }
        this.message = headers;
      };
      task.on('response', responseOnCallback);
      task.on('failed', async (progress) => {
        this.message = JSON.stringify(progress);
        logger.debug(TAG, `/Request upload failed ${(JSON.stringify(progress))}`);
        promptAction.showToast({ message: $r('app.string.upload_fail'), bottom: TOAST_BOTTOM });
      })
      logger.debug(TAG, `Succeeded in creating a upload task. result: ${task.tid}`);
    }).catch((err: BusinessError) => {
      this.progress = `Failed to create a upload task, Code: ${err.code}, message: ${err.message}`;
    });
  }

  aboutToAppear() {
    logger.debug(TAG, 'aboutToAppear');
  }

  stateChange() {
    logger.debug(TAG, 'stateChange');
  }
}