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

import fs from '@ohos.file.fs';
import request from '@ohos.request';

import { logger } from '../utils/Logger';

let TAG: string = 'RequestDataUtil';

export default class RequestDataUtil {
  private downloadTask: request.DownloadTask;
  private filePath: string = '';
  private loadCount: number = 0;
  private reloadCount: number = 3;
  private waitTime: number = 30000;
  private delayTime: number = 500;

  constructor(private context: Context) {
    this.context = context;
    this.filePath = `${this.context.tempDir}/video_4.mp4`;
  }

  // 删除旧的视频资源
  private async checkVideoAvailable(): Promise<void> {
    try {
      await fs.unlink(this.filePath);
    } catch (err) {
      logger.error('Delete old file error: ' + JSON.stringify(err));
    }
  }

  public async requestGoodsInfo(): Promise<void> {
    await this.checkVideoAvailable();
    // 多次尝试加载视频失败拦截
    if (this.loadCount > this.reloadCount) {
      logger.error(`Has try to load video 3 times.`);
      return;
    }
    logger.info(TAG, 'localPath: ' + this.filePath);

    let downloadFileConfig = {
      // 现在库上视频播放的资源
      url: 'https://gitee.com/openharmony/app_samples/raw/master/media/VideoShow/VideoComponent/src/main/resources/rawfile/video_4.mp4',
      header: {
        headers: 'https'
      },
      enableMetered: true,
      enableRoaming: true,
      description: 'request goods data!',
      networkType: request.NETWORK_WIFI,
      filePath: this.filePath,
      title: 'request goods data!',
      background: false
    };

    try {
      this.downloadTask = await request.downloadFile(this.context, downloadFileConfig);
      this.downloadTask.on('complete', () => {
        logger.info(TAG, 'Download task completed.');
        setTimeout(() => {
          AppStorage.SetOrCreate('video_path', this.filePath);
          AppStorage.SetOrCreate('video_complete', true);
        }, this.delayTime);
      });
    } catch (err) {
      logger.error(TAG, `downloadFile Error ! ${JSON.stringify(err)} loadCount:  ${this.loadCount}`);
      this.loadCount++;
      // 下载失败，尝试重新下载
      this.requestGoodsInfo();
      return;
    }

    setTimeout(() => {
      AppStorage.SetOrCreate('video_path', this.filePath);
      AppStorage.SetOrCreate('video_complete', true);
    }, this.waitTime);
  }
}


