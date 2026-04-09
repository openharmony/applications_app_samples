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

import { AsyncCallback , Callback } from './@ohos.base'

/**
 * @namespace usbSetting
 * @syscap SystemCapability.Multimedia.TvService.Display
 * @atomicservice
 * @since 12
 */
declare namespace usbSetting {
  enum UsbPortType {
    USB1,
    USB2,
    USB3,
    USB4,
    USB_BUTT
  }

  /* Usb使能 */
  function UsbEnable(usbport: UsbPortType, enable: boolean, callback: AsyncCallback<boolean>): void;
  function UsbEnable(usbport: UsbPortType, enable: boolean): Promise<boolean>;

  /*获取Usb使能状态*/
  function IsUsbEnable(usbport: UsbPortType, callback: AsyncCallback<boolean>): void;
  function IsUsbEnable(usbport: UsbPortType): Promise<boolean>;

  /*获取支持源列表*/
  function GetSupportUsbList(callback: AsyncCallback<Array<UsbPortType>>):void;
  function GetSupportUsbList(): Promise<Array<UsbPortType>>;
}

export default usbSetting;