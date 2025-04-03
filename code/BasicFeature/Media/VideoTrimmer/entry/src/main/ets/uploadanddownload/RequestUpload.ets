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

import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { request } from '@kit.BasicServicesKit';
import CommonConstants from '../constants/Constants'
import { logger } from '../utils/Logger';
import { urlUtils } from '../utils/UrlUtils';

const TOAST_BOTTOM: number = 135;
const UPLOAD_TOKEN: string = 'upload_token';
const TAG: string = 'videoTrimmer_RequestUpload';
const HEADER: Record<string, string> = { 'Content-Type': 'multipart/form-data' };

class RequestUpload {
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
  private uploadTask: request.agent.Task | undefined = undefined; // 上传任务
  public progressCallback: Function | undefined = undefined; // 进度回调
  public completedCallback: Function | undefined = undefined; // 完成回调
  public failedCallback: Function | undefined = undefined; // 失败回调

  /**
   * 上传文件
   */
  async uploadFiles(fileUris: Array<string>, callback: (progress: number, isSucceed: boolean) => void): Promise<void> {
    logger.info(TAG, `uploadFiles begin, ${JSON.stringify(fileUris)}`);
    if (fileUris.length === 0) {
      return;
    }
    // Found an ongoing upload task, prompted and returned.
    let tasks = await request.agent.search({
      state: request.agent.State.RUNNING,
      action: request.agent.Action.UPLOAD,
      mode: request.agent.Mode.FOREGROUND
    });
    if (tasks.length > 0) {
      promptAction.showToast({ message: $r('app.string.video_trimmer_have_upload_task_tips'), bottom: TOAST_BOTTOM });
      return;
    }
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    // 获取本地上传文件
    this.config.data = await this.getFilesAndData(context.cacheDir, fileUris);
    // TODO : 知识点 将视频上传到服务器地址
    // 获取服务器地址
    this.config.url = await urlUtils.getUrl(context);
    // 前台模式
    this.config.mode = request.agent.Mode.FOREGROUND;
    try {
      // 创建上传任务
      this.uploadTask = await request.agent.create(context, this.config);
      logger.info(TAG, `create uploadTask success, TaskID= ${this.uploadTask.tid}`);
      // 监听上传进度
      this.uploadTask.on('progress', this.progressCallback = (progress: request.agent.Progress) => {
        logger.info(TAG, `progress,  progress = ${progress.processed} ${progress.state}`);
        let processed = Number(progress.processed.toString()).valueOf();
        let size = progress.sizes[0];
        let process: number = Math.floor(processed / size * CommonConstants.PROGRESS_MAX);
        if (process < CommonConstants.PROGRESS_MAX) {
          // 进度通知
          callback(process, false);
        }
      });
      // 下载完成事件
      this.uploadTask.on('completed', this.completedCallback = (progress: request.agent.Progress) => {
        logger.info(TAG, `complete,  progress = ${progress.processed}, state= ${progress.state}`);
        // 通知下载完成
        callback(CommonConstants.PROGRESS_MAX, true);
        // 删除任务
        this.deleteTask();
      });
      this.uploadTask.on('failed', this.failedCallback = async (progress: request.agent.Progress) => {
        if (this.uploadTask) {
          let taskInfo = await request.agent.touch(this.uploadTask.tid, UPLOAD_TOKEN);
          logger.error(TAG, `fail,  resean = ${taskInfo.reason}, faults = ${JSON.stringify(taskInfo.faults)}`);
        }
        this.deleteTask();
        callback(CommonConstants.PROGRESS_MAX, false);
      });
      await this.uploadTask.start();
    } catch (err) {
      logger.error(TAG, `task  err, err  = ${JSON.stringify(err)}`);
      callback(CommonConstants.PROGRESS_MAX, false);
    }
  }

  // 取消任务
  async deleteTask() {
    if (this.uploadTask === undefined) {
      return;
    }
    try {
      this.uploadTask.off('progress');
      this.progressCallback = undefined;
      this.uploadTask.off('failed');
      this.failedCallback = undefined
      this.uploadTask.off('completed');
      this.completedCallback = undefined
      await request.agent.remove(this.uploadTask.tid);
    } catch (err) {
      logger.error(TAG, `deleteTask fail,err= ${JSON.stringify(err)}, TaskID= ${this.uploadTask.tid}`);
    }
    this.uploadTask = undefined;
  }

  // 获取上传文件数据
  private async getFilesAndData(cacheDir: string, fileUris: Array<string>): Promise<Array<request.agent.FormItem>> {
    logger.info(TAG, `getFilesAndData begin`);
    let files: request.agent.FormItem[] = [];
    for (let i = 0; i < fileUris.length; i++) {
      logger.info(TAG, `getFilesAndData fileUri = ${fileUris[i]}`);
      let photoPath = fileUris[i];
      logger.info(TAG, `getFilesAndData photoPath = ${JSON.stringify(photoPath)}`);
      let file: request.agent.FormItem = {
        name: photoPath.split('cache/')[1],
        value: {
          path: './' + photoPath.split('cache/')[1]
        }
      }
      files.push(file);
    }
    logger.info(TAG, `getFilesAndData finish ${JSON.stringify(files)}`);
    return files;
  }
}

export const requestUpload = new RequestUpload();