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

import { UIAbility, Want, AbilityConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import logger from '../utils/Logger';
import { window } from '@kit.ArkUI';
import preferencesUtils from '../utils/Preferences';
// 暂时注释掉AppStorage导入，使用全局变量替代
// import { AppStorageV2 as AppStorage } from '@kit.ArkUI';

// 全局变量替代AppStorage
let remoteServiceExtensionConnectEvent: boolean = false;
let musicPlay: boolean = false;
let musicPause: boolean = false;
let changePlayFlag: string = '';
interface SongInfo {
  url: string | undefined;
  name: string | undefined;
  author: string;
  time: number;
}
let sendSongInfo: SongInfo | null = null;
let status: Record<string, string | number | boolean | object> | null = null;
let exitMusicApp: boolean = false;

const TAG: string = 'MainAbility';

// 全局变量替代globalThis
interface TransferManager {
  release: () => void;
}
let transferManager: TransferManager | null = null;

export default class MainAbility extends UIAbility {
  // 应用启动时初始化，处理启动参数
  // 重置全局状态，确保应用每次启动都处于初始状态
  onCreate(want : Want) {
    logger.info(TAG, '[Demo] MainAbility onCreate');
    // 保存启动参数，用于后续恢复播放状态
    status = want.parameters as Record<string, string | number | boolean | object> || null;
    // 处理启动参数中的音乐信息
    this.changeWant(want);
    // 重置全局状态变量
    exitMusicApp = false;
    remoteServiceExtensionConnectEvent = false;
    musicPlay = false;
    musicPause = false;
    changePlayFlag = '';

  }

  // 处理启动参数中的音乐信息
  // 当应用通过音乐文件启动时，提取音乐信息并存储
  changeWant(want:Want){
    console.log('changeWant:',JSON.stringify(want));
    if (want.action == 'ohos.want.action.viewData' && want.parameters) {
      // 存储音乐信息数据，用于后续播放
      sendSongInfo = {
        url:String(want.parameters.uri) || undefined,
        name: String(want.parameters.name) || undefined,
        author: '佚名',
        time:0
      }
      console.log('changeWant:',JSON.stringify(sendSongInfo));
    }
  }
  // 应用销毁时清理资源
  // 释放全局变量和管理器实例，避免内存泄漏
  onDestroy() {
    logger.info(TAG, '[Demo] MainAbility onDestroy');
    // 清空音乐信息
    sendSongInfo = null;
    // 切换退出标志
    if (exitMusicApp !== undefined) {
      exitMusicApp = !exitMusicApp;
    }
    // 释放分布式管理器资源
    if (transferManager) {
      transferManager.release();
    }
  }

  // 窗口创建时初始化
  // 设置全屏模式，提升用户体验
  onWindowStageCreate(windowStage: window.WindowStage) {
    logger.info(TAG, '[Demo] MainAbility onWindowStageCreate');
    // 初始化偏好设置
    preferencesUtils.init(this.context);
    try {
      // 获取顶层窗口
      let promise = window.getLastWindow(this.context);
      promise.then((data: window.Window) => {
        // 设置窗口为全屏模式
        let isFullScreen = true;
        try {
          data.setFullScreen(isFullScreen, (err) => {
            if (err) {
              logger.error('Failed to set the window to full-screen mode. Cause:' + JSON.stringify(err));
              return;
            }
            logger.info('Succeeded in setting the window to full-screen mode.');
          });
        } catch (exception) {
          logger.error('Failed to set the window to full-screen mode. Cause:' + JSON.stringify(exception));
        }
        logger.info('Succeeded in obtaining the top window. Data: ' + JSON.stringify(data));
      }).catch((err: BusinessError) => {
        logger.error('Failed to obtain the top window. Cause: ' + JSON.stringify(err));
      });
    } catch (exception) {
      logger.error('Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
    }
    // 加载首页内容，避免应用停留在启动页
    windowStage.loadContent('pages/Index', (err) => {
      if (err) {
        logger.error(TAG, `Failed to load page content. Cause: ${JSON.stringify(err)}`);
      } else {
        logger.info(TAG, 'Succeeded in loading page content.');
      }
    });
  }

  // 窗口销毁时的清理工作
  // 记录窗口销毁事件，便于调试和问题定位
  onWindowStageDestroy() {
    logger.info(TAG, '[Demo] MainAbility onWindowStageDestroy')
  }

  // 应用切换到前台时的处理
  // 记录前台切换事件，便于调试和问题定位
  onForeground() {
    logger.info(TAG, '[Demo] MainAbility onForeground')
  }

  // 应用切换到后台时的处理
  // 记录后台切换事件，便于调试和问题定位
  onBackground() {
    logger.info(TAG, '[Demo] MainAbility onBackground')
  }

  // 处理返回键事件
  // 切换退出标志，控制应用是否退出
  onBackPressed() {
    logger.info(TAG, '[Demo] MainAbility onBackPressed');
    // 切换退出标志，用于控制应用的退出行为
    if (exitMusicApp !== undefined) {
      exitMusicApp = !exitMusicApp;
    }
    return false;
  }
  // 处理新的启动参数
  // 当应用已启动时，通过新的Want参数更新音乐信息
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.changeWant(want)
  }

};
