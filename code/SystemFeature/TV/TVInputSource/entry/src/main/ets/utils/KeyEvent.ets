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

import { inputEventClient } from '@kit.InputKit';
import { KeyCode } from '@kit.InputKit';
import { objType } from './Utils';

interface KeyInjectOptions {
    isPressed: boolean;
    keyCode: number;
    keyDownDuration: number;
    isIntercepted: boolean;
}

interface InjectEventPayload {
  [payloadKey: string]: KeyInjectOptions;
}

interface KeyClickBindingTarget {
    leftClick?: () => void;
    rightClick?: () => void;
    upClick?: () => void;
    downClick?: () => void;
    tabClick?: () => void;
}

/**
 * Creates one mutable key-event option object used by injection helpers.
 *
 * @param isPressed Whether the synthesized event is a key-down event.
 * @returns KeyInjectOptions Mutable event options reused across injections.
 */
function createKeyInjectOptions(isPressed: boolean): KeyInjectOptions {
    return {
        isPressed: isPressed,
        keyCode: KeyCode.KEYCODE_UNKNOWN,
        keyDownDuration: 0,
        isIntercepted: false
    };
}

let keyDownOpt: KeyInjectOptions = createKeyInjectOptions(true);

let keyUpOpt: KeyInjectOptions = createKeyInjectOptions(false);

/**
 * Wraps key options in the payload shape expected by `injectEvent`.
 *
 * @param keyEvent Key event options to inject.
 * @returns InjectEventPayload Typed input-kit payload wrapper.
 */
function createInjectEventPayload(keyEvent: KeyInjectOptions): InjectEventPayload {
    return {
        KeyEvent: keyEvent
    };
}

/**
 * Injects a key-down event for the current key code.
 *
 * @returns void.
 */
function keyDown() {
    try {
        inputEventClient.injectEvent(createInjectEventPayload(keyDownOpt));
    } catch (error) {
        console.log(`Failed to inject keyDown, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
}

/**
 * Injects a key-up event for the current key code.
 *
 * @returns void.
 */
function keyUp() {
    try {
        inputEventClient.injectEvent(createInjectEventPayload(keyUpOpt));
    } catch (error) {
        console.log(`Failed to inject keyUp, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
}

/**
 * Synchronizes the key code used by paired down/up injections.
 *
 * @param keyCode Business key code to inject.
 * @returns void.
 */
function setKeyCode(keyCode: number) {
    keyDownOpt.keyCode = keyCode;
    keyUpOpt.keyCode = keyCode;
}

/**
 * Injects a TAB key-down event.
 *
 * @returns void.
 */
export function tabKeyDown() {
    setKeyCode(KeyCode.KEYCODE_TAB);
    keyDown();
}

/**
 * Injects a TAB key-up event.
 *
 * @returns void.
 */
export function tabKeyUp() {
    setKeyCode(KeyCode.KEYCODE_TAB);
    keyUp();
}

/**
 * Injects one full TAB key click sequence.
 *
 * @returns void.
 */
export function tabClick() {
    setKeyCode(KeyCode.KEYCODE_TAB);
    keyDown();
    keyUp();
}

/**
 * Injects a DPAD-LEFT key-down event.
 *
 * @returns void.
 */
export function leftKeyDown() {
    setKeyCode(KeyCode.KEYCODE_DPAD_LEFT);
    keyDown();
}

/**
 * Injects a DPAD-LEFT key-up event.
 *
 * @returns void.
 */
export function leftKeyUp() {
    setKeyCode(KeyCode.KEYCODE_DPAD_LEFT);
    keyUp();
}

/**
 * Injects one full DPAD-LEFT click sequence.
 *
 * @returns void.
 */
export function leftClick() {
    setKeyCode(KeyCode.KEYCODE_DPAD_LEFT);
    keyDown();
    keyUp();
}

/**
 * Injects a DPAD-RIGHT key-down event.
 *
 * @returns void.
 */
export function rightKeyDown() {
    setKeyCode(KeyCode.KEYCODE_DPAD_RIGHT);
    keyDown();
}

/**
 * Injects a DPAD-RIGHT key-up event.
 *
 * @returns void.
 */
export function rightKeyUp() {
    setKeyCode(KeyCode.KEYCODE_DPAD_RIGHT);
    keyUp();
}

/**
 * Injects one full DPAD-RIGHT click sequence.
 *
 * @returns void.
 */
export function rightClick() {
    setKeyCode(KeyCode.KEYCODE_DPAD_RIGHT);
    keyDown();
    keyUp();
}

/**
 * Injects a DPAD-UP key-down event.
 *
 * @returns void.
 */
export function upKeyDown() {
    setKeyCode(KeyCode.KEYCODE_DPAD_UP);
    keyDown();
}

/**
 * Injects a DPAD-UP key-up event.
 *
 * @returns void.
 */
export function upKeyUp() {
    setKeyCode(KeyCode.KEYCODE_DPAD_UP);
    keyUp();
}

/**
 * Injects one full DPAD-UP click sequence.
 *
 * @returns void.
 */
export function upClick() {
    setKeyCode(KeyCode.KEYCODE_DPAD_UP);
    keyDown();
    keyUp();
}

/**
 * Injects a DPAD-DOWN key-down event.
 *
 * @returns void.
 */
export function downKeyDown() {
    setKeyCode(KeyCode.KEYCODE_DPAD_DOWN);
    keyDown();
}

/**
 * Injects a DPAD-DOWN key-up event.
 *
 * @returns void.
 */
export function downKeyUp() {
    setKeyCode(KeyCode.KEYCODE_DPAD_DOWN);
    keyUp();
}

/**
 * Injects one full DPAD-DOWN click sequence.
 *
 * @returns void.
 */
export function downClick() {
    setKeyCode(KeyCode.KEYCODE_DPAD_DOWN);
    keyDown();
    keyUp();
}

/**
 * Binds click helper methods onto one plain-object fixture.
 *
 * @param obj Candidate target that may receive click helpers.
 * @returns void.
 */
export function bindKeyClick(obj: Object | string | number | boolean | undefined | null) {
    if (objType(obj) === 'object') {
        const bindTarget = obj as KeyClickBindingTarget;
        bindTarget.leftClick = leftClick;
        bindTarget.rightClick = rightClick;
        bindTarget.upClick = upClick;
        bindTarget.downClick = downClick;
        bindTarget.tabClick = tabClick;
    }
}
