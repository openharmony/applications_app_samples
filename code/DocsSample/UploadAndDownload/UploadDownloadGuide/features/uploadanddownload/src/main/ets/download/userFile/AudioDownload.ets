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

const TAG: string = 'AudioDownload';

class AudioDownload {
  // [Start audio_user_file_download]
  async audioFileAgentTask(url: string, fileName: string, callback: (progress: number, isSuccess: boolean) => void,
    context: common.UIAbilityContext) {
    // 创建文件管理器选项实例。
    const audioSaveOptions = new picker.AudioSaveOptions();
    // 保存文件名（可选）。 默认为空。
    audioSaveOptions.newFileNames = [fileName];

    let uri: string = '';
    // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
    const audioViewPicker = new picker.AudioViewPicker(context);
    await audioViewPicker.save(audioSaveOptions).then((audioSelectResult: Array<string>) => {
      uri = audioSelectResult[0];
      logger.info(TAG, `AudioViewPicker.save to file succeed and uri is ${uri}`);
    }).catch((err: BusinessError) => {
      logger.error(TAG, `Invoke audioViewPicker.save failed, code is ${err.code}, message is ${err.message}`);
    })
    if (uri != '') {
      let config: request.agent.Config = {
        action: request.agent.Action.DOWNLOAD,
        url: url,
        // saveas字段是AudioViewPicker保存的文件的uri
        saveas: uri,
        gauge: true,
        // overwrite字段必须为true
        overwrite: true,
        network: request.agent.Network.WIFI,
        // mode字段必须为request.agent.Mode.FOREGROUND
        mode: request.agent.Mode.FOREGROUND,
      };
      try {
        request.agent.create(context, config).then((task: request.agent.Task) => {
          task.start((err: BusinessError) => {
            if (err) {
              logger.error(TAG, `Failed to start the download task, Code: ${err.code}  message: ${err.message}`);
              return;
            }
          });
          task.on('progress', async (progress) => {
            logger.info(TAG, `Request download status ${progress.state}, downloaded ${progress.processed}`);
          })
          task.on('completed', async (progress) => {
            logger.info(TAG, `Request download completed, ${JSON.stringify(progress)}`);
            callback(100, true);
            // 该方法需用户管理任务生命周期，任务结束后调用remove释放task对象.
            request.agent.remove(task.tid);
          })
        }).catch((err: BusinessError) => {
          logger.error(TAG, `Failed to create a download task, code=${err.code}, message=${err.message}`);
        });
      } catch (error) {
        let err: BusinessError = error as BusinessError;
        logger.error(TAG, `Failed to create a audio download task, code=${err.code}, message=${err.message}`);
      }
    }
  }

  // [End audio_user_file_download]
}

export const audioDownload = new AudioDownload();