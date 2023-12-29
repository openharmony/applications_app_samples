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
import { logger } from '../utils/Logger';
import { BackgroundTaskState, TASK_MAX, TOAST_BOTTOM } from '../utils/Constants';

const TAG: string = 'RequestDownload';

class RequestDownload {
  private context: common.UIAbilityContext | undefined = undefined;
  private waitList: Array<string[]> = [];
  private downloadTask: request.agent.Task | undefined = undefined;
  private backgroundDownloadTaskList: Array<request.agent.Task> = [];

  constructor() {
    setInterval(() => {
      this.flushBackgroundTask()
    }, 2000);
  }

  async downloadFilesBackground(folder: string, files: Array<string>) {
    logger.info(TAG, 'downloadFiles');
    this.context = getContext(this) as common.UIAbilityContext;
    files.forEach((item: string) => {
      this.waitList.push([folder, item]);
    });
  }

  async flushBackgroundTask() {
    let tasks = await request.agent.search({
      state: request.agent.State.RUNNING
    });
    if (tasks.length < TASK_MAX && this.waitList.length > 0) {
      let downloadList: Array<string[]> = [];
      if (this.waitList.length <= TASK_MAX - tasks.length) {
        downloadList = this.waitList;
        this.waitList = [];
      } else {
        downloadList = this.waitList.slice(0, TASK_MAX - tasks.length);
        this.waitList = this.waitList.slice(TASK_MAX - tasks.length, this.waitList.length);
      }
      logger.info(TAG, `this.waitList = ${JSON.stringify(this.waitList)}`);
      this.createBackgroundTask(downloadList);
    } else {
      let state = AppStorage.get<number>('backDownTaskState');
      logger.info(TAG, `backLists  = ${this.backgroundDownloadTaskList.map(i => i.tid)}`);
      if (state === BackgroundTaskState.RUNNING) {
        if (tasks.length === 0) {
          AppStorage.setOrCreate('backDownTaskState', BackgroundTaskState.NONE);
          this.backgroundDownloadTaskList = [];
        }
      }
    }
  }

  async createBackgroundTask(downloadList: Array<string[]>) {
    if (this.context === undefined) {
      return;
    }
    for (let i = 0; i < downloadList.length; i++) {
      try {
        let splitUrl = downloadList[i][1].split('//')[1].split('/');
        let downloadConfig: request.agent.Config = {
          action: request.agent.Action.DOWNLOAD,
          url: downloadList[i][1],
          method: 'POST',
          title: 'download',
          mode: request.agent.Mode.BACKGROUND,
          network: request.agent.Network.ANY,
          saveas: `./${downloadList[i][0]}/${splitUrl[splitUrl.length-1]}`,
          overwrite: true,
          gauge: true
        }
        let downTask = await request.agent.create(this.context, downloadConfig);
        if (this.backgroundDownloadTaskList.findIndex(task => task.config.url === downTask.config.url) === -1) {
          this.backgroundDownloadTaskList.push(downTask);
        }
        await downTask.start();
      } catch (err) {
        logger.error(TAG, `task  err, err  = ${JSON.stringify(err)}`);
        this.waitList.push(downloadList[i]);
      }
    }
  }

  async downloadFile(folder: string, url: string, callback: (progress: number, isSuccess: boolean) => void) {
    logger.info(TAG, 'downloadFile');
    // 查询到存在正在执行的下载任务，提示并返回
    let tasks = await request.agent.search({
      state: request.agent.State.RUNNING,
      action: request.agent.Action.DOWNLOAD,
      mode: request.agent.Mode.FOREGROUND
    });
    if (tasks.length > 0) {
      promptAction.showToast({ message: $r('app.string.have_download_task_tips'), bottom: TOAST_BOTTOM });
      return;
    }
    let splitUrl = url.split('//')[1].split('/');
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    let downloadConfig: request.agent.Config = {
      action: request.agent.Action.DOWNLOAD,
      url: url,
      method: 'POST',
      title: 'download',
      mode: request.agent.Mode.FOREGROUND,
      network: request.agent.Network.ANY,
      saveas: `./${folder}/${splitUrl[splitUrl.length-1]}`,
      overwrite: true
    }
    logger.info(TAG, `downloadFile, downloadConfig = ${JSON.stringify(downloadConfig)}`);
    try {
      this.downloadTask = await request.agent.create(context, downloadConfig);
      this.downloadTask.on('progress', (progress: request.agent.Progress) => {
        logger.info(TAG, `progress,  progress = ${progress.processed} ${progress.state}`);
        let processed = Number(progress.processed.toString()).valueOf();
        let size = progress.sizes[0];
        let process: number = Math.floor(processed / size * 100);
        if (process < 100) {
          callback(process, false);
        }
      })
      this.downloadTask.on('completed', (progress: request.agent.Progress) => {
        logger.info(TAG, `download complete, file= ${url}, progress = ${progress.processed}`);
        callback(100, true);
        this.deleteTask();
      })
      this.downloadTask.on('failed', async (progress: request.agent.Progress) => {
        if (this.downloadTask) {
          let taskInfo = await request.agent.show(this.downloadTask.tid);
          logger.info(TAG, `fail,  resean = ${taskInfo.reason}, faults = ${JSON.stringify(taskInfo.faults)}`);
        }
        callback(100, false);
        this.deleteTask();
      })
      await this.downloadTask.start();
    } catch (err) {
      logger.error(TAG, `task  err, err  = ${JSON.stringify(err)}`);
      callback(100, false);
    }
  }

  async pauseOrResume() {
    let state = AppStorage.get<number>('backDownTaskState');
    if (state === BackgroundTaskState.RUNNING) {
      await this.pause();
      AppStorage.setOrCreate('backDownTaskState', BackgroundTaskState.PAUSE);
    } else if (state === BackgroundTaskState.PAUSE) {
      await this.resume();
      AppStorage.setOrCreate('backDownTaskState', BackgroundTaskState.RUNNING);
    } else {
      logger.info(TAG, 'this task state is error');
    }
  }

  async pause() {
    logger.info(TAG, 'pause');
    if (this.backgroundDownloadTaskList.length === 0) {
      return;
    }
    try {
      this.backgroundDownloadTaskList.forEach(async task => {
        await task.pause();
      })
    } catch (err) {
      logger.info(TAG, `pause fail,err= ${JSON.stringify(err)}`);
    }
  }

  async resume() {
    logger.info(TAG, 'resume');
    if (this.backgroundDownloadTaskList.length === 0) {
      return;
    }
    try {
      this.backgroundDownloadTaskList.forEach(async task => {
        await task.resume();
      })
    } catch (err) {
      logger.info(TAG, `resume fail,err= ${JSON.stringify(err)}`);
    }
  }

  async deleteTask() {
    if (this.downloadTask) {
      try {
        this.downloadTask.off('progress');
        this.downloadTask.off('completed');
        this.downloadTask.off('failed');
        await request.agent.remove(this.downloadTask.tid);
      } catch (err) {
        logger.info(TAG, `deleteTask fail, err= ${JSON.stringify(err)}`);
      }
    }

    this.downloadTask = undefined;
  }

  async deleteAllBackTasks() {
    if (this.backgroundDownloadTaskList.length > 0) {
      try {
        this.backgroundDownloadTaskList.forEach(async task => {
          await request.agent.remove(task.tid);
        })
        this.backgroundDownloadTaskList = [];
        AppStorage.setOrCreate('backDownTaskState', BackgroundTaskState.NONE);
      } catch (err) {
        logger.info(TAG, `deleteAllTask fail, err= ${JSON.stringify(err)}`);
      }
    }
  }
}

export const requestDownload = new RequestDownload();