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

import { AsyncCallback, Callback } from './basic';

/**
 * Providers interfaces to create a {@link deviceManager} instances.
 *
 * @since 7
 * @Syscap SystemCapability.DISTRIBUTEDHARDWARE.deviceManager
 *
 */
declare namespace deviceManager {
  /**
   * DeviceInfo
   *
   * @systemapi this method can be used only by system applications.
   */
  interface DeviceInfo {
    /**
     * DeviceId ID.
     */
    deviceId: string;

    /**
     * Device name of the device.
     */
    deviceName: string;

    /**
     * Device type of the device.
     */
    deviceType: DeviceType;

    /**
     * NetworkId of the device.
     *
     * @since 8
     */
    networkId: string;

    /**
     * @since 9
     * The distance of dicovered device, in centimeters(cm).
     */
    range: number;
  }

  /**
   * Device Type definitions
   */
  enum DeviceType {
    /**
     * Indicates an unknown device type.
     */
    UNKNOWN_TYPE = 0,

    /**
     * Indicates a speaker.
     */
    SPEAKER = 0x0A,

    /**
     * Indicates a smartphone.
     */
    PHONE = 0x0E,

    /**
     * Indicates a tablet.
     */
    TABLET = 0x11,

    /**
     * Indicates a smart watch.
     */
    WEARABLE = 0x6D,

    /**
     * Indicates a car.
     */
    CAR = 0x83,

    /**
     * Indicates a smart TV.
     */
    TV = 0x9C
  }

  /**
   * Device state change event definition
   *
   * @systemapi this method can be used only by system applications.
   */
  enum DeviceStateChangeAction {
    /**
     * device online action
     */
    ONLINE = 0,

    /**
     * device ready action, the device information synchronization was completed.
     */
    READY = 1,

    /**
     * device offline action
     */
    OFFLINE = 2,

    /**
     * device change action
     */
    CHANGE = 3
  }

  /**
   * Service subscribe info for device discover
   *
   * @systemapi this method can be used only by system applications.
   */
  interface SubscribeInfo {
    /**
     * Service subscribe ID, the value is in scope [0, 65535], should be unique for each discover process
     */
    subscribeId: number;

    /**
     * Discovery mode for service subscription.
     */
    mode: DiscoverMode;

    /**
     * Service subscription medium.
     */
    medium: ExchangeMedium;

    /**
     * Service subscription frequency.
     */
    freq: ExchangeFreq;

    /**
     * only find the device with the same account.
     */
    isSameAccount: boolean;

    /**
     * find the sleeping devices.
     */
    isWakeRemote: boolean;

    /**
     * Subscribe capability.
     */
    capability: SubscribeCap;
  }

  /**
   * Service publish info for device discover
   * @since 9
   * @systemapi this method can be used only by system applications.
   */
  interface PublishInfo {
    /**
     * Service publish ID, the value is in scope [0, 65535], should be unique for each publish process
     */
    publishId: number;

    /**
     * Discovery mode for service subscription.
     */
    mode: DiscoverMode;

    /**
     * Service subscription frequency.
     */
    freq: ExchangeFreq;

    /**
     *  Whether the device should be ranged by discoverers.
     */
    ranging : boolean;
  }

  /**
   * device discover mode
   *
   * @systemapi this method can be used only by system applications.
   */
  enum DiscoverMode {
    /**
     * when using this key at client side, it means discovering for available nearby devices by
     * calling @startDeviceDiscovery function, while using this key at server side indicating that
     * a device publication or advertisement by calling @publishDeviceDiscovery.
     */
    DISCOVER_MODE_PASSIVE = 0x55,

    /**
     * when using this key at server side, it means discovering for available nearby devices by
     * calling @startDeviceDiscovery function, while using this key at client side indicating that
     * a device publication or advertisement by calling @publishDeviceDiscovery.
     */
    DISCOVER_MODE_ACTIVE = 0xAA
  }

  /**
   * device discover medium
   *
   * @systemapi this method can be used only by system applications.
   */
  enum ExchangeMedium {
    /**
     * Automatic medium selection
     */
    AUTO = 0,

    /**
     * Bluetooth
     */
    BLE = 1,

    /**
     * Wi-Fi
     */
    COAP = 2,

    /**
     * USB
     */
    USB = 3
  }

  /**
   * device discover freq
   *
   * @systemapi this method can be used only by system applications.
   */
  enum ExchangeFreq {
    /**
     * Low
     */
    LOW = 0,

    /**
     * Medium
     */
    MID = 1,

    /**
     * High
     */
    HIGH = 2,

    /**
     * Super-high
     */
    SUPER_HIGH = 3
  }

  /**
   * device discover capability
   *
   * @systemapi this method can be used only by system applications.
   */
  enum SubscribeCap {
    /**
     * ddmpCapability, will be discarded later. Currently, it will be converted to OSD capability inner.
     */
    SUBSCRIBE_CAPABILITY_DDMP = 0,

    /**
     * One Super Device Capability
     */
    SUBSCRIBE_CAPABILITY_OSD = 1
  }

  /**
   * Device Authentication param
   *
   * @systemapi this method can be used only by system applications
   */
  interface AuthParam {
    /**
     * Authentication type, 1 for pin code.
     */
    authType: number;

    /**
     * Authentication extra infos.
     */
    extraInfo: {[key:string] : any};
  }

  /**
   * Device auth info.
   *
   * @systemapi this method can be used only by system applications
   */
  interface AuthInfo {
    /**
     * Authentication type, 1 for pin code.
     */
    authType: number;

    /**
     * the token used for this authentication.
     */
    token: number;

    /**
     * Authentication extra infos.
     */
    extraInfo: {[key:string] : any};
  }

  /**
   * Creates a {@code DeviceManager} instance.
   *
   * <p>To manage devices, you must first call this method to obtain a {@code DeviceManager} instance and then
   * use this instance to call other device management methods.
   *
   * @param bundleName Indicates the bundle name of the application.
   * @param callback Indicates the callback to be invoked upon {@code DeviceManager} instance creation.
   * @systemapi this method can be used only by system applications.
   */
  function createDeviceManager(bundleName: string, callback: AsyncCallback<DeviceManager>): void;

  /**
   * Provides methods for managing devices.
   */
  interface DeviceManager {
    /**
     * Releases the {@code DeviceManager} instance after the methods for device management are no longer used.
     *
     * @systemapi this method can be used only by system applications.
     */
    release(): void;

    /**
     * Obtains a list of trusted devices.
     *
     * @return Returns a list of trusted devices.
     * @systemapi this method can be used only by system applications.
     */
    getTrustedDeviceListSync(): Array<DeviceInfo>;

    /**
     * Obtains a list of trusted devices.
     *
     * @since 8
     * @param callback Indicates the callback to be invoked upon getTrustedDeviceList
     * @return Returns a list of trusted devices.
     * @systemapi this method can be used only by system applications.
     */
    getTrustedDeviceList(callback:AsyncCallback<Array<DeviceInfo>>): void;

    /**
     * Obtains a list of trusted devices.
     *
     * @since 8
     * @return Returns a list of trusted devices.
     * @systemapi this method can be used only by system applications.
     */
    getTrustedDeviceList(): Promise<Array<DeviceInfo>>;

    /**
     * Obtains local device info
     *
     * @since 8
     * @return Returns local device info.
     * @systemapi this method can be used only by system applications.
     */
    getLocalDeviceInfoSync(): DeviceInfo;

    /**
     * Obtains local device info
     *
     * @since 8
     * @param callback Indicates the callback to be invoked upon getLocalDeviceInfo
     * @return Returns local device info.
     * @systemapi this method can be used only by system applications.
     */
    getLocalDeviceInfo(callback:AsyncCallback<DeviceInfo>): void;

    /**
     * Obtains local device info
     *
     * @since 8
     * @return Returns local device info.
     * @systemapi this method can be used only by system applications.
     */
    getLocalDeviceInfo(): Promise<DeviceInfo>;

    /**
     * Start to discover device.
     *
     * @since 8
     * @param subscribeInfo subscribe info to discovery device
     * @systemapi this method can be used only by system applications.
     */
    startDeviceDiscovery(subscribeInfo: SubscribeInfo): void;

    /**
     * Start to discover device.
     *
     * @since 9
     * @param subscribeInfo subscribe info to discovery device
     * @param filterOptions filterOptions to filter discovery device
     * @systemapi this method can be used only by system applications.
     */
    startDeviceDiscovery(subscribeInfo: SubscribeInfo, filterOptions?: string): void;

    /**
     * Stop to discover device.
     *
     * @param subscribeId Service subscribe ID
     * @systemapi this method can be used only by system applications.
     */
    stopDeviceDiscovery(subscribeId: number): void;

    /**
     * Publish discover device.
     * @since 9
     * @param publishInfo publish info to Publish discovery device
     * @systemapi this method can be used only by system applications.
     */
    publishDeviceDiscovery(publishInfo: PublishInfo): void;

    /**
     * UnPublish discover device.
     * @since 9
     * @param publishId Service publish ID, identify a publish operation, should be a unique id in package range
     * @systemapi this method can be used only by system applications.
     */
    unPublishDeviceDiscovery(publishId: number): void;

    /**
     * Authenticate the specified device.
     *
     * @param deviceInfo deviceInfo of device to authenticate
     * @param authParam authParam of device to authenticate
     * @param callback Indicates the callback to be invoked upon authenticateDevice
     * @systemapi this method can be used only by system applications.
     */
    authenticateDevice(deviceInfo: DeviceInfo, authParam: AuthParam, callback: AsyncCallback<{deviceId: string, pinTone ?: number}>): void;

    /**
     * unAuthenticate the specified device.
     *
     * @since 8
     * @param deviceInfo deviceInfo of device to unAuthenticate
     * @systemapi this method can be used only by system applications.
     */
    unAuthenticateDevice(deviceInfo: DeviceInfo): void

     /**
     * verify auth info, such as pin code.
     *
     * @param authInfo device auth info o verify
     * @param callback Indicates the callback to be invoked upon verifyAuthInfo
     * @systemapi this method can be used only by system applications.
     */
    verifyAuthInfo(authInfo: AuthInfo, callback: AsyncCallback<{deviceId: string, level: number}>): void;

    /**
     * Set user Operation from devicemanager ui, this interface can only be used by devicemanager ui.
     *
     * @since 9
     * @param operateAction User Operation Actions.
     *        operateAction = 0 - allow authentication
     *        operateAction = 1 - cancel authentication
     *        operateAction = 2 - user operation timeout for authentication confirm
     *        operateAction = 3 - cancel pincode display
     *        operateAction = 4 - cancel pincode input
     *        operateAction = 5 - confirm pincode input
     * @param params Indicates the input param of the user.
     * @throws {BusinessError} 401 - Input parameter error.
     * @systemapi this method can be used only by system applications.
     */  
    setUserOperation(operateAction: number, params: string): void;

    /**
    * Register a callback from deviceManager service so that the devicemanager ui can be notified when ui statue
    * changes.
    *
    * @since 9
    * @param callback Indicates the devicemanager ui state to register.
    * @throws {BusinessError} 401 - Input parameter error.
    * @systemapi this method can be used only by system applications.
    */
    on(type: 'uiStateChange', callback: Callback<{ param: string}>): void;

    /**
     * Unregister uiStatueChange, this interface can only be used by devicemanager ui.
     *
     * @since 9
     * @param callback Indicates the devicemanager ui state to unregister.
     * @throws {BusinessError} 401 - Input parameter error.
     * @systemapi this method can be used only by system applications.
     */
    off(type: 'uiStateChange', callback?: Callback<{ param: string}>): void;

    /**
     * Register a device state callback so that the application can be notified upon device state changes based on
     * the application bundle name.
     *
     * @param bundleName Indicates the bundle name of the application.
     * @param callback Indicates the device state callback to register.
     * @systemapi this method can be used only by system applications.
     */
    on(type: 'deviceStateChange', callback: Callback<{ action: DeviceStateChangeAction, device: DeviceInfo }>): void;

    /**
     * UnRegister device state callback based on the application bundle name.
     *
     * @param bundleName Indicates the bundle name of the application.
     * @param callback Indicates the device state callback to register.
     * @systemapi this method can be used only by system applications.
     */
    off(type: 'deviceStateChange', callback?: Callback<{ action: DeviceStateChangeAction, device: DeviceInfo }>): void;

    /**
     * Register a device found callback so that the application can be notified when the device was found
     *
     * @param callback Indicates the device found callback to register.
     * @systemapi this method can be used only by system applications.
     */
    on(type: 'deviceFound', callback: Callback<{ subscribeId: number, device: DeviceInfo }>): void;

    /**
     * UnRegister a device found callback so that the application can be notified when the device was found
     *
     * @param callback Indicates the device found callback to register.
     * @systemapi this method can be used only by system applications.
     */
    off(type: 'deviceFound', callback?: Callback<{ subscribeId: number, device: DeviceInfo }>): void;

    /**
     * Register a device found result callback so that the application can be notified when the device discover was failed
     *
     * @param callback Indicates the device found result callback to register.
     * @systemapi this method can be used only by system applications.
     */
    on(type: 'discoverFail', callback: Callback<{ subscribeId: number, reason: number }>): void;

    /**
     * UnRegister a device found result callback so that the application can be notified when the device discover was failed
     *
     * @param callback Indicates the device found result callback to register.
     * @systemapi this method can be used only by system applications.
     */
    off(type: 'discoverFail', callback?: Callback<{ subscribeId: number, reason: number }>): void;

    /**
     * Register a device publish result callback so that the application can be notified when the device publish success
     *
     * @since 9
     * @param callback Indicates the device publish result callback to register.
     * @systemapi this method can be used only by system applications.
     */
     on(type: 'publishSuccess', callback: Callback<{ publishId: number }>): void;

    /**
     * UnRegister a device publish result callback so that the application can be notified when the device publish was failed
     *
     * @since 9
     * @param callback Indicates the device publish result callback to register.
     * @systemapi this method can be used only by system applications.
     */
     off(type: 'publishSuccess', callback?: Callback<{ publishId: number }>): void;

    /**
     * Register a device publish result callback so that the application can be notified when the device publish was failed
     *
     * @since 9
     * @param callback Indicates the device publish result callback to register.
     * @systemapi this method can be used only by system applications.
     */
     on(type: 'publishFail', callback: Callback<{ publishId: number, reason: number }>): void;

    /**
     * UnRegister a device publish result callback so that the application can be notified when the device publish was failed
     *
     * @since 9
     * @param callback Indicates the device publish result callback to register.
     * @systemapi this method can be used only by system applications.
     */
     off(type: 'publishFail', callback?: Callback<{ publishId: number, reason: number }>): void;

    /**
     * Register a serviceError callback so that the application can be notified when devicemanager service died
     *
     * @param callback Indicates the service error callback to register.
     * @systemapi this method can be used only by system applications.
     */
    on(type: 'serviceDie', callback: () => void): void;

    /**
     * UnRegister a serviceError callback so that the application can be notified when devicemanager service died
     *
     * @param callback Indicates the service error callback to register.
     * @systemapi this method can be used only by system applications.
     */
    off(type: 'serviceDie', callback?: () => void): void;
  }
}

export default deviceManager;
