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
import { BackgroundTaskState, UPLOAD_TOKEN, TOAST_BOTTOM, TASK_MAX } from '../utils/Constants';

const TAG: string = 'RequestUpload';
const HEADER: Record<string, string> = { 'Content-Type': 'multipart/form-data' };

class Upload {
  private mediaUtils: MediaUtils = new MediaUtils();
  private config: request.agent.Config = {
    action: request.agent.Action.UPLOAD,
    headers: HEADER,
    url: '',
    mode: request.agent.Mode.FOREGROUND,
    method: 'POST',
    title: 'upload',
    network: request.agent.Network.ANY,
    data: [],
    token: UPLOAD_TOKEN
  }
  private context: common.UIAbilityContext | undefined = undefined;
  private uploadTask: request.agent.Task | undefined = undefined;
  private backgroundTask: request.agent.Task | undefined = undefined;
  private waitList: Array<string> = [];

  constructor() {
    setInterval(() => {
      this.flushBackgroundTask()
    }, 2000);
  }

  getFileName(filePath: string): string {
    const lastSlashIndex = filePath.lastIndexOf('/');
    if (lastSlashIndex === -1) {
      return filePath;
    }
    return filePath.substring(lastSlashIndex + 1);
  }

  async uploadFilesBackground(fileUris: Array<string>): Promise<void> {
    logger.info(TAG, `uploadFilesBackground:uploadFiles begin, ${JSON.stringify(fileUris)}`);
    this.context = getContext(this) as common.UIAbilityContext;
    if (fileUris.length === 0) {
      return;
    }
    fileUris.forEach((item: string) => {
      this.waitList.push(item);
    });
  }

  async flushBackgroundTask() {
    logger.info(TAG, 'flushBackgroundTask:uploadFiles begin');
    let tasks = await request.agent.search({
      state: request.agent.State.RUNNING
    });
    let state = AppStorage.get<number>('backTaskState');
    if (state === BackgroundTaskState.RUNNING) {
      if (tasks.length < TASK_MAX && this.waitList.length > 0) {
        this.createBackgroundTask(this.waitList);
        this.waitList = [];
      } else {
        if (this.backgroundTask === undefined || tasks.indexOf(this.backgroundTask.tid) === -1) {
          AppStorage.setOrCreate('backTaskState', BackgroundTaskState.NONE);
          this.backgroundTask = undefined;
        }
      }
    }
  }

  async createBackgroundTask(fileUris: Array<string>) {
    logger.info(TAG, `createBackgroundTask:uploadFiles begin, ${JSON.stringify(fileUris)}`);
    if (this.context === undefined) {
      return;
    }
    this.config.url = await urlUtils.getUrl(this.context);
    this.config.data = await this.getFilesAndData(this.context.cacheDir, fileUris);
    this.config.mode = request.agent.Mode.BACKGROUND;
    try {
      this.backgroundTask = await request.agent.create(this.context, this.config);
      await this.backgroundTask.start();
      let state = AppStorage.get<number>('backTaskState');
      if (state === BackgroundTaskState.PAUSE) {
        await this.backgroundTask.pause();
      }
      logger.info(TAG, `createBackgroundTask success`);
    } catch (err) {
      logger.error(TAG, `task  err, err  = ${JSON.stringify(err)}`);
    }
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
      return;
    }
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    this.config.data = await this.getFilesAndData(context.cacheDir, fileUris);
    logger.info(TAG, `config data:${JSON.stringify(this.config.data)}`);
    this.config.url = await urlUtils.getUrl(context);
    logger.info(TAG, `config url:${JSON.stringify(this.config.url)}`);
    this.config.mode = request.agent.Mode.FOREGROUND;
    try {
      this.uploadTask = await request.agent.create(context, this.config);
      this.uploadTask.on('progress', (progress: request.agent.Progress) => {
        logger.info(TAG, `progress,  progress = ${progress.processed} ${progress.state}`);
        let processed = Number(progress.processed.toString()).valueOf();
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
        if (this.uploadTask) {
          let taskInfo = await request.agent.touch(this.uploadTask.tid, UPLOAD_TOKEN);
          logger.info(TAG, `fail,  resean = ${taskInfo.reason}, faults = ${JSON.stringify(taskInfo.faults)}`);
        }
        callback(100, false);
        this.cancelTask();
      });
      await this.uploadTask.start();
    } catch (err) {
      logger.error(TAG, `task  err, err  = ${JSON.stringify(err)}`);
      callback(100, false);
    }
  }

  async uploadFileChunk(fileUris: Array<string>, begin: number, end: number, callback: (progress: number, isSucceed: boolean) => void): Promise<void> {
    logger.info(TAG, `uploadFileChunk begin,${fileUris}, begin:${begin}, end:${end}`);
    // 查询到存在正在执行的上传任务，提示并返回
    let tasks = await request.agent.search({
      state: request.agent.State.RUNNING,
      action: request.agent.Action.UPLOAD,
      mode: request.agent.Mode.FOREGROUND
    });
    if (tasks.length > 0) {
      promptAction.showToast({ message: $r('app.string.have_upload_task_tips'), bottom: TOAST_BOTTOM });
      return;
    }
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    let config: request.agent.Config = {
      action: request.agent.Action.UPLOAD,
      headers: HEADER,
      url: await urlUtils.getUrl(context),
      mode: request.agent.Mode.FOREGROUND,
      method: 'POST',
      title: 'upload',
      network: request.agent.Network.ANY,
      data: await this.getFilesAndData(context.cacheDir, fileUris),
      token: UPLOAD_TOKEN,
      index: 0, // 指定片段上传的文件
      begins: begin,
      ends: end
    };

    try {
      this.uploadTask = await request.agent.create(context, config);
      this.uploadTask.on('progress', (progress: request.agent.Progress) => {
        let processed = Number(progress.processed.toString()).valueOf();
        let size = progress.sizes[progress.index];
        if (progress.index === 0) {
          if (end === -1) {
            size -= begin;
          } else {
            size = end - begin + 1;
          }
        }
        logger.info(TAG, `progress,  index:${progress.index}, progressed = ${progress.processed}, size=${size}`);
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
        if (this.uploadTask) {
          let taskInfo = await request.agent.touch(this.uploadTask.tid, UPLOAD_TOKEN);
          logger.info(TAG, `fail,  resean = ${taskInfo.reason}, faults = ${JSON.stringify(taskInfo.faults)}`);
        }
        callback(100, false);
        this.cancelTask();
      })
      await this.uploadTask.start();
    } catch (err) {
      logger.error(TAG, `task  err, err  = ${JSON.stringify(err)}`);
      callback(100, false);
    }
  }

  async cancelTask() {
    logger.info(TAG, 'cancelTask');
    if (this.uploadTask === undefined) {
      return;
    }
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

  async pauseOrResume() {
    logger.info(TAG, 'pauseOrResume');
    let state = AppStorage.get<number>('backTaskState');
    if (state === BackgroundTaskState.RUNNING) {
      await this.pause();
      AppStorage.setOrCreate('backTaskState', BackgroundTaskState.PAUSE);
    } else if (state === BackgroundTaskState.PAUSE) {
      await this.resume();
      AppStorage.setOrCreate('backTaskState', BackgroundTaskState.RUNNING);
    } else {
      logger.info(TAG, 'this task state is error');
    }
  }

  async pause() {
    logger.info(TAG, 'pause');
    if (this.backgroundTask === undefined) {
      return;
    }
    try {
      await this.backgroundTask.pause();
    } catch (err) {
      logger.info(TAG, `pause fail,err= ${JSON.stringify(err)}`);
    }
  }

  async resume() {
    logger.info(TAG, 'resume');
    if (this.backgroundTask === undefined) {
      return;
    }
    try {
      await this.backgroundTask.resume();
    } catch (err) {
      logger.info(TAG, `resume fail,err= ${JSON.stringify(err)}`);
    }
  }

  private async getFilesAndData(cacheDir: string, fileUris: Array<string>): Promise<Array<request.agent.FormItem>> {
    logger.info(TAG, `getFilesAndData begin`);
    let files: Array<request.agent.FormItem> = [];
    for (let i = 0; i < fileUris.length; i++) {
      logger.info(TAG, `getFile fileUri = ${fileUris[i]}`);
      let imagePath = fileUris[i];
      logger.info(TAG, `getFilesAndData  imagePath: ${JSON.stringify(imagePath)}`);
      let fileName = this.getFileName(imagePath);
      let file: request.agent.FormItem = {
        name: 'createTest',
        value: {
          filename: fileName,
          mimeType: 'application/octet-stream',
          path: imagePath,
        }
      }
      logger.info(TAG, `getFile file = ${JSON.stringify(file)}`);
      files.push(file);
    }
    logger.info(TAG, `getFilesAndData ${JSON.stringify(files)}`);
    return files;
  }
}

export const requestUpload = new Upload();