/*
 * Copyright (c) 2021-2026 Huawei Device Co., Ltd.
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

import { Callback } from './basic';
import { MouseEvent } from './@ohos.multimodalInput.mouseEvent';

/**
 * Global input event listener
 * System API, available only to system processes
 * @since 7
 * @syscap SystemCapability.MultimodalInput.Input.InputMonitor
 * @import import inputMonitor from '@ohos.multimodalInput.inputMonitor';
 * @permission ohos.permission.INPUT_MONITORING
 * @systemapi hide for inner use
 */
declare namespace inputMonitor {
    /**
     * Callback used to receive touch input events. If **true** is returned, the touch input is consumed, and the system performs the closing operation.
     * @since 7
     * @syscap SystemCapability.MultimodalInput.Input.InputMonitor
     * @systemapi hide for inner use
     */
    interface TouchEventReceiver {
        (touchEvent:TouchEvent): Boolean;
    }

    /**
     * Listens for touch input events.
     * @since 7
     * @syscap SystemCapability.MultimodalInput.Input.InputMonitor
     * @systemapi hide for inner use
     * @permission ohos.permission.INPUT_MONITORING
     * @param type Event type.
     * @param receiver Callback used to receive the reported data.
     */
    function on(type:"touch", receiver:TouchEventReceiver):void;

    /**
     * Listens for mouse input events.
     * @since 9
     * @syscap SystemCapability.MultimodalInput.Input.InputMonitor
     * @systemapi hide for inner use
     * @permission ohos.permission.INPUT_MONITORING
     * @param type Event type.
     * @param receiver Callback used to receive the reported data.
     */
    function on(type:"mouse", receiver:Callback<MouseEvent>):void;

    /**
     * Listens for keyboard input events.
     * @since 9
     * @syscap SystemCapability.MultimodalInput.Input.InputMonitor
     * @systemapi hide for inner use
     * @permission ohos.permission.INPUT_MONITORING
     * @param type Event type.
     * @param receiver Callback used to receive the reported data.
     */
    function on(type:"keyboard", receiver:Callback<any>):void;

    /**
     * Cancels listening for touch input events.
     * @since 7
     * @syscap SystemCapability.MultimodalInput.Input.InputMonitor
     * @systemapi hide for inner use
     * @permission ohos.permission.INPUT_MONITORING
     * @param type Event type.
     * @param receiver Callback used to receive the reported data.
     */
    function off(type:"touch", receiver?:TouchEventReceiver):void;

    /**
     * Cancels listening for mouse input events.
     * @since 9
     * @syscap SystemCapability.MultimodalInput.Input.InputMonitor
     * @systemapi hide for inner use
     * @permission ohos.permission.INPUT_MONITORING
     * @param type Event type.
     * @param receiver Callback used to receive the reported data.
     */
    function off(type:"mouse", receiver?:Callback<MouseEvent>):void;
}
export default inputMonitor;
