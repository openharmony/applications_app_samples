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

import { NetWorkComponent } from '../../default/layout/NetworkComponent';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { Duration } from '../../common/constants/Duration';
import { inputEventClient, KeyCode } from '@kit.InputKit';

class InjectedKeyEventPayload {
}

/**
 * 网络设置
 */
@Entry
@Component
struct Network {
  @State pageTranState: boolean = false; //判断是进场动效还是出场动效

  onPageHide(): void {
    this.pageTranState = false
  }

aboutToAppear(): void {
  this.tabClick();
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
    }
  }

  pageTransition() {
    if (this.pageTranState) {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
    } else {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
    }
  }

  build() {
      Column() {
        NetWorkComponent({ pageTranState: $pageTranState })
      }
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
    }
}
