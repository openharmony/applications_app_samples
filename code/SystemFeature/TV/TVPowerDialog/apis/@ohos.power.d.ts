/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import {AsyncCallback, BusinessError} from './basic';

/**
 * Provides interfaces to manage power.
 *
 * @syscap SystemCapability.PowerManager.PowerManager.Core
 * @since 7
 */
declare namespace power {
    function shutdownDevice(reason: string): void;
    function forceSuspendDevice(): void;
    function closeScreen(reason: string): void;

    /**
     * Wakes up the device to turn on the screen.
     *
     * @param detail Indicates the detailed wakeup information.
     * @systemapi
     * @since 9
     */
    function wakeupDevice(detail: string): void;

    /**
     * Suspends the device to turn off the screen.
     *
     * @systemapi
     * @since 9
     */
    function suspendDevice(): void;

    /**
     * Shuts down the system.
     *
     * <p>This method requires the ohos.permission.REBOOT permission.
     *
     * @permission ohos.permission.REBOOT
     * @param {string} reason Indicates the shutdown reason.
     * @throws {BusinessError} 201 - If the permission is denied.
     * @throws {BusinessError} 401 - If the reason is not valid.
     * @throws {BusinessError} 4900101 - If connecting to the service failed.
     * @systemapi
     * @since 7
     */
    function shutdown(reason: string): void;

    /**
     * Restarts the system.
     *
     * <p>This method requires the ohos.permission.REBOOT permission.
     *
     * @param reason Indicates the restart reason. For example, "updater" indicates entering the updater mode
     * after the restart. If the parameter is not specified, the system enters the normal mode after the restart.
     * @permission ohos.permission.REBOOT
     * @since 7
     * @deprecated since 9
     * @useinstead {@link power#reboot}
     */
    function rebootDevice(reason: string): void;

    /**
     * Restarts the system.
     *
     * <p>This method requires the ohos.permission.REBOOT permission.
     *
     * @permission ohos.permission.REBOOT
     * @param {string} reason Indicates the restart reason. For example, "updater" indicates entering the updater mode
     * after the restart. If the parameter is not specified, the system enters the normal mode after the restart.
     * @throws {BusinessError} 201 - If the permission is denied.
     * @throws {BusinessError} 401 - If the reason is not valid.
     * @throws {BusinessError} 4900101 - If connecting to the service failed.
     * @systemapi
     * @since 9
     */
    function reboot(reason: string): void;

    /**
     * Checks whether the screen of a device is on or off.
     *
     * @returns Returns true if the screen is on; returns false otherwise.
     * @since 7
     * @deprecated since 9
     * @useinstead {@link power#isActive}
     */
    function isScreenOn(callback: AsyncCallback<boolean>): void;
    function isScreenOn(): Promise<boolean>;

    /**
     * Checks whether the device is active.
     * <p>
     * The screen will be on if device is active, screen will be off otherwise.
     *
     * @returns Returns true if the device is active; returns false otherwise.
     * @throws {BusinessError} 4900101 - If connecting to the service failed.
     * @since 9
     */
    function isActive(): boolean;

    /**
     * Wakes up the device to turn on the screen.
     *
     * @param {string} detail Indicates the detail information who request wakeup.
     * @throws {BusinessError} 401 - If the detail is not valid.
     * @throws {BusinessError} 4900101 - If connecting to the service failed.
     * @systemapi
     * @since 9
     */
    function wakeup(detail: string): void;

    /**
     * Suspends the device to turn off the screen.
     *
     * @throws {BusinessError} 4900101 - If connecting to the service failed.
     * @systemapi
     * @since 9
     */
    function suspend(): void;

    /**
     * Obtains the power mode of the current device. For details, see {@link DevicePowerMode}.
     *
     * @returns The power mode {@link DevicePowerMode} of current device .
     * @throws {BusinessError} 4900101 - If connecting to the service failed.
     * @since 9
     */
    function getPowerMode(): DevicePowerMode;

    /**
     * Obtains the power mode of the current device. For details, see {@link DevicePowerMode}.
     *
     * @permission ohos.permission.POWER_OPTIMIZATION
     * @param {DevicePowerMode} mode Indicates power mode {@link DevicePowerMode} to set.
     * @param {AsyncCallback<void>} callback Indicates the callback of setting the power mode.
     * @throws {BusinessError} 201 – If the permission is denied.
     * @throws {BusinessError} 401 - If mode or callback is not valid.
     * @systemapi
     * @since 9
     */
    function setPowerMode(mode: DevicePowerMode, callback: AsyncCallback<void>): void;

    /**
     * Sets the power mode of current device. For details, see {@link DevicePowerMode}.
     *
     * @permission ohos.permission.POWER_OPTIMIZATION
     * @param {DevicePowerMode} mode Indicates power mode {@link DevicePowerMode} to set.
     * @throws {BusinessError} 201 – If the permission is denied.
     * @throws {BusinessError} 401 - If mode or callback is not valid.
     * @systemapi
     * @since 9
     */
    function setPowerMode(mode: DevicePowerMode): Promise<void>;

    /**
     * Power mode of a device.
     *
     * @syscap SystemCapability.PowerManager.PowerManager.Core
     * @since 9
     */
    export enum DevicePowerMode {
        /**
         * Normal power mode
         * @since 9
         */
        MODE_NORMAL = 600,
        /**
         * Power save mode
         * @since 9
         */
        MODE_POWER_SAVE,
        /**
         * Performance power mode
         * @since 9
         */
        MODE_PERFORMANCE,
        /**
         * Extreme power save mode
         * @since 9
         */
        MODE_EXTREME_POWER_SAVE
    }
}
export default power;
