/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import oneConnectShare from '@ohos.oneConnect.fileShare';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import { FileBean } from '../../component/bean/FileBean';
import { common, appManager, Want } from '@kit.AbilityKit';
import { MLog } from '../utils/MLog';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'AbilityManager';

const SHARE_BUNDLE_NAME: string = 'com.ohos.oneconnect.share';
const SHARE_ABILITY_NAME: string = 'ServiceExtAbility';

/**
 * 分享服务冷启动时，窗口是异步创建的，需要等待初始化完成后再发第二次调用触发 showWindow。
 */
const SHARE_SERVICE_COLD_INIT_DELAY_MS: number = 800;

export class AbilityManager {

  /**
   * 检查分享服务进程是否已在运行（区分冷启动/热启动）。
   * 冷启动：第一次 startAbility 只负责启动服务并创建窗口，
   *         等初始化完成后必须发第二次 startAbility 才能触发 showWindow。
   * 热启动：服务已运行、窗口已就绪，一次 startAbility 即可直接显示弹窗。
   */
  private async isShareServiceRunning(): Promise<boolean> {
    MLog.info(TAG, `isShareServiceRunning: checking if [${SHARE_BUNDLE_NAME}] is already running`);
    try {
      const processes: Array<appManager.ProcessInformation> = await appManager.getRunningProcessInformation();
      const running: boolean = processes.some(p => p.bundleNames.includes(SHARE_BUNDLE_NAME));
      MLog.info(TAG, `isShareServiceRunning: result=${running}, total processes=${processes.length}`);
      return running;
    } catch (err) {
      MLog.warn(TAG, `isShareServiceRunning: query failed, assume not running. err=${JSON.stringify(err)}`);
      return false;
    }
  }

  /**
   * 进入图片/音频/视频页时提前预热分享服务，使后续用户点击分享时服务已是热启动状态，
   */
  public preloadShareService(context: common.UIAbilityContext): void {
    this.isShareServiceRunning().then(isRunning => {
      if (isRunning) {
        MLog.info(TAG, `preloadShareService: service already running, skip`);
        return;
      }
      MLog.info(TAG, `preloadShareService: service not running, starting warm-up...`);
      const preloadWant: oneConnectShare.ShareWant = {
        type: oneConnectShare.ShareType.SAVE_TO_MEDIA_ASSET,
        data: []
      };
      const preloadStartWant: Want = {
        bundleName: SHARE_BUNDLE_NAME,
        abilityName: SHARE_ABILITY_NAME,
        parameters: { shareWant: preloadWant }
      };
      context.startAbility(preloadStartWant).then(() => {
        MLog.info(TAG, `preloadShareService: warm-up startAbility success, service initializing (~800ms)`);
      }).catch((err: BusinessError) => {
        MLog.warn(TAG, `preloadShareService: warm-up failed (non-critical): ${JSON.stringify(err)}`);
      });
    });
  }

  /**
   * 启动分享弹窗。
   * @returns true=成功触发弹窗，false=失败
   */
  public async startShareAbility(file: FileBean, context: common.UIAbilityContext): Promise<boolean> {
    MLog.info(TAG, `startShareAbility begin: file=${file.name}, path=${file.getPath()}`);

    const utdType: string = this.getUtdType(file.name);
    MLog.info(TAG, `startShareAbility utdType=${utdType}`);

    const shareWant: oneConnectShare.ShareWant = {
      type: oneConnectShare.ShareType.SAVE_TO_MEDIA_ASSET,
      data: [{
        utd: utdType,
        title: file.name,
        uri: file.getPath()
      }]
    };

    const want: Want = {
      bundleName: SHARE_BUNDLE_NAME,
      abilityName: SHARE_ABILITY_NAME,
      parameters: { shareWant: shareWant }
    };

    const isWarm: boolean = await this.isShareServiceRunning();
    MLog.info(TAG, `startShareAbility: isWarm=${isWarm}`);

    if (isWarm) {
      MLog.info(TAG, `startShareAbility [WARM] calling startAbility directly`);
      try {
        await context.startAbility(want);
        MLog.info(TAG, `startShareAbility [WARM] success, dialog should appear`);
        return true;
      } catch (err) {
        MLog.error(TAG, `startShareAbility [WARM] failed: ${JSON.stringify(err)}`);
        return false;
      }
    }

    MLog.info(TAG, `startShareAbility [COLD] attempt 1: waking up service...`);
    try {
      await context.startAbility(want);
      MLog.info(TAG, `startShareAbility [COLD] attempt 1 success (service starting, window creating...)`);
    } catch (err) {
      MLog.error(TAG, `startShareAbility [COLD] attempt 1 failed: ${JSON.stringify(err)}`);
      return false;
    }

    MLog.info(TAG,
      `startShareAbility [COLD] waiting ${SHARE_SERVICE_COLD_INIT_DELAY_MS}ms for service window to initialize...`);
    await new Promise<void>(resolve => setTimeout(resolve, SHARE_SERVICE_COLD_INIT_DELAY_MS));

    MLog.info(TAG, `startShareAbility [COLD] attempt 2: triggering showWindow on warm service...`);
    try {
      await context.startAbility(want);
      MLog.info(TAG, `startShareAbility [COLD] attempt 2 success, dialog should appear`);
      return true;
    } catch (err) {
      MLog.error(TAG, `startShareAbility [COLD] attempt 2 failed: ${JSON.stringify(err)}`);
      return false;
    }
  }

  private getUtdType(fileName: string): string {
    return utd.getUniformDataTypeByFilenameExtension(fileName.substring(fileName.lastIndexOf('.')));
  }
}

let abilityManager: AbilityManager = new AbilityManager();

export default abilityManager;
