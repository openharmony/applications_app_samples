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

import ConfigData from '../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { EntryComponent } from '../default/layout/EntrySetting';
import { inputEventClient } from '@kit.InputKit';
import LogUtil from '../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import { KeyCode } from '../common/constants/KeyCode';
import { common } from '@kit.AbilityKit';
import { Duration } from '../common/constants/Duration';
import { EventUtil } from '../common/EventUtil';
import { commonEventDataFunc, commonEventFloatBallDataFunc } from '../MainAbility/MainAbility';
import DisplayHelper from './links/screenExpansion/DisplayHelper';
import { BooleanPreferences } from '../common/UserStorageManager';

class InjectedKeyEventPayload {
}

/**
 * setting home page
 */
@Entry
@Component
struct SettingList {
  // 状态变量：标记是否为首次进入（初始值为true）
  @State isFirstEnter: boolean = true

  onBackPress(): boolean | void {
    (getContext(this) as common.UIAbilityContext).terminateSelf()
  }

  onPageShow(): void {
    if (this.isFirstEnter) {
      this.tabClick();
      this.isFirstEnter=false
    }
    this.getPreDataFlush();
  }

  async getPreDataFlush() {
    let preDataFlush = new BooleanPreferences(getContext(this));
    await preDataFlush.initialize();
    // 获取默认输入源开关Status
    // 读取值
    const defaultInputSource = await preDataFlush.getBoolean('defaultInputSource')
    console.log('Current defaultInputSource value:', defaultInputSource); // 输出: true
    AppStorage.setOrCreate('defaultInputSource', defaultInputSource)
    commonEventDataFunc(defaultInputSource)

    const defaultFloatBall = await preDataFlush.getBoolean('defaultFloatBall')
    console.log('Current defaultFloatBall value:', defaultFloatBall); // 输出: true
    AppStorage.setOrCreate('defaultFloatBall', defaultFloatBall)
    commonEventFloatBallDataFunc(defaultFloatBall)
    DisplayHelper.getInstance()
  }

  tabClick() {
    let keyDownOpt: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUpOpt: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let eventDown: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventDown, 'KeyEvent', keyDownOpt)
    let eventUp: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventUp, 'KeyEvent', keyUpOpt)

    try {
      inputEventClient.injectEvent(eventDown as never);
      inputEventClient.injectEvent(eventUp as never);
    } catch (err) {
      LogUtil.error('settingList inputEventClient' + err)
    }
  }

  build() {
    Column() {
      Column() {
        EntryComponent()
      }
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
    }
    .onTouch((event) => {
      if (!event) {
        return;
      }
      EventUtil.isTouchEvent(event);
    })

  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
  }
}
