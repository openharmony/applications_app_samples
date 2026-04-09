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
 * @file Defines share capability.
 * @kit ShareKit
 */
import { AsyncCallback, Callback } from "@kit.BasicServicesKit";

/**
 * Provide methods make the host (data owner) application can conveniently wrap shared data,
 * make show the system share panel.
 *
 * @namespace oneConnectShare
 * @stagemodelonly
 * @since 12
 */
declare namespace OneConnectFileShare {
  /**
   * Describe the shared want
   * @typedef ShareWant
   * @stagemodelonly
   * @since 12
   */
  interface ShareWant {
    /**
     * Indicates the array of shared data
     *
     * @type { Array<SharedRecord> }
     * @stagemodelonly
     * @since 12
     */
    type: ShareType;

    /**
     * Indicates the array of shared data
     *
     * @type { Array<SharedRecord> }
     * @stagemodelonly
     * @since 12
     */
    data: Array<SharedRecord>;

    /**
     * Share controller options definitions.
     * @typedef ShareControllerOptions
     * @stagemodelonly
     * @since 12
     */
    options?: ShareControllerOptions;
  }

  /**
   * Describe the shared record
   * @typedef SharedRecord
   * @stagemodelonly
   * @since 12
   */
  interface SharedRecord {
    /**
     * Indicates the uniform type descriptor of shared record,
     * for details,see {@link @ohos.data.uniformTypeDescriptor}.
     *
     * @type { string }
     * @stagemodelonly
     * @since 12
     */
    utd: string;

    /**
     * Indicates the content of shared record, information that does not
     * require authorization, including but not limited to text, HTML text, and URL.
     *
     * @type { ?string }
     * @stagemodelonly
     * @since 12
     */
    content?: string;

    /**
     * Indicates the uri of shared record.
     *
     * @type { string }
     * @stagemodelonly
     * @since 12
     */
    uri: string;

    /**
     * Indicates the title of shared record
     *
     * @type { ?string }
     * @stagemodelonly
     * @since 12
     */
    title: string;

    /**
     * Indicates the label of shared record
     *
     * @type { ?string }
     * @stagemodelonly
     * @since 12
     */
    label?: string;

    /**
     * Indicates the description of shared record
     *
     * @type { ?string }
     * @stagemodelonly
     * @since 12
     */
    description?: string;

    /**
     * Indicates the thumbnail of shared record
     *
     * @type { ?Uint8Array }
     * @stagemodelonly
     * @since 12
     */
    thumbnail?: Uint8Array;

    /**
     * Indicates the thumbnail uri of shared record
     *
     * @type { ?string }
     * @stagemodelonly
     * @since 12
     */
    thumbnailUri?: string;

    /**
     * Indicates the extra data of shared record. The content
     * is forwarded to the target application without permission authorization.
     *
     * @type { ?Record<string, string | number | boolean | Array<string | number | boolean>> }
     * @stagemodelonly
     * @since 12
     */
    extraData?: Record<string, string | number | boolean | Array<string | number | boolean>>;
  }

  /**
   * Share controller options definitions.
   * @typedef ShareControllerOptions
   * @stagemodelonly
   * @since 12
   */
  interface ShareControllerOptions {
    /**
     * Indicates the selection mode.
     *
     * @type { ?SelectionMode }
     * @stagemodelonly
     * @since 12
     */
    selectionMode?: SelectionMode;

    /**
     * Indicates the preview mode.
     *
     * @type { ?SharePreviewMode }
     * @stagemodelonly
     * @since 12
     */
    previewMode?: SharePreviewMode;
  }

  /**
   * Selection mode definitions.
   *
   * @enum { number }
   * @stagemodelonly
   * @since 12
   */
  const enum SelectionMode {
    /**
     * Indicates the single selection mode.
     *
     * @stagemodelonly
     * @since 12
     */
    SINGLE = 0,
    /**
     * Indicates the batch selection mode.
     *
     * @stagemodelonly
     * @since 12
     */
    BATCH = 1
  }

  /**
   * Shared data preview mode definitions.
   *
   * @enum { number }
   * @stagemodelonly
   * @since 12
   */
  const enum SharePreviewMode {
    /**
     * Indicates the default preview mode.
     *
     * @stagemodelonly
     * @since 12
     */
    DEFAULT = 0,
    /**
     * Indicates the detail preview mode.
     *
     * @stagemodelonly
     * @since 12
     */
    DETAIL
  }

  /**
   * SystemShare ShareAbilityType definitions.
   *
   * @enum { number }
   * @stagemodelonly
   * @since 12
   */
  const enum ShareType {
    /**
     * Indicates the type of share media assets.
     *
     * @stagemodelonly
     * @since 12
     */
    SAVE_TO_MEDIA_ASSET = 1,
    /**
     * Indicates the type of normal files.
     *
     * @stagemodelonly
     * @since 12
     */
    SAVE_AS_FILE = 2,
    /**
     * Indicates the type of folder.
     *
     * @stagemodelonly
     * @since 12
     */
    SAVE_AS_FOLDER = 10,
  }

  /**
   * Describe the shared file info
   * @typedef ShareFileInfo
   * @stagemodelonly
   * @since 12
   */
  interface ShareFileInfo {
    /**
     * File name.
     * @type { string }
     * @since 12
     */
    name: string;

    /**
     * File uri.
     * @type { string }
     * @since 12
     */
    uri: string;

    /**
     * File size.
     * @type { number }
     * @since 12
     */
    size: number;

    /**
     * Indicates the uniform type descriptor of shared record,
     * for details,see {@link @ohos.data.uniformTypeDescriptor}.
     *
     * @type { string }
     * @stagemodelonly
     * @since 12
     */
    utd: string;
  }

  /**
   * The state of the nearby devices.
   * @enum { number }
   * @since 12
   */
  const enum ShareDeviceStateChange {
    /**
     * This state indicates the device is online but the state is unknown,The distributed function cannot used until
     * state changes to AVAILABLE.
     * @since 12
     */
    UNKNOWN = 0,
    /**
     * This state indicates the device has been synchronized to the database, Now the distributed function can be used.
     * @since 12
     */
    AVAILABLE = 1,
    /**
     * This state indicates the device is offline.
     * @since 12
     */
    UNAVAILABLE = 2
  }

  /**
   * Basic description information of a distributed device.
   * @interface ShareDeviceInfo
   * @since 12
   */
  interface ShareDeviceInfo {
    /**
     * Device unique identifier, The actual value is the udid-hash confused with the appid based on sha256.
     * @type { string }
     * @since 12
     */
    deviceId: string;

    /**
     * Device name.
     * @type { string }
     * @since 12
     */
    deviceName: string;

    /**
     * Obtains the device type represented by a string,
     * which can be {@code phone}, {@code tablet}, {@code tv}, {@code smartVision}, {@code car}.
     * @type { string }
     * @since 12
     */
    deviceType: string;

    /**
     * Device network id.
     * @type { ?string }
     * @since 12
     */
    networkId?: string;
  }

  /**
   * The state of sending files.
   * @enum { number }
   * @since 12
   */
  const enum SendState {
    /**
     * The initial state to send files.
     * @since 12
     */
    UNKNOWN = 0,
    /**
     * This state indicates the device is sending files.
     * @since 12
     */
    PROCESSING = 1,
    /**
     * This state indicates the files has been sent successfully.
     * @since 12
     */
    SUCCESS = 2,
    /**
     * This state indicates the files has not been sent successfully.
     * @since 12
     */
    FAILURE = 3,
    /**
     * This state indicates the sending process has been canceled by source device.
     * @since 12
     */
    CANCEL = 4,
    /**
     * This state indicates the sending process has been aborted by sink device.
     * @since 12
     */
    ABORT = 5,
  }

  /**
   * Basic description information of sending files.
   * @interface SendInfo
   * @since 12
   */
  interface SendInfo {
    /**
     * The progress fo send files in percent, from 0 to 100.
     * @type { number }
     * @since 12
     */
    progress: number;

    /**
     * The type of shared files：
     *
     * @type { ShareType }
     * @since 12
     */
    type: ShareType;

    /**
     * The list of sending files.
     * @type { Array<ShareFileInfo> }
     * @since 12
     */
    files: Array<ShareFileInfo>;

    /**
     * The speed of sending files, in bytes per second：
     * @type { number }
     * @since 12
     */
    speed: number;
  }

  /**
   * Creates an {@code ShareManager} instance.
   *
   * To share files, you must first call this method to obtain a {@code DeviceManager} instance and then
   * use this instance to call other share methods.
   *
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @returns { ShareManager } - Return the ShareManager object.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *                                                  1. Mandatory parameters are left unspecified;
   *                                                  2. Incorrect parameter type;
   *                                                  3. Parameter verification failed.
   * @since 12
   */
  function createShareManager(bundleName: string): ShareManager;

  /**
   * Releases the {@code ShareManager} instance that is no longer used.
   *
   * @param { ShareManager } shareManager - Indicates the {@code ShareManager} instance.
   * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *                                                  1. Mandatory parameters are left unspecified;
   *                                                  2. Incorrect parameter types;
   *                                                  3. Parameter verification failed.
   * @throws { BusinessError } 11600101 - Failed to execute the function.
   * @since 12
   */
  function releaseShareManager(shareManager: ShareManager): void;

  /**
   * Provides methods for sharing files.
   *
   * @interface ShareManager
   * @since 12
   */
  interface ShareManager {
    /**
     * Enable file share.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    enableShare(): void;

    /**
     * Disable file share.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    disableShare(): void;

    /**
     * Get file share status.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    getShareStatus(): boolean;

    /**
     * Start to scan share devices.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    startScan(): void;

    /**
     * Stop scanning share devices.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    stopScan(): void;

    /**
     * Connect the special device.
     *
     * @param { string } deviceId - id of device to connect.
     * @param { object } bindParam - parameters of device to bind, The parameter type is map,such as:
     *      "bindType" : 1,           - This value is type of bind, the values are as follows:
     *                                  1 - The bind type is pin code .
     *      "targetPkgName" : "xxxx", - The package name of binding target.
     *      "fileInfo" : "xxxx" - The information of files.
     * @param { AsyncCallback<{deviceId: string;}> } callback - indicates the callback to be invoked upon bindDevice.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified deviceId is greater than 255.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 11600101 - Failed to execute the function.
     * @throws { BusinessError } 11600103 - Authentication unavailable.
     * @since 12
     */
    connect(deviceId: string, bindParam: { [key: string]: Object },
      callback: AsyncCallback<{ deviceId: string }>): void;

    /**
     * Disconnect the special device.
     *
     * @param { string } deviceId - The id of device to disconnect
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified deviceId is greater than 255.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 11600101 - Failed to execute the function.
     * @since 12
     */
    disconnect(deviceId: string): void;

    /**
     * Confirm the connection from source device.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    confirmConnect(): void;

    /**
     * Refuse the connection from source device.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    refuseConnect(): void;

    /**
     * Start to send files.
     * @param { string } deviceId - The id of device.
     * @param { ShareType } type - The share type.
     * @param { Array<FileInfo> } files - The information of files.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    sendFile(deviceId: string, type: ShareType, files: Array<ShareFileInfo>): void;

    /**
     * Cancel to send files.
     * @param { string } deviceId - The id of device.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    cancelSendFile(deviceId: string): void;

    /**
     * Abort to receiving files.
     * @param { string } deviceId - The id of device.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    abortReceiveFile(deviceId: string): void;

    /**
     * Register a device state callback so that the application can be notified upon connection state changes based on
     * the application bundle name.
     *
     * @param { 'connectionChange' } type - Connection state change.
     * @param { Callback<{ action: ShareDeviceStateChange; device: ShareDeviceInfo; }> } callback
     * Indicates the device state callback to register.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @since 12
     */
    on(type: 'connectionChange', callback: Callback<{
      action: ShareDeviceStateChange;
      device: ShareDeviceInfo;
    }>): void;

    /**
     * UnRegister device state callback based on the application bundle name.
     *
     * @param { 'connectionChange' } type - Connection state change.
     * Indicates the connection state callback to unregister.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @since 12
     */
    off(type: 'connectionChange'): void;

    /**
     * Register a device discovery result callback so that the application can be notified when discovery success.
     *
     * @param { 'discoverSuccess' } type - Successfully discovered device.
     * @param { Callback<{ device: ShareDeviceInfo; }> } callback - Indicates the device discovery callback to register.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @since 12
     */
    on(type: 'discoverSuccess', callback: Callback<{
      device: ShareDeviceInfo;
    }>): void;

    /**
     * UnRegister the device discovery result callback.
     *
     * @param { 'discoverSuccess' } type - Successfully discovered device.
     * @param { Callback<{ device: ShareDeviceInfo; }> } callback - Indicates the device discovery callback to unregister.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @since 12
     */
    off(type: 'discoverSuccess'): void;

    /**
     * Register a device discovery result callback so that the application can be notified when discover failed.
     *
     * @param { 'discoverFailure' } type - Discovery Device Failure.
     * @param { Callback<{ reason: number; }> } callback
     * Indicates the device found result callback to register.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @since 12
     */
    on(type: 'discoverFailure', callback: Callback<{
      reason: number;
    }>): void;

    /**
     * UnRegister the device discovery result callback.
     *
     * @param { 'discoverFailure' } type - Discovery Device Failure.
     * @param { Callback<{ reason: number; }> } callback
     * Indicates the device found result callback to unregister.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @since 12
     */
    off(type: 'discoverFailure'): void;

    /**
     * Register send state changes.
     *
     * @param { 'connectionChange' } type - Send state change.
     * @param { Callback<{ state: SendState; info: SendInfo; }> } callback
     * Indicates the send state callback to register.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @since 12
     */
    on(type: 'sendChange', callback: Callback<{
      state: SendState;
      info: SendInfo;
    }>): void;

    /**
     * Unregister send state changes.
     *
     * @param { 'sendChange' } type - Send state change.
     * Indicates the send state callback to unregister.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @since 12
     */
    off(type: 'sendChange'): void;

    /**
     * Register share status changes.
     *
     * @param { 'shareStatusChange' } type - Share status change.
     * @param { Callback<boolean> } callback
     * Indicates the share status change callback to register.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @since 12
     */
    on(type: 'shareStatusChange', callback: Callback<boolean>): void;

    /**
     * Unregister share status changes.
     *
     * @param { 'shareStatusChange' } type - Send state change.
     * Indicates the share status change callback to unregister.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @since 12
     */
    off(type: 'shareStatusChange'): void;

    /**
     * Get shared files storage path.
     *
     * @returns { string } - Return the absolute path to storage shared files.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    getShareStoragePath(): string;

    /**
     * Set shared files storage path.
     *
     * @param { string } path - The path to storage shared files.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    setShareStoragePath(path: string): void;


    /**
     * Get share service opening time.
     *
     * @returns { number } - Return the duration of share service in minutes, 0 means the share service will not close automatically.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    getShareOpenTime(): number;

    /**
     * Set share service opening time.
     *
     * @param { number } time - The duration of share service in minutes, 0 means the share service will not close automatically.
     * @throws {BusinessError} 201 - Permission denied.
     * @throws {BusinessError} 202 - System API is not allowed called by Non-system application.
     * @throws {BusinessError} 801 - Capability not supported.
     * @throws {BusinessError} 2501000 - Operation failed.or inner system use.
     * @since 12
     */
    setShareOpenTime(time: number): void;

    /**
     * Register a callback from deviceManager service so that the share app can be notified when authStateChanges.
     *
     * @param { 'authStateChange' } type - Ui reply result to register.
     * @param { Callback<{ param: string; }> } callback - Indicates the devicemanager ui state to register.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
     * @since 12
     */
    on(type: 'authStateChange', callback: Callback<{ param: string }>): void;

    /**
     * Unregister uiStateChange.
     *
     * @param { 'authStateChange' } type - Ui reply result to unregister.
     * @param { Callback<{ param: string; }> } callback - Indicates the devicemanager ui state to unregister.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter type;
     *                                                  3. Parameter verification failed;
     *                                                  4. The size of specified type is greater than 255.
     * @throws { BusinessError } 202 - Permission verification failed. A non-system application calls a system API.
     * @since 12
     */
    off(type: 'authStateChange'): void;

    /**
     * Get a list of available devices. This interface query all authorized and connectable devices.
     *
     * @returns { Array<ShareDeviceInfo> } - Returns a list of available devices.
     * @throws { BusinessError } 201 - Permission verification failed. The application does not have the permission required to call the API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes:
     *                                                  1. Mandatory parameters are left unspecified;
     *                                                  2. Incorrect parameter types;
     *                                                  3. Parameter verification failed.
     * @throws { BusinessError } 11600101 - Failed to execute the function.
     * @since 12
     */
    getAvailableDeviceList(): Array<ShareDeviceInfo>;
  }
}

export default OneConnectFileShare;