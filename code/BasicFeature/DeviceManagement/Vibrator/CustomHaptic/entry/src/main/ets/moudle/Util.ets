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

export function getDynamicStates(dis:boolean[], id:number) : boolean[] {
  for(let i = 0; i < dis.length; i++) {
    i == id ? dis[i] = true : dis[i] = false
    console.info(dis[i].toString())
  }
  return dis
}

export async function PlayVibrateCustom(fileName:string) {
  let rawFd = undefined
  await getContext().resourceManager.getRawFd(fileName).then(value => {
    rawFd = value
    console.info("rawFd of vibration:" + " fd:"+ rawFd.fd + ", offset:" + rawFd.offset + ", length: " + rawFd.length)
  })
  try {
    vibrator.startVibration({
      type: "file",
      hapticFd: { fd: rawFd.fd, offset: rawFd.offset, length: rawFd.length }
    }, {
      usage:"unknown"
    }, (error) => {
      if(error) {
        console.info('startVibration failed, type is file, in callback');
      } else {
        console.info('startVibration successful, type is file, in callback');
      }
    });
  } catch(error) {
    console.info('startVibration failed, type is file, in catch, err code:' + error.code + ' err msg:' + error.message)
  }
}

export function setAVPlayerCallback(avPlayer) {
  avPlayer.reset()
  avPlayer.on('stateChange', async (state, reason) => {
    switch (state) {
      case 'idle':
        console.info('state idle called')
        break;
      case 'initialized':
        console.info('state initialized called ')
        avPlayer.prepare().then(() => {
          console.info('prepare success');
        }, (err) => {
          console.error('prepare filed,error message is :' + err.message)
        })
        break;
      case 'prepared':
        console.info('state prepared called')
        avPlayer.play()
        break;
      case 'playing':
        console.info('state playing called')
        break;
      case 'completed':
        console.info('state completed called')
        avPlayer.stop()
        avPlayer.reset()
        break;
      case 'stopped':
        console.info('state stopped called')
        avPlayer.release()
        break;
      case 'error':
        console.info('state error called')
        break;
      default:
        console.info('unkown state :' + state)
        break;
    }
  })
}

export async function avPlayer(audioName:string) {
  let avPlayer = await media.createAVPlayer()
  setAVPlayerCallback(avPlayer)
  let rawFd = undefined
  await globalThis.getContext().resourceManager.getRawFd(audioName).then(value => {
    rawFd = value
    console.info('get audio resource successful');
    console.info("rawFd of audio:" + " fd:"+ rawFd.fd + ", offset:" + rawFd.offset + ", length: " + rawFd.length)
  }).catch((error) => {
    console.info('get audio resource failed, err code:' + error.code + ' err msg:' + error.message)
  })
  avPlayer.fdSrc = rawFd
}

export function changeOrientationInternal(lastWindow: Window.Window, portrait:boolean) {
  if (portrait) {
    lastWindow.setPreferredOrientation(Window.Orientation.LANDSCAPE).then(() => {
      console.log("setPreferredOrientation success")
    }).catch((error) => {
      console.log("setPreferredOrientation failure" + JSON.stringify(error))
    })
  } else {
    lastWindow.setPreferredOrientation(Window.Orientation.PORTRAIT).then(() => {
      console.log("setPreferredOrientation success")
    }).catch((error) => {
      console.log("setPreferredOrientation failure: " + JSON.stringify(error))
    })
  }
}

export function changeOrientation(portrait:boolean) {
  Window.getLastWindow(getContext()).then((lastWindow) => {
    changeOrientationInternal(lastWindow,portrait)
  }).catch((error) => {
    console.log("getLastWindow error: " + JSON.stringify(error))
  })
}

export function hideTitleBar() {
  Window.getLastWindow(getContext()).then((lastWindow) => {
    if (lastWindow) {
      lastWindow.setWindowSystemBarEnable([], (err) => {
        if(err) {
          console.info("hideTitleBar failed")
        } else {
          console.info("hideTitleBar successful")
        }
      })
    }
  }).catch((error) => {
    console.log("getLastWindow error: " + JSON.stringify(error))
  })
}

export function showTitleBar() {
  Window.getLastWindow(getContext()).then((lastWindow) => {
    if (lastWindow) {
      lastWindow.setWindowSystemBarEnable(['status','navigation'],(err)=>{
        if(err){
          console.info("showTitleBar failed")
        } else {
          console.info("showTitleBar successful")
        }
      })
    }
  }).catch((error) => {
    console.log("getLastWindow error: " + JSON.stringify(error))
  })
}
