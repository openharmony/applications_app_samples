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

import { inputEventClient, KeyCode } from '@kit.InputKit';


export class PageViewUtils {
  public static tabClick() {
    try {
      let backKeyDown: inputEventClient.KeyEvent = {
        isPressed: true,
        keyCode: KeyCode.KEYCODE_TAB,
        keyDownDuration: 0,
        isIntercepted: false
      };
      inputEventClient.injectEvent({ KeyEvent: backKeyDown });

      let backKeyUp: inputEventClient.KeyEvent = {
        isPressed: false,
        keyCode: KeyCode.KEYCODE_TAB,
        keyDownDuration: 0,
        isIntercepted: false
      };
      inputEventClient.injectEvent({ KeyEvent: backKeyUp });
    } catch (error) {
      console.log(`Failed to inject KeyEvent, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }
}
