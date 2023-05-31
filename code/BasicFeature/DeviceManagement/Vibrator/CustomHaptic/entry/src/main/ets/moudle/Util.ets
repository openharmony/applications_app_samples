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
import media from '@ohos.multimedia.media'
import Window from '@ohos.window'
import Logger from '../moudle/Logger'

const TAG = '[Util]'

export function getDynamicStates(dis: boolean[], id: number): boolean[] {
  for (let i = 0; i < dis.length; i++) {
      i == id ? dis[i] = true : dis[i] = false
    Logger.info(TAG, dis[i].toString())
  }
  return dis
}

export async function playVibrateCustom(fileName: string) {
  let rawFd = undefined
  await getContext().resourceManager.getRawFd(fileName).then(value => {
    rawFd = value
    Logger.info(TAG, "rawFd of vibration:" + " fd:" + rawFd.fd + ", offset:" + rawFd.offset + ", length: " + rawFd.length)
  })
  try {
    vibrator.startVibration({
      type: "file",
      hapticFd: { fd: rawFd.fd, offset: rawFd.offset, length: rawFd.length }
    }, {
      usage: "unknown"
    }, (error) => {
      if (error) {
        Logger.info(TAG, 'startVibration failed, type is file, in callback');
      } else {
        Logger.info(TAG, 'startVibration successful, type is file, in callback');
      }
    });
  } catch (error) {
    Logger.info(TAG, 'startVibration failed, type is file, in catch, err code:' + error.code + ' err msg:' + error.message)
  }
}

export function setAVPlayerCallback(avPlayer) {
  avPlayer.reset()
  avPlayer.on('stateChange', async (state) => {
    switch (state) {
      case 'idle':
        Logger.info(TAG, 'state idle called')
        break;
      case 'initialized':
        Logger.info(TAG, 'state initialized called ')
        avPlayer.prepare().then(() => {
          Logger.info(TAG, 'prepare success');
        }, (err) => {
          Logger.info(TAG, 'prepare filed,error message is :' + err.message)
        })
        break;
      case 'prepared':
        Logger.info(TAG, 'state prepared called')
        avPlayer.play()
        break;
      case 'playing':
        Logger.info(TAG, 'state playing called')
        break;
      case 'completed':
        Logger.info(TAG, 'state completed called')
        avPlayer.stop()
        avPlayer.reset()
        break;
      case 'stopped':
        Logger.info(TAG, 'state stopped called')
        avPlayer.release()
        break;
      case 'error':
        Logger.info(TAG, 'state error called')
        break;
      default:
        Logger.info(TAG, 'unkown state :' + state)
        break;
    }
  })
}

export async function avPlayer(audioName: string) {
  let avPlayer = await media.createAVPlayer()
  setAVPlayerCallback(avPlayer)
  let rawFd = undefined
  await globalThis.getContext()
    .resourceManager
    .getRawFd(audioName)
    .then(value => {
      rawFd = value
      Logger.info(TAG, 'get audio resource successful');
      Logger.info(TAG, "rawFd of audio:" + " fd:" + rawFd.fd + ", offset:" + rawFd.offset + ", length: " + rawFd.length)
    })
    .catch((error) => {
      Logger.info(TAG, 'get audio resource failed, err code:' + error.code + ' err msg:' + error.message)
    })
  avPlayer.fdSrc = rawFd
}

export function changeOrientationInternal(lastWindow: Window.Window, portrait: boolean) {
  if (portrait) {
    lastWindow.setPreferredOrientation(Window.Orientation.LANDSCAPE).then(() => {
      Logger.info(TAG, "setPreferredOrientation success")
    }).catch((error) => {
      Logger.info(TAG, "setPreferredOrientation failure" + JSON.stringify(error))
    })
  } else {
    lastWindow.setPreferredOrientation(Window.Orientation.PORTRAIT).then(() => {
      Logger.info(TAG, "setPreferredOrientation success")
    }).catch((error) => {
      Logger.info(TAG, "setPreferredOrientation failure: " + JSON.stringify(error))
    })
  }
}

export function changeOrientation(portrait: boolean) {
  Window.getLastWindow(getContext()).then((lastWindow) => {
    changeOrientationInternal(lastWindow, portrait)
  }).catch((error) => {
    Logger.info(TAG, "getLastWindow error: " + JSON.stringify(error))
  })
}

export function hideTitleBar() {
  Window.getLastWindow(getContext()).then((lastWindow) => {
    if (lastWindow) {
      lastWindow.setWindowSystemBarEnable([], (err) => {
        if (err) {
          Logger.info(TAG, "hideTitleBar failed")
        } else {
          Logger.info(TAG, "hideTitleBar successful")
        }
      })
    }
  }).catch((error) => {
    Logger.info(TAG, "getLastWindow error: " + JSON.stringify(error))
  })
}

export function showTitleBar() {
  Window.getLastWindow(getContext()).then((lastWindow) => {
    if (lastWindow) {
      lastWindow.setWindowSystemBarEnable(['status', 'navigation'], (err) => {
        if (err) {
          Logger.info(TAG, "showTitleBar failed")
        } else {
          Logger.info(TAG, "showTitleBar successful")
        }
      })
    }
  }).catch((error) => {
    Logger.info(TAG, "getLastWindow error: " + JSON.stringify(error))
  })
}
