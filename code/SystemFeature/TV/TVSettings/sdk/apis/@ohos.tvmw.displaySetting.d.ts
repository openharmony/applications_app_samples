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

import { AsyncCallback } from './@ohos.base'

/**
 * @namespace displaySetting
 * @syscap SystemCapability.Multimedia.TvMW.Display
 * @atomicservice
 * @since 12
 */
declare namespace displaySetting {
interface ColorTempParam {
    redGain: number;
    greenGain: number;
    blueGain: number;
    redOffset: number;
    greenOffset: number;
    blueOffset: number;
  }

  enum RandomNr {
    RANDOM_LEVEL_CLOSE = 0,
    RANDOM_LEVEL_LOW = 1,
    RANDOM_LEVEL_MEDIUM = 2,
    RANDOM_LEVEL_HIGH = 3,
    RANDOM_LEVEL_AUTO = 4
  }

  enum MPEGNr {
    MPEG_LEVEL_CLOSE = 0,
    MPEG_LEVEL_LOW = 1,
    MPEG_LEVEL_MEDIUM = 2,
    MPEG_LEVEL_HIGH = 3,
    MPEG_LEVEL_AUTO = 4
  }

  enum GammaType{
    GAMMA_TYPE_NATURE = 0,
    GAMMA_TYPE_COOL = 1,
    GAMMA_TYPE_WARM = 2,
    GAMMA_TYPE_TOCOOL = 3,
    GAMMA_TYPE_TOWARM = 4,
    GAMMA_TYPE_HDR10 = 5,
    GAMMA_TYPE_DOLBY = 6,
    GAMMA_TYPE_VIVID = 7,
    GAMMA_TYPE_BRIGHT = 8,
    GAMMA_TYPE_DARK = 9,
    GAMMA_TYPE_NATURE_18 = 10,
    GAMMA_TYPE_NATURE_19 = 11,
    GAMMA_TYPE_NATURE_20 = 12,
    GAMMA_TYPE_NATURE_21 = 13,
    GAMMA_TYPE_NATURE_23 = 14,
    GAMMA_TYPE_NATURE_24 = 15,
    GAMMA_TYPE_NATURE_25 = 16,
    GAMMA_TYPE_NATURE_26 = 17,
    GAMMA_TYPE_WARM_18 = 18, 
    GAMMA_TYPE_WARM_19 = 19,
    GAMMA_TYPE_WARM_20 = 20,
    GAMMA_TYPE_WARM_21 = 21,
    GAMMA_TYPE_WARM_23 = 22,
    GAMMA_TYPE_WARM_24 = 23,
    GAMMA_TYPE_WARM_25 = 24,
    GAMMA_TYPE_WARM_26 = 25
  }

  enum ColorTempPoint {
    COLOR_TEMP_5000K = 5000,
    COLOR_TEMP_5500K = 5500,
    COLOR_TEMP_6000K = 6000,
    COLOR_TEMP_6300K = 6300,
    COLOR_TEMP_6500K = 6500,
    COLOR_TEMP_7000K = 7000,
    COLOR_TEMP_7500K = 7500,
    COLOR_TEMP_8000K = 8000,
    COLOR_TEMP_8500K = 8500,
    COLOR_TEMP_9000K = 9000,
    COLOR_TEMP_9300K = 9300,
    COLOR_TEMP_9500K = 9500,
    COLOR_TEMP_10000K = 10000,
    COLOR_TEMP_10500K = 10500,
    COLOR_TEMP_11000K = 11000,
    COLOR_TEMP_11500K = 11500,
    COLOR_TEMP_12000K = 12000,
  }

  enum PictureMode {
    PICTURE_MODE_STANDARD = 0,
    PICTURE_MODE_VIVID = 1,
    PICTURE_MODE_MOVIE = 2,
    PICTURE_MODE_SPORTS = 3,
    PICTURE_MODE_PICTURE = 4,
    PICTURE_MODE_GAME = 5,
    PICTURE_MODE_EYEPROTECT = 6,
    PICTURE_MODE_AUTO = 7,
  }

  enum HdcpType {
    HDCP_AUTO = 1,
    HDCP_14 = 2,
    HDCP_2X = 3,
  }

  enum InputSource { 
    HDMI1 = 0,
    HDMI2 = 1,
    AV = 2
  }
  /**
   * 设置亮度
   */
  function setOutputBrightness(value: number, callback: AsyncCallback<boolean>): void;
  function setOutputBrightness(value: number): Promise<boolean>;
  function getOutputBrightness(): Promise<number>;
  /**
   * 设置动态对比度
   */
  function setOutputDciLevel(value: number, callback: AsyncCallback<boolean>): void;
  function setOutputDciLevel(value: number): Promise<boolean>;
  function getOutputDciLevel(): Promise<number>;
  /**
   * 设置锐利度
   */
  function setOutputSharpness(value: number, callback: AsyncCallback<boolean>): void;
  function setOutputSharpness(value: number): Promise<boolean>;
  function getOutputSharpness(): Promise<number>;
  /**
   * 开关动态背光
   */
  function enableDynamicBacklight(callback: AsyncCallback<boolean>): void;
  function enableDynamicBacklight(): Promise<boolean>;
  function disableDynamicBacklight(callback: AsyncCallback<boolean>): void;
  function disableDynamicBacklight(): Promise<boolean>;
  function isDynamicBacklight(): Promise<boolean>;

  /**
   * 色温精细调节
   */
  function setColorTempParamStep(param: ColorTempParam, callback: AsyncCallback<boolean>): void;
  function setColorTempParamStep(param: ColorTempParam): Promise<boolean>;
  function getColorTempParam(): Promise<ColorTempParam>;
  /**
   * 随机降噪
   */
  function setOutputNR(value: RandomNr, callback: AsyncCallback<boolean>): void;
  function setOutputNR(value: RandomNr): Promise<boolean>;
  function getOutputNR(): Promise<RandomNr>;
  /**
   * MPEG降噪
   */
  function setOutputMpegNR(value: MPEGNr, callback: AsyncCallback<boolean>): void;
  function setOutputMpegNR(value: MPEGNr): Promise<boolean>;
  function getOutputMpegNR(): Promise<MPEGNr>;
  /**
   * 图像模式
   */
  function setOutputPictureMode(mode: PictureMode, callback: AsyncCallback<boolean>): void;
  function setOutputPictureMode(mode: PictureMode): Promise<boolean>;
  /**
   * 伽马
   */
  function setOutputGrammaType(type: GammaType, callback: AsyncCallback<boolean>): void;
  function setOutputGrammaType(type: GammaType): Promise<boolean>;
  /**
   * 色温
   */
  function setColorTempType(colorTemp: ColorTempPoint, callback: AsyncCallback<boolean>): void;
  function setColorTempType(colorTemp: ColorTempPoint): Promise<boolean>;

  /**
   * 设置HDCP类型
   */
  function setHDMIHDCP(type: HdcpType, callback: AsyncCallback<boolean>): void;
  function setHDMIHDCP(type: HdcpType): Promise<boolean>;
  function getHDMIHDCP(): Promise<HdcpType>;
  /**
   * 输入源
   */
  function setInputSource(type: InputSource, callback: AsyncCallback<boolean>): void;
  function setInputSource(type: InputSource): Promise<boolean>;
  function getInputSource(): Promise<InputSource>;

  /**
       * Sets the saturation (chrominance) of the video output. This setting does not apply to a single video output unit. 
       * It takes effect for all video output units at the same time.
       * @devices tv, phone, tablet, wearable
       * @param value –number: Indicates the saturation (chrominance). The value ranges from 0 to 100 in ascending order.
       * @return Returns true if the setting is successful,returns false otherwise.
       */
  function setOutputSaturation(value: number, callback: AsyncCallback<boolean>): void;

  /**
    * Sets the saturation (chrominance) of the video output. This setting does not apply to a single video output unit. 
    * It takes effect for all video output units at the same time.
    * @devices tv, phone, tablet, wearable
    * @param value –number: Indicates the saturation (chrominance). The value ranges from 0 to 100 in ascending order.
    * @return Returns true if the setting is successful,returns false otherwise.
    */
  function setOutputSaturation(value: number): Promise<boolean>;

  /**
    * Obtains the saturation (chrominance) of the video output.
    * @devices tv, phone, tablet, wearable
    * @return Number type, indicating the saturation (chrominance) of the video output. The value ranges from 0 to 100 in ascending order.
    */
  function getOutputSaturation(): Promise<number>;

  /**
    * Sets the contrast of the video output. This setting does not apply to a single video output unit. 
    * It takes effect for all video output units at the same time.
    * @devices tv, phone, tablet, wearable
    * @param value –number: indicates the contrast of the video output. The value ranges from 0 to 100 in ascending order.
    * @return Returns true if the setting is successful,returns false otherwise.
    */
  function setOutputContrast(value: number, callback: AsyncCallback<boolean>): void;

  /**
    * Sets the contrast of the video output. This setting does not apply to a single video output unit. 
    * It takes effect for all video output units at the same time.
    * @devices tv, phone, tablet, wearable
    * @param value –number: indicates the contrast of the video output. The value ranges from 0 to 100 in ascending order.
    * @return Returns true if the setting is successful,returns false otherwise.
    */
  function setOutputContrast(value: number): Promise<boolean>;

  /**
    * Obtains the contrast of the video output.
    * @devices tv, phone, tablet, wearable
    * @return Number type, indicating the contrast of the video output. The value ranges from 0 to 100 in ascending order.
    */
  function getOutputContrast(): Promise<number>;

  /**
    * Sets the hue of the video output. This setting does not apply to a single video output unit. 
    * It takes effect for all video output units at the same time.
    * @devices tv, phone, tablet, wearable
    * @param value –number: indicates the hue of the video output. The value ranges from 0 to 100 in ascending order.
    * @return Returns true if the setting is successful,returns false otherwise.
    */
  function setDisplayHue(value: number, callback: AsyncCallback<boolean>): void;

  /**
    * Sets the hue of the video output. This setting does not apply to a single video output unit. 
    * It takes effect for all video output units at the same time.
    * @devices tv, phone, tablet, wearable
    * @param value –number: indicates the hue of the video output. The value ranges from 0 to 100 in ascending order.
    * @return Returns true if the setting is successful,returns false otherwise.
    */
  function setDisplayHue(value: number): Promise<boolean>;

  /**
    * Obtains the hue of the video output.
    * @devices tv, phone, tablet, wearable
    * @return Number type, indicating the hue of the video output. The value ranges from 0 to 100 in ascending order.
    */
  function getDisplayHue(): Promise<number>;

  /**
    * Set the HDR mode.
    * @devices tv, phone, tablet, wearable
    * @param type–number,0-HDRTYPE_SDR,1-HDRTYPE_DOLBY,2-HDRTYPE_HDR10,3-CHDRTYPE_AUTO
    * @return Returns true if the setting is successful,returns false otherwise.
    */
  function setHDRType(value: number, callback: AsyncCallback<number>): void;

  /**
    * Set the HDR mode. 
    * @devices tv, phone, tablet, wearable
    * @param type–number,0-HDRTYPE_SDR,1-HDRTYPE_DOLBY,2-HDRTYPE_HDR10,3-CHDRTYPE_AUTO
    * @return Returns true if the setting is successful,returns false otherwise.
    */
  function setHDRType(value: number): Promise<number>;

  /**
    * Obtains the HDR mode.
    * @devices tv, phone, tablet, wearable
    * @return Number type. 0: SDR; 1: HDR; 2: HLG; 3: vivid monitor.
    */
  function getHDRType(): number;

  /**
    * Sets the video output standard. The SD output unit and HD output unit need to be set separately.
    * @devices tv, phone, tablet, wearable
    * @param device - number type, indicating the video output unit. standard-number,
    * which indicates the video output standard. The SD output unit can select only the SD standard, and the HD output unit can select only the HD standard.
    * @return Returns true if the setting is successful,returns false otherwise.
    */
  function setOutputStandard(value: string, callback: AsyncCallback<number>): void;

  /**
    * Sets the video output standard. The SD output unit and HD output unit need to be set separately.
    * @devices tv, phone, tablet, wearable
    * @params device -string type, indicating the video output channel. The value can "AUTO", "PAL", 
    * "NTSC", "PALN", "PALM", "SECAM", "480P", "576P", "HD_720P","HD_1080I", "HD_1080P", 
    * "HD_3840X2160", "HD_3840X2160", "480I", "576I", "UNKNOWN", "BUTT"
    * @return Returns true if the setting is successful,returns false otherwise.
    */
  function setOutputStandard(value: string): Promise<number>;

  /**
    * Obtains the video output standard.
    * @devices tv, phone, tablet, wearable
    * @params device -string type, indicating the video output channel. The value can "AUTO", "PAL", 
    * "NTSC", "PALN", "PALM", "SECAM", "480P", "576P", "HD_720P","HD_1080I", "HD_1080P", 
    * "HD_3840X2160", "HD_3840X2160", "480I", "576I", "UNKNOWN", "BUTT"
    * @return String type, indicating the video output standard.
    */
  function getOutputStandard(): Array<string>;

  /**
     * Obtains the current output standard..
     * @devices tv, phone, tablet, wearable
     * @return string type, @params device -string type, indicating the video output channel. The value can "AUTO", "PAL", 
     * "NTSC", "PALN", "PALM", "SECAM", "480P", "576P", "HD_720P","HD_1080I", "HD_1080P", 
     * "HD_3840X2160", "HD_3840X2160", "480I", "576I", "UNKNOWN", "BUTT"
     */
  function getCurOutputStandard(): string;

  /* 
   * Enables the HDMI adaptation function.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableHDMIAdaptive(callback: AsyncCallback<number>): void;

  /* 
   * Enables the HDMI adaptation function.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableHDMIAdaptive(): Promise<number>;

  /* 
   * Disables the HDMI adaptation function.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableHDMIAdaptive(callback: AsyncCallback<number>): void;

  /* 
   * Disables the HDMI adaptation function.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableHDMIAdaptive(): Promise<number>;

  /* 
   * DCheck whether the HDMI status is adaptive.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the HDMI is adaptive,returns false otherwise.
   */
  function isHDMIAdaptive(): number;

  /* 
   * Enables the CEC function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableHDMICEC(callback: AsyncCallback<boolean>): void;

  /* 
   * Enables the CEC function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableHDMICEC(): Promise<boolean>;

  /* 
   * Disables the CEC function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableHDMICEC(callback: AsyncCallback<boolean>): void;

  /* 
   * Disables the CEC function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableHDMICEC(): Promise<boolean>;

  /* 
   * Check whether the HDMI status is CEC.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the status is CEC,returns false otherwise.
   */
  function isHDMICEC(): Promise<boolean>;

  /* 
   * The external HDMI CEC device can be remotely controlled to enter the standby mode.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setHDMICECRemote(callback: AsyncCallback<number>): void;

  /* 
   * Enables the CEC remote function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableHDMICECRemote(): Promise<number>;

  /* 
   * Enables the CEC remote function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableHDMICECRemote(callback: AsyncCallback<number>): void;

  /* 
   * Disables the CEC remote function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableHDMICECRemote(): Promise<number>;

  /* 
   * Disables the CEC remote function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableHDMICECRemote(callback: AsyncCallback<number>): void;

  /* 
   * Disables the CEC remote function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function isHDMICECRemote(): number;

  /* 
   * Enables the HDCP function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableHDMIHDCP(callback: AsyncCallback<number>): void;

  /* 
   * Enables the HDCP function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableHDMIHDCP(): Promise<number>;

  /* 
   * Disables the HDCP function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableHDMIHDCP(callback: AsyncCallback<number>): void;

  /* 
   * Disables the HDCP function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableHDMIHDCP(): Promise<number>;

  /* 
   * Check whether the HDMI status is CEC remote.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function isHDMIHDCP(): number;

  /* 
   * Setting the video display area.
   * @devices tv, phone, tablet, wearable
   * @params left - margin-left, top - margin-top, right - margin-right, bottom - margin-bottom.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setVideoDisplayArea(left: number, top: number, right: number, bottom: number, callback: AsyncCallback<number>): void;

  /* 
   * Setting the video display area
   * @devices tv, phone, tablet, wearable
   * @params left - margin-left, top - margin-top, right - margin-right, bottom - margin-bottom.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setVideoDisplayArea(left: number, top: number, right: number, bottom: number): Promise<number>;

  interface VideoDisplayArea {
    left: number;
    top: number;
    right: number;
    bottom: number;
  }

  /* 
   * get the video display area
   * @devices tv, phone, tablet, wearable
   * @return Returns VideoDisplayArea obj. left - margin-left, top - margin-top, right - margin-right, bottom - margin-bottom.
   */
  function getVideoDisplayArea(): VideoDisplayArea;
}

export default displaySetting;