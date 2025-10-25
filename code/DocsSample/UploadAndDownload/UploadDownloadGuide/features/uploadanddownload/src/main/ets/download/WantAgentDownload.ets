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

import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent';
import { request } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';
import { logger } from '../utils/Logger';

const TAG: string = 'WantAgentDownload';

class WantAgentDownload {
  // [Start want_agent_download]
  async wantAgentDownload(url: string, fileName: string, callback: (progress: number, isSuccess: boolean) => void,
    context: common.UIAbilityContext) {
    // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext

    // 创建wantAgentInfo对象，用于定义点击通知后要执行的操作
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          deviceId: '',
          bundleName: 'com.samples.uploaddownloadguide', // 替换为实际应用的包名
          abilityName: 'EntryAbility', // 替换为实际的ability名称
          action: '',
          entities: [],
          uri: '',
          parameters: {} // 可以传递自定义参数
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
    };

    // 获取WantAgent实例
    let wantAgentInstance: WantAgent;
    try {
      wantAgentInstance = await wantAgent.getWantAgent(wantAgentInfo);
    } catch (error) {
      logger.error(TAG, `Failed to get WantAgent, Code: ${error.code}  message: ${error.message}`);
      return;
    }

    let filesDir = context.cacheDir;
    // 创建下载任务配置，包含wantAgent参数
    let config: request.agent.Config = {
      action: request.agent.Action.DOWNLOAD,
      url: url, // 替换为实际的下载地址
      title: '下载任务通知标题',
      description: '下载任务通知描述',
      mode: request.agent.Mode.BACKGROUND,
      overwrite: true,
      method: 'GET',
      saveas: fileName,
      network: request.agent.Network.ANY,
      gauge: true,
      notification: {
        visibility: request.agent.VISIBILITY_COMPLETION | request.agent.VISIBILITY_PROGRESS,
        wantAgent: wantAgentInstance,
      }
    };

    // 创建并启动下载任务
    try {
      request.agent.create(context, config).then((task: request.agent.Task) => {
        task.start((err: BusinessError) => {
          if (err) {
            logger.error(TAG, `Failed to start the download task, Code: ${err.code}  message: ${err.message}`);
            return;
          }
        });
        task.on('progress', async (progress) => {
          logger.error(TAG, `Request download status ${progress.state}, downloaded ${progress.processed}`);
        })
        task.on('completed', async (progress) => {
          console.warn('Request download completed, ' + JSON.stringify(progress));
          logger.error(TAG, `Request download completed, ${JSON.stringify(progress)}`);
          // 获取文件状态信息，其中包含大小
          let filePath = filesDir + '/' + fileName;
          // 获取文件状态信息，其中包含大小
          let fileStat = fileIo.statSync(filePath);
          let fileSize = fileStat.size;
          logger.info(TAG, `download complete, file= ${url}, size=${fileSize}, progress = 100%`);
          callback(100, true);
          // 该方法需用户管理任务生命周期，任务结束后调用remove释放task对象
          request.agent.remove(task.tid);
        })
      }).catch((err: BusinessError) => {
        logger.error(TAG, `Failed to operate a download task, Code: ${err.code}, message: ${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, `Failed to operate a download task, Code: ${err.code}, message: ${err.message}`);
    }
  }

  // [End want_agent_download]
}

export const wantAgentDownload = new WantAgentDownload();