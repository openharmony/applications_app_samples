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
 

import keyButton from './keybutton';
import Constants from '../common/constants'
import Log from '../../../../../../../common/src/main/ets/default/Log';

interface KeyCode {
  uri: ResourceStr
  keyCode: number
}

const TAG = 'NavigationBar-ThreeLayout';

let keyCodeArr: KeyCode[] = [
  {
    uri: $r('app.media.ic_systemui_back'),
    keyCode: Constants.KEYCODE_BACK
  },
  {
    uri: $r('app.media.ic_systemui_home'),
    keyCode: Constants.KEYCODE_HOME
  },
  {
    uri: $r('app.media.ic_systemui_recent'),
    keyCode: Constants.KEYCODE_RECENT
  }];

@Component
export default
struct threeLayout {
  @StorageLink('minNavHeight') minNavHeight:number = 32
  @StorageLink('showNavHorizontal') showNavHorizontal: boolean = AppStorage.setAndLink('showNavHorizontal', false).get();
  @State currentTouchItem: number = Constants.KEYCODE_NONE;
  aboutToAppear() {
    Log.showDebug(TAG, `aboutToAppear Start`)
  }

  aboutToDisappear(){
    Log.showDebug(TAG, `aboutToDisAppear`)
  }

  build() {
    if (this.showNavHorizontal) {
      Grid() {
        ForEach(keyCodeArr, (item: KeyCode) => {
          GridItem() {
            Row() {
              keyButton({ uri: item.uri, keyCode: item.keyCode, currentTouchItem: $currentTouchItem })
            }.height('100%')
          }
          .height('100%')
          .constraintSize({ minHeight: this.minNavHeight  + 'px'})
          .align(Alignment.Center)
        },(item:KeyCode,index)=>JSON.stringify(item)+index)
      }
      .columnsTemplate(Constants.THREE_TEMPLATE)
      .height('100%')
      .align(Alignment.Center);
    } else {
      Grid() {
        ForEach(keyCodeArr, (item: KeyCode) => {
          GridItem() {
            Column() {
              keyButton({ uri: item.uri, keyCode: item.keyCode, currentTouchItem: $currentTouchItem })
            }.width('100%')
          }
          .width('100%')
          .constraintSize({ minHeight: this.minNavHeight  + 'px'})
          .align(Alignment.Center)
        },(item:KeyCode,index)=>JSON.stringify(item)+index)
      }
      .rowsTemplate(Constants.THREE_TEMPLATE)
      .width('100%')
      .align(Alignment.Center);
    }
  }
}
