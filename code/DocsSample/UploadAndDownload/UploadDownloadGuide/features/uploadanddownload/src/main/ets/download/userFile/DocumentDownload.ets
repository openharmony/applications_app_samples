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
import { picker } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { logger } from '../../utils/Logger';

const TAG: string = 'DocumentDownload';

class DocumentDownload {
  // [Start doc_user_file_download]
  async docFileAgentTask(url: string, fileName: string, callback: (progress: number, isSuccess: boolean) => void,
    context: common.UIAbilityContext) {
    // 创建文件管理器选项实例。
    try {
      const documentSaveOptions = new picker.DocumentSaveOptions();
      // 保存文件名（可选）。 默认为空。
      documentSaveOptions.newFileNames = [fileName];
      // 保存文件类型['后缀类型描述|后缀类型']，选择所有文件：'所有文件(*.*)|.*'（可选），如果选择项存在多个后缀（最大限制100个过滤后缀），默认选择第一个。如果不传该参数，默认无过滤后缀。
      documentSaveOptions.fileSuffixChoices = ['文档|.txt', '.pdf'];
      let uri: string = '';
      // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
      const documentViewPicker = new picker.DocumentViewPicker(context);
      await documentViewPicker.save(documentSaveOptions).then((documentSaveResult: Array<string>) => {
        uri = documentSaveResult[0];
        logger.info(TAG, `DocumentViewPicker.save to file succeed and uri is ${uri}`);
      }).catch((err: BusinessError) => {
        logger.error(TAG, `documentViewPicker.save error, code=${err.code}, message=${err.message}`);
      })
      if (uri != '') {
        let config: request.agent.Config = {
          action: request.agent.Action.DOWNLOAD,
          url: url,
          // saveas字段是DocumentViewPicker保存的文件的uri
          saveas: uri,
          gauge: true,
          // overwrite字段必须为true
          overwrite: true,
          network: request.agent.Network.WIFI,
          // mode字段必须为request.agent.Mode.FOREGROUND
          mode: request.agent.Mode.FOREGROUND,
        };
        try {
          await request.agent.create(context, config).then((task: request.agent.Task) => {
            task.start((err: BusinessError) => {
              if (err) {
                logger.error(TAG, `start download task error, code=${err.code}, message=${err.message}`);
                return;
              }
            });
            task.on('progress', async (progress) => {
              logger.info(TAG, `download status ${progress.state}, downloaded ${progress.processed}`);
            })
            task.on('completed', async (progress) => {
              logger.info(TAG, `download completed ${JSON.stringify(progress)}`);
              callback(100, true);
              // 该方法需用户管理任务生命周期，任务结束后调用remove释放task对象
              request.agent.remove(task.tid);
            })
          }).catch((err: BusinessError) => {
            logger.error(TAG, `Failed to operate a download task, Code: ${err.code}, message: ${err.message}`);
          });
        } catch (error) {
          let err: BusinessError = error as BusinessError;
          logger.error(TAG, `Failed to create a download task, code=${err.code}, message=${err.message}`);
        }
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, `Failed to create a documentSaveOptions, code=${err.code}, message=${err.message}`);
      return;
    }
  }

  // [End doc_user_file_download]
}

export const documentDownload = new DocumentDownload();