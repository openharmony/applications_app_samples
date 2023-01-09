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

import animator from '@ohos.animator'
import mediaQuery from '@system.mediaquery'
import Logger from '../../common/Logger'

const TAG = 'index'

export default {
  data: {
    sunLeft: 0,
    sunBottom: 0,
    divLeft: 600,
    divBottom: 0,
    state: 0, // 0:finish, can start, 1: pause, 2: playing
    isPlay: false,
    isSunFinish: false,
    isMoonFinish: false,
    heightScale: 3.2
  },
  sunAnimator: null,
  moonAnimator: null,

  onInit() {
    this.sunAnimator = animator.createAnimator({
      duration: 3000,
      delay: 0,
      easing: 'cubic-bezier(0.5,0.8,0.5,0.2)',
      fill: 'none',
      direction: 'normal',
      iterations: 1,
      begin: 0.0,
      end: 600.0
    })

    this.moonAnimator = animator.createAnimator({
      duration: 3000,
      delay: 3000,
      easing: 'cubic-bezier(0.5,0.8,0.5,0.2)',
      fill: 'none',
      direction: 'normal',
      iterations: 1,
      begin: 600.0,
      end: 0.0
    })
    this.sunAnimator.onframe = (value) => {
      if (value > 300) {
        this.sunBottom = (600 - value) / this.heightScale
      } else {
        this.sunBottom = value / this.heightScale
      }
      this.sunLeft = value
    };
    this.moonAnimator.onframe = (value) => {
      if (parseInt(value) < 300) {
        this.divBottom = -value / this.heightScale
      } else {
        this.divBottom = (value - 600) / this.heightScale
      }
      this.divLeft = value
    }
    this.sunAnimator.onfinish = () => {
      Logger.info(TAG, `sun finish`)
      this.isSunFinish = true
    }
    this.moonAnimator.onfinish = () => {
      Logger.info(TAG, `moon finish`)
      this.isMoonFinish = true
      this.state = 0 // moon finishes, means the whole animation finished
      this.isPlay = false
    }
    let mMediaQueryList = mediaQuery.matchMedia('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)');
    mMediaQueryList.addListener(this.orientationMatch);
  },
  orientationMatch(data) {
    if (data.matches) {
      this.heightScale = 3.2
    } else {
      this.heightScale = 1.0
    }
  },
  rise() {
    this.sunAnimator.play()
    Logger.info(TAG, `rise play`)
  },
  fall() {
    this.moonAnimator.play()
    Logger.info(TAG, `fall play`)
  },

  start() {
    Logger.info(TAG, `in start, this.state=${this.state}`)
    if (this.state === 0) { // can start
      this.isSunFinish = false // clear the flag
      this.isMoonFinish = false
      this.rise()
      this.fall()
    } else if (this.state === 1) { // means the state is pause
      if (!this.isSunFinish) {
        this.rise()
        this.fall()
      } else {
        this.fall()
      }
    }
    this.isPlay = true
    this.state = 2

  },

  pause() {
    Logger.info(TAG, `in pause, this.state=${this.state}`)
    if (this.state === 2) { // means the state is running
      this.state = 1
      this.isPlay = false
      if (!this.isSunFinish) {
        this.sunAnimator.pause()
      }
      if (!this.isMoonFinish) {
        this.moonAnimator.pause()
      }
    }
  },

  stop() {
    this.sunAnimator.finish()
    this.moonAnimator.finish() // finish will call the finish callback of moonAnimator, so the state will be 0
  },

  reverse() {
    Logger.info(TAG, `in reverse, this.state=${this.state}`)
    if (this.state === 0) {
      this.isSunFinish = false // clear the flag
      this.isMoonFinish = false
      this.state = 2
      this.isPlay = true
      this.sunAnimator.reverse() // reverse will start the animator
      this.moonAnimator.reverse()
    }
  }
}
