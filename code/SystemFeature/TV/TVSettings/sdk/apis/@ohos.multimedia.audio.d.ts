/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

/**
 * @file
 * @kit AudioKit
 */

import { ErrorCallback, AsyncCallback, Callback } from './@ohos.base';

/**
 * @namespace audio
 * @since 7
 */
/**
 * @namespace audio
 * @syscap SystemCapability.Multimedia.Audio.Core
 * @crossplatform
 * @atomicservice
 * @since 12
 */
declare namespace audio {
  /**
   * Enumerates audio errors.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 9
   */
  /**
   * Enumerates audio errors.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @crossplatform
   * @since 12
   */
  enum AudioErrors {
    /**
     * Invalid parameter.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 9
     */
    /**
     * Invalid parameter.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    ERROR_INVALID_PARAM = 6800101,
    /**
     * Allocate memory failed.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 9
     */
    /**
     * Allocate memory failed.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    ERROR_NO_MEMORY = 6800102,
    /**
     * Operation not permit at current state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 9
     */
    /**
     * Operation not permit at current state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    ERROR_ILLEGAL_STATE = 6800103,
    /**
     * Unsupported option.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 9
     */
    /**
     * Unsupported option.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    ERROR_UNSUPPORTED = 6800104,
    /**
     * Time out.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 9
     */
    ERROR_TIMEOUT = 6800105,
    /**
     * Audio specific errors.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 9
     */
    ERROR_STREAM_LIMIT = 6800201,
    /**
     * Default error.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 9
     */
    /**
     * Default error.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    ERROR_SYSTEM = 6800301
  }

  /**
   * Define local device network id for audio
   * @syscap SystemCapability.Multimedia.Audio.Device
   * @systemapi
   * @since 9
   */
  const LOCAL_NETWORK_ID: string;

  /**
   * Define default volume group id for audio
   * @syscap SystemCapability.Multimedia.Audio.Volume
   * @since 9
   */
  /**
   * Define default volume group id for audio
   * @syscap SystemCapability.Multimedia.Audio.Volume
   * @crossplatform
   * @since 12
   */
  const DEFAULT_VOLUME_GROUP_ID: number;

  /**
   * Define default interrupt group id for audio
   * @syscap SystemCapability.Multimedia.Audio.Interrupt
   * @since 9
   */
  const DEFAULT_INTERRUPT_GROUP_ID: number;

  /**
   * Obtains an {@link AudioManager} instance.
   * @returns { AudioManager } this {@link AudioManager} object.
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 7
   */
  /**
   * Obtains an {@link AudioManager} instance.
   * @returns { AudioManager } this {@link AudioManager} object.
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @crossplatform
   * @since 12
   */
  function getAudioManager(): AudioManager;

  /**
   * Obtains an {@link AudioCapturer} instance.
   * Success: This method uses an asynchronous callback to return the capturer instance.
   * Failure: This method uses an asynchronous callback to return the error instance. Possible causes:
   *          6800301: Parameter verification failed, Permission denied, System error;
   *          6800101: Mandatory parameters are left unspecified, Incorrect parameter types.
   * @param { AudioCapturerOptions } options - Capturer configurations.
   * @param { AsyncCallback<AudioCapturer> } callback - Callback used to return the audio capturer instance.
   * @syscap SystemCapability.Multimedia.Audio.Capturer
   * @since 8
   */
  /**
   * Obtains an {@link AudioCapturer} instance. This method uses an asynchronous callback to return the capturer instance.
   * @param { AudioCapturerOptions } options - Capturer configurations.
   * @param { AsyncCallback<AudioCapturer> } callback - Callback used to return the audio capturer instance.
   * @syscap SystemCapability.Multimedia.Audio.Capturer
   * @crossplatform
   * @since 12
   */
  function createAudioCapturer(options: AudioCapturerOptions, callback: AsyncCallback<AudioCapturer>): void;

  /**
   * Obtains an {@link AudioCapturer} instance.
   * Success: This method uses a promise to return the capturer instance.
   * Failure: This method uses a promise to return the error instance. Possible causes:
   *          6800301: Parameter verification failed, Permission denied, System error;
   *          6800101: Mandatory parameters are left unspecified, Incorrect parameter types.
   * @param { AudioCapturerOptions } options - Capturer configurations.
   * @returns { Promise<AudioCapturer> } Promise used to return the audio capturer instance.
   * @syscap SystemCapability.Multimedia.Audio.Capturer
   * @since 8
   */
  /**
   * Obtains an {@link AudioCapturer} instance. This method uses a promise to return the capturer instance.
   * @param { AudioCapturerOptions } options - Capturer configurations.
   * @returns { Promise<AudioCapturer> } Promise used to return the audio capturer instance.
   * @syscap SystemCapability.Multimedia.Audio.Capturer
   * @crossplatform
   * @since 12
   */
  function createAudioCapturer(options: AudioCapturerOptions): Promise<AudioCapturer>;

  /**
   * Obtains an {@link AudioRenderer} instance. This method uses an asynchronous callback to return the renderer instance.
   * @param { AudioRendererOptions } options - Renderer configurations.
   * @param { AsyncCallback<AudioRenderer> } callback - Callback used to return the audio renderer instance.
   * @syscap SystemCapability.Multimedia.Audio.Renderer
   * @since 8
   */
  /**
   * Obtains an {@link AudioRenderer} instance. This method uses an asynchronous callback to return the renderer instance.
   * @param { AudioRendererOptions } options - Renderer configurations.
   * @param { AsyncCallback<AudioRenderer> } callback - Callback used to return the audio renderer instance.
   * @syscap SystemCapability.Multimedia.Audio.Renderer
   * @crossplatform
   * @since 12
   */
  function createAudioRenderer(options: AudioRendererOptions, callback: AsyncCallback<AudioRenderer>): void;

  /**
   * Obtains an {@link AudioRenderer} instance. This method uses a promise to return the renderer instance.
   * @param { AudioRendererOptions } options - Renderer configurations.
   * @returns { Promise<AudioRenderer> } Promise used to return the audio renderer instance.
   * @syscap SystemCapability.Multimedia.Audio.Renderer
   * @since 8
   */
  /**
   * Obtains an {@link AudioRenderer} instance. This method uses a promise to return the renderer instance.
   * @param { AudioRendererOptions } options - Renderer configurations.
   * @returns { Promise<AudioRenderer> } Promise used to return the audio renderer instance.
   * @syscap SystemCapability.Multimedia.Audio.Renderer
   * @crossplatform
   * @since 12
   */
  function createAudioRenderer(options: AudioRendererOptions): Promise<AudioRenderer>;

  /**
   * Obtains a {@link TonePlayer} instance. This method uses an asynchronous callback to return the renderer instance.
   * @param { AudioRendererInfo } options - Tone playing attribute.
   * @param { AsyncCallback<TonePlayer> } callback - Callback used to return the tonePlayer instance.
   * @syscap SystemCapability.Multimedia.Audio.Tone
   * @systemapi
   * @since 9
   */
  function createTonePlayer(options: AudioRendererInfo, callback: AsyncCallback<TonePlayer>): void;

  /**
   * Obtains a {@link TonePlayer} instance. This method uses a promise to return the renderer instance.
   * @param { AudioRendererInfo } options - Tone playing attribute.
   * @returns { Promise<TonePlayer> } Promise used to return the tonePlayer instance.
   * @syscap SystemCapability.Multimedia.Audio.Tone
   * @systemapi
   * @since 9
   */
  function createTonePlayer(options: AudioRendererInfo): Promise<TonePlayer>;

  /**
   * Enumerates the audio states.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 8
   */
  /**
   * Enumerates the audio states.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @crossplatform
   * @since 12
   */
  enum AudioState {
    /**
     * Invalid state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Invalid state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    STATE_INVALID = -1,
    /**
     * Create new instance state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Create new instance state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    STATE_NEW = 0,
    /**
     * Prepared state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Prepared state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    STATE_PREPARED = 1,
    /**
     * Running state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Running state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    STATE_RUNNING = 2,
    /**
     * Stopped state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Stopped state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    STATE_STOPPED = 3,
    /**
     * Released state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Released state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    STATE_RELEASED = 4,
    /**
     * Paused state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Paused state.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    STATE_PAUSED = 5
  }

  /**
   * Enumerates audio stream types.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Volume
   * @since 7
   */
  /**
   * Enumerates audio stream types.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Volume
   * @crossplatform
   * @since 12
   */
  enum AudioVolumeType {
    /**
     * Audio streams for voice calls.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @since 8
     */
    /**
     * Audio streams for voice calls.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @crossplatform
     * @since 12
     */
    VOICE_CALL = 0,
    /**
     * Audio streams for ringtones.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @since 7
     */
    /**
     * Audio streams for ringtones.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @crossplatform
     * @since 12
     */
    RINGTONE = 2,
    /**
     * Audio streams for media purpose.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @since 7
     */
    /**
     * Audio streams for media purpose.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @crossplatform
     * @since 12
     */
    MEDIA = 3,
    /**
     * Audio volume for alarm purpose.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @since 10
     */
    /**
     * Audio volume for alarm purpose.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @crossplatform
     * @since 12
     */
    ALARM = 4,
    /**
     * Audio volume for accessibility purpose.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @since 10
     */
    /**
     * Audio volume for accessibility purpose.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @crossplatform
     * @since 12
     */
    ACCESSIBILITY = 5,
    /**
     * Audio stream for voice assistant.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @since 8
     */
    VOICE_ASSISTANT = 9,
    /**
     * Audio volume for ultrasonic.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @systemapi
     * @since 10
     */
    ULTRASONIC = 10,
    /**
     * Audio stream for all common.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @systemapi
     * @since 9
     */
    ALL = 100,
  }

  /**
   * Enumerates audio device flags.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Device
   * @since 7
   */
  /**
   * Enumerates audio device flags.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Device
   * @crossplatform
   * @since 12
   */
  enum DeviceFlag {
    /**
     * None devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @systemapi
     * @since 9
     */
    NONE_DEVICES_FLAG = 0,
    /**
     * Output devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Output devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @since 12
     */
    OUTPUT_DEVICES_FLAG = 1,
    /**
     * Input devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Input devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @since 12
     */
    INPUT_DEVICES_FLAG = 2,
    /**
     * All devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * All devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @since 12
     */
    ALL_DEVICES_FLAG = 3,
    /**
     * Distributed output devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @systemapi
     * @since 9
     */
    DISTRIBUTED_OUTPUT_DEVICES_FLAG = 4,
    /**
     * Distributed input devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @systemapi
     * @since 9
     */
    DISTRIBUTED_INPUT_DEVICES_FLAG = 8,
    /**
     * All Distributed devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @systemapi
     * @since 9
     */
    ALL_DISTRIBUTED_DEVICES_FLAG = 12,
  }

  /**
   * Enumerates audio device for usage.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Device
   * @since 12
   */
  enum DeviceUsage {
    /**
     * Media output devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 12
     */
    MEDIA_OUTPUT_DEVICES = 1,
    /**
     * Media input devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 12
     */
    MEDIA_INPUT_DEVICES = 2,
    /**
     * All media devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 12
     */
    ALL_MEDIA_DEVICES = 3,
    /**
     * Call output devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 12
     */
    CALL_OUTPUT_DEVICES = 4,
    /**
     * Call input devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 12
     */
    CALL_INPUT_DEVICES = 8,
    /**
     * All call devices.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 12
     */
    ALL_CALL_DEVICES = 12,
  }

  /**
   * Enumerates device roles.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Device
   * @since 7
   */
  /**
   * Enumerates device roles.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Device
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  enum DeviceRole {
    /**
     * Input role.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Input role.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    INPUT_DEVICE = 1,
    /**
     * Output role.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Output role.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    OUTPUT_DEVICE = 2,
  }

  /**
   * Enumerates device types.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Device
   * @since 7
   */
  /**
   * Enumerates device types.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Device
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  enum DeviceType {
    /**
     * Invalid device.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Invalid device.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    INVALID = 0,
    /**
     * Built-in earpiece.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Built-in earpiece.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    EARPIECE = 1,
    /**
     * Built-in speaker.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Built-in speaker.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    SPEAKER = 2,
    /**
     * Wired headset, which is a combination of a pair of earpieces and a microphone.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Wired headset, which is a combination of a pair of earpieces and a microphone.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    WIRED_HEADSET = 3,
    /**
     * A pair of wired headphones.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * A pair of wired headphones.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    WIRED_HEADPHONES = 4,
    /**
     * Bluetooth device using the synchronous connection oriented link (SCO).
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Bluetooth device using the synchronous connection oriented link (SCO).
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    BLUETOOTH_SCO = 7,
    /**
     * Bluetooth device using advanced audio distribution profile (A2DP).
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Bluetooth device using advanced audio distribution profile (A2DP).
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    BLUETOOTH_A2DP = 8,
    /**
     * Built-in microphone.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * Built-in microphone.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    MIC = 15,
    /**
     * USB audio headset.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     */
    /**
     * USB audio headset.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    USB_HEADSET = 22,
    /**
     * Display port device.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @atomicservice
     * @since 12
     */
    DISPLAY_PORT = 23,
    /**
     * Device type for rerouting audio to other remote devices by system application
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @atomicservice
     * @since 12
     */
    REMOTE_CAST = 24,
    /**
     * Default device type.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 9
     */
    /**
     * Default device type.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    DEFAULT = 1000,
  }

  /**
   * Enumerates the active device types.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Device
   * @since 7
   * @deprecated since 9
   * @useinstead ohos.multimedia.audio.CommunicationDeviceType
   */
  enum ActiveDeviceType {
    /**
     * Speaker.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     * @deprecated since 9
     * @useinstead ohos.multimedia.audio.CommunicationDeviceType.SPEAKER
     */
    SPEAKER = 2,
    /**
     * Bluetooth device using the SCO link.
     * @syscap SystemCapability.Multimedia.Audio.Device
     * @since 7
     * @deprecated since 9
     */
    BLUETOOTH_SCO = 7,
  }

  /**
   * Enumerates the available device types for communication.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Communication
   * @since 9
   */
  /**
   * Enumerates the available device types for communication.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Communication
   * @crossplatform
   * @since 12
   */
  enum CommunicationDeviceType {
    /**
     * Speaker.
     * @syscap SystemCapability.Multimedia.Audio.Communication
     * @since 9
     */
    /**
     * Speaker.
     * @syscap SystemCapability.Multimedia.Audio.Communication
     * @crossplatform
     * @since 12
     */
    SPEAKER = 2
  }

  /**
   * Enumerates ringer modes.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Communication
   * @since 7
   */
  /**
   * Enumerates ringer modes.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Communication
   * @crossplatform
   * @since 12
   */
  enum AudioRingMode {
    /**
     * Silent mode.
     * @syscap SystemCapability.Multimedia.Audio.Communication
     * @since 7
     */
    /**
     * Silent mode.
     * @syscap SystemCapability.Multimedia.Audio.Communication
     * @crossplatform
     * @since 12
     */
    RINGER_MODE_SILENT = 0,
    /**
     * Vibration mode.
     * @syscap SystemCapability.Multimedia.Audio.Communication
     * @since 7
     */
    /**
     * Vibration mode.
     * @syscap SystemCapability.Multimedia.Audio.Communication
     * @crossplatform
     * @since 12
     */
    RINGER_MODE_VIBRATE = 1,
    /**
     * Normal mode.
     * @syscap SystemCapability.Multimedia.Audio.Communication
     * @since 7
     */
    /**
     * Normal mode.
     * @syscap SystemCapability.Multimedia.Audio.Communication
     * @crossplatform
     * @since 12
     */
    RINGER_MODE_NORMAL = 2,
  }

  /**
   * Enumerates type.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Volume
   * @systemapi
   * @since 12
   */
  enum PolicyType {
    /**
     * EDM type.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @systemapi
     * @since 12
     */
    EDM = 0,
    /**
     * PRIVACY type.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @systemapi
     * @since 12
     */
    PRIVACY = 1,
  }

  /**
   * Enumerates the audio sample formats.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 8
   */
  /**
   * Enumerates the audio sample formats.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @crossplatform
   * @since 12
   */
  enum AudioSampleFormat {
    /**
     * Invalid format.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Invalid format.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_FORMAT_INVALID = -1,
    /**
     * Unsigned 8 format.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Unsigned 8 format.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_FORMAT_U8 = 0,
    /**
     * Signed 16 bit integer, little endian.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Signed 16 bit integer, little endian.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_FORMAT_S16LE = 1,
    /**
     * Signed 24 bit integer, little endian.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Signed 24 bit integer, little endian.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_FORMAT_S24LE = 2,
    /**
     * Signed 32 bit integer, little endian.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Signed 32 bit integer, little endian.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_FORMAT_S32LE = 3,
    /**
     * Signed 32 bit float, little endian.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 9
     */
    /**
     * Signed 32 bit float, little endian.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_FORMAT_F32LE = 4,
  }

  /**
   * Enumerates the audio channel.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 8
   */
  /**
   * Enumerates the audio channel.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @crossplatform
   * @since 12
   */
  enum AudioChannel {
    /**
     * Channel 1.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Channel 1.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_1 = 0x1 << 0,
    /**
     * Channel 2.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Channel 2.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_2 = 0x1 << 1,
    /**
     * Channel 3.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 3.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_3 = 3,
    /**
     * Channel 4.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 4.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_4 = 4,
    /**
     * Channel 5.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 5.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_5 = 5,
    /**
     * Channel 6.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 6.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_6 = 6,
    /**
     * Channel 7.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 7.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_7 = 7,
    /**
     * Channel 8.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 8.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_8 = 8,
    /**
     * Channel 9.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 9.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_9 = 9,
    /**
     * Channel 10.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 10.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_10 = 10,
    /**
     * Channel 12.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 12.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_12 = 12,
    /**
     * Channel 14.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 14.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_14 = 14,
    /**
     * Channel 16.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Channel 16.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    CHANNEL_16 = 16
  }

  /**
   * Enumerates the audio sampling rate.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 8
   */
  /**
   * Enumerates the audio sampling rate.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @crossplatform
   * @since 12
   */
  enum AudioSamplingRate {
    /**
     * 8kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 8kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_8000 = 8000,
    /**
     * 11.025kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 11.025kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_11025 = 11025,
    /**
     * 12kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 12kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_12000 = 12000,
    /**
     * 16kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 16kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_16000 = 16000,
    /**
     * 22.05kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 22.05kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_22050 = 22050,
    /**
     * 24kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 24kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_24000 = 24000,
    /**
     * 32kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 32kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_32000 = 32000,
    /**
     * 44.1kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 44.1kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_44100 = 44100,
    /**
     * 48kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 48kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_48000 = 48000,
    /**
     * 64kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 64kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_64000 = 64000,
    /**
     * 88.2kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 12
     */
    SAMPLE_RATE_88200 = 88200,
    /**
     * 96kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * 96kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    SAMPLE_RATE_96000 = 96000,
    /**
     * 176.4kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 12
     */
    SAMPLE_RATE_176400 = 176400,
    /**
     * 192kHz sample rate.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 12
     */
    SAMPLE_RATE_192000 = 192000
  }

  /**
   * Enumerates the audio encoding type.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 8
   */
  /**
   * Enumerates the audio encoding type.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  enum AudioEncodingType {
    /**
     * Invalid type.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Invalid type.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    ENCODING_TYPE_INVALID = -1,
    /**
     * PCM encoding.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * PCM encoding.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    ENCODING_TYPE_RAW = 0
  }

  /**
   * Enumerates the audio content type.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 7
   * @deprecated since 10
   * @useinstead ohos.multimedia.audio.StreamUsage
   */
  enum ContentType {
    /**
     * Unknown content.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 7
     * @deprecated since 10
     * @useinstead ohos.multimedia.audio.StreamUsage.STREAM_USAGE_UNKNOWN
     */
    CONTENT_TYPE_UNKNOWN = 0,
    /**
     * Speech content.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 7
     * @deprecated since 10
     * @useinstead ohos.multimedia.audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION
     */
    CONTENT_TYPE_SPEECH = 1,
    /**
     * Music content.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 7
     * @deprecated since 10
     * @useinstead ohos.multimedia.audio.StreamUsage.STREAM_USAGE_MUSIC
     */
    CONTENT_TYPE_MUSIC = 2,
    /**
     * Movie content.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 7
     * @deprecated since 10
     * @useinstead ohos.multimedia.audio.StreamUsage.STREAM_USAGE_MOVIE
     */
    CONTENT_TYPE_MOVIE = 3,
    /**
     * Notification content.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 7
     * @deprecated since 10
     * @useinstead ohos.multimedia.audio.StreamUsage.STREAM_USAGE_NOTIFICATION
     */
    CONTENT_TYPE_SONIFICATION = 4,
    /**
     * Ringtone content.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     * @deprecated since 10
     * @useinstead ohos.multimedia.audio.StreamUsage.STREAM_USAGE_RINGTONE
     */
    CONTENT_TYPE_RINGTONE = 5,
  }

  /**
   * Enumerates the stream usage.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 7
   */
  /**
   * Enumerates the stream usage.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  enum StreamUsage {
    /**
     * Unknown usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 7
     */
    /**
     * Unknown usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_UNKNOWN = 0,
    /**
     * Media usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 7
     * @deprecated since 10
     * @useinstead ohos.multimedia.audio.StreamUsage.STREAM_USAGE_MUSIC or
     *             ohos.multimedia.audio.StreamUsage.STREAM_USAGE_MOVIE or
     *             ohos.multimedia.audio.StreamUsage.STREAM_USAGE_GAME or
     *             ohos.multimedia.audio.StreamUsage.STREAM_USAGE_AUDIOBOOK
     */
    STREAM_USAGE_MEDIA = 1,
    /**
     * Music usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    /**
     * Music usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_MUSIC = 1,
    /**
     * Voice communication usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 7
     */
    /**
     * Voice communication usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_VOICE_COMMUNICATION = 2,
    /**
     * Voice assistant broadcast usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 9
     */
    /**
     * Voice assistant broadcast usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_VOICE_ASSISTANT = 3,
    /**
     * Alarm usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    /**
     * Alarm usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_ALARM = 4,
    /**
     * Voice message usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    /**
     * Voice message usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_VOICE_MESSAGE = 5,
    /**
     * Notification or ringtone usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 7
     * @deprecated since 10
     * @useinstead ohos.multimedia.audio.StreamUsage.STREAM_USAGE_RINGTONE
     */
    STREAM_USAGE_NOTIFICATION_RINGTONE = 6,
    /**
     * Ringtone usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    /**
     * Ringtone usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_RINGTONE = 6,
    /**
     * Notification usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    /**
     * Notification usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_NOTIFICATION = 7,
    /**
     * Accessibility usage, such as screen reader.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    /**
     * Accessibility usage, such as screen reader.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_ACCESSIBILITY = 8,
    /**
     * System usage, such as screen lock or key click.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @systemapi
     * @since 10
     */
    STREAM_USAGE_SYSTEM = 9,
    /**
     * Movie or video usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    /**
     * Movie or video usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_MOVIE = 10,
    /**
     * Game sound effect usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    /**
     * Game sound effect usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_GAME = 11,
    /**
     * Audiobook usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    /**
     * Audiobook usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_AUDIOBOOK = 12,
    /**
     * Navigation usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    /**
     * Navigation usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_NAVIGATION = 13,
    /**
     * DTMF dial tone usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @systemapi
     * @since 10
     */
    STREAM_USAGE_DTMF = 14,
    /**
     * Enforced tone usage, such as camera shutter.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @systemapi
     * @since 10
     */
    STREAM_USAGE_ENFORCED_TONE = 15,
    /**
     * Ultrasonic playing usage. This type is only used for msdp condition.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @systemapi
     * @since 10
     */
    STREAM_USAGE_ULTRASONIC = 16,
    /**
     * Video call usage.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @atomicservice
     * @since 12
     */
    STREAM_USAGE_VIDEO_COMMUNICATION = 17,
    /**
     * Voice call assistant type. This type is only used for call assistant functionalities.
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @systemapi
     * @since 12
     */
    STREAM_USAGE_VOICE_CALL_ASSISTANT = 21,
  }

  /**
   * Enumerates the audio interrupt request type.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Interrupt
   * @systemapi
   * @since 9
   */
  enum InterruptRequestType {
    /**
     * Default type to request audio interrupt.
     * @syscap SystemCapability.Multimedia.Audio.Interrupt
     * @systemapi
     * @since 9
     */
    INTERRUPT_REQUEST_TYPE_DEFAULT = 0,
  }

  /**
   * Enumerates volume related operations.
   * Flags should be powers of 2!
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.Volume
   * @systemapi
   * @since 12
   */
  enum VolumeFlag {
    /**
     * Show system volume bar.
     * @syscap SystemCapability.Multimedia.Audio.Volume
     * @systemapi
     * @since 12
     */
    FLAG_SHOW_SYSTEM_UI = 1,
  }

  /**
   * Describes audio stream information.
   * @typedef AudioStreamInfo
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 8
   */
   /**
   * Describes audio stream information.
   * @typedef AudioStreamInfo
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @crossplatform
   * @since 12
   */
  interface AudioStreamInfo {
    /**
     * Sampling rate.
     * @type { AudioSamplingRate }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Sampling rate.
     * @type { AudioSamplingRate }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    samplingRate: AudioSamplingRate;
    /**
     * Audio channels.
     * @type { AudioChannel }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
   /**
     * Audio channels.
    * @type { AudioChannel }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    channels: AudioChannel;
    /**
     * Audio sample format.
     * @type { AudioSampleFormat }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Audio sample format.
     * @type { AudioSampleFormat }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    sampleFormat: AudioSampleFormat;
    /**
     * Audio encoding type.
     * @type { AudioEncodingType }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Audio encoding type.
     * @type { AudioEncodingType }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    encodingType: AudioEncodingType;
    /**
     * Audio channel layout.
     * @type { ?AudioChannelLayout }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 11
     */
    /**
     * Audio channel layout.
     * @type { ?AudioChannelLayout }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @since 12
     */
    channelLayout?: AudioChannelLayout;
  }

  /**
   * Describes audio renderer information.
   * @typedef AudioRendererInfo
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @since 8
   */
  /**
   * Describes audio renderer information.
   * @typedef AudioRendererInfo
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  interface AudioRendererInfo {
    /**
     * Content type.
     * @type { ContentType }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     * @deprecated since 10
     * @useinstead ohos.multimedia.audio.AudioRendererInfo#usage
     */
    /**
     * Content type.
     * @type { ?ContentType }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 10
     */
    content?: ContentType;
    /**
     * Stream usage.
     * @type { StreamUsage }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Stream usage.
     * @type { StreamUsage }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    usage: StreamUsage;
    /**
     * Audio renderer flags.
     * @type { number }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @since 8
     */
    /**
     * Audio renderer flags.
     * @type { number }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    rendererFlags: number;
  }

  /**
   * Describes audio renderer filter.
   * @typedef AudioRendererFilter
   * @syscap SystemCapability.Multimedia.Audio.Core
   * @systemapi
   * @since 9
   */
  interface AudioRendererFilter {
    /**
     * Application uid.
     * @type { ?number }
     * @syscap SystemCapability.Multimedia.Audio.Core
     * @systemapi
     * @since 9
     */
    uid?: number;
    /**
     * Renderer information.
     * @type { ?AudioRendererInfo }
     * @syscap SystemCapability.Multimedia.Audio.Renderer
     * @systemapi
     * @since 9
     */
    rendererInfo?: AudioRendererInfo;
    /**
     * AudioRenderer id.
     * @type { ?number }
     * @syscap SystemCapability.Multimedia.Audio.Renderer
     * @systemapi
     * @since 9
     */
    rendererId?: number;
  }

  /**
   * Describes audio renderer configuration options.
   * @typedef AudioRendererOptions
   * @syscap SystemCapability.Multimedia.Audio.Renderer
   * @since 8
   */
   /**
   * Describes audio renderer configuration options.
   * @typedef AudioRendererOptions
   * @syscap SystemCapability.Multimedia.Audio.Renderer
   * @crossplatform
   * @since 12
   */
  interface AudioRendererOptions {
    /**
     * Stream information.
     * @type { AudioStreamInfo }
     * @syscap SystemCapability.Multimedia.Audio.Renderer
     * @since 8
     */
    /**
     * Stream information.
     * @type { AudioStreamInfo }
     * @syscap SystemCapability.Multimedia.Audio.Renderer
     * @crossplatform
     * @since 12
     */
    streamInfo: AudioStreamInfo;
    /**
     * Renderer information.
     * @type { AudioRendererInfo }
     * @syscap SystemCapability.Multimedia.Audio.Renderer
     * @since 8
     */
    /**
     * Renderer information.
     * @type { AudioRendererInfo }
     * @syscap SystemCapability.Multimedia.Audio.Renderer
     * @crossplatform
     * @since 12
     */
    rendererInfo: AudioRendererInfo;
    /**
     * Privacy configuration.
     * @type { ?AudioPrivacyType }
     * @syscap SystemCapability.Multimedia.Audio.PlaybackCapture
     * @since 10
     */
    /**
     * Privacy configuration.
     * @type { ?AudioPrivacyType }
     * @syscap SystemCapability.Multimedia.Audio.PlaybackCapture
     * @crossplatform
     * @since 12
     */
    privacyType?: AudioPrivacyType;
  }

  /**
   * Enumerates audio stream privacy type for playback capture.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.PlaybackCapture
   * @since 10
   */
  /**
   * Enumerates audio stream privacy type for playback capture.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Audio.PlaybackCapture
   * @crossplatform
   * @since 12
   */
  enum AudioPrivacyType {
    /**
     * Privacy type that stream can be captured by third party applications.
     * @syscap SystemCapability.Multimedia.Audio.PlaybackCapture
     * @since 10
     */
    /**
     * Privacy type that stream can be captured by third party applications.
     * @syscap SystemCapability.Multimedia.Audio.PlaybackCapture
     * @crossplatform
     * @since 12
     */
    PRIVACY_TYPE_PUBLIC = 0,

    /**
     * Privacy type that stream can not be captured.
     * @syscap SystemCapability.Multimedia.Audio.PlaybackCapture
     * @since 10
     */
    /**
     * Privacy type that stream can not be captured.
