/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import keyCodeEvent from '../../../../../../../features/navigationservice/src/main/ets/com/ohos/navigationservice/KeyCodeEvent';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import Constants from '../common/constants';
import StyleConfiguration, { KeyButtonStyle } from '../common/StyleConfiguration';
import NavigationBarViewModel from '../viewmodel/NavigationBarViewModel';
import { NavigationBarComponentData } from '../common/constants';

const TAG = 'NavigationBar-KeyButton';

@Component
export default struct keyButton {
  private uri: PixelMap | ResourceStr = '';
  @State keyCode: number = 0;
  @Link currentTouchItem: number;
  @State backGroundColor: ResourceColor = $r('app.color.button_default_background');
  @StorageLink('showNavHorizontal') showNavHorizontal: boolean = AppStorage.setAndLink('showNavHorizontal', true).get();
  @State mNavigationBarComponentData: NavigationBarComponentData = NavigationBarViewModel.getInstance()
    .getNavigationBarComponentData()
  @State style: KeyButtonStyle = StyleConfiguration.getKeyButtonStyle()

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Flex() {
      }
      .borderRadius(this.style.buttonBorderRadius)
      .width('100%')
      .height('100%')
      .backgroundColor(this.backGroundColor)

      Image(this.uri)
        .objectFit(ImageFit.Contain)
        .size({
          width: this.style.buttonIconWidth,
          height: this.style.buttonIconHeight
        })
        .fillColor(this.mNavigationBarComponentData.contentColor)
    }
    .onTouch(this.onKeyTouch.bind(this))
    .width(this.showNavHorizontal ? this.style.buttonWidth : this.style.buttonHeight)
    .height(this.showNavHorizontal ? this.style.buttonHeight : this.style.buttonWidth)
  }

  private onKeyTouch(event: TouchEvent) {
    if (this.currentTouchItem != Constants.KEYCODE_NONE && this.currentTouchItem != this.keyCode) {
      Log.showInfo(TAG, `current has item touch.`);
      return;
    }
    Log.showDebug(TAG, `onKeyTouch event: ${ event }`)
    let eventType = event.type;
    switch (eventType) {
      case TouchType.Down:
        this.currentTouchItem = this.keyCode;
        this.backGroundColor = $r('app.color.button_click_background')
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        this.backGroundColor = $r('app.color.button_default_background')
        this.currentTouchItem = Constants.KEYCODE_NONE;
        break;
      default:
        break;
    }
    keyCodeEvent.sendKeyEvent(this.keyCode, eventType)
  }
}
