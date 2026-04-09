import { AsyncCallback , Callback } from './@ohos.base'

/**
 * @namespace Settings
 * @syscap SystemCapability.Multimedia.TvService.Display
 * @atomicservice
 * @since 12
 */
declare namespace Settings {
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

  /*获取usb支持源列表*/
  function GetSupportUsbList(callback: AsyncCallback<Array<UsbPortType>>):void; 
  function GetSupportUsbList(): Promise<Array<UsbPortType>>;
}

export default Settings;