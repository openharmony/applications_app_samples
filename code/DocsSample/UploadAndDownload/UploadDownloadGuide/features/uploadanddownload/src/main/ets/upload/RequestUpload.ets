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
import { common, UIAbility, Want } from '@kit.AbilityKit';
import { urlUtils } from '../utils/UrlUtils';
import fs from '@ohos.file.fs';
import { logger } from '../utils/Logger';

const TAG: string = 'RequestUpload';

class Upload {
  // [Start request_upload_file]
  async requestUploadFile(fileName: string, callback: (progress: number, isSuccess: boolean) => void,
    context: common.UIAbilityContext) {
    // 获取应用文件路径
    // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
    let url = await urlUtils.getUrl(context);
    let cacheDir = context.cacheDir;

    // 新建一个本地应用文件
    try {
      let file = fs.openSync(cacheDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.writeSync(file.fd, 'upload file test');
      fs.closeSync(file);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, `Invoke uploadFile failed, code=${err.code}, message=${err.message}`);
    }

    // 上传任务配置项
    let files: request.File[] = [
    //uri前缀internal://cache 对应cacheDir目录
      {
        filename: fileName,
        name: 'test',
        uri: 'internal://cache/' + fileName,
        type: 'txt'
      }
    ]
    let data: request.RequestData[] = [{ name: 'name', value: 'value' }];
    let uploadConfig: request.UploadConfig = {
      url: url,
      header: {
        'key1': 'value1',
        'key2': 'value2'
      },
      method: 'POST',
      files: files,
      data: data
    }

    // 将本地应用文件上传至网络服务器
    try {
      request.uploadFile(context, uploadConfig)
        .then((uploadTask: request.UploadTask) => {
          uploadTask.on('complete', (taskStates: Array<request.TaskState>) => {
            for (let i = 0; i < taskStates.length; i++) {
              logger.info(TAG, `upload complete taskState: ${JSON.stringify(taskStates[i])}`);
            }
            callback(100, true);
          });
        })
        .catch((err: BusinessError) => {
          logger.error(TAG, `Invoke uploadFile failed, code=${err.code}, message=${err.message}`);
        })
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, `Invoke uploadFile failed, code=${err.code}, message=${err.message}`);
    }
  }

  // [End request_upload_file]

  // [Start upload_agent_task]
  async requestAgentUpload(fileName: string, callback: (progress: number, isSucceed: boolean) => void,
    context: common.UIAbilityContext) {
    // 获取应用文件路径
    // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
    let url = await urlUtils.getUrl(context);
    let cacheDir = context.cacheDir;

    let attachments: request.agent.FormItem[] = [{
      name: 'test',
      value: [
        {
          filename: fileName,
          path: cacheDir + '/' + fileName,
        },
      ]
    }];
    let config: request.agent.Config = {
      action: request.agent.Action.UPLOAD,
      url: url,
      mode: request.agent.Mode.FOREGROUND,
      overwrite: true,
      method: 'POST',
      headers: {
        'key1': 'value1',
        'key2': 'value2'
      },
      data: attachments
    };
    request.agent.create(context, config).then((task: request.agent.Task) => {
      task.start((err: BusinessError) => {
        if (err) {
          logger.error(TAG, `Failed to start the upload task, code=${err.code}, message=${err.message}`);
          return;
        }
      });
      task.on('progress', async (progress) => {
        logger.info(TAG, `Request upload status ${progress.state}, uploaded ${progress.processed}`);
      })
      task.on('completed', async () => {
        logger.info(TAG, `Request upload completed`);
        callback(100, true);
        //该方法需用户管理任务生命周期，任务结束后调用remove释放task对象
        request.agent.remove(task.tid);
      })
    }).catch((err: BusinessError) => {
      logger.error(TAG, `Failed to start the upload task, code=${err.code}, message=${err.message}`);
    });
  }

  // [End upload_agent_task]
}

export const requestUpload = new Upload();