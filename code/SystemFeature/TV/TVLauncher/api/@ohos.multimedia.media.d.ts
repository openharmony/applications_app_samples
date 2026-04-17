/*
* Copyright (C) 2021 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { ErrorCallback, AsyncCallback, Callback } from './basic';
import audio from "./@ohos.multimedia.audio";

/**
 * @name media
 * @since 6
 * @import import media from '@ohos.multimedia.media'
 */
declare namespace media {
/**
 * Creates an AudioPlayer instance.
 * @since 6
 * @syscap SystemCapability.Multimedia.Media.AudioPlayer
 * @import import media from '@ohos.multimedia.media'
 * @return Returns an AudioPlayer instance if the operation is successful; returns null otherwise.
 */
  function createAudioPlayer(): AudioPlayer;

  /**
   * Creates an AudioRecorder instance.
   * @since 6
   * @syscap SystemCapability.Multimedia.Media.AudioRecorder
   * @import import media from '@ohos.multimedia.media'
   * @return Returns an AudioRecorder instance if the operation is successful; returns null otherwise.
   */
  function createAudioRecorder(): AudioRecorder;

  /**
   * Creates an VideoPlayer instance.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   * @import import media from '@ohos.multimedia.media'
   * @param callback Callback used to return AudioPlayer instance if the operation is successful; returns null otherwise.
   */
  function createVideoPlayer(callback: AsyncCallback<VideoPlayer>): void;
  /**
   * Creates an VideoPlayer instance.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   * @import import media from '@ohos.multimedia.media'
   * @return A Promise instance used to return VideoPlayer instance if the operation is successful; returns null otherwise.
   */
  function createVideoPlayer() : Promise<VideoPlayer>;

  /**
   * Extend for TV
   * Creates an VideoPlayer instance.
   * @since 1
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   * @import import media from '@ohos.multimedia.media'
   * @param type see@PlayerType
   * @param callback Callback used to return VideoPlayer instance if the operation is successful; returns null otherwise.
   * @return A callback instance used to return VideoPlayer instance if the operation is successful; returns null otherwise.
   */
  function createVideoPlayer(type:PlayerType, callback: AsyncCallback<VideoPlayer>): void;

  /**
   * Extend for TV
   * Creates an VideoPlayer instance.
   * @since 1
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   * @import import media from '@ohos.multimedia.media'
   * @param type see@PlayerType
   * @return A callback instance used to return VideoPlayer instance if the operation is successful; returns null otherwise.
   */
  function createVideoPlayer(type:PlayerType) : Promise<VideoPlayer>;

  /**
   * Creates an VideoRecorder instance.
   * @since 9
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   * @import import media from '@ohos.multimedia.media'
   * @param callback Callback used to return AudioPlayer instance if the operation is successful; returns null otherwise.
   */
  function createVideoRecorder(callback: AsyncCallback<VideoRecorder>): void;

  /**
   * Creates an VideoRecorder instance.
   * @since 9
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   * @import import media from '@ohos.multimedia.media'
   * @return A Promise instance used to return VideoRecorder instance if the operation is successful; returns null otherwise.
   */
  function createVideoRecorder(): Promise<VideoRecorder>;

  /**
   * Extend for TV
   * Enumerates player types
   * @since 1
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   * @import import media from '@ohos.multimedia.media'
   */
  enum PlayerType {
    /**
     * type for ohos
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PLAYER_TYPE_OHOS = 0,

    /**
     * type for TV
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PLAYER_TYPE_TV = 1,

    /**
     * type for butt
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PLAYER_TYPE_BUTT = 2,
  }

  /**
   * Enumerates ErrorCode types, return in BusinessError::code
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.Core
   * @import import media from '@ohos.multimedia.media'
   */
  enum MediaErrorCode {
    /**
     * operation success.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MSERR_OK = 0,

    /**
     * malloc or new memory failed. maybe system have no memory.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MSERR_NO_MEMORY = 1,

    /**
     * no permission for the operation.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MSERR_OPERATION_NOT_PERMIT = 2,

    /**
     * invalid argument.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MSERR_INVALID_VAL = 3,

    /**
     * an IO error occurred.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MSERR_IO = 4,

    /**
     * operation time out.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MSERR_TIMEOUT = 5,

    /**
     * unknown error.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MSERR_UNKNOWN = 6,

    /**
     * media service died.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MSERR_SERVICE_DIED = 7,

    /**
     * operation is not permit in current state.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MSERR_INVALID_STATE = 8,

    /**
     * operation is not supported in current version.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MSERR_UNSUPPORTED = 9,
  }

  /**
   * Enumerates buffering info type, for network playback.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.Core
   * @import import media from '@ohos.multimedia.media'
   */
  enum BufferingInfoType {
    /**
     * begin to buffering
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    BUFFERING_START = 1,

    /**
     * end to buffering
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    BUFFERING_END = 2,

    /**
     * buffering percent
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    BUFFERING_PERCENT = 3,

    /**
     * cached duration in milliseconds
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    CACHED_DURATION = 4,
  }

  interface AVFileDescriptor {
    /**
     * The file descriptor of audio or video source from file system. The caller
     * is responsible to close the file descriptor.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    fd: number

    /**
     * The offset into the file where the data to be readed, in bytes. Defaultly,
     * the offset is zero.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    offset?: number

    /**
     * The length in bytes of the data to be readed. Defaultly, the length is the
     * rest of bytes in the file from the offset.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    length?: number
  }

  /**
   * Describes audio playback states.
   * @since 6
   * @syscap SystemCapability.Multimedia.Media.AudioPlayer
   * @import import media from '@ohos.multimedia.media'
   */
  type AudioState = 'idle' | 'playing' | 'paused' | 'stopped' | 'error';

  /**
   * Manages and plays audio. Before calling an AudioPlayer method, you must use createAudioPlayer()
   * to create an AudioPlayer instance.
   * @since 6
   * @syscap SystemCapability.Multimedia.Media.AudioPlayer
   */
  interface AudioPlayer {
    /**
     * Starts audio playback.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    play(): void;

    /**
     * Pauses audio playback.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    pause(): void;

    /**
     * Stops audio playback.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    stop(): void;

    /**
     * Resets audio playback.
     * @since 7
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    reset(): void;

    /**
     * Jumps to the specified playback position.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     * @param timeMs Playback position to jump
     */
    seek(timeMs: number): void;

    /**
     * Sets the volume.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     * @param vol Relative volume. The value ranges from 0.00 to 1.00. The value 1 indicates the maximum volume (100%).
     */
    setVolume(vol: number): void;

    /**
     * Releases resources used for audio playback.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    release(): void;
    /**
     * get all track infos in MediaDescription, should be called after data loaded callback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     * @param callback async callback return track info in MediaDescription.
     */
    getTrackDescription(callback: AsyncCallback<Array<MediaDescription>>): void;

    /**
     * get all track infos in MediaDescription, should be called after data loaded callback..
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     * @return A Promise instance used to return the track info in MediaDescription.
     */
    getTrackDescription() : Promise<Array<MediaDescription>>;

    /**
     * Listens for audio playback buffering events.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     * @param type Type of the playback buffering update event to listen for.
     * @param callback Callback used to listen for the buffering update event, return BufferingInfoType and the value.
     */
    on(type: 'bufferingUpdate', callback: (infoType: BufferingInfoType, value: number) => void): void;

    /**
     * Audio media URI. Mainstream audio formats are supported.
     * local:fd://XXX, file://XXX. network:http://xxx
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     * @permission ohos.permission.READ_MEDIA or ohos.permission.INTERNET
     */
    src: string;

    /**
     * Audio file descriptor. Mainstream audio formats are supported.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    fdSrc: AVFileDescriptor;

    /**
     * Whether to loop audio playback. The value true means to loop playback.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    loop: boolean;

    /**
     * Describes audio interrupt mode, refer to {@link #audio.InterruptMode}. If it is not
     * set, the default mode will be used. Set it before calling the {@link #play()} in the
     * first time in order for the interrupt mode to become effective thereafter.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    audioInterruptMode ?: audio.InterruptMode;

    /**
     * Current playback position.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    readonly currentTime: number;

    /**
     * Playback duration, When the data source does not support seek, it returns - 1, such as a live broadcast scenario.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    readonly duration: number;

    /**
     * Playback state.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     */
    readonly state: AudioState;

    /**
     * Listens for audio playback events.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event.
     */
    on(type: 'play' | 'pause' | 'stop' | 'reset' | 'dataLoad' | 'finish' | 'volumeChange', callback: () => void): void;

    /**
     * Listens for audio playback events.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event.
     */
    on(type: 'timeUpdate', callback: Callback<number>): void;

    /**
     * Listens for audio interrupt event, refer to {@link #audio.InterruptEvent}
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event return audio interrupt info.
     */
    on(type: 'audioInterrupt', callback: (info: audio.InterruptEvent) => void): void;

    /**
     * Listens for playback error events.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioPlayer
     * @param type Type of the playback error event to listen for.
     * @param callback Callback used to listen for the playback error event.
     */
    on(type: 'error', callback: ErrorCallback): void;
  }

  /**
   * Enumerates audio encoding formats, it will be deprecated after API8, use @CodecMimeType to replace.
   * @since 6
   * @syscap SystemCapability.Multimedia.Media.AudioRecorder
   * @import import media from '@ohos.multimedia.media'
   * @deprecated since 8
   */
  enum AudioEncoder {
    /**
     * Default audio encoding format, which is AMR-NB.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    DEFAULT = 0,

    /**
     * Indicates the AMR-NB audio encoding format.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    AMR_NB = 1,

    /**
     * Indicates the AMR-WB audio encoding format.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    AMR_WB = 2,

    /**
     * Advanced Audio Coding Low Complexity (AAC-LC).
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    AAC_LC = 3,

    /**
     * High-Efficiency Advanced Audio Coding (HE-AAC).
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    HE_AAC = 4
  }

  /**
   * Enumerates audio output formats, it will be deprecated after API8, use @ContainerFormatType to replace.
   * @since 6
   * @syscap SystemCapability.Multimedia.Media.AudioRecorder
   * @import import media from '@ohos.multimedia.media'
   * @deprecated since 8
   */
  enum AudioOutputFormat {
    /**
     * Default audio output format, which is Moving Pictures Expert Group 4 (MPEG-4).
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    DEFAULT = 0,

    /**
     * Indicates the Moving Picture Experts Group-4 (MPEG4) media format.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    MPEG_4 = 2,

    /**
     * Indicates the Adaptive Multi-Rate Narrowband (AMR-NB) media format.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    AMR_NB = 3,

    /**
     * Indicates the Adaptive Multi-Rate Wideband (AMR-WB) media format.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    AMR_WB = 4,

    /**
     * Audio Data Transport Stream (ADTS), a transmission stream format of Advanced Audio Coding (AAC) audio.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    AAC_ADTS = 6
  }

  /**
   * Provides the geographical location definitions for media resources.
   * @since 6
   * @syscap SystemCapability.Multimedia.Media.Core
   */
  interface Location {
    /**
     * Latitude.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    latitude: number;

    /**
     * Longitude.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    longitude: number;
  }

  /**
   * Provides the audio recorder configuration definitions.
   * @since 6
   * @syscap SystemCapability.Multimedia.Media.AudioRecorder
   */
  interface AudioRecorderConfig {
    /**
     * Audio encoding format. The default value is DEFAULT, it will be deprecated after API8.
     * use "audioEncoderMime" instead.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     * @deprecated since 8
     */
    audioEncoder?: AudioEncoder;

    /**
     * Audio encoding bit rate.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    audioEncodeBitRate?: number;

    /**
     * Audio sampling rate.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    audioSampleRate?: number;

    /**
     * Number of audio channels.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    numberOfChannels?: number;

    /**
     * Audio output format. The default value is DEFAULT, it will be deprecated after API8.
     * it will be replaced with "fileFormat".
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     * @deprecated since 8
     */
    format?: AudioOutputFormat;

    /**
     * Audio output uri.support two kind of uri now.
     * format like: scheme + "://" + "context".
     * file:  file://path
     * fd:    fd://fd
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    uri: string;

    /**
     * Geographical location information.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    location?: Location;

    /**
     * audio encoding format MIME. it used to replace audioEncoder.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    audioEncoderMime?: CodecMimeType;
    /**
     * output file format. see @ContainerFormatType , it used to replace "format".
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    fileFormat?: ContainerFormatType;
  }

  /**
   * Manages and record audio. Before calling an AudioRecorder method, you must use createAudioRecorder()
   * to create an AudioRecorder instance.
   * @since 6
   * @syscap SystemCapability.Multimedia.Media.AudioRecorder
   */
  interface AudioRecorder {
    /**
     * Prepares for recording.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     * @param config Recording parameters.
     * @permission ohos.permission.MICROPHONE
     */
    prepare(config: AudioRecorderConfig): void;

    /**
     * Starts audio recording.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    start(): void;

    /**
     * Pauses audio recording.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    pause(): void;

    /**
     * Resumes audio recording.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    resume(): void;

    /**
     * Stops audio recording.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    stop(): void;

    /**
     * Releases resources used for audio recording.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    release(): void;

    /**
     * Resets audio recording.
     * Before resetting audio recording, you must call stop() to stop recording. After audio recording is reset,
     * you must call prepare() to set the recording configurations for another recording.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     */
    reset(): void;

    /**
     * Listens for audio recording events.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     * @param type Type of the audio recording event to listen for.
     * @param callback Callback used to listen for the audio recording event.
     */
    on(type: 'prepare' | 'start' | 'pause' | 'resume' | 'stop' | 'release' | 'reset', callback: () => void): void;

    /**
     * Listens for audio recording error events.
     * @since 6
     * @syscap SystemCapability.Multimedia.Media.AudioRecorder
     * @param type Type of the audio recording error event to listen for.
     * @param callback Callback used to listen for the audio recording error event.
     */
    on(type: 'error', callback: ErrorCallback): void;
  }

  /**
   * Describes video recorder states.
   * @since 9
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   */
  type VideoRecordState = 'idle' | 'prepared' | 'playing' | 'paused' | 'stopped' | 'error';

  /**
   * Manages and record video. Before calling an VideoRecorder method, you must use createVideoRecorder()
   * to create an VideoRecorder instance.
   * @since 9
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   */
  interface VideoRecorder {
    /**
     * Prepares for recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @param config Recording parameters.
     * @param callback A callback instance used to return when prepare completed.
     * @permission ohos.permission.MICROPHONE
     */
    prepare(config: VideoRecorderConfig, callback: AsyncCallback<void>): void;
    /**
     * Prepares for recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @param config Recording parameters.
     * @return A Promise instance used to return when prepare completed.
     * @permission ohos.permission.MICROPHONE
     */
    prepare(config: VideoRecorderConfig): Promise<void>;
    /**
     * get input surface.it must be called between prepare completed and start.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @param callback Callback used to return the input surface id in string.
     */
    getInputSurface(callback: AsyncCallback<string>): void;
    /**
     * get input surface. it must be called between prepare completed and start.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @return A Promise instance used to return the input surface id in string.
     */
    getInputSurface(): Promise<string>;
    /**
     * Starts video recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @param callback A callback instance used to return when start completed.
     */
    start(callback: AsyncCallback<void>): void;
    /**
     * Starts video recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @return A Promise instance used to return when start completed.
     */
    start(): Promise<void>;
    /**
     * Pauses video recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @param callback A callback instance used to return when pause completed.
     */
    pause(callback: AsyncCallback<void>): void;
    /**
     * Pauses video recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @return A Promise instance used to return when pause completed.
     */
    pause(): Promise<void>;
    /**
     * Resumes video recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @param callback A callback instance used to return when resume completed.
     */
    resume(callback: AsyncCallback<void>): void;
    /**
     * Resumes video recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @return A Promise instance used to return when resume completed.
     */
    resume(): Promise<void>;
    /**
     * Stops video recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @param callback A callback instance used to return when stop completed.
     */
    stop(callback: AsyncCallback<void>): void;
    /**
     * Stops video recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @return A Promise instance used to return when stop completed.
     */
    stop(): Promise<void>;
    /**
     * Releases resources used for video recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @param callback A callback instance used to return when release completed.
     */
    release(callback: AsyncCallback<void>): void;
    /**
     * Releases resources used for video recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @return A Promise instance used to return when release completed.
     */
    release(): Promise<void>;
    /**
     * Resets video recording.
     * Before resetting video recording, you must call stop() to stop recording. After video recording is reset,
     * you must call prepare() to set the recording configurations for another recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @param callback A callback instance used to return when reset completed.
     */
    reset(callback: AsyncCallback<void>): void;
    /**
     * Resets video recording.
     * Before resetting video recording, you must call stop() to stop recording. After video recording is reset,
     * you must call prepare() to set the recording configurations for another recording.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @return A Promise instance used to return when reset completed.
     */
    reset(): Promise<void>;
    /**
     * Listens for video recording error events.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     * @param type Type of the video recording error event to listen for.
     * @param callback Callback used to listen for the video recording error event.
     */
    on(type: 'error', callback: ErrorCallback): void;

    /**
     * video recorder state.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly state: VideoRecordState;
  }

  /**
   * Describes video playback states.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   */
  type VideoPlayState = 'idle' | 'prepared' | 'playing' | 'paused' | 'stopped' | 'error';

  /**
   * Enumerates playback speed.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   */
  enum PlaybackSpeed {
    /**
     * playback at 0.75x normal speed
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    SPEED_FORWARD_0_75_X = 0,
    /**
     * playback at normal speed
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    SPEED_FORWARD_1_00_X = 1,
    /**
     * playback at 1.25x normal speed
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    SPEED_FORWARD_1_25_X = 2,
    /**
     * playback at 1.75x normal speed
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    SPEED_FORWARD_1_75_X = 3,
    /**
     * playback at 2.0x normal speed
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    SPEED_FORWARD_2_00_X = 4,
  }

  /**
   * Manages and plays video. Before calling an video method, you must use createVideoPlayer() to create an VideoPlayer
   * instance.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   * @import import media from '@ohos.multimedia.media'
   */
  interface VideoPlayer {
    /**
     * set display surface.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param surfaceId surface id, video player will use this id get a surface instance.
     * @return A Promise instance used to return when release output buffer completed.
     */
    setDisplaySurface(surfaceId: string, callback: AsyncCallback<void>): void;
    /**
     * set display surface.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param surfaceId surface id, video player will use this id get a surface instance.
     * @return A Promise instance used to return when release output buffer completed.
     */
    setDisplaySurface(surfaceId: string): Promise<void>;
    /**
     * prepare video playback, it will request resource for playing.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback A callback instance used to return when prepare completed.
     */
    prepare(callback: AsyncCallback<void>): void;
    /**
     * prepare video playback, it will request resource for playing.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @return A Promise instance used to return when prepare completed.
     */
    prepare(): Promise<void>;
    /**
     * Starts video playback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback A callback instance used to return when start completed.
     */
    play(callback: AsyncCallback<void>): void;
    /**
     * Starts video playback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @return A Promise instance used to return when start completed.
     */
    play(): Promise<void>;
    /**
     * Pauses video playback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback A callback instance used to return when pause completed.
     */
    pause(callback: AsyncCallback<void>): void;
    /**
     * Pauses video playback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @return A Promise instance used to return when pause completed.
     */
    pause(): Promise<void>;
    /**
     * Stops video playback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback A callback instance used to return when stop completed.
     */
    stop(callback: AsyncCallback<void>): void;
    /**
     * Stops video playback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @return A Promise instance used to return when stop completed.
     */
    stop(): Promise<void>;
    /**
     * Resets video playback, it will release the resource.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback A callback instance used to return when reset completed.
     */
    reset(callback: AsyncCallback<void>): void;
    /**
     * Resets video playback, it will release the resource.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @return A Promise instance used to return when reset completed.
     */
    reset(): Promise<void>;
    /**
     * Jumps to the specified playback position by default SeekMode(SEEK_CLOSEST),
     * the performance may be not the best.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param timeMs Playback position to jump
     * @param callback A callback instance used to return when seek completed
     * and return the seeking position result.
     */
    seek(timeMs: number, callback: AsyncCallback<number>): void;
    /**
     * Jumps to the specified playback position.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param timeMs Playback position to jump
     * @param mode seek mode, see @SeekMode .
     * @param callback A callback instance used to return when seek completed
     * and return the seeking position result.
     */
    seek(timeMs: number, mode:SeekMode, callback: AsyncCallback<number>): void;
    /**
     * Jumps to the specified playback position.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param timeMs Playback position to jump
     * @param mode seek mode, see @SeekMode .
     * @return A Promise instance used to return when seek completed
     * and return the seeking position result.
     */
    seek(timeMs: number, mode?:SeekMode): Promise<number>;
    /**
     * Sets the volume.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param vol Relative volume. The value ranges from 0.00 to 1.00. The value 1 indicates the maximum volume (100%).
     * @param callback A callback instance used to return when set volume completed.
     */
    setVolume(vol: number, callback: AsyncCallback<void>): void;
    /**
     * Sets the volume.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param vol Relative volume. The value ranges from 0.00 to 1.00. The value 1 indicates the maximum volume (100%).
     * @return A Promise instance used to return when set volume completed.
     */
    setVolume(vol: number): Promise<void>;
    /**
     * Releases resources used for video playback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback A callback instance used to return when release completed.
     */
    release(callback: AsyncCallback<void>): void;
    /**
     * Releases resources used for video playback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @return A Promise instance used to return when release completed.
     */
    release(): Promise<void>;
    /**
     * get all track infos in MediaDescription, should be called after data loaded callback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback async callback return track info in MediaDescription.
     */
    getTrackDescription(callback: AsyncCallback<Array<MediaDescription>>): void;

    /**
     * get all track infos in MediaDescription, should be called after data loaded callback..
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @return A Promise instance used to return the track info in MediaDescription.
     */
    getTrackDescription() : Promise<Array<MediaDescription>>;

    /**
     * media url. Mainstream video formats are supported.
     * local:fd://XXX, file://XXX. network:http://xxx
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    url: string;

    /**
     * Video file descriptor. Mainstream video formats are supported.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    fdSrc: AVFileDescriptor;

    /**
     * Whether to loop video playback. The value true means to loop playback.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    loop: boolean;

    /**
     * Current playback position.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    readonly currentTime: number;

    /**
     * Playback duration, if -1 means cannot seek.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    readonly duration: number;

    /**
     * Playback state.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    readonly state: VideoPlayState;

    /**
     * video width, valid after prepared.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    readonly width: number;

    /**
     * video height, valid after prepared.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    readonly height: number;

    /**
     * Describes audio interrupt mode, refer to {@link #audio.InterruptMode}. If it is not
     * set, the default mode will be used. Set it before calling the {@link #play()} in the
     * first time in order for the interrupt mode to become effective thereafter.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    audioInterruptMode ?: audio.InterruptMode;

    /**
     * video scale type. Defaultly, the {@link #VIDEO_SCALE_TYPE_FIT} will be used, for more
     * information, refer to {@link #VideoScaleType}
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    videoScaleType ?: VideoScaleType;

    /**
     * set payback speed.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param speed playback speed, see @PlaybackSpeed .
     * @param callback Callback used to return actually speed.
     */
    setSpeed(speed:number, callback: AsyncCallback<number>): void;
    /**
     * set output surface.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param speed playback speed, see @PlaybackSpeed .
     * @return A Promise instance used to return actually speed.
     */
    setSpeed(speed:number): Promise<number>;

    /**
     * select a specified bitrate to playback, only valid for HLS protocal network stream. Defaulty, the
     * player will select the appropriate bitrate according to the network connection speed. The
     * available bitrates list reported by {@link #on('availableBitratesCollect')}. Set it to select
     * a specified bitrate. If the specified bitrate is not in the list of available bitrates, the player
     * will select the minimal and closest one from the available bitrates list.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param bitrate the playback bitrate must be expressed in bits per second.
     * @return A Promise instance used to return actually selected bitrate.
     */
    selectBitrate(bitrate: number): Promise<number>;

    /**
     * select a specified bitrate to playback, only valid for HLS protocal network stream. Defaulty, the
     * player will select the appropriate bitrate according to the network connection speed. The
     * available bitrates list reported by {@link #on('availableBitratesCollect')}. Set it to select
     * a specified bitrate. If the specified bitrate is not in the list of available bitrates, the player
     * will select the minimal and closest one from the available bitrates list.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param bitrate the playback bitrate must be expressed in bits per second.
     * @param callback Callback used to return actually selected bitrate.
     */
    selectBitrate(bitrate: number, callback: AsyncCallback<number>): void;

    /**
     * Listens for video playback completed events.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event return .
     */
    on(type: 'playbackCompleted', callback: Callback<void>): void;

    /**
     * Listens for video playback buffering events.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback buffering update event to listen for.
     * @param callback Callback used to listen for the buffering update event, return BufferingInfoType and the value.
     */
    on(type: 'bufferingUpdate', callback: (infoType: BufferingInfoType, value: number) => void): void;

    /**
     * Listens for start render video frame events.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event return .
     */
    on(type: 'startRenderFrame', callback: Callback<void>): void;

    /**
     * Listens for video size changed event.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event return video size.
     */
    on(type: 'videoSizeChanged', callback: (width: number, height: number) => void): void;

    /**
     * Listens for audio interrupt event, refer to {@link #audio.InterruptEvent}
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event return audio interrupt info.
     */
    on(type: 'audioInterrupt', callback: (info: audio.InterruptEvent) => void): void;

    /**
     * Listens for available bitrates collect completed events for HLS protocal stream playback.
     * This event will be reported after the {@link #prepare} called.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event return available bitrates.
     */
    on(type: 'availableBitratesCollect', callback: (bitrates: Array<number>) => void): void;

    /**
     * Listens for playback error events.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback error event to listen for.
     * @param callback Callback used to listen for the playback error event.
     */
    on(type: 'error', callback: ErrorCallback): void;

    /**
     * Extend API for TV
     * set stop mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param mode stop mode. The value is 0 or 1. 0:BLACK mode, 1:LASTFRAME mode
     * @return callback Callback used to return when set stop mode completed
     */
    setStopMode(mode: number, callback: Callback<void>): void;

    /**
     * Extend API for TV
     * get stop mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback Callback used to return stop mode.
     */
    getStopMode(callback: Callback<number>): void;

    /**
     * Extend API for TV
     * get the start time of time shift program
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback Callback used to return the start time of time shift program
     */
    getStartTime(callback: Callback<number>): void;

    /**
     * Extend API for TV
     * set display mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param mode see@DisPlayMode
     * @param callback Callback used to return when set display mode completed.
     */
    setDisplayMode(mode: DisPlayMode, callback: Callback<void>): void;

    /**
     * Extend API for TV
     * get display mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback Callback used to return the display mode
     */
    getDisplayMode(callback: Callback<DisPlayMode>): void;

    /**
     * Extend API for TV
     * set display ratio
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param eRatio see@DisplayRatio
     * @param callback Callback used to return when set display ratio completed.
     */
    setDisplayRatio(eRatio: DisplayRatio, callback: Callback<void>):void;

    /**
     * Extend API for TV
     * get display ratio
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback Callback used to return the display ratio
     */
    getDisplayRatio(callback: Callback<DisplayRatio>): void;

    /**
     * Extend API for TV
     * set video display
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param flag The value is 0 or 1. 0:close display, 1:open display
     * @param callback Callback used to return when set video display completed.
     */
    setVideoDisplay(flag: number, callback: Callback<void>): void;

    setVideoZOrder(zIndex:number): any
    setVideoDisplay(flag: number): any;

    /**
     * Extend API for TV
     * get video display
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback Callback used to return the video display flag
     */
    getVideoDisplay(callback: Callback<number>): void;

    /**
     * Extend API for TV
     * set audio mute
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param mute: The value is 0 or 1. 0:unmute, 1:mute
     * @param callback Callback used to return when set audio mute completed.
     */
    setAudioMute(mute: number, callback: Callback<void>): void;

    /**
     * Extend API for TV
     * get audio mute
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback Callback used to return the audio mute flag
     */
    getAudioMute(callback: Callback<number>): void;

    /**
     * Extend API for TV
     * set audio channel mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param mode: see @AudioChannelMode
     * @param callback Callback used to return when set audio channel mode completed.
     */
    setAudioChannelMode(type: number, callback: Callback<void>): void;

    /**
     * Extend API for TV
     * get audio channel mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback Callback used to return the audio channel mode
     */
    getAudioChannelMode(callback: Callback<number>): void;

    /**
     * Extend API for TV
     * select audio stream
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param audioPid audioPid
     * @param audioCodec audioCodec
     * @param callback Callback used to return when select audio stream completed.
     */
    selectAudioStream(audioPid: number, audioCodec: number, callback: Callback<void>): void;

    /**
     * Extend API for TV
     * get current language
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback Callback used to return the current language
     */
    getCurrentLanguage(callback: Callback<string>): void;

    /**
     * Extend API for TV
     * set clip
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param area: see@VideoArea
     * @param callback Callback used to return when set clip completed.
     */
    setClip(area: VideoArea, callback: Callback<void>): void;

    /**
     * Extend API for TV
     * get clip
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback Callback used to return the current clip
     */
    getClip(callback: Callback<VideoArea>): void;

    /**
     * Extend API for TV
     * set video area
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param area: video display area, see@VideoArea
     * @param callback Callback used to return when set video area completed.
     */
    setVideoArea(area: VideoArea, callback: Callback<void>): void;

    /**
     * Extend API for TV
     * get video area
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param callback Callback used to return the current video area
     */
    getVideoArea(callback: Callback<VideoArea>): void;

    /**
     * Extend API for TV
     * Listens for start render frame events.
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event.
     */
    on(type: 'startRenderFrame', callback: Callback<void>): void;

    /**
     * Extend API for TV
     * Listens for not stream events.
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event.
     */
    on(type: 'haveNoStream', callback: Callback<void>): void;

    /**
     * Extend API for TV
     * Listens for stream recover events.
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event.
     */
    on(type: 'streamRecover', callback: Callback<void>): void;

    /**
     * Extend API for TV
     * Listens for video size change events.
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     * @param type Type of the playback event to listen for.
     * @param callback Callback used to listen for the playback event.
     */
    on(type: 'videoSizeChange', callback: (width: number, height: number) => void): void;

  }

  /**
   * Enumerates video scale type.
   * @since 9
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   * @import import media from '@ohos.multimedia.media'
   */
  enum VideoScaleType {
    /**
     * The content is stretched to the fit the display surface rendering area. When
     * the aspect ratio of the content is not same as the display surface, the aspect
     * of the content is not maintained. This is the default scale type.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    VIDEO_SCALE_TYPE_FIT = 0,

    /**
     * The content is stretched to the fit the display surface rendering area. When
     * the aspect ratio of the content is not the same as the display surface, content's
     * aspect ratio is maintained and the content is cropped to fit the display surface.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    VIDEO_SCALE_TYPE_FIT_CROP = 1,
  }

  /**
   * Enumerates container format type(The abbreviation for 'container format type' is CFT).
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.Core
   * @import import media from '@ohos.multimedia.media'
   */
  enum ContainerFormatType {
    /**
     * A video container format type mp4.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    CFT_MPEG_4 = "mp4",

    /**
     * A audio container format type m4a.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    CFT_MPEG_4A = "m4a",
  }

  /**
   * Enumerates media data type.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.Core
   * @import import media from '@ohos.multimedia.media'
   */
  enum MediaType {
    /**
     * track is audio.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MEDIA_TYPE_AUD = 0,
    /**
     * track is video.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MEDIA_TYPE_VID = 1,
  }

  /**
   * Enumerates media description key.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.Core
   * @import import media from '@ohos.multimedia.media'
   */
  enum MediaDescriptionKey {
    /**
     * key for track index, value type is number.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MD_KEY_TRACK_INDEX = "track_index",

    /**
     * key for track type, value type is number, see @MediaType.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MD_KEY_TRACK_TYPE = "track_type",

    /**
     * key for codec mime type, value type is string.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MD_KEY_CODEC_MIME = "codec_mime",

    /**
     * key for duration, value type is number.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MD_KEY_DURATION = "duration",

    /**
     * key for bitrate, value type is number.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MD_KEY_BITRATE = "bitrate",

    /**
     * key for video width, value type is number.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MD_KEY_WIDTH = "width",

    /**
     * key for video height, value type is number.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MD_KEY_HEIGHT = "height",

    /**
     * key for video frame rate, value type is number.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MD_KEY_FRAME_RATE = "frame_rate",

    /**
     * key for audio channel count, value type is number
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MD_KEY_AUD_CHANNEL_COUNT = "channel_count",

    /**
     * key for audio sample rate, value type is number
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    MD_KEY_AUD_SAMPLE_RATE = "sample_rate",
  }

  /**
   * Provides the video recorder profile definitions.
   * @since 9
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   */
  interface VideoRecorderProfile {
    /**
     * Indicates the audio bit rate.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly audioBitrate: number;

    /**
     * Indicates the number of audio channels.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly audioChannels: number;

    /**
     * Indicates the audio encoding format.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly audioCodec: CodecMimeType;

    /**
     * Indicates the audio sampling rate.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly audioSampleRate: number;

    /**
     * Indicates the output file format.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly fileFormat: ContainerFormatType;

    /**
     * Indicates the video bit rate.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly videoBitrate: number;

    /**
     * Indicates the video encoding format.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly videoCodec: CodecMimeType;

    /**
     * Indicates the video width.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly videoFrameWidth: number;

    /**
     * Indicates the video height.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly videoFrameHeight: number;

    /**
     * Indicates the video frame rate.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    readonly videoFrameRate: number;
  }

  /**
   * Enumerates audio source type for recorder.
   * @since 9
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   * @import import media from '@ohos.multimedia.media'
   */
  enum AudioSourceType {
    /**
     * default audio source type.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    AUDIO_SOURCE_TYPE_DEFAULT = 0,
    /**
     * source type mic.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    AUDIO_SOURCE_TYPE_MIC = 1,
  }

  /**
   * Enumerates video source type for recorder.
   * @since 9
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   * @import import media from '@ohos.multimedia.media'
   */
  enum VideoSourceType {
    /**
     * surface raw data.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    VIDEO_SOURCE_TYPE_SURFACE_YUV = 0,
    /**
     * surface ES data.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    VIDEO_SOURCE_TYPE_SURFACE_ES = 1,
  }

  /**
   * Provides the video recorder configuration definitions.
   * @since 9
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   */
  interface VideoRecorderConfig {
    /**
     * audio source type, details see @AudioSourceType .
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    audioSourceType: AudioSourceType;
    /**
     * video source type, details see @VideoSourceType .
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    videoSourceType: VideoSourceType;
    /**
     * video recorder profile, can get by "getVideoRecorderProfile", details see @VideoRecorderProfile .
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    profile: VideoRecorderProfile;
    /**
     * video output uri.support two kind of uri now.
     * format like: scheme + "://" + "context".
     * file:  file://path
     * fd:    fd://fd
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    url: string;
    /**
     * Sets the video rotation angle in output file, and for the file to playback. mp4 support.
     * the range of rotation angle should be {0, 90, 180, 270}, default is 0.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    rotation?: number;
    /**
     * geographical location information.
     * @since 9
     * @syscap SystemCapability.Multimedia.Media.VideoRecorder
     */
    location?: Location;
  }

  /**
   * Provides the container definition for media description key-value pairs.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.Core
   */
  interface MediaDescription {
    /**
     * key:value pair, key see @MediaDescriptionKey .
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    [key : string]: Object;
  }

  /**
   * Enumerates seek mode.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.Core
   * @import import media from '@ohos.multimedia.media'
   */
  enum SeekMode {
    /**
     * seek to the next sync frame of the given timestamp
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    SEEK_NEXT_SYNC = 0,
    /**
     * seek to the previous sync frame of the given timestamp
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    SEEK_PREV_SYNC = 1,
  }

  /**
   * Enumerates Codec MIME types.
   * @since 8
   * @syscap SystemCapability.Multimedia.Media.Core
   * @import import media from '@ohos.multimedia.media'
   */
  enum CodecMimeType {
    /**
     * H.263 codec MIME type.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    VIDEO_H263 = 'video/h263',
    /**
     * H.264 codec MIME type.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    VIDEO_AVC = 'video/avc',
    /**
     * MPEG2 codec MIME type.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    VIDEO_MPEG2 = 'video/mpeg2',
    /**
     * MPEG4 codec MIME type
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    VIDEO_MPEG4 = 'video/mp4v-es',

    /**
     * VP8 codec MIME type
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    VIDEO_VP8 = 'video/x-vnd.on2.vp8',

    /**
     * AAC codec MIME type.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    AUDIO_AAC = 'audio/mp4a-latm',

    /**
     * vorbis codec MIME type.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    AUDIO_VORBIS = 'audio/vorbis',

    /**
     * flac codec MIME type.
     * @since 8
     * @syscap SystemCapability.Multimedia.Media.Core
     */
    AUDIO_FLAC = 'audio/flac',
  }

  /**
   * Extend for TV
   * Description of video area
   * @since 1
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   */
  interface VideoArea {
    /**
     * Extend for TV
     * describe video area, x coordinate of the upper left corner of the window
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    x: number;
    /**
     * Extend for TV
     * describe video area, y coordinate of the upper left corner of the window
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    y: number;

    /**
     * Extend for TV
     * describe video area, width of the window
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    width: number;

    /**
     * Extend for TV
     * describe video area, height of the window
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    height: number;
  }

  /**
   * Extend API for TV
   * Enumerates audio channel mode.
   * @since 1
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   */
  enum AudioChannelMode  {
    /**
     * stereo mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    AUDIO_CHANNEL_MODE_STEREO = 0,
    /**
     * stereo mixing into left and right channel output: left，right，left，right…
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    AUDIO_CHANNEL_MODE_DOUBLE_MONO = 1,
    /**
     * double left channel output
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    AUDIO_CHANNEL_MODE_DOUBLE_LEFT = 2,
    /**
     * double right channel output
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    AUDIO_CHANNEL_MODE_DOUBLE_RIGHT = 3,
    /**
     * output with left channel and right channel exchanging
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    AUDIO_CHANNEL_MODE_EXCHANGE = 4,
    /**
     * only right channel output
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    AUDIO_CHANNEL_MODE_ONLY_RIGHT = 5,
    /**
     * only left channel output
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    AUDIO_CHANNEL_MODE_ONLY_LEFT = 6,
    /**
     * mute mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    AUDIO_CHANNEL_MODE_MUTED = 7,
  }

  /**
   * Extend API for TV
   * Enumerates display ratio.
   * @since 1
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   */
  enum DisplayRatio {
    /**
     * display ratio 4:3
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    DISPLAY_RATIO_4TO3 = 0,
    /**
     * display ratio 16:9
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    DISPLAY_RATIO_16TO9 = 1,
    /**
     * display ratio auto
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    DISPLAY_RATIO_AUTO = 6,
    /**
     * display ratio error
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    DISPLAY_RATIO_ERROR = 7,
  }

  /**
   * Extend API for TV
   * Enumerates display mode.
   * @since 1
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   */
  enum DisPlayMode {
    /**
     * display pan scan mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    DIS_MODE_PAN_SCAN = 0,
    /**
     * display letterbox mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    DIS_MODE_LETTERBOX,
    /**
     * display combined mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    DIS_MODE_COMBINED,
    /**
     * display ignore mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    DIS_MODE_IGNORE,
    /**
     * display custom mode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    DIS_MODE_CUSTOM,
  }

  /**
   * Extend API for TV
   * Enumerates paramType.
   * @since 1
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   */
  enum ParamType {
    /**
     * Turn on or off video display, type: number, 0: close, 1: open
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_CTRL_VDISP = 0,
    /**
     * FTP MODE SETTING, type: number, 1: port mode,0: passive, default: 0
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_FTP_MODE,
    /**
     * unique id, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_UNIQID,
    /**
     * zorder, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_ZORDER,
    /**
     * input window, type: VideoArea
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_INPUT_RECT,
    /**
     * rotation, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_ROTATION,
    /**
     * dolby stream info, type: DolbyStreamInfo
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DOLBY_STREAM_INFO,
    /**
     * dolby drc mode, type: ParamDolbyDcrMode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DOLBY_DRC_MODE,
    /**
     * dolby drc range, type: DolbyDcrRange
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DOLBY_DRC_RANGE,
    /**
     * dolby dmx mode, type: DolbyDmxMode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DOLBY_DMX_MODE,
    /**
     * set adaptive bandwidth, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_ADAP_BANDWIDTH,
    /**
     * set buffer time, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_BUFFERTIME,
    /**
     * set buffer watermark, type:BufferWaterMark
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_BUFFERWATERMARK,
    /**
     * set useragent, type:string; HTTP request header field
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_USERAGENT,
    /**
     * set byte range, type:boolean; byte-range HTTP header,default is 1
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_BYTERANGE,
    /**
     * set cookies, type:Cookies; HTTP request cookies
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_COOKIES,
    /**
     * set referer, type:string; Referer HTTP header
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_REFERER,
    /**
     * get download rate, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DOWNLOADRATE,
    /**
     * get buffer status, type:BufferStatus
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_BUFFERSTATUS,
    /**
     * pace mode, type:PlayerPaceMode
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_PACE_MODE,
    /**
     * set the time which client want to seek, type string, unit seconds
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_HTTP_RANGETIME,
    /**
     * set play type, type: string
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_PLAY_TYPE,
    /**
     * fcc mode, type: boolean
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_FCC_MODE,
    /**
     * enable ffmpeg native seek for mpegts or not, type: number, 1: enable, 0: disable, default: 0
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_FAST_SEEK_MODE,
    /**
     * sync mode, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_SYNC_MODE,
    /**
     * sideband mode, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_SIDEBAND_MODE,
    /**
     * thumbnail mode, type: boolean
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_THUMBNAIL_MODE,
    /**
     * metadata, type: MetadataInfo
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_METADATA,
    /**
     * the type for start display, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DVBSYNC_START_TYPE,
    /**
     * max time for pre-synchronization maximum time, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DVBSYNC_MAX_PRE_SYNC_TIME,
    /**
     * video fast/slow synchronization, type: boolean
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DVBSYNC_VIDEO_FAST_SYNC,
    /**
     * the diff pts values for abnormal stream, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DVBSYNC_MAX_AV_PTS_DIFF,
    /**
     * max time for slow display, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DVBSYNC_MAX_SLOW_PLAY_TIME,
    /**
     * waiting time for start display, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DVBSYNC_MAX_WAIT_ANOTHER_STREAM_TIME,
    /**
     * exception threshold of advance synchronous, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DVBSYNC_MAXEARLINESS,
    /**
     * exception threshold of hysteresis synchronous, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DVBSYNC_MAXLATENESS,
    /**
     * handle method for exception threshold, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DVBSYNC_HANDLE_ABNORMAL_BUF,
    /**
     * file size for app src, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_FILESIZE_FOR_APPSRC,
    /**
     * cal mode, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_CAL_MODE,
    /**
     * multi program index, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_MULTI_PROG_IDX,
    /**
     * multi program info, type: ProgramInfo
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_MULTI_PROG_INFO,
    /**
     * setup udp interface, type: string
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_MULTI_IFACE,
    /**
     * set HTTP persistent connection, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_KEEP_ALIVE,
    /**
     * The time of buffer invalid when the player is prepared, type: number
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_DISABLE_BUFFERTIME,
    /**
     * set app name for pulse asink, to decide priority, type:string
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_APP_NAME_FOR_PULSE_ASINK,
    /**
     * is 4k enable, type:boolean
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_ENABLE_4K,
    /**
     * butt
     * @since 1
     * @syscap SystemCapability.Multimedia.Media.VideoPlayer
     */
    PARAM_TYPE_BUTT
  }

}
export default media;
