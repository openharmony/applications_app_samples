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
  public windowWidth?: number

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

