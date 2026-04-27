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
import { ServiceExtensionAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { display } from '@kit.ArkUI';
import Log from '../common/Log';
import { Constants } from 'screenshot_tv';
import { screenShotModel } from 'screenshot_tv';
import { BusinessError } from '@kit.BasicServicesKit';
import { sizeCalc } from '../common/SizeCalc';

const TAG = 'ScreenShot-ScreenShotServiceAbility';
const INDEX_PAGE = 'pages/Index';

/**
 * ServiceExtAbility 是 TV 应用的后台服务入口。
 * 它继承自 ServiceExtensionAbility，允许应用在没有前台界面的情况下响应系统事件。
 * 在本工程中，它负责在接收到截屏指令时，快速拉起一个悬浮窗并触发截屏流程。
 */
class ServiceExtAbility extends ServiceExtensionAbility {
  /**
   * 当服务首次创建时调用。
   * 业务背景：系统检测到截屏快捷键按下，触发此服务的启动。
   * 原理：在此方法中异步创建一个 TYPE_FLOAT 类型的悬浮窗。
   * 这种窗口类型具有高优先级，可以覆盖在其他应用之上，是实现系统级截屏 UI 的关键。
   */
  async onCreate(want: Want): Promise<void> {
    Log.showInfo(TAG, 'ServiceExtAbility onCreate, want:' + want.abilityName);

    AppStorage.setOrCreate('context', this.context);
    
    const windowConfig: window.Configuration = {
      name: Constants.WIN_NAME,
      windowType: window.WindowType.TYPE_FLOAT,
      ctx: this.context,
    };

    // 根据电视屏幕比例计算预览窗口的初始坐标和尺寸，确保视觉上的居中和美感。
    const rectX = sizeCalc(96);
    const rectY = sizeCalc(570);
    const rectW = sizeCalc(750);
    const rectH = sizeCalc(421);

    try {
      const win = await window.createWindow(windowConfig);
      Log.showInfo(TAG, 'create window finish');
      await win.moveWindowTo(rectX, rectY);
      Log.showInfo(TAG, 'window move finish');
      const dis = display.getDefaultDisplaySync();
      Log.showInfo(TAG, 'dis.width = ' + dis.width + ' dis.height = ' + dis.height);
      await win.resize(rectW, rectH);
      Log.showInfo(TAG, 'window reset size finish');
      await win.setWindowFocusable(false);
      await win.setUIContent(INDEX_PAGE);
      win.setWindowBackgroundColor('#00000000');
      screenShotModel.shotScreen();
      Log.showInfo(TAG, 'then begin window loadContent in then! ');
    } catch (error) {
      Log.showError(TAG, 'window createFailed, error.code = ' + (error as BusinessError).code);
    }
    Log.showInfo(TAG, 'after window create');
  }

  /**
   * 处理后续的启动请求。
   * 业务背景：服务已经在运行，用户再次按下截屏键。
   * 原理：通过 startId 判断是否为重复触发。若是，则通过 AppStorage 发送节流提示，
   * 避免频繁创建窗口导致系统资源浪费或 UI 闪烁。
   */
  onRequest(want: Want, startId: number): void {
    if (startId > 1) {
      AppStorage.setOrCreate('saveTipStr', '当前操作频繁，请稍后再试');
    }
  }

  /**
   * 服务销毁时的资源清理。
   * 业务背景：截屏流程结束，服务准备退出。
   * 原理：确保在服务退出前记录日志，协助排查非预期的服务中断问题。
   */
  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;
