import { AsyncCallback , Callback } from './@ohos.base'

/**
 * @namespace hdmitxSetting
 * @syscap SystemCapability.Multimedia.TvService.Display
 * @atomicservice
 * @since 12
 */
declare namespace hdmitxSetting {
  enum HdmitxPortType {
    HDMITX_HDMI1,
    HDMITX_HDMI2,
    HDMITX_HDMI3,
    HDMITX_HDMI4,
    HDMITX_BUTT
  }


  /* HDMITX使能 */
  function HDMITXEnable(hdmitxport: HdmitxPortType, enable: boolean, callback: AsyncCallback<boolean>): void;
  function HDMITXEnable(hdmitxport: HdmitxPortType, enable: boolean): Promise<boolean>;

  /*获取HDMITX使能状态*/
  function IsHDMITXEnable(hdmitxport: HdmitxPortType, callback: AsyncCallback<boolean>): void;
  function IsHDMITXEnable(hdmitxport: HdmitxPortType): Promise<boolean>;

  /*获取hdmitx支持源列表*/
  function GetSupportHdmitxList(callback: AsyncCallback<Array<HdmitxPortType>>):void;
  function GetSupportHdmitxList(): Promise<Array<HdmitxPortType>>;
}

export default hdmitxSetting;