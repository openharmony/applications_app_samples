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
 * @kit NetworkKit
 */

import type { AsyncCallback, Callback } from './@ohos.base';
import type connection from './@ohos.net.connection';

/**
 * Provides interfaces to manage ethernet.
 * @namespace ethernet
 * @syscap SystemCapability.Communication.NetManager.Ethernet
 * @since 9
 */
declare namespace ethernet {
  /**
   * @typedef { connection.HttpProxy }
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @since 10
   */
  type HttpProxy = connection.HttpProxy;

  /**
   * Get the specified network interface information.
   * @permission ohos.permission.GET_NETWORK_INFO
   * @param { string } iface - Indicates the network interface name.
   * @param { AsyncCallback<InterfaceConfiguration> } callback - the callback of getIfaceConfig.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Parameter error.
   * @throws { BusinessError } 2200001 - Invalid parameter value.
   * @throws { BusinessError } 2200002 - Failed to connect to the service.
   * @throws { BusinessError } 2200003 - System internal error.
   * @throws { BusinessError } 2201005 - Device information does not exist.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 9
   */
  function getIfaceConfig(iface: string, callback: AsyncCallback<InterfaceConfiguration>): void;

  /**
   * Get the specified network interface information.
   * @permission ohos.permission.GET_NETWORK_INFO
   * @param { string } iface - Indicates the network interface name.
   * @returns { Promise<InterfaceConfiguration> } the promise returned by the function.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Parameter error.
   * @throws { BusinessError } 2200001 - Invalid parameter value.
   * @throws { BusinessError } 2200002 - Failed to connect to the service.
   * @throws { BusinessError } 2200003 - System internal error.
   * @throws { BusinessError } 2201005 - Device information does not exist.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 9
   */
  function getIfaceConfig(iface: string): Promise<InterfaceConfiguration>;

  /**
   * Set the specified network interface parameters.
   * @permission ohos.permission.CONNECTIVITY_INTERNAL
   * @param { string } iface - Indicates the network interface name of the network parameter.
   * @param { InterfaceConfiguration } ic - Indicates the ic. See {@link InterfaceConfiguration}.
   * @param { AsyncCallback<void> } callback - the callback of setIfaceConfig.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Parameter error.
   * @throws { BusinessError } 2200001 - Invalid parameter value.
   * @throws { BusinessError } 2200002 - Failed to connect to the service.
   * @throws { BusinessError } 2200003 - System internal error.
   * @throws { BusinessError } 2201004 - Invalid Ethernet profile.
   * @throws { BusinessError } 2201005 - Device information does not exist.
   * @throws { BusinessError } 2201006 - Ethernet device not connected.
   * @throws { BusinessError } 2201007 - Ethernet failed to write user configuration information.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 9
   */
  function setIfaceConfig(iface: string, ic: InterfaceConfiguration, callback: AsyncCallback<void>): void;

  /**
   * Set the specified network interface parameters.
   * @permission ohos.permission.CONNECTIVITY_INTERNAL
   * @param { string } iface - Indicates the network interface name of the network parameter.
   * @param { InterfaceConfiguration } ic - Indicates the ic. See {@link InterfaceConfiguration}.
   * @returns { Promise<void> } the promise returned by the function.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Parameter error.
   * @throws { BusinessError } 2200001 - Invalid parameter value.
   * @throws { BusinessError } 2200002 - Failed to connect to the service.
   * @throws { BusinessError } 2200003 - System internal error.
   * @throws { BusinessError } 2201004 - Invalid Ethernet profile.
   * @throws { BusinessError } 2201005 - Device information does not exist.
   * @throws { BusinessError } 2201006 - Ethernet device not connected.
   * @throws { BusinessError } 2201007 - Ethernet failed to write user configuration information.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 9
   */
  function setIfaceConfig(iface: string, ic: InterfaceConfiguration): Promise<void>;

  /**
   * Check whether the specified network is active.
   * @permission ohos.permission.GET_NETWORK_INFO
   * @param { string } iface - Indicates the network interface name.
   * @param { AsyncCallback<number> } callback - the callback of isIfaceActive.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Parameter error.
   * @throws { BusinessError } 2200001 - Invalid parameter value.
   * @throws { BusinessError } 2200002 - Failed to connect to the service.
   * @throws { BusinessError } 2200003 - System internal error.
   * @throws { BusinessError } 2201005 - Device information does not exist.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 9
   */
  function isIfaceActive(iface: string, callback: AsyncCallback<number>): void;

  /**
   * Check whether the specified network is active.
   * @permission ohos.permission.GET_NETWORK_INFO
   * @param { string } iface - Indicates the network interface name.
   * @returns { Promise<number> } the promise returned by the function. 
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Parameter error.
   * @throws { BusinessError } 2200001 - Invalid parameter value.
   * @throws { BusinessError } 2200002 - Failed to connect to the service.
   * @throws { BusinessError } 2200003 - System internal error.
   * @throws { BusinessError } 2201005 - Device information does not exist.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 9
   */
  function isIfaceActive(iface: string): Promise<number>;

  /**
   * Gets the names of all active network interfaces.
   * @permission ohos.permission.GET_NETWORK_INFO
   * @param { AsyncCallback<Array<string>> } callback - the callback of getAllActiveIfaces.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 2200002 - Failed to connect to the service.
   * @throws { BusinessError } 2200003 - System internal error.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 9
   */
  function getAllActiveIfaces(callback: AsyncCallback<Array<string>>): void;

  /**
   * Gets the names of all active network interfaces.
   * @permission ohos.permission.GET_NETWORK_INFO
   * @returns { Promise<Array<string>> } the promise returned by the function.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 2200002 - Failed to connect to the service.
   * @throws { BusinessError } 2200003 - System internal error.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 9
   */
  function getAllActiveIfaces(): Promise<Array<string>>;

  /**
   * Register a callback for the ethernet interface active state change.
   * @permission ohos.permission.GET_NETWORK_INFO
   * @param { 'interfaceStateChange' } type - Indicates Event name.
   * @param { Callback<{ iface: string, active: boolean }> } callback - Including iface Indicates the ethernet interface,
   * and active Indicates whether the interface is active.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Parameter error.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 10
   */
  /**
   * Register a callback for the ethernet interface active state change.
   * @permission ohos.permission.GET_NETWORK_INFO
   * @param { 'interfaceStateChange' } type - Indicates Event name.
   * @param { Callback<InterfaceStateInfo> } callback - Including iface Indicates the ethernet interface,
   * and active Indicates whether the interface is active.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Parameter error.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 11
   */
  function on(type: 'interfaceStateChange', callback: Callback<InterfaceStateInfo>): void;

  /**
   * Unregister a callback from the ethernet interface active state change.
   * @permission ohos.permission.GET_NETWORK_INFO
   * @param { 'interfaceStateChange' } type - Indicates Event name.
   * @param { Callback<{ iface: string, active: boolean }> } callback - Including iface Indicates the ethernet interface,
   * and active Indicates whether the interface is active.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Parameter error.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 10
   */
  /**
   * Unregister a callback from the ethernet interface active state change.
   * @permission ohos.permission.GET_NETWORK_INFO
   * @param { 'interfaceStateChange' } type - Indicates Event name.
   * @param { Callback<InterfaceStateInfo> } callback - Including iface Indicates the ethernet interface,
   * and active Indicates whether the interface is active.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 401 - Parameter error.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 11
   */
  function off(type: 'interfaceStateChange', callback?: Callback<InterfaceStateInfo>): void;

  /**
   * Get the ethernet mac address list.
   * @permission ohos.permission.GET_ETHERNET_LOCAL_MAC
   * @returns { Promise<Array<string>> } the promise returned by the function.
   * @throws { BusinessError } 201 - Permission denied.
   * @throws { BusinessError } 202 - Non-system applications use system APIs.
   * @throws { BusinessError } 2200002 - Operation failed. Cannot connect to service.
   * @throws { BusinessError } 2201005 - Device information does not exist.
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 13
   */
  function getMacAddress(): Promise<Array<MacAddressInfo>>;

  /**
   * Defines the network configuration for the Ethernet connection.
   * @interface InterfaceConfiguration
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 9
   */
  export interface InterfaceConfiguration {
    /**
     * @type {IPSetMode}
     * See {@link IPSetMode}
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 9
     */
    mode: IPSetMode;
    /**
     * Ethernet connection static configuration IP information.
     * The address value range is 0-255.0-255.0-255.0-255.0-255
     * (DHCP mode does not need to be configured)
     * @type {string}
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 9
     */
    ipAddr: string;

    /**
     * Ethernet connection static configuration route information.
     * The address value range is 0-255.0-255.0-255.0-255.0-255
     * (DHCP mode does not need to be configured)
     * @type {string}
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 9
     */
    route: string;

    /**
     * Ethernet connection static configuration gateway information.
     * The address value range is 0-255.0-255.0-255.0-255.0-255
     * (DHCP mode does not need to be configured)
     * @type {string}
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 9
     */
    gateway: string;

    /**
     * Ethernet connection static configuration netMask information.
     * The address value range is 0-255.0-255.0-255.0-255.0-255
     * (DHCP mode does not need to be configured)
     * @type {string}
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 9
     */
    netMask: string;

    /**
     * The Ethernet connection is configured with the dns service address.
     * The address value range is 0-255.0-255.0-255.0-255.0-255
     * (DHCP mode does not need to be configured, Multiple addresses are separated by ",")
     * @type {string}
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 9
     */
    dnsServers: string;

    /**
     * Indicates the HttpProxy settings, no proxy is to be used as default.
     * @type {?HttpProxy}
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 10
     */
    httpProxy?: HttpProxy;
  }

  /**
   * The interface is used to monitor network interface status changes.
   * @interface InterfaceStateInfo
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 11
   */
  export interface InterfaceStateInfo {
    /**
     * Define network card name.
     * @type { string }
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 11
     */
    iface: string;
    /**
     * Check if it is active.
     * @type { boolean }
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 11
     */
    active: boolean;
  }

  /**
   * Defines the configuration mode of the Ethernet connection.
   * @enum {number}
   * @syscap SystemCapability.Communication.NetManager.Ethernet
   * @systemapi Hide this for inner system use.
   * @since 9
   */
  export enum IPSetMode {
    /**
     * WAN Static configuration.
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 9
     */
    STATIC = 0,

    /**
     * WAN Dynamic configuration.
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 9
     */
    DHCP = 1,

    /**
     * LAN Static configuration.
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 11
     */
    LAN_STATIC = 2,

    /**
     * LAN Dynamic configuration.
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @systemapi Hide this for inner system use.
     * @since 11
     */
    LAN_DHCP = 3
  }

    /**
     * Defines the mac address info of the Ethernet.
     * @interface MacAddressInfo
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @since 14
     */
    export interface MacAddressInfo {
    /**
     * Ethernet interface name.
     * @type { string }
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @since 14
     */
    iface: string;

    /**
     * Ethernet specific mac address.
     * @type { string }
     * @syscap SystemCapability.Communication.NetManager.Ethernet
     * @since 14
     */
    macAddress: string;
  }
}

export default ethernet;