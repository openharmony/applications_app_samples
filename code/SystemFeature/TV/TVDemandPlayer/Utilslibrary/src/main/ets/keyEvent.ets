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
import { objType } from './Utils'
import { promptAction } from '@kit.ArkUI';

let keyDownOpt = {
  isPressed: true,
  keyCode: KeyCode.KEYCODE_UNKNOWN,
  keyDownDuration: 0,
  isIntercepted: false
}

let keyUpOpt = {
  isPressed: false,
  keyCode: KeyCode.KEYCODE_UNKNOWN,
  keyDownDuration: 0,
  isIntercepted: false
};

function keyDown() {
  try {
    inputEventClient.injectEvent({ KeyEvent: keyDownOpt });
  } catch (error) {
    console.log(`Failed to inject keyDown, error: ${JSON.stringify(error, [`code`, `message`])}`);
  }
}

function keyUp() {
  try {
    inputEventClient.injectEvent({ KeyEvent: keyUpOpt });
  } catch (error) {
    console.log(`Failed to inject keyUp, error: ${JSON.stringify(error, [`code`, `message`])}`);
  }
}

export function tabKeyDown() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_TAB;
  keyDown();
}

export function tabKeyUp() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_TAB;
  keyUp();
}


export function tabClick() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_TAB;
  keyDown();
  keyUp();
}

export function leftKeyDown() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_LEFT;
  keyDown();
}

export function leftKeyUp() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_LEFT;
  keyUp();
}

export function leftClick() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_LEFT;
  keyDown();
  keyUp();
}

export function rightKeyDown() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_RIGHT;
  keyDown();
}

export function rightKeyUp() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_RIGHT;
  keyUp();
}

export function rightClick() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_RIGHT;
  keyDown();
  keyUp();
}

export function upKeyDown() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_UP;
  keyDown();
}

export function upKeyUp() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_UP;
  keyUp();
}

export function upClick() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_UP;
  keyDown();
  keyUp();
}

export function downKeyDown() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_DOWN;
  keyDown();
}

export function downKeyUp() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_DOWN;
  keyUp();
}

export function downClick() {
  keyDownOpt.keyCode = KeyCode.KEYCODE_DPAD_DOWN;
  keyDown();
  keyUp();
}

export function bindKeyClick(obj) {
  if (objType(obj) == 'object') {
    obj.leftClick = leftClick;
    obj.rightClick = rightClick;
    obj.upClick = upClick;
    obj.downClick = downClick;
    obj.tabClick = tabClick;
  }
}
