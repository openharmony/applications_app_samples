/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import request from '@ohos.request';
import promptAction from '@ohos.promptAction';
import { urlUtils } from '../utils/UrlUtils';
import { logger } from '../utils/Logger';
import { MediaUtils } from '../utils/MediaUtils';
import { UPLOAD_TOKEN, TOAST_BOTTOM } from '../utils/Constants';

const TAG: string = 'RequestUpload';

class Upload {
  private mediaUtils: MediaUtils = new MediaUtils();
  private config: request.agent.Config = {
    action: request.agent.Action.UPLOAD,
    headers: { 'Content-Type': 'multipart/form-data' },
    url: '',
    mode: request.agent.Mode.FOREGROUND,
    method: 'POST',
    title: 'upload',
    network: request.agent.Network.ANY,
    data: [],
    token: UPLOAD_TOKEN
  }
  private uploadTask: request.agent.Task = undefined;
  private backgroundTask: Array<request.agent.Task> = [];

  async uploadFilesBackground(fileUris: Array<string>): Promise<void> {
    logger.info(TAG, `uploadFiles begin, ${JSON.stringify(fileUris)}`);
    if (fileUris.length === 0) {
      return;
    }
    let index = this.backgroundTask.length;
    if (this.backgroundTask.length > 0) {
      await this.pause(index);
    }
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    this.config.data = await this.getFilesAndData(fileUris);
    this.config.url = await urlUtils.getUrl(context);
    this.config.mode = request.agent.Mode.BACKGROUND;
    try {
      let task = await request.agent.create(context, this.config);
      await task.start();
      this.backgroundTask.push(task);
    } catch (err) {
      logger.error(TAG, `task  err.code  = ${err.code} , msg= ${err.message}`);
    }
    await this.resume(index);
  }

  async uploadFiles(fileUris: Array<string>, callback: (progress: number, isSucceed: boolean) => void): Promise<void> {
    logger.info(TAG, `uploadFiles begin, ${JSON.stringify(fileUris)}`);
    if (fileUris.length === 0) {
      return;
    }
    // 查询到存在正在执行的上传任务，提示并返回
    let tasks = await request.agent.search({
      state: request.agent.State.RUNNING,
      action: request.agent.Action.UPLOAD,
      mode: request.agent.Mode.FOREGROUND
    });
    if (tasks.length > 0) {
      promptAction.showToast({ message: $r('app.string.have_upload_task_tips'), bottom: TOAST_BOTTOM });
    }
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    this.config.data = await this.getFilesAndData(fileUris);
    this.config.url = await urlUtils.getUrl(context);
    this.config.mode = request.agent.Mode.FOREGROUND;
    try {
      this.uploadTask = await request.agent.create(context, this.config);
      this.uploadTask.on('progress', (progress: request.agent.Progress) => {
        logger.info(TAG, `progress,  progress = ${progress.processed} ${progress.state}`);
        let processed = parseInt(progress.processed.toString());
        let size = progress.sizes[0];
        let process: number = Math.floor(processed / size * 100);
        if (process < 100) {
          callback(process, false);
        }
      });
      this.uploadTask.on('completed', (progress: request.agent.Progress) => {
        logger.info(TAG, `complete,  progress = ${progress.processed} ${progress.state}`);
        callback(100, true);
        this.cancelTask();
      });
      this.uploadTask.on('failed', async (progress: request.agent.Progress) => {
        let taskInfo = await request.agent.touch(this.uploadTask.tid, UPLOAD_TOKEN);
        logger.info(TAG, `fail,  resean = ${taskInfo.reason}, faults = ${JSON.stringify(taskInfo.faults)}`);
        callback(100, false);
        this.cancelTask();
      });
      await this.uploadTask.start();
    } catch (err) {
      logger.error(TAG, `task  err.code  = ${err.code} , msg= ${err.message}`);
      callback(100, false);
    }
  }

  async cancelTask() {
    try {
      this.uploadTask.off('progress');
      this.uploadTask.off('failed');
      this.uploadTask.off('completed');
      await this.uploadTask.stop();
      await request.agent.remove(this.uploadTask.tid);
    } catch (err) {
      logger.info(TAG, `deleteTask fail,err= ${JSON.stringify(err)}`);
    }
    this.uploadTask = undefined;
  }

  async pause(index) {
    logger.info(TAG, 'pause');
    for (let i = 0; i < index; i++) {
      try {
        await this.backgroundTask[i].pause();
      } catch (err) {
        logger.info(TAG, `pause fail,err= ${JSON.stringify(err)}`);
      }
    }
  }

  async resume(index: number) {
    logger.info(TAG, 'resume');
    for (let i = 0; i < index; i++) {
      try {
        await this.backgroundTask[i].resume();
      } catch (err) {
        logger.info(TAG, `pause fail,err= ${JSON.stringify(err)}`);
      }
    }
  }

  private async getFilesAndData(fileUris: Array<string>): Promise<Array<request.agent.FormItem>> {
    logger.info(TAG, `getFilesAndData begin`);
    let files: Array<request.agent.FormItem> = [];
    for (let i = 0; i < fileUris.length; i++) {
      logger.info(TAG, `getFile fileUri = ${fileUris[i]}`);
      let imagePath = await this.mediaUtils.copyFileToCache(fileUris[i]);
      logger.info(TAG, `getFilesAndData ${JSON.stringify(imagePath)}`);
      let file: request.agent.FormItem = {
        name: imagePath.split('cache/')[1],
        value: {
          path: './' + imagePath.split('cache/')[1]
        }
      }
      files.push(file);
    }
    logger.info(TAG, `getFilesAndData ${JSON.stringify(files)}`);
    return files;
  }
}

export const requestUpload = new Upload();