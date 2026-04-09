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
 * @syscap SystemCapability.Multimedia.TvService.Audio
 * @atomicservice
 * @since 12
 */
declare namespace audioSetting {
  enum GetValue {
    UNSUPPORT = -999
  }

  enum AudioEffectMode {
    AUTO = 0,
    STD = 1,
    CINEMA = 2,
    MUSIC = 3,
    NEWS = 4,
    DEFINE = 5
  }

  interface geqParams {
    band: number;
    gain: number;
  }

  type geqParamsArray = geqParams[];

  enum CecUiMenu {
    CEC_UI_MENU_ENABLE = 0,
    CEC_UI_MENU_ONETCHPLY = 1,
    CEC_UI_MENU_STANDBY = 2,
    CEC_UI_MENU_DEVMENUCTRL = 3,
    CEC_UI_MENU_AMPLIFIER = 4,
    CEC_UI_MENU_ARC = 5,
    CEC_UI_MENU_BUTT = 6
  }

  interface CecDevMenuAndEnable {
    cecUiMenu: CecUiMenu;
    enable: boolean;
  }

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
   * 设置输出设备类型
   * @param type -OutputType: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setAudioOutputType(type: OutputType, callback: AsyncCallback<boolean>): void;

  /**
   * 设置输出设备类型
   * @param type -OutputType: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setAudioOutputType(type: OutputType): Promise<boolean>;

  /**
   * 获取输出设备类型
   * @return OutputType 枚举
   */
  function getAudioOutputType(): Promise<OutputType>;

  /**
   * 设置音效
   * @param value -AudioEffect: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setAduioEffect(value: AudioEffect, callback: AsyncCallback<boolean>): void;

  /**
   * 设置音效
   * @param value -AudioEffect: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setAduioEffect(value: AudioEffect): Promise<boolean>;

  /**
   * 获取音效值
   * @return AudioEffect 枚举
   */
  function getAduioEffect(): Promise<AudioEffect>;

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

  function SetArcEnable(enable: boolean, callback: AsyncCallback<boolean>): void;

  function SetArcEnable(enable: boolean): Promise<boolean>;

  function GetArcEnable(): Promise<boolean>;

  /**
   * 设置ARC音频模式
   * @param arcMode - SoundArcModeType枚举类型，指定要设置的ARC模式
   * @param callback - AsyncCallback<boolean>类型回调函数，设置成功时回调参数为true，失败时为false
   * @return 无返回值，结果通过回调返回
   */
  function setArcMode(arcMode: SoundArcModeType, callback: AsyncCallback<boolean>): void;

  /**
   * 设置ARC音频模式
   * @param arcMode - SoundArcModeType枚举类型，指定要设置的ARC模式
   * @return Promise<boolean>对象，设置成功时解析为true，失败时解析为false
   */
  function setArcMode(arcMode: SoundArcModeType): Promise<boolean>;

  /**
   * 获取当前ARC音频模式
   * @return Promise<SoundArcModeType>对象，解析结果为当前生效的ARC模式
   */
  function getArcMode(): Promise<SoundArcModeType>;

  function GetArcSupported(): Promise<boolean>;

  function SetSpdifEnable(enable: boolean, callback: AsyncCallback<boolean>): void;

  function SetSpdifEnable(enable: boolean): Promise<boolean>;

  function GetSpdifEnable(): Promise<boolean>;

  function SetSpdifMode(mode: SoundSpdifModeType, callback: AsyncCallback<boolean>): void;

  function SetSpdifMode(mode: SoundSpdifModeType): Promise<boolean>;

  function GetSpdifMode(): Promise<SoundSpdifModeType>;

  function SetMute(channel: AudioChannelType, isMute: boolean, muteType: SoundMuteType,
    callback: AsyncCallback<boolean>): void;

  function SetMute(channel: AudioChannelType, isMute: boolean, muteType: SoundMuteType): Promise<boolean>;

  function GetMute(channel: AudioChannelType): Promise<boolean>;

  /**
   * 设置特定音频通道
   * @param channelType - AudioChannelType枚举类型，指定要设置的音频通道
   * @param callback - AsyncCallback<boolean>类型回调函数，设置成功时回调参数为true，失败时为false
   * @return 无返回值，结果通过回调返回
   */
  function setAudioChannelType(channelType: AudioChannelType, callback: AsyncCallback<boolean>): void;

  /**
   * 设置特定音频通道
   * @param channelType - AudioChannelType枚举类型，指定要设置的音频通道
   * @return Promise<boolean>对象，设置成功时解析为true，失败时解析为false
   */
  function setAudioChannelType(channelType: AudioChannelType): Promise<boolean>;

  /**
   * 获取当前音频通道
   * @return Promise<AudioChannelType>对象，解析结果为当前的音频通道类型
   */
  function getAudioChannelType(): Promise<AudioChannelType>;

  function SetVolume(channel: AudioChannelType, volume: number, callback: AsyncCallback<boolean>): void;

  function SetVolume(channel: AudioChannelType, volume: number): Promise<boolean>;

  function GetVolume(channel: AudioChannelType): Promise<number>;

  function SetArcVolume(volumeUp: boolean, callback: AsyncCallback<boolean>): void;

  function SetArcVolume(volumeUp: boolean): Promise<boolean>;

  function SetVolumeByPid(volume: number, pid: number, callback: AsyncCallback<boolean>): void;

  function SetVolumeByPid(volume: number, pid: number): Promise<boolean>;

  function RestoreVolumeByPid(usrId: number, callback: AsyncCallback<boolean>): void;

  function RestoreVolumeByPid(usrId: number): Promise<boolean>;

  function GetStereoMode(): Promise<StereoType>;

  function SetStereoMode(stereo: StereoType, callback: AsyncCallback<boolean>): void;

  function SetStereoMode(stereo: StereoType): Promise<boolean>;

  function GetTrackWeight(): Promise<TrackGainAttr>;

  function SetTrackWeight(gainAttr: TrackGainAttr, callback: AsyncCallback<boolean>): void;

  function SetTrackWeight(gainAttr: TrackGainAttr): Promise<boolean>;

  function SetUsrAudioMute(source: SourceType, Mute: boolean, pid: number, callback: AsyncCallback<boolean>): void;

  function SetUsrAudioMute(source: SourceType, Mute: boolean, pid: number): Promise<boolean>;

  function GetAudioStreamInfo(): Promise<AudioStreamInfo>;

  function GetChipDecoderCap(): Promise<ChipDecoderCap>;

  function SetAudioChannel(channelType: AudioChannelType, isMute: boolean, callback: AsyncCallback<boolean>): void;

  function SetAudioChannel(channelType: AudioChannelType, isMute: boolean): Promise<boolean>;

  function SetSubwooferAef(isSubwooferAef: boolean, callback: AsyncCallback<boolean>): void;

  function SetSubwooferAef(isSubwooferAef: boolean): Promise<boolean>;

  function SetSubwooferModeEnable(isEnable: boolean, callback: AsyncCallback<boolean>): void;

  function SetSubwooferModeEnable(isEnable: boolean): Promise<boolean>;

  function SetSubwooferDelayEnable(isEnable: boolean, callback: AsyncCallback<boolean>): void;

  function SetSubwooferDelayEnable(isEnable: boolean): Promise<boolean>;

  /*获取CEC状态*/
  function getCecStatus(cecUiMenu: CecUiMenu, callback: AsyncCallback<boolean>): void;

  function getCecStatus(cecUiMenu: CecUiMenu): Promise<boolean>;

  /*设置CEC状态*/
  function setCecStatus(type: CecDevMenuAndEnable, callback: AsyncCallback<boolean>): void;

  function setCecStatus(type: CecDevMenuAndEnable): Promise<boolean>;

  //音效接口
  /**
   * 设置音效
   * @param value -AudioEffectMode: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setAudioEffect(value: AudioEffectMode, callback: AsyncCallback<boolean>): void;

  /**
   * 设置音效
   * @param value -AudioEffectMode: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setAudioEffect(value: AudioEffectMode): Promise<boolean>;

  /**
   * 获取音效值
   * @return AudioEffectMode: 枚举类型，具体值见定义。
   */
  function getAudioEffect(): Promise<AudioEffectMode>;

  /**
   * 自定义音效参考模式设置
   * @param referMode 参考模式。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setCustomReferMode(referMode: number, callback: AsyncCallback<boolean>): void;

  /**
   * 自定义音效参考模式设置
   * @param referMode 参考模式。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setCustomReferMode(referMode: number): Promise<boolean>;

  /**
   * 自定义音效参考模式查询
   * @return number 参考模式。
   */
  function getCustomReferMode(): Promise<number>;

  /**
   * 自定义音效均衡器参数设置
   * @param geqParams 均衡器参数，具体见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setCustomGeqParams(params: geqParams, callback: AsyncCallback<boolean>): void;

  /**
   * 自定义音效均衡器参数设置
   * @param geqParams 均衡器参数，具体见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setCustomGeqParams(params: geqParams): Promise<boolean>;

  /**
   * 自定义音效均衡器参数查询
   * @return geqParamsArray 均衡器参数，具体见定义。
   */
  function getCustomGeqParams(): Promise<geqParamsArray>;

  /**
   * 自定义音效人声增强参数设置
   * @param vocParams 人声增强参数。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setCustomVocParams(vocParams: number, callback: AsyncCallback<boolean>): void;

  /**
   * 自定义音效人声增强参数设置
   * @param vocParams 人声增强参数。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setCustomVocParams(vocParams: number): Promise<boolean>;

  /**
   * 自定义音效人声增强参数查询
   * @return number 人声增强参数。
   */
  function getCustomVocParams(): Promise<number>;

  /**
   * 自定义音效水平环绕参数设置
   * @param hSurround 水平环绕参数。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setCustomHSurround(hSurround: number, callback: AsyncCallback<boolean>): void;

  /**
   * 自定义音效水平环绕参数设置
   * @param value 水平环绕参数。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setCustomHSurround(hSurround: number): Promise<boolean>;

  /**
   * 自定义音效水平环绕参数查询
   * @return number 水平环绕参数。
   */
  function getCustomHSurround(): Promise<number>;

  /**
   * 自定义音效垂直环绕参数设置
   * @param vSurround 垂直环绕参数。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setCustomVSurround(vSurround: number, callback: AsyncCallback<boolean>): void;

  /**
   * 自定义音效垂直环绕参数设置
   * @param value 垂直环绕参数。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setCustomVSurround(vSurround: number): Promise<boolean>;

  /**
   * 自定义音效垂直环绕参数查询
   * @return number 垂直环绕参数。
   */
  function getCustomVSurround(): Promise<number>;

  /**
   * 重置自定义音效数据
   * @param callback - 异步回调函数，返回布尔值表示是否成功
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function reSetCustomizeData(callback: AsyncCallback<boolean>): void;

  /**
   * 重置自定义音效数据
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function reSetCustomizeData(): Promise<boolean>;

  enum SoundArcModeType {
    SOUND_ARC_AUDIO_MODE_LPCM = 0,
    SOUND_ARC_AUDIO_MODE_RAW = 1,
    SOUND_ARC_AUDIO_MODE_AUTO = 3,
    SOUND_ARC_AUDIO_MODE_BUTT
  }

  enum SoundSpdifModeType {
    SOUND_SPDIF_MODE_PCM,
    SOUND_SPDIF_MODE_RAW,
    SOUND_SPDIF_MODE_AUTO,
    SOUND_SPDIF_MODE_BUTT
  }

  enum AudioChannelType {
    AUDIO_CHANNEL_SPEAKER = 0,
    AUDIO_CHANNEL_HEADPHONE = 1,
    AUDIO_CHANNEL_BLUETOOTH = 2,
    AUDIO_CHANNEL_ARC = 3,
    AUDIO_CHANNEL_SPDIF = 4,
    AUDIO_CHANNEL_AVOUT = 5,
    AUDIO_CHANNEL_24G = 6,
    AUDIO_CHANNEL_I2S0 = 7,
    AUDIO_CHANNEL_HDMITX = 8,
    AUDIO_CHANNEL_EARC = 9,
    AUDIO_CHANNEL_SUNWOOFER = 10,
    AUDIO_CHANNEL_BUTT
  }

  enum SoundMuteType {
    SOUND_MUTE_IRCTRL = 0, // IR Mute
    SOUND_MUTE_PILICY = 1, // Policy Mute
    SOUND_MUTE_SIGNAL = 2, // No signal mute
    SOUND_MUTE_SELSRC = 3, // change source mute
    SOUND_MUTE_SELPRG = 4, // switch channel mute
    SOUND_MUTE_SCNPRG = 5, // search channel mute
    SOUND_MUTE_FOCUS = 6, // Out-of-focus mute
    SOUND_MUTE_CONFIG = 7, // config parameters mute
    SOUND_MUTE_HEADSET = 8, // HeadSet Link, Speaker mute
    SOUND_MUTE_SPDIF = 9, // SPDIF output, Speaker mute
    SOUND_MUTE_ARC = 10, // ARC output, Speaker mute
    SOUND_MUTE_SRC_LOCK = 11, // signal source  lock mute
    SOUND_MUTE_CHANNEL_LOCK = 12, // channel lock mute
    SOUND_MUTE_PARENT_LOCK = 13, // parental lock mute
    SOUND_MUTE_BUTT
  }

  enum StereoType {
    STEREO_STEREO = 0,
    STEREO_MONO = 1,
    STEREO_DOUBLE_LEFT = 2,
    STEREO_DOUBLE_RIGHT = 3,
    STEREO_EXCHANGE = 4,
    STEREO_ONLY_RIGHT = 5,
    STEREO_ONLY_LEFT = 6,
    STEREO_MUTED = 7,
    STEREO_BUTT
  }

  enum SourceType {
    SOURCE_MEDIA,
    SOURCE_HDMI1,
    SOURCE_HDMI2,
    SOURCE_HDMI3,
    SOURCE_HDMI4,
    SOURCE_CVBS1,
    SOURCE_DTMB,
    SOURCE_DVBC,
    SOURCE_DVBT,
    SOURCE_CAST,
    SOURCE_GRAPHIC,
    SOURCE_NETWORK,
    SOURCE_BUTT
  }

  enum AudioStreamType {
    AUDIO_STREAM_TYPE_DTS = 0,
    AUDIO_STREAM_TYPE_DOLBY = 1,
    AUDIO_STREAM_TYPE_BUTT
  }

  interface ChipDecoderCap {
    ddSupport: boolean;
    ddpSupport: boolean;
    dtsSupport: boolean;
  }

  interface TrackGainAttr {
    linearMode: boolean;
    gain: number;
  }

  interface AudioStreamInfo {
    streamType: AudioStreamType;
    value: number;
  }

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
  /**
   * 设置按键音功能开关状态
   * @param enable - boolean类型，true表示开启按键音功能，false表示关闭
   * @param callback - AsyncCallback<boolean>类型回调函数，设置成功时回调参数为true，失败时为false
   * @return 无返回值，结果通过回调返回
   */
  function setKeyToneEnable(enable: boolean, callback: AsyncCallback<boolean>): void;
  /**
   * 设置按键音功能开关状态
   * @param enable - boolean类型，true表示开启按键音功能，false表示关闭
   * @return Promise<boolean>对象，设置成功时解析为true，失败时解析为false
   */
  function setKeyToneEnable(enable: boolean): Promise<boolean>;
  /**
   * 获取当前按键音功能开关状态
   * @return Promise<boolean>对象，解析结果为当前按键音状态（true表示开启，false表示关闭）
   */
  function getKeyToneEnable(): Promise<boolean>;
  /**
   * 设置SPDIF音频模式
   * @param mode - SoundSpdifModeType枚举类型，指定要设置的SPDIF模式
   * @param callback - AsyncCallback<boolean>类型回调函数，设置成功时回调参数为true，失败时为false
   * @return 无返回值，结果通过回调返回
   */
  function setSpdifMode(mode: SoundSpdifModeType, callback: AsyncCallback<boolean>): void;

  /**
   * 设置SPDIF音频模式
   * @param mode - SoundSpdifModeType枚举类型，指定要设置的SPDIF模式
   * @return Promise<boolean>对象，设置成功时解析为true，失败时解析为false
   */
  function setSpdifMode(mode: SoundSpdifModeType): Promise<boolean>;

  /**
   * 获取当前SPDIF音频模式
   * @return Promise<SoundSpdifModeType>对象，解析结果为当前生效的SPDIF模式
   */
  function getSpdifMode(): Promise<SoundSpdifModeType>;
}

export default audioSetting;