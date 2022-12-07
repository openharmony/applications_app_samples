/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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


import window from '@ohos.window'
import emitter from '@ohos.events.emitter'
import Logger from '../common/Logger'
import { DESTROY_FLOAT_WINDOW } from '../common/Constants'

const TAG: string = '[index]'

@Entry
@Component
struct Index {
  build() {
    Column() {
      Row() {
        Text($r('app.string.title'))
          .fontColor(Color.White)
          .fontSize(26)
      }
      .height('8%')
      .width('100%')
      .constraintSize({ minHeight: 70 })
      .backgroundColor('#0D9FFB')
      .padding({ left: 16, right: 16 })

      Column() {
        Text($r('app.string.recorder_desc'))
          .fontColor(Color.Black)
          .fontSize(20)
          .margin(20)
        Button($r('app.string.start_rec'))
          .onClick(this.start)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

    }
    .justifyContent(FlexAlign.Start)
    .size({width: '100%', height: '100%'})
  }

  start = () => {
    let windowClass
    //TODO: use the  new api "window.createWindow(config: Configuration, callback: AsyncCallback<Window>): void" instead
    window.create(getContext(this), 'floatWindow', window.WindowType.TYPE_FLOAT, (err, data) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to create the floatWindow: ' + JSON.stringify(err))
        return
      }
      Logger.info(TAG, 'Succeeded in creating the floatWindow. Data: ' + JSON.stringify(data))
      windowClass = data
      windowClass.moveTo(vp2px(50), vp2px(50), (err, data) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to move the window. Cause: ' + JSON.stringify(data))
          return
        }
        Logger.info(TAG, 'Succeeded in moving the window. Data:' + JSON.stringify(data))
      })
      windowClass.resetSize(vp2px(130), vp2px(30), (err, data) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to resetSize. Cause: ' + JSON.stringify(data))
          return
        }
        Logger.info(TAG, 'Succeeded in resetting size. Data:' + JSON.stringify(data))
      })
      windowClass.loadContent('pages/ScreenRecorder', (err, data) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to load ScreenRecorder page. Cause: ' + JSON.stringify(data))
          return
        }
        Logger.info(TAG, 'Succeeded in loading ScreenRecorder page. Data:' + JSON.stringify(data))

        windowClass.show((err, data) => {
          if (err.code) {
            Logger.error(TAG, 'Failed to show window. Case: ' + JSON.stringify(data))
            return
          }
          Logger.info(TAG, 'Succeeded in showing the window. Data:' + JSON.stringify(data))
        })
      })
      windowClass.setBackgroundColor(Color.Transparent)
    })
    globalThis.floatWindow = windowClass
    globalThis.mainWindow.hide()
    emitter.once({ eventId: DESTROY_FLOAT_WINDOW }, () => {
      Logger.info(TAG, 'emitter once')
      windowClass.destroyWindow((err, data) => {
        if(err.code) {
          Logger.error(TAG, 'Failed to destroy the window. Cause:' + JSON.stringify(err))
          return
        }
        Logger.info(TAG, 'Succeeded to destroy the window. Data:' + JSON.stringify(data))
      })
    })
  }
}