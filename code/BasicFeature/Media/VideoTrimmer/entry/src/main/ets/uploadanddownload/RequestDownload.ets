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

import { BusinessError, request } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import CommonConstants from '../constants/Constants';
import { logger } from '../utils/Logger';
import TaskConstants from '../constants/DoanloadConstants';

/**
 * 下载文件。
 */

const TAG: string = 'videoTrimmer_RequestDownload';
const TOAST_BOTTOM: number = 135;
let isNetPause = false;

class RequestDownload {
  private context: common.UIAbilityContext | undefined = undefined;
  private downloadTask: request.agent.Task | undefined = undefined; // 下载任务
  public progressCallback: Function | undefined = undefined; // 进度回调
  public completedCallback: Function | undefined = undefined; // 完成回调
  public failedCallback: Function | undefined = undefined; // 失败回调

  /**
   * 下载文件
   */
  async downloadFile(folder: string, url: string,
    callback: (progress: number, isSuccess: boolean, localPath: string) => void) {
    logger.info(TAG, 'downloadFile,url:' + url);
    // Found an ongoing download task, prompted and returned.
    let tasks = await request.agent.search({
      state: request.agent.State.RUNNING,
      action: request.agent.Action.DOWNLOAD,
      mode: request.agent.Mode.FOREGROUND
    });
    if (tasks.length > 0) {
      promptAction.showToast({ message: $r('app.string.video_trimmer_have_download_task_tips'), bottom: TOAST_BOTTOM });
      return;
    }
    let splitUrl = url.split('//')[1].split('/');
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    // 下载保存的本地路径
    let localPath = `${folder}/${splitUrl[splitUrl.length-1]}`;
    logger.info(TAG, 'downloadFile, localPath:' + localPath);
    let downloadConfig: request.agent.Config = {
      action: request.agent.Action.DOWNLOAD,
      url: url,
      method: 'GET',
      title: 'download',
      mode: request.agent.Mode.BACKGROUND,
      retry: true,
      network: request.agent.Network.ANY,
      saveas: `./${localPath}`,
      overwrite: true
    }
    logger.info(TAG, `downloadFile, downloadConfig = ${JSON.stringify(downloadConfig)}`);
    try {
      this.downloadTask = await request.agent.create(context, downloadConfig);
      // 监听下载进度
      this.downloadTask.on('progress', this.progressCallback = (progress: request.agent.Progress) => {
        logger.info(TAG, `progress = ${progress.processed} ,state =  ${progress.state}`);
        let processed = Number(progress.processed.toString()).valueOf();
        let size = progress.sizes[0];
        let process: number = Math.floor(processed / size * CommonConstants.PROGRESS_MAX);
        if (process < CommonConstants.PROGRESS_MAX) {
          callback(process, false, '');
        }
      })
      // 监听下载完成
      this.downloadTask.on('completed', this.completedCallback = (progress: request.agent.Progress) => {
        logger.info(TAG, `download complete, file= ${url}, progress = ${progress.processed}, localPath=${localPath}`);
        callback(CommonConstants.PROGRESS_MAX, true, localPath);
        this.deleteTask();
      })
      // 监听暂停事件
      this.downloadTask.on('pause', this.failedCallback = async (progress: request.agent.Progress) => {
        if (this.downloadTask) {
          let taskInfo = await request.agent.show(this.downloadTask.tid);
          logger.info(TAG,
            `pause,  resean = ${taskInfo.reason}, progress = ${progress.processed}, faults = ${JSON.stringify(taskInfo.faults)}`);
          isNetPause = taskInfo.faults === 0;
          if (isNetPause) {
            callback(TaskConstants.TASK_NET_PAUSE_MSG, isNetPause, '');
          } else {
            callback(TaskConstants.TASK_PAUSE_MSG, isNetPause, '');
          }
        }
      })
      // 监听恢复下载事件
      this.downloadTask.on('resume', this.failedCallback = async (progress: request.agent.Progress) => {
        if (this.downloadTask) {
          let taskInfo = await request.agent.show(this.downloadTask.tid);
          logger.info(TAG,
            `resume,  resean = ${taskInfo.reason}, progress = ${progress.processed}, faults = ${JSON.stringify(taskInfo.faults)}`);
          if (isNetPause) {
            isNetPause = false;
            callback(TaskConstants.TASK_NET_RESUME_MSG, isNetPause, '');
          } else {
            callback(TaskConstants.TASK_RESUME_MSG, isNetPause, '');
          }
        }
      })
      // 监听下载失败事件
      this.downloadTask.on('failed', this.failedCallback = async (progress: request.agent.Progress) => {
        if (this.downloadTask) {
          let taskInfo = await request.agent.show(this.downloadTask.tid);
          logger.info(TAG,
            `fail,  resean = ${taskInfo.reason}, progress = ${progress.processed}, faults = ${JSON.stringify(taskInfo.faults)}`);
        }
        callback(CommonConstants.PROGRESS_MAX, false, '');
        this.deleteTask();
      })
      await this.downloadTask.start();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      logger.error(TAG, `task  err, Code is ${err.code}, message is ${err.message}`);
      callback(CommonConstants.PROGRESS_MAX, false, '');
    }
  }

  // 取消任务
  async deleteTask() {
    if (this.downloadTask) {
      try {
        this.downloadTask.off('progress');
        this.progressCallback = undefined;
        this.downloadTask.off('completed');
        this.completedCallback = undefined
        this.downloadTask.off('failed');
        this.failedCallback = undefined
        await request.agent.remove(this.downloadTask.tid);
      } catch (err) {
        logger.info(TAG, `deleteTask fail, err= ${JSON.stringify(err)}`);
      }
    }
    this.downloadTask = undefined;
  }
}

export const requestDownload = new RequestDownload();