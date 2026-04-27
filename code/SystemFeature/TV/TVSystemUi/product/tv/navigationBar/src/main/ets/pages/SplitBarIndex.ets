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
 

import Log from '../../../../../../../common/src/main/ets/default/Log'
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager'

const TAG = 'Navigation-SplitBar'

interface configuration {
  maxWidth: number
  maxHeight: number
  minHeight: number
  showNavHorizontal: boolean
  direction: number
  realWidth: number
  realHeight: number
  xCoordinate: number
  yCoordinate: number
}

@Entry
@Component
struct Index {
  @State mHorizontalScreen: boolean = true;
  @StorageLink('SplitBarComponentMode') @Watch('onSplitBarUpdate') splitBarComponentMode :boolean = true

  onBackPress(): boolean {
    return true;
  }

  onSplitBarUpdate(){
    Log.showDebug(TAG,`updata--${this.splitBarComponentMode}`)
    this.mHorizontalScreen = this.splitBarComponentMode
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`);
    let configInfo: configuration = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config');
    if (configInfo.maxWidth > configInfo.maxHeight) {
      this.mHorizontalScreen = true;
    } else {
      this.mHorizontalScreen= false;
    }
    Log.showDebug(TAG, `aboutToAppear, end`);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Button({ type: ButtonType.Capsule, stateEffect: true }) {
      }
      .backgroundColor(Color.White)
      .width(this.mHorizontalScreen ? 7 : 80)
      .height(this.mHorizontalScreen? 80 : 7)
      .onTouch(this.touchEvent.bind(this))
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }

  touchEvent(event: TouchEvent) {
    Log.showDebug(TAG, 'touchEvent' + event.touches)
  }
}