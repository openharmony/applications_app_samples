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

import lock from '@ohos.runningLock'
import Logger from '../util/Logger'

const TAG: string = 'RunningLock'

@Component
export struct LockSwitch {
  private isLock: boolean = false
  @Link output: Resource
  @Link isDelayTime: boolean

  build() {
    Row() {
      Text($r('app.string.sleepLockSwitch'))
        .fontSize(20)
        .fontColor('#0D9FFB')
        .width('30%')
        .margin({ left: '22%' })
        .fontWeight(FontWeight.Bold)
      Toggle({ type: ToggleType.Switch, isOn: this.isLock })
        .width(70)
        .height(30)
        .margin({ left: '20%', right: 10 })
        .onChange(() => {
          this.isLock = !(this.isLock)
          lock.createRunningLock('running_lock_test', lock.RunningLockType.BACKGROUND)
            .then(lock => {
              lock.isUsed()
              if (this.isLock === true) {
                this.output = $r('app.string.stopSleep')
                this.isDelayTime = false
                lock.lock(1000);
              } else {
                lock.unlock()
                this.output = $r('app.string.turnSleep')
                this.isDelayTime = true
              }
            })
            .catch(error => {
              Logger.info(TAG, `create runningLock test error: ${error}`)
            })
        })
    }
    .width('100%')
    .height(50)
    .margin({ top: 10 })
  }
}