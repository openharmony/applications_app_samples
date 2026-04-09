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
 * @namespace audioSetting
 * @syscap SystemCapability.Multimedia.TvMW.Audio
 * @atomicservice
 * @since 12
 */
declare namespace audioSetting {
  enum OutputType {
    PDIF = 1,
    HDMI = 2,
    SPEAKERS = 3
  }

  enum AudioEffect {
    AUTO = 0,
    STD = 1,
    CINEMA = 2,
    MUSIC = 3,
    NEWS = 4,
    DEFINE = 5
  }
  /**
   * 音量
   */
  function setVolume(value: number, callback: AsyncCallback<boolean>): void;
  function setVolume(value: number): Promise<boolean>;
  function getVolume(): Promise<number>;
  /**
   * 输出设备类型
   */
  function setAudioOutputType(type: OutputType, callback: AsyncCallback<boolean>): void;
  function setAudioOutputType(type: OutputType): Promise<boolean>;
  function getAudioOutputType(): Promise<OutputType>;
  /**
   * 音效
   */
  function setAduioEffect(value: number, callback: AsyncCallback<boolean>): void;
  function setAduioEffect(value: number): Promise<boolean>;
  function getAduioEffect(): Promise<number>;
  /**
   * 按键音
   */
  function enableKeyAudio(callback: AsyncCallback<boolean>): void;
  function enableKeyAudio(): Promise<boolean>;
  function disableKeyAudio(callback: AsyncCallback<boolean>): void;
  function disableKeyAudio(): Promise<boolean>;
  function isKeyAudio(): Promise<boolean>;

  /**
   * Setting the Data Format of the HDMI Output Interface.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setOutputHDMIMode(mode: AudioHDMIMode, callback: AsyncCallback<boolean>): void;

  /**
   * Setting the Data Format of the HDMI Output Interface.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setOutputHDMIMode(mode: AudioHDMIMode): Promise<boolean>;

  /**
   * Obtains the data format of the HDMI output interface.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function getOutputHDMIMode(callback: AsyncCallback<number>): void;
  function getOutputHDMIMode(): Promise<number>;

  /**
   * Sets the data format (compressed or PCM) of the S/PDIF output interface.
   * @return Returns true if the setting is successful,returns false otherwise. 
   */
  function setOutputSPDIFMode(mode: AudioSPDIFMode, callback: AsyncCallback<void>): void;

  /**
   * Sets the data format (compressed or PCM) of the S/PDIF output interface.
   * @return Returns true if the setting is successful,returns false otherwise. 
   */
  function setOutputSPDIFMode(mode: AudioSPDIFMode): Promise<void>;

  /**
 * Obtains the data format of the SPDIF output interface.
 */
  function getOutputSPDIFMode(callback: AsyncCallback<number>): void;
  function getOutputSPDIFMode(): Promise<number>;

  /**
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setOutNgenerationMode(mode: AudioNgenerationMode, callback: AsyncCallback<boolean>): void;

  /** 
  * @return Returns true if the setting is successful,returns false otherwise.
  */
  function setOutNgenerationMode(mode: AudioNgenerationMode): Promise<boolean>;

  function getOutNgenerationMode(callback: AsyncCallback<number>): void;
  function getOutNgenerationMode(): Promise<number>;

  enum AudioHDMIMode {
    /**
     * outputting a decoded signal
     */
    HDMI_MODE_LPCM = 0,

    /**
     * Output original signal.
     */
    HDMI_MODE_RAW = 1,

    /**
     * AutoNegotiation mode.
     */
    HDMI_MODE_AUTO = 2,
  }

  enum AudioSPDIFMode {
    /**
     * Compressed audio is decoded by the receiving terminal.
     */
    SPDIF_MODE_LPCM = 0,

    /**
     * Compressed audio is decoded by an external decoding device.
     */
    SPDIF_MODE_RAW = 1,
  }

  enum AudioNgenerationMode {
    /**
     * 7.1 Transparent transmission.
     */
    NGENERATION_MODE_RAW = 1,
    /**
     * auto.
     */
    NGENERATION_MODE_AUTO = 2,
    /**
     * 5.1 Transparent transmission.
     */
    NGENERATION_MODE_HBR2LBR = 3,
  }
}

export default audioSetting;