/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import vibrator from '@ohos.vibrator'
import Window from '@ohos.window'
import Logger from './Logger'
import resourceManager from '@ohos.resourceManager'
import { BusinessError } from '@ohos.base'
import { StartCustom }  from 'library';

const TAG = '[Util]'

export function getDynamicStates(dis: boolean[], id: number): boolean[] {
  for (let i = 0; i < dis.length; i++) {
    i === id ? dis[i] = true : dis[i] = false
    Logger.info(TAG, dis[i].toString())
  }
  return dis
}

export async function playVibrateCustom(fileName: string, mode: string) {
  let rawFd: resourceManager.RawFileDescriptor | undefined = undefined
  await getContext().resourceManager.getRawFd(fileName).then(value => {
    rawFd = value
    Logger.info(TAG, "rawFd of vibration:" + " fd:" + rawFd.fd + ", offset:" + rawFd.offset + ", length: " + rawFd.length)
  })
  if (mode === "ets") {
    try {
      vibrator.startVibration({
        type: "file",
        hapticFd: { fd: rawFd!.fd, offset: rawFd!.offset, length: rawFd!.length }
      }, {
        usage: "unknown"
      }, (error: BusinessError) => {
        if (error) {
          Logger.info(TAG, 'startVibration failed, type is file, in callback');
        } else {
          Logger.info(TAG, 'startVibration successful, type is file, in callback');
        }
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.info(TAG, 'startVibration failed, type is file, in catch, err code:' + err.code + ' err msg:' + err.message)
    }
  } else if (mode === "capi"){
      let ret: number
      ret = StartCustom(rawFd!.fd, rawFd!.offset, rawFd!.length)
      console.info('StartCustom ret', ret);
  }
}

export function changeOrientationInternal(lastWindow: Window.Window, portrait: boolean): void {
  if (portrait) {
    lastWindow.setPreferredOrientation(Window.Orientation.LANDSCAPE).then(() => {
      Logger.info(TAG, "setPreferredOrientation success")
    }).catch((error: BusinessError) => {
      Logger.info(TAG, "setPreferredOrientation failure" + JSON.stringify(error))
    })
  } else {
    lastWindow.setPreferredOrientation(Window.Orientation.PORTRAIT).then(() => {
      Logger.info(TAG, "setPreferredOrientation success")
    }).catch((error: BusinessError) => {
      Logger.info(TAG, "setPreferredOrientation failure: " + JSON.stringify(error))
    })
  }
}

export function changeOrientation(portrait: boolean): void {
  Window.getLastWindow(getContext()).then((lastWindow: Window.Window) => {
    changeOrientationInternal(lastWindow, portrait)
  }).catch((error: BusinessError) => {
    Logger.info(TAG, "getLastWindow error: " + JSON.stringify(error))
  })
}

export function hideTitleBar(): void {
  Window.getLastWindow(getContext()).then((lastWindow: Window.Window) => {
    if (lastWindow) {
      lastWindow.setWindowSystemBarEnable([], (err: BusinessError) => {
        if (err) {
          Logger.info(TAG, "hideTitleBar failed")
        } else {
          Logger.info(TAG, "hideTitleBar successful")
        }
      })
    }
  }).catch((error: BusinessError) => {
    Logger.info(TAG, "getLastWindow error: " + JSON.stringify(error))
  })
}

export function showTitleBar(): void {
  Window.getLastWindow(getContext()).then((lastWindow: Window.Window) => {
    if (lastWindow) {
      lastWindow.setWindowSystemBarEnable(['status', 'navigation'], (err: BusinessError) => {
        if (err) {
          Logger.info(TAG, "showTitleBar failed")
        } else {
          Logger.info(TAG, "showTitleBar successful")
        }
      })
    }
  }).catch((error: BusinessError) => {
    Logger.info(TAG, "getLastWindow error: " + JSON.stringify(error))
  })
}
