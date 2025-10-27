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

import { logger } from '../utils/Logger';
import { BusinessError, request } from '@kit.BasicServicesKit';
import fileIo from '@ohos.file.fs';
import fs from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';

const TAG: string = 'RequestDownload';

class RequestDownload {
  // [Start request_download_file]
  async requestDownloadFile(url: string, fileName: string, callback: (progress: number, isSuccess: boolean) => void,
    context: common.UIAbilityContext) {
    // 获取应用文件路径
    // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
    let filesDir = context.cacheDir;
    let filePath = filesDir + '/' + fileName;
    this.clearExistFile(filePath);
    try {
      await request.downloadFile(context, {
        url: url,
        filePath: filePath,
      }).then((downloadTask: request.DownloadTask) => {
        downloadTask.on('complete', () => {
          // 获取文件状态信息，其中包含大小
          let fileStat = fileIo.statSync(filePath);
          let fileSize = fileStat.size;
          logger.info(TAG, `download complete, file= ${url}, size=${fileSize}, progress = 100%`);
          callback(100, true);
        })
      }).catch((err: BusinessError) => {
        logger.error(TAG, `downloadFile error, code=${err.code}, message=${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, `downloadFile catch error, code=${err.code}, message=${err.message}`);
    }
  }

  // [End request_download_file]

  // [Start download_agent_task]
  async requestAgentDownload(url: string, fileName: string, callback: (progress: number, isSuccess: boolean) => void,
    context: common.UIAbilityContext) {
    // 获取应用文件路径
    // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
    let filesDir = context.cacheDir;

    let config: request.agent.Config = {
      action: request.agent.Action.DOWNLOAD,
      url: url,
      saveas: fileName,
      gauge: true,
      overwrite: true,
      network: request.agent.Network.WIFI,
    };
    await request.agent.create(context, config).then((task: request.agent.Task) => {
      task.start((error: BusinessError) => {
        if (error) {
          logger.error(TAG, `start agent download task error, code=${error.code}, message=${error.message}`);
          return;
        }
      });
      task.on('progress', async (progress) => {
        logger.info(TAG, `Request download status ${progress.state}, downloaded ${progress.processed}`);
      })
      task.on('completed', async () => {
        logger.info(TAG, `Request download completed`);
        let filePath = filesDir + '/' + fileName;
        // 获取文件状态信息，其中包含大小
        let fileStat = fileIo.statSync(filePath);
        let fileSize = fileStat.size;
        logger.info(TAG, `download complete, file= ${url}, size=${fileSize}, progress = 100%`);
        callback(100, true);
        request.agent.remove(task.tid);
      })
    }).catch((err: BusinessError) => {
      logger.error(TAG, `download agent task catch error, code=${err.code}, message=${err.message}`);
    });
  }

  // [End download_agent_task]

  clearExistFile(path: string) {
    try {
      let exist = fs.accessSync(path);
      if (exist) {
        fs.unlinkSync(path);
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, `clearExistFile error, code=${err.code}, message=${err.message}`);
    }
  }
}

export const requestDownload = new RequestDownload();