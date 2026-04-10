/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License"),
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

/**
 * @file
 * @kit BasicServicesKit
 */


/**
 * Provides interfaces to manage power.
 *
 * @namespace hlGallery
 * @syscap SystemCapability.PowerManager.PowerManager.Core
 * @since 7
 */
declare namespace hlGallery {
  /**
   * Shuts down the system.
   * <p>This method requires the ohos.permission.REBOOT permission.
   *
   * @permission ohos.permission.REBOOT
   * @param { string } reason Indicates the shutdown reason.
   * reason parameter must be of type string.
   * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
   * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Incorrect parameter types;
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @systemapi
   * @since 7
   */
  function viewImage(fd:number): number;

  /**
   * Checks whether the device is active.
   * <p>
   * The screen will be on if device is active, screen will be off otherwise.
   *
   * @returns { string } Returns true if the device is active; returns false otherwise.
   * @throws { BusinessError } 4900101 - Failed to connect to the service.
   * @syscap SystemCapability.PowerManager.PowerManager.Core
   * @since 9
   */
  function exitViewImage(): number;
}


export default hlGallery;
