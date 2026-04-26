/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { EventConstants, Logger } from '@ohos/common';
import { emitter } from '@kit.BasicServicesKit';

export default class WindowsUtil {
  private static instance: WindowsUtil = new WindowsUtil();

  private constructor() {
  }

  public static getInstance(): WindowsUtil {
    return WindowsUtil.instance;
  }

  public windowClass: window.Window | undefined = undefined;
  public windowHeight?: number;
  public windowWidth?: number;

  // 窗口尺寸变化时通过 emitter 高优先级事件广播，而非直接回调，
  // 是为了解耦窗口监听者与业务组件，使导航按钮布局、位置计算等多个模块
  // 能各自独立响应尺寸变化，无需互相持有引用。
  private sendWindowsChangeEvent() {
    let innerEvent: emitter.InnerEvent = {
      eventId: EventConstants.ON_WINDOWS_SIZE_CHANGE_EVENT,
      priority: emitter.EventPriority.HIGH
    };
    emitter.emit(innerEvent, {
      data: {
        width: this.windowWidth,
        height: this.windowHeight,
      }
    });
  }

  // 初始化时先取一次当前窗口尺寸并立即广播，确保页面首次渲染时就能获得正确的布局参数，
  // 避免等到第一次 windowSizeChange 事件才触发布局导致界面初始状态错乱。
  public initWindows(context: common.UIAbilityContext) {
    try {
      window.getLastWindow(context, (err: Error, data) => {
        this.windowClass = data;
        Logger.info('Succeeded in obtaining the top window. Data: ' + JSON.stringify(data));
        this.addListener();
      });
    } catch (exception) {
      Logger.error('Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
    }
  }

  private addListener() {
    if (this.windowClass) {
      let properties = this.windowClass.getWindowProperties();
      this.windowHeight = properties.windowRect.height;
      this.windowWidth = properties.windowRect.width;
      this.sendWindowsChangeEvent();

      try {
        this.windowClass.on('windowSizeChange', (data) => {
          Logger.info('Succeeded in enabling the listener for window size changes. Data: ' + JSON.stringify(data));
          this.windowWidth = data.width;
          this.windowHeight = data.height;
          this.sendWindowsChangeEvent();
        });
      } catch (exception) {
        Logger.error('Failed to enable the listener for window size changes. Cause: ' + JSON.stringify(exception));
      }
    }
  }
}

