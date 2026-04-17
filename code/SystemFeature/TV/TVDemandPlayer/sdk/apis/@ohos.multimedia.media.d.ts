/*
* Copyright (C) 2021-2024 Huawei Device Co., Ltd.
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

/**
 * @file
 * @kit MediaKit
 */

import { ErrorCallback, AsyncCallback, Callback } from './@ohos.base';
import audio from './@ohos.multimedia.audio';
import photoAccessHelper from './@ohos.file.photoAccessHelper';
import type image from './@ohos.multimedia.image';
import type { SoundPool as _SoundPool } from './multimedia/soundPool';
import type { PlayParameters as _PlayParameters } from './multimedia/soundPool';
import type drm from './@ohos.multimedia.drm';

/**
 * @namespace media
 * @since 6
 */
/**
 * @namespace media
 * @atomicservice
 * @since 11
 */
/**
 * @namespace media
 * @syscap SystemCapability.Multimedia.Media.Core
 * @crossplatform
 * @atomicservice
 * @since 12
 */
declare namespace media {
  /**
   * Creates an AVPlayer instance.
   * @param { AsyncCallback<AVPlayer> } callback - used to return AVPlayer instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by callback.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @since 9
   */
  /**
   * Creates an AVPlayer instance.
   * @param { AsyncCallback<AVPlayer> } callback - used to return AVPlayer instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by callback.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @atomicservice
   * @since 11
   */
  /**
   * Creates an AVPlayer instance.
   * @param { AsyncCallback<AVPlayer> } callback - used to return AVPlayer instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by callback.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  function createAVPlayer(callback: AsyncCallback<AVPlayer>): void;

  /**
   * Creates an AVPlayer instance.
   * @returns { Promise<AVPlayer> } A Promise instance used to return AVPlayer instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @since 9
   */
  /**
   * Creates an AVPlayer instance.
   * @returns { Promise<AVPlayer> } A Promise instance used to return AVPlayer instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @atomicservice
   * @since 11
   */
  /**
   * Creates an AVPlayer instance.
   * @returns { Promise<AVPlayer> } A Promise instance used to return AVPlayer instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  function createAVPlayer(): Promise<AVPlayer>;

  /**
   * Creates an AVRecorder instance.
   * @param { AsyncCallback<AVRecorder> } callback - used to return AVRecorder instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by callback.
   * @syscap SystemCapability.Multimedia.Media.AVRecorder
   * @since 9
   */
  /**
   * Creates an AVRecorder instance.
   * @param { AsyncCallback<AVRecorder> } callback - used to return AVRecorder instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by callback.
   * @syscap SystemCapability.Multimedia.Media.AVRecorder
   * @crossplatform
   * @since 12
   */
  function createAVRecorder(callback: AsyncCallback<AVRecorder>): void;

  /**
   * Creates an AVRecorder instance.
   * @returns { Promise<AVRecorder> } A Promise instance used to return AVRecorder instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.AVRecorder
   * @since 9
   */
  /**
   * Creates an AVRecorder instance.
   * @returns { Promise<AVRecorder> } A Promise instance used to return AVRecorder instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.AVRecorder
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  function createAVRecorder(): Promise<AVRecorder>;

  /**
   * Creates an AudioPlayer instance.
   * @returns { AudioPlayer } Returns an AudioPlayer instance if the operation is successful; returns null otherwise.
   * @syscap SystemCapability.Multimedia.Media.AudioPlayer
   * @since 6
   * @deprecated since 9
   * @useinstead ohos.multimedia.media/media#createAVPlayer
   */
  function createAudioPlayer(): AudioPlayer;

  /**
   * Creates an AudioRecorder instance.
   * @returns { AudioRecorder } Returns an AudioRecorder instance if the operation is successful; returns null otherwise.
   * @syscap SystemCapability.Multimedia.Media.AudioRecorder
   * @since 6
   * @deprecated since 9
   * @useinstead ohos.multimedia.media/media#createAVRecorder
   */
  function createAudioRecorder(): AudioRecorder;

  /**
   * Create MediaSource from url.
   * @param { string } url : The location for the media source.
   * @param { Record<string, string> } headers : Headers attached to network request while player request data.
   * @returns { MediaSource } MediaSource instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   * <br>2. Incorrect parameter types. 3.Parameter verification failed.
   * @throws { BusinessError } 5400101 - No memory.
   * @syscap SystemCapability.Multimedia.Media.Core
   * @since 12
   */
  /**
   * Create MediaSource from url.
   * @param { string } url : The location for the media source.
   * @param { Record<string, string> } headers : Headers attached to network request while player request data.
   * @returns { MediaSource } MediaSource instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   * <br>2. Incorrect parameter types. 3.Parameter verification failed.
   * @throws { BusinessError } 5400101 - No memory.
   * @syscap SystemCapability.Multimedia.Media.Core
   * @atomicservice
   * @since 13
   */
  function createMediaSourceWithUrl(url: string, headers?: Record<string, string>): MediaSource;

  /**
   * Creates an VideoPlayer instance.
   * @param { AsyncCallback<VideoPlayer> } callback - used to return AudioPlayer instance if the operation is successful; returns null otherwise.
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   * @since 8
   * @deprecated since 9
   * @useinstead ohos.multimedia.media/media#createAVPlayer
   */
  function createVideoPlayer(callback: AsyncCallback<VideoPlayer>): void;

  /**
   * Creates an VideoPlayer instance.
   * @returns { Promise<VideoPlayer> } A Promise instance used to return VideoPlayer instance if the operation is successful; returns null otherwise.
   * @syscap SystemCapability.Multimedia.Media.VideoPlayer
   * @since 8
   * @deprecated since 9
   * @useinstead ohos.multimedia.media/media#createAVPlayer
   */
  function createVideoPlayer(): Promise<VideoPlayer>;

  /**
   * The maintenance of this interface has been stopped since version api 9. Please use AVRecorder
   * Creates an VideoRecorder instance.
   * @param { AsyncCallback<VideoRecorder> } callback - used to return AudioPlayer instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by callback.
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   * @systemapi
   * @since 9
   */
  /**
   * The maintenance of this interface has been stopped since version api 9. Please use AVRecorder
   * Creates an VideoRecorder instance.
   * @param { AsyncCallback<VideoRecorder> } callback - used to return AudioPlayer instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 202 - Not System App.
   * @throws { BusinessError } 5400101 - No memory. Return by callback.
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   * @systemapi
   * @since 12
   */
  function createVideoRecorder(callback: AsyncCallback<VideoRecorder>): void;

  /**
   * The maintenance of this interface has been stopped since version api 9. Please use AVRecorder
   * Creates an VideoRecorder instance.
   * @returns { Promise<VideoRecorder> } A Promise instance used to return VideoRecorder instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   * @systemapi
   * @since 9
   */
  /**
   * The maintenance of this interface has been stopped since version api 9. Please use AVRecorder
   * Creates an VideoRecorder instance.
   * @returns { Promise<VideoRecorder> } A Promise instance used to return VideoRecorder instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 202 - Not System App.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.VideoRecorder
   * @systemapi
   * @since 12
   */
  function createVideoRecorder(): Promise<VideoRecorder>;

  /**
   * Creates a soundPool instance.
   *
   * @param {number} maxStreams The maximum number of simultaneous streams for this soundPool instance
   * @param {audio.AudioRendererInfo} audioRenderInfo Audio renderer information
   * @param {AsyncCallback<SoundPool>} callback Callback used to return soundPool instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by callback.
   * @syscap SystemCapability.Multimedia.Media.SoundPool
   * @since 10
   */
  function createSoundPool(
    maxStreams: number,
    audioRenderInfo: audio.AudioRendererInfo,
    callback: AsyncCallback<SoundPool>
  ): void;

  /**
   * Creates a soundPool instance.
   *
   * @param {number} maxStreams The maximum number of simultaneous streams for this soundPool instance
   * @param {audio.AudioRendererInfo} audioRenderInfo Audio renderer information
   * @returns {Promise<SoundPool>} A Promise instance used to return SoundPool instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.SoundPool
   * @since 10
   */
  function createSoundPool(maxStreams: number, audioRenderInfo: audio.AudioRendererInfo): Promise<SoundPool>;

  /**
   * Creates an AVScreenCaptureRecorder instance.
   * @returns { Promise<AVScreenCaptureRecorder> } A Promise instance used to return AVScreenCaptureRecorder instance if the operation is successful;
   * returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.AVScreenCapture
   * @since 12
   */
  function createAVScreenCaptureRecorder(): Promise<AVScreenCaptureRecorder>;

  /**
   * Report user choice back to AVScreenCapture server
   *
   * @param {number} sessionId The AVScreenCapture server session ID.
   * @param {string} choice Content chosen by user.
   * @returns { Promise<void> } Promise used to return the result.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
   * <br>2. Incorrect parameter types. 3.Parameter verification failed.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.AVScreenCapture
   * @systemapi
   * @since 12
   */
  function reportAVScreenCaptureUserChoice(sessionId: number, choice: string): Promise<void>;

  /**
   * Creates a AVTranscoder instance.
   *
   * @returns {Promise<AVTranscoder>} A Promise instance used to return AVTranscoder instance if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.AVTranscoder
   * @since 12
   */
  function createAVTranscoder(): Promise<AVTranscoder>;

  /**
   * Get the ScreenCaptureMonitor instance
   *
   * @returns { Promise<ScreenCaptureMonitor> } A Promise instance used to return ScreenCaptureMonitor instance if the operation is successful;
   * returns null otherwise.
   * @throws { BusinessError } 202 - Not System App.
   * @throws { BusinessError } 5400101 - No memory. Return by promise.
   * @syscap SystemCapability.Multimedia.Media.AVScreenCapture
   * @systemapi
   * @since 18
   */
  function getScreenCaptureMonitor(): Promise<ScreenCaptureMonitor>;

  /**
   * Manages and plays sound. Before calling an SoundPool method, you must use createSoundPool()
   * to create an SoundPool instance.
   *
   * @typedef { _SoundPool }
   * @syscap SystemCapability.Multimedia.Media.SoundPool
   * @since 10
   */
  type SoundPool = _SoundPool;

  /**
   * Describes play parameters.
   *
   * @typedef { _PlayParameters }
   * @syscap SystemCapability.Multimedia.Media.SoundPool
   * @since 10
   */
  type PlayParameters = _PlayParameters;

  /**
   * Enumerates state change reason.
   *
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.Core
   * @since 9
   */
  /**
   * Enumerates state change reason.
   *
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.Core
   * @atomicservice
   * @since 11
   */
  /**
   * Enumerates state change reason.
   *
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  enum StateChangeReason {
    /**
     * State changed by user operation.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * State changed by user operation.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * State changed by user operation.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    USER = 1,

    /**
     * State changed by background action.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * State changed by background action.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * State changed by background action.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    BACKGROUND = 2,
  }

  /**
   * Creates an AVMetadataExtractor instance.
   * @returns { Promise<AVMetadataExtractor> } A Promise instance used to return AVMetadataExtractor instance
   * if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Returned by promise.
   * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
   * @since 11
   */
  /**
   * Creates an AVMetadataExtractor instance.
   * @returns { Promise<AVMetadataExtractor> } A Promise instance used to return AVMetadataExtractor instance
   * if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Returned by promise.
   * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
   * @crossplatform
   * @since 12
   */
  function createAVMetadataExtractor(): Promise<AVMetadataExtractor>;

  /**
   * Creates an AVMetadataExtractor instance.
   * @param { AsyncCallback<AVMetadataExtractor> } callback - Callback used to return AVMetadataExtractor instance
   * if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Returned by callback.
   * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
   * @since 11
   */
  /**
   * Creates an AVMetadataExtractor instance.
   * @param { AsyncCallback<AVMetadataExtractor> } callback - Callback used to return AVMetadataExtractor instance
   * if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Returned by callback.
   * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
   * @crossplatform
   * @since 12
   */
  function createAVMetadataExtractor(callback: AsyncCallback<AVMetadataExtractor>): void;

  /**
   * Creates an AVImageGenerator instance.
   * @returns { Promise<AVImageGenerator> } A Promise instance used to return AVImageGenerator instance
   * if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Returned by promise.
   * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
   * @since 12
   */
  function createAVImageGenerator(): Promise<AVImageGenerator>;

  /**
   * Creates an AVImageGenerator instance.
   * @param { AsyncCallback<AVImageGenerator> } callback - Callback used to return AVImageGenerator instance
   * if the operation is successful; returns null otherwise.
   * @throws { BusinessError } 5400101 - No memory. Returned by callback.
   * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
   * @since 12
   */
  function createAVImageGenerator(callback: AsyncCallback<AVImageGenerator>): void;

  /**
   * Fetch media meta data or audio art picture from source. Before calling an AVMetadataExtractor method,
   * you must use createAVMetadataExtractor() to create an AVMetadataExtractor instance.
   * @typedef AVMetadataExtractor
   * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
   * @since 11
   */
  /**
   * Fetch media meta data or audio art picture from source. Before calling an AVMetadataExtractor method,
   * you must use createAVMetadataExtractor() to create an AVMetadataExtractor instance.
   * @typedef AVMetadataExtractor
   * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
   * @crossplatform
   * @since 12
   */
  interface AVMetadataExtractor {
    /**
     * Media file descriptor.
     * @type { ?AVFileDescriptor }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * Media file descriptor.
     * @type { ?AVFileDescriptor }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    fdSrc ?: AVFileDescriptor;

    /**
     * DataSource descriptor.
     * @type { ?AVDataSrcDescriptor }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * DataSource descriptor.
     * @type { ?AVDataSrcDescriptor }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    dataSrc ?: AVDataSrcDescriptor;

    /**
     * It will extract the resource to fetch media meta data info.
     * @param { AsyncCallback<AVMetadata> } callback - A callback instance used to return when fetchMetadata completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by callback.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by callback.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * It will extract the resource to fetch media meta data info.
     * @param { AsyncCallback<AVMetadata> } callback - A callback instance used to return when fetchMetadata completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by callback.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by callback.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    fetchMetadata(callback: AsyncCallback<AVMetadata>): void;

    /**
     * It will extract the resource to fetch media meta data info.
     * @returns { Promise<AVMetadata> } A Promise instance used to return when fetchMetadata completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by promise.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by promise.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * It will extract the resource to fetch media meta data info.
     * @returns { Promise<AVMetadata> } A Promise instance used to return when fetchMetadata completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by promise.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by promise.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    fetchMetadata(): Promise<AVMetadata>;

    /**
     * It will extract the audio resource to fetch an album cover.
     * @param { AsyncCallback<image.PixelMap> } callback - A callback instance used
     * to return when fetchAlbumCover completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by callback.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * It will extract the audio resource to fetch an album cover.
     * @param { AsyncCallback<image.PixelMap> } callback - A callback instance used
     * to return when fetchAlbumCover completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by callback.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    fetchAlbumCover(callback: AsyncCallback<image.PixelMap>): void;

    /**
     * It will extract the audio resource to fetch an album cover.
     * @returns { Promise<image.PixelMap> } A Promise instance used to return when fetchAlbumCover completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by promise.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by promise.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * It will extract the audio resource to fetch an album cover.
     * @returns { Promise<image.PixelMap> } A Promise instance used to return when fetchAlbumCover completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by promise.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by promise.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    fetchAlbumCover(): Promise<image.PixelMap>;

    /**
     * Get timestamp according to frame index.
     * @param { number } index - Index of the frame.
     * @returns { Promise<number> } A Promise instance used to return frame timestamp, in microseconds.
     * @throws { BusinessError } 401 - The parameter check failed. Return by promise.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by promise.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by promise.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @systemapi
     * @since 12
     */
    getTimeByFrameIndex(index: number): Promise<number>;

    /**
     * Get frame index according to the given timestamp.
     * @param { number } timeUs - Timestamp of the frame, in microseconds.
     * @returns { Promise<number> } A Promise instance used to return frame index.
     * @throws { BusinessError } 401 - The parameter check failed. Return by promise.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by promise.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by promise.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @systemapi
     * @since 12
     */
    getFrameIndexByTime(timeUs: number): Promise<number>;

    /**
     * Release resources used for AVMetadataExtractor.
     * @param { AsyncCallback<void> } callback - A callback instance used to return when release completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by callback.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * Release resources used for AVMetadataExtractor.
     * @param { AsyncCallback<void> } callback - A callback instance used to return when release completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by callback.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    release(callback: AsyncCallback<void>): void;

    /**
     * Release resources used for AVMetadataExtractor.
     * @returns { Promise<void> } A Promise instance used to return when release completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by promise.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * Release resources used for AVMetadataExtractor.
     * @returns { Promise<void> } A Promise instance used to return when release completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by promise.
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    release(): Promise<void>;
  }

  /**
   * Provides the container definition for media meta data.
   * @typedef AVMetadata
   * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
   * @since 11
   */
  /**
   * Provides the container definition for media meta data.
   * @typedef AVMetadata
   * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
   * @crossplatform
   * @since 12
   */
  interface AVMetadata {
    /**
     * The metadata to retrieve the information about the album title
     * of the media source.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the information about the album title
     * of the media source. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    album?: string;

    /**
     * The metadata to retrieve the information about the performer or
     * artist associated with the media source.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the information about the performer or
     * artist associated with the media source. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    albumArtist?: string;

    /**
     * The metadata to retrieve the information about the artist of
     * the media source.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the information about the artist of
     * the media source. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    artist?: string;

    /**
     * The metadata to retrieve the information about the author of
     * the media source.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the information about the author of
     * the media source. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    author?: string;

    /**
     * The metadata to retrieve the information about the created time of
     * the media source.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the information about the created time of
     * the media source. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    dateTime?: string;

    /**
     * The metadata to retrieve the information about the created or modified time
     * with the specific date format of the media source.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the information about the created or modified time
     * with the specific date format of the media source. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    dateTimeFormat?: string;

    /**
     * The metadata to retrieve the information about the composer of
     * the media source.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the information about the composer of
     * the media source. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    composer?: string;

    /**
     * The metadata to retrieve the playback duration of the media source.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the playback duration of the media source. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    duration?: string;

    /**
     * The metadata to retrieve the content type or genre of the data
     * source.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the content type or genre of the data
     * source.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    genre?: string;

    /**
     * If this value exists the media contains audio content.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * If this value exists the media contains audio content. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    hasAudio?: string;

    /**
     * If this value exists the media contains video content.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * If this value exists the media contains video content. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    hasVideo?: string;

    /**
     * The metadata to retrieve the mime type of the media source. Some
     * example mime types include: "video/mp4", "audio/mp4", "audio/amr-wb",
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the mime type of the media source. Some
     * example mime types include: "video/mp4", "audio/mp4", "audio/amr-wb". This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    mimeType?: string;

    /**
     * The metadata to retrieve the number of tracks, such as audio, video,
     * text, in the media source, such as a mp4 or 3gpp file.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the number of tracks, such as audio, video,
     * text, in the media source, such as a mp4 or 3gpp file. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    trackCount?: string;

    /**
     * It is the audio sample rate, if available.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * It is the audio sample rate, if available. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    sampleRate?: string;

    /**
     * The metadata to retrieve the media source title.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the media source title. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    title?: string;

    /**
     * If the media contains video, this key retrieves its height.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * If the media contains video, this key retrieves its height. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    videoHeight?: string;

    /**
     * If the media contains video, this key retrieves its width.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * If the media contains video, this key retrieves its width. This field is readonly in current version.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    videoWidth?: string;

    /**
     * The metadata to retrieve the information about the video
     * orientation.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 11
     */
    /**
     * The metadata to retrieve the information about the video
     * orientation.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    videoOrientation?: string;

     /**
     * This value exists if the video is HDR video.This field is readonly in current version.
     * @type { ?HdrType }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @crossplatform
     * @since 12
     */
    hdrType?: HdrType;

    /**
     * The geographical location info of the video.
     * @type { ?Location }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 12
     */
    location?: Location;

    /**
     * Custom parameter key-value map read from moov.meta.list.
     * @type { ?Record<string, string> }
     * @syscap SystemCapability.Multimedia.Media.AVMetadataExtractor
     * @since 12
     */
    customInfo?: Record<string, string>;
  }

  /**
   * Enumerates options about the HDR Type of the video.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.Core
   * @crossplatform
   * @since 12
   */
  enum HdrType {
    /**
     * This option is used to mark none HDR type.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @since 12
     */
    AV_HDR_TYPE_NONE = 0,

    /**
     * This option is used to mark HDR Vivid type.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @since 12
     */
    AV_HDR_TYPE_VIVID = 1,
  }

  /**
   * Generate an image from a video resource with the specific time. Before calling an AVImageGenerator method,
   * you must use createAVImageGenerator() to create an AVImageGenerator instance.
   * @typedef AVImageGenerator
   * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
   * @since 12
   */
  interface AVImageGenerator {
    /**
     * Media file descriptor.
     * @type { ?AVFileDescriptor }
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    fdSrc ?: AVFileDescriptor;

    /**
     * It will fetch a picture at @timeUs from the given video resource.
     * @param { number } timeUs - The time expected to fetch picture from the video resource.
     * The unit is microsecond(us).
     * @param { AVImageQueryOptions } options - The time options about the relationship
     * between the given timeUs and a key frame, see @AVImageQueryOptions .
     * @param { PixelMapParams } param - The output pixel map format params, see @PixelMapParams .
     * @param { AsyncCallback<image.PixelMap> } callback - A callback instance used
     * to return when fetchFrameByTime completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by callback.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by callback.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    fetchFrameByTime(timeUs: number, options: AVImageQueryOptions, param: PixelMapParams,
      callback: AsyncCallback<image.PixelMap>): void;

    /**
     * It will decode the given video resource. Then fetch a picture
     * at @timeUs according the given @options and @param .
     * @param { number } timeUs - The time expected to fetch picture from the video resource.
     * The unit is microsecond(us).
     * @param { AVImageQueryOptions } options - The time options about the relationship
     * between the given timeUs and a key frame, see @AVImageQueryOptions .
     * @param { PixelMapParams } param - The output pixel map format params, see @PixelMapParams .
     * @returns { Promise<image.PixelMap> } A Promise instance used to return the pixel map
     * when fetchFrameByTime completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by promise.
     * @throws { BusinessError } 5400106 - Unsupported format. Returned by promise.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    fetchFrameByTime(timeUs: number, options: AVImageQueryOptions, param: PixelMapParams): Promise<image.PixelMap>;

    /**
     * Release resources used for AVImageGenerator.
     * @param { AsyncCallback<void> } callback - A callback instance used to return when release completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by callback.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    release(callback: AsyncCallback<void>): void;

    /**
     * Release resources used for AVImageGenerator.
     * @returns { Promise<void> } A Promise instance used to return when release completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Returned by promise.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    release(): Promise<void>;
  }

  /**
   * Enumerates options about the relationship between the given timeUs and a key frame.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
   * @since 12
   */
  enum AVImageQueryOptions {
    /**
     * This option is used to fetch a key frame from the given media
     * resource that is located right after or at the given time.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    AV_IMAGE_QUERY_NEXT_SYNC,

    /**
     * This option is used to fetch a key frame from the given media
     * resource that is located right before or at the given time.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    AV_IMAGE_QUERY_PREVIOUS_SYNC,

    /**
     * This option is used to fetch a key frame from the given media
     * resource that is located closest to or at the given time.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    AV_IMAGE_QUERY_CLOSEST_SYNC,

    /**
     * This option is used to fetch a frame (maybe not keyframe) from
     * the given media resource that is located closest to or at the given time.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    AV_IMAGE_QUERY_CLOSEST,
  }

  /**
   * Expected pixel map format for the fetched image from video resource.
   * @typedef PixelMapParams
   * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
   * @since 12
   */
  interface PixelMapParams {
    /**
     * Expected pixelmap's width, -1 means to keep consistent with the
     * original dimensions of the given video resource.
     * @type { ?number }
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    width?: number;

    /**
     * Expected pixelmap's width, -1 means to keep consistent with the
     * original dimensions of the given video resource.
     * @type { ?number }
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @since 12
     */
    height?: number;

    /**
     * Expected pixelmap's color format, see {@link PixelFormat}.
     * @type { ?PixelFormat }
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @systemapi
     * @since 11
     */
    colorFormat?: PixelFormat;
  }

  /**
   * Enumerates options about the expected color options for the fetched image.
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
   * @systemapi
   * @since 11
   */
  enum PixelFormat {
    /**
     * RGB_565 options.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @systemapi
     * @since 11
     */
    RGB_565 = 2,

    /**
     * RGBA_8888 options.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @systemapi
     * @since 11
     */
    RGBA_8888 = 3,

    /**
     * RGB_888 options.
     * @syscap SystemCapability.Multimedia.Media.AVImageGenerator
     * @systemapi
     * @since 11
     */
    RGB_888 = 5,
  }

  /**
    * Enumerates ErrorCode types, return in BusinessError::code.
    *
    * @enum { number }
    * @syscap SystemCapability.Multimedia.Media.Core
    * @since 9
    */
  /**
   * Enumerates ErrorCode types, return in BusinessError::code.
   *
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.Core
   * @atomicservice
   * @since 11
   */
  /**
   * Enumerates ErrorCode types, return in BusinessError::code.
   *
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  enum AVErrorCode {
    /**
     * Operation success.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * Operation success.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Operation success.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_OK = 0,

    /**
     * Permission denied.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * Permission denied.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Permission denied.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_NO_PERMISSION = 201,

    /**
     * Invalid parameter.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * Invalid parameter.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Invalid parameter.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_INVALID_PARAMETER = 401,

    /**
     * The api is not supported in the current version.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * The api is not supported in the current version.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * The api is not supported in the current version.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_UNSUPPORT_CAPABILITY = 801,

    /**
     * The system memory is insufficient or the number of services reaches the upper limit.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * The system memory is insufficient or the number of services reaches the upper limit.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * The system memory is insufficient or the number of services reaches the upper limit.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_NO_MEMORY = 5400101,

    /**
     * Current status does not allow or do not have permission to perform this operation.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * Current status does not allow or do not have permission to perform this operation.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Current status does not allow or do not have permission to perform this operation.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_OPERATE_NOT_PERMIT = 5400102,

    /**
     * Data flow exception information.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * Data flow exception information.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Data flow exception information.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_IO = 5400103,

    /**
     * System or network response timeout.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * System or network response timeout.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * System or network response timeout.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_TIMEOUT = 5400104,

    /**
     * Service process died.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * Service process died.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Service process died.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_SERVICE_DIED = 5400105,

    /**
     * Unsupported media format.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 9
     */
    /**
     * Unsupported media format.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Unsupported media format.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_UNSUPPORT_FORMAT = 5400106,

    /**
     * Audio interrupted.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Audio interrupted.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    AVERR_AUDIO_INTERRUPTED = 5400107,
    /**
     * The address of server is incorrect, and IO can not find host.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_HOST_NOT_FOUND = 5411001,
    /**
     * Network connection timeout.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_CONNECTION_TIMEOUT = 5411002,
    /**
     * Failed link due to abnormal network.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_NETWORK_ABNORMAL = 5411003,
    /**
     * Failed link due to unavailable network.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_NETWORK_UNAVAILABLE = 5411004,
    /**
     * Network permission dennied.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_NO_PERMISSION = 5411005,
    /**
     * The client request parameters are incorrect or exceed the processing capacity.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_REQUEST_DENIED = 5411006,
    /**
     * Cannot find available network resources.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_RESOURCE_NOT_FOUND = 5411007,
    /**
     * The server failS to verify the client certificate because the certificate is not carried,
     * the certificate is invalid, or the certificate is expired.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_SSL_CLIENT_CERT_NEEDED = 5411008,
    /**
     * The client fails to verify the server certificate because the certificate is not carried,
     * the certificate is invalid, or the certificate is expired.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_SSL_CONNECTION_FAILED = 5411009,
    /**
     * IO SSL server cert untrusted.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_SSL_SERVER_CERT_UNTRUSTED = 5411010,
    /**
     * Unsupported request due to network protocols.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    AVERR_IO_UNSUPPORTED_REQUEST = 5411011,
    /**
     * Seek continuous unsupported.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 18
     */
    AVERR_SEEK_CONTINUOUS_UNSUPPORTED = 5410002,

    /**
     * Super-resolution unsupported.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 18
     */
    AVERR_SUPER_RESOLUTION_UNSUPPORTED = 5410003,

    /**
     * No PlaybackStrategy set to enable super-resolution feature.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 18
     */
    AVERR_SUPER_RESOLUTION_NOT_ENABLED = 5410004,
  }

  /**
   * Describes AVPlayer states.
   * @typedef {'idle' | 'initialized' | 'prepared' | 'playing' | 'paused' | 'completed' | 'stopped' | 'released' | 'error'}
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @since 9

   */
  /**
   * Describes AVPlayer states.
   * @typedef {'idle' | 'initialized' | 'prepared' | 'playing' | 'paused' | 'completed' | 'stopped' | 'released' | 'error'}
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @atomicservice
   * @since 11

   */
  /**
   * Describes AVPlayer states.
   * @typedef {'idle' | 'initialized' | 'prepared' | 'playing' | 'paused' | 'completed' | 'stopped' | 'released' | 'error'}
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  type AVPlayerState = 'idle' | 'initialized' | 'prepared' | 'playing' | 'paused' | 'completed' | 'stopped' | 'released' | 'error';

  /**
   * Define the TrackChange Event callback.
   * @typedef { function } OnTrackChangeHandler
   * @param { number } index - index number for change Track.
   * @param { boolean } isSelected - Target index number for moving elements.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @atomicservice
   * @since 12
   */
  type OnTrackChangeHandler = (index: number, isSelected: boolean) => void;

  /**
   * Defines the OnStateChange callback.
   *
   * @typedef { function } OnAVPlayerStateChangeHandle
   * @param { AVPlayerState } state - state for AVPlayer.
   * @param { StateChangeReason } reason - reason for state change.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  type OnAVPlayerStateChangeHandle = (state: AVPlayerState, reason: StateChangeReason) => void;

  /**
   * Defines the OnBufferingUpdateHandler callback.
   *
   * @typedef { function } OnBufferingUpdateHandler
   * @param { BufferingInfoType } infoType - define the Buffering info Type.
   * @param { number } value - define the value of buffering info type if exist.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  type OnBufferingUpdateHandler = (infoType: BufferingInfoType, value: number) => void;

  /**
   * Defines the OnVideoSizeChangeHandler callback.
   *
   * @typedef { function } OnVideoSizeChangeHandler
   * @param { number } width - Value of video Width.
   * @param { number } height - Value of video Height.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  type OnVideoSizeChangeHandler = (width: number, height: number) => void;

  /**
   * Defines the OnSuperResolutionChanged callback.
   *
   * @typedef { function } OnSuperResolutionChanged
   * @param { boolean } enabled - Super-resolution enabled or not.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @atomicservice
   * @since 18
   */
  type OnSuperResolutionChanged = (enabled: boolean) => void;

  /**
   * SEI message.
   *
   * @typedef SeiMessage
   * @syscap SystemCapability.Multimedia.Media.Core
   * @atomicservice
   * @since 18
   */
  interface SeiMessage {
    /**
     * Payload type of SEI message.
     * @type { number }
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 18
     */
    payloadType: number;

    /**
     * Payload data of SEI message.
     * @type { ArrayBuffer }
     * @syscap SystemCapability.Multimedia.Media.Core
     * @atomicservice
     * @since 18
     */
    payload: ArrayBuffer;
  }

  /**
   * Defines the OnSeiMessageHandle callback.
   *
   * @typedef { function } OnSeiMessageHandle
   * @param { Array<SeiMessage> } messages - SEI messages.
   * @param { ?number } playbackPosition - playback position.
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @atomicservice
   * @since 18
   */
  type OnSeiMessageHandle = (messages: Array<SeiMessage>, playbackPosition?: number) => void;

  /**
   * Manages and plays media. Before calling an AVPlayer method, you must use createAVPlayer()
   * to create an AVPlayer instance.
   *
   * @typedef AVPlayer
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @since 9
   */
  /**
   * Manages and plays media. Before calling an AVPlayer method, you must use createAVPlayer()
   * to create an AVPlayer instance.
   *
   * @typedef AVPlayer
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @atomicservice
   * @since 11
   */
  /**
   * Manages and plays media. Before calling an AVPlayer method, you must use createAVPlayer()
   * to create an AVPlayer instance.
   *
   * @typedef AVPlayer
   * @syscap SystemCapability.Multimedia.Media.AVPlayer
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  interface AVPlayer {
    /**
     * Prepare audio/video playback, it will request resource for playing. This API can be called
     * only when the AVPlayer is in the initialized state.
     * @param { AsyncCallback<void> } callback used to return the result when prepare completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @throws { BusinessError } 5400106 - Unsupported format. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Prepare audio/video playback, it will request resource for playing. This API can be called
     * only when the AVPlayer is in the initialized state.
     * @param { AsyncCallback<void> } callback used to return the result when prepare completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @throws { BusinessError } 5400106 - Unsupported format. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Prepare audio/video playback, it will request resource for playing. This API can be called
     * only when the AVPlayer is in the initialized state.
     * @param { AsyncCallback<void> } callback used to return the result when prepare completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @throws { BusinessError } 5400106 - Unsupported format. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    prepare(callback: AsyncCallback<void>): void;

    /**
     * Prepare audio/video playback, it will request resource for playing. This API can be called
     * only when the AVPlayer is in the initialized state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @throws { BusinessError } 5400106 - Unsupported format. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Prepare audio/video playback, it will request resource for playing. This API can be called
     * only when the AVPlayer is in the initialized state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @throws { BusinessError } 5400106 - Unsupported format. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Prepare audio/video playback, it will request resource for playing. This API can be called
     * only when the AVPlayer is in the initialized state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @throws { BusinessError } 5400106 - Unsupported format. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    prepare(): Promise<void>;

    /**
     * Play audio/video playback. This API can be called only when the AVPlayer is in the prepared, paused or completed state.
     * @param { AsyncCallback<void> } callback used to return the result when play completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Play audio/video playback. This API can be called only when the AVPlayer is in the prepared, paused or completed state.
     * @param { AsyncCallback<void> } callback used to return the result when play completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Play audio/video playback. This API can be called only when the AVPlayer is in the prepared, paused or completed state.
     * @param { AsyncCallback<void> } callback used to return the result when play completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    play(callback: AsyncCallback<void>): void;

    /**
     * Play audio/video playback. This API can be called only when the AVPlayer is in the prepared, paused or completed state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Play audio/video playback. This API can be called only when the AVplayer is in the prepared, paused or completed state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Play audio/video playback. This API can be called only when the AVPlayer is in the prepared, paused or completed state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    play(): Promise<void>;

    /**
     * Pause audio/video playback. This API can be called only when the AVPlayer is in the playing state.
     * @param { AsyncCallback<void> } callback used to return the result when pause completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Pause audio/video playback. This API can be called only when the AVPlayer is in the playing state.
     * @param { AsyncCallback<void> } callback used to return the result when pause completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Pause audio/video playback. This API can be called only when the AVPlayer is in the playing state.
     * @param { AsyncCallback<void> } callback used to return the result when pause completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    pause(callback: AsyncCallback<void>): void;

    /**
     * Pause audio/video playback. This API can be called only when the AVPlayer is in the playing state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Pause audio/video playback. This API can be called only when the AVPlayer is in the playing state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Pause audio/video playback. This API can be called only when the AVPlayer is in the playing state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    pause(): Promise<void>;

    /**
     * Stop audio/video playback. This API can be called only when the AVPlayer is in the prepared,
     * playing, paused or completed state.
     * @param { AsyncCallback<void> } callback used to return the result when stop completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Stop audio/video playback. This API can be called only when the AVPlayer is in the prepared,
     * playing, paused or completed state.
     * @param { AsyncCallback<void> } callback used to return the result when stop completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Stop audio/video playback. This API can be called only when the AVPlayer is in the prepared,
     * playing, paused or completed state.
     * @param { AsyncCallback<void> } callback used to return the result when stop completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    stop(callback: AsyncCallback<void>): void;

    /**
     * Stop audio/video playback. This API can be called only when the AVPlayer is in the prepared,
     * playing, paused or completed state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Stop audio/video playback. This API can be called only when the AVPlayer is in the prepared,
     * playing, paused or completed state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Stop audio/video playback. This API can be called only when the AVPlayer is in the prepared,
     * playing, paused or completed state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    stop(): Promise<void>;

    /**
     * Reset AVPlayer, it will be set to idle state and can set src again. This API can be called only when
     * the AVPlayer is in the initialized, prepared, playing, paused, completed, stopped or error state.
     * @param { AsyncCallback<void> } callback used to return the result when reset completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Reset AVPlayer, it will be set to idle state and can set src again. This API can be called only when
     * the AVPlayer is in the initialized, prepared, playing, paused, completed, stopped or error state.
     * @param { AsyncCallback<void> } callback used to return the result when reset completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Reset AVPlayer, it will be set to idle state and can set src again. This API can be called only when
     * the AVPlayer is in the initialized, prepared, playing, paused, completed, stopped or error state.
     * @param { AsyncCallback<void> } callback used to return the result when reset completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    reset(callback: AsyncCallback<void>): void;

    /**
     * Reset AVPlayer, it will be set to idle state and can set src again. This API can be called only when
     * the AVPlayer is in the initialized, prepared, playing, paused, completed, stopped or error state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Reset AVPlayer, it will be set to idle state and can set src again. This API can be called only when
     * the AVPlayer is in the initialized, prepared, playing, paused, completed, stopped or error state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Reset AVPlayer, it will be set to idle state and can set src again. This API can be called only when
     * the AVPlayer is in the initialized, prepared, playing, paused, completed, stopped or error state.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    reset(): Promise<void>;

    /**
     * Releases resources used for AVPlayer. This API can be called when the AVPlayer is in any state except released.
     * @param { AsyncCallback<void> } callback used to return the result when release completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Releases resources used for AVPlayer. This API can be called when the AVPlayer is in any state except released.
     * @param { AsyncCallback<void> } callback used to return the result when release completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Releases resources used for AVPlayer. This API can be called when the AVPlayer is in any state except released.
     * @param { AsyncCallback<void> } callback used to return the result when release completed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    release(callback: AsyncCallback<void>): void;

    /**
     * Releases resources used for AVPlayer. This API can be called when the AVPlayer is in any state except released.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Releases resources used for AVPlayer. This API can be called when the AVPlayer is in any state except released.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Releases resources used for AVPlayer. This API can be called when the AVPlayer is in any state except released.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    release(): Promise<void>;

    /**
     * Jumps to the specified playback position. This API can be called only when the AVPlayer is in the prepared,
     * playing, paused, or completed state.
     * @param { number } timeMs - Playback position to jump, should be in [0, duration].
     * @param { SeekMode } mode - See @SeekMode .
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Jumps to the specified playback position. This API can be called only when the AVPlayer is in the prepared,
     * playing, paused, or completed state.
     * @param { number } timeMs - Playback position to jump, should be in [0, duration].
     * @param { SeekMode } mode - See @SeekMode .
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Jumps to the specified playback position. This API can be called only when the AVPlayer is in the prepared,
     * playing, paused, or completed state.
     * @param { number } timeMs - Playback position to jump, should be in [0, duration].
     * @param { SeekMode } mode - See @SeekMode .
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    seek(timeMs: number, mode?: SeekMode): void;

    /**
     * Sets the volume.
     * @param { number } volume - Relative volume. The value ranges from 0.00 to 1.00. The value 1 indicates the maximum volume (100%).
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Sets the volume.
     * @param { number } volume - Relative volume. The value ranges from 0.00 to 1.00. The value 1 indicates the maximum volume (100%).
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    setVolume(volume: number): void;

    /**
     * Get all track infos in MediaDescription, should be called after data loaded callback.
     * @param { AsyncCallback<Array<MediaDescription>> } callback - Async callback return track info in MediaDescription.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Get all track infos in MediaDescription, should be called after data loaded callback.
     * @param { AsyncCallback<Array<MediaDescription>> } callback - Async callback return track info in MediaDescription.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Get all track infos in MediaDescription, should be called after data loaded callback.
     * @param { AsyncCallback<Array<MediaDescription>> } callback - Async callback return track info in MediaDescription.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by callback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    getTrackDescription(callback: AsyncCallback<Array<MediaDescription>>): void;

    /**
     * Get all track infos in MediaDescription, should be called after data loaded callback.
     * @returns { Promise<Array<MediaDescription>> } A Promise instance used to return the track info in MediaDescription.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Get all track infos in MediaDescription, should be called after data loaded callback.
     * @returns { Promise<Array<MediaDescription>> } A Promise instance used to return the track info in MediaDescription.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Get all track infos in MediaDescription, should be called after data loaded callback.
     * @returns { Promise<Array<MediaDescription>> } A Promise instance used to return the track info in MediaDescription.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    getTrackDescription(): Promise<Array<MediaDescription>>;

    /**
     * Get selected tracks, should be called after prepared state.
     * @returns { Promise<Array<number>> } A Promise instance used to return selected track index.
     * @throws { BusinessError } 5400102 - Operation not allowed.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    getSelectedTracks(): Promise<Array<number>>;

    /**
     * Select specific track to play.
     * @param { number } index - Track index returned by getTrackDescription#MD_KEY_TRACK_INDEX
     * @param { SwitchMode } mode - set switchmode for track select behavior.
     * @returns { Promise<void> } A Promise instance used to return when select track completed.
     * @throws { BusinessError } 401 - The parameter check failed. Return by promise.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    selectTrack(index: number, mode?: SwitchMode): Promise<void>;

    /**
     * Deselect specific track to play.
     * @param { number } index : Track index returned by getTrackDescription#MD_KEY_TRACK_INDEX
     * @returns { Promise<void> } A Promise instance used to return when deselect track completed.
     * @throws { BusinessError } 401 - The parameter check failed. Return by promise.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    deselectTrack(index: number): Promise<void>;

    /**
     * Set MediaSource to AVPlayer, this interface is exclusive with fd/url/dataSrc assign.
     * @param { MediaSource } src : MediaSource instance to be set to the avplayer instance.
     * @param { PlaybackStrategy } strategy : Play strategy of the media source.
     * @returns { Promise<void> } A Promise instance used to return when setMediaSource completed.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
     * <br>2. Incorrect parameter types. 3.Parameter verification failed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    setMediaSource(src: MediaSource, strategy?: PlaybackStrategy): Promise<void>;

    /**
     * Add subtitle resource represented by FD to the player.
     * @param { number } fd : The file descriptor of subtitle source from file system.
     * The caller is responsible to close the file descriptor.
     * @param { number } offset : The offset into the file where the data to be read, in bytes.
     * By default, the offset is zero.
     * @param { number } length : The length in bytes of the data to be read.
     * By default, the length is the rest of bytes in the file from the offset.
     * @returns { Promise<void> } Promise used to return the result.
     * @throws { BusinessError } 401 - The parameter check failed. Return by promise.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    addSubtitleFromFd(fd: number, offset?: number, length?: number): Promise<void>;

    /**
     * Add subtitle resource represented by url to the player. After the Promise returns,
     * subtitle info can be obtained by @getTrackDescription
     * @param { string } url : Address of external subtitle file.
     * @returns { Promise<void> } Promise used to return the result.
     * @throws { BusinessError } 401 - The parameter check failed. Return by promise.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    addSubtitleFromUrl(url: string): Promise<void>;

    /**
     * Get statistic infos of current player.
     * @returns { Promise<PlaybackInfo> } Statistic infos of current player.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 12
     */
    getPlaybackInfo(): Promise<PlaybackInfo>;

    /**
     * Set playback strategy to AVPlayer.
     * @param { PlaybackStrategy } strategy : specified strategy of the AVPlayer.
     * @returns { Promise<void> }  A Promise instance used to return when setPlaybackStrategy completed.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Incorrect parameter types. 2. Parameter verification failed.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    setPlaybackStrategy(strategy: PlaybackStrategy): Promise<void>;

    /**
     * Mute specified media stream.
     * @param { MediaType } mediaType - specified media Type, see @MediaType..
     * @param { boolean } muted - true for mute, false for unmute.
     * @returns { Promise<void> } A Promise instance used to return when setMediaMuted completed.
     * @throws { BusinessError } 401 - The parameter check failed. Return by promise.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    setMediaMuted(mediaType: MediaType, muted: boolean): Promise<void>;

    /**
     * Set playback start position and end position.
     * @param { number } startTimeMs - Playback start position, should be in [0, duration),
     *                                 -1 means that the start position is not set,
     *                                 and the playback will start from 0.
     * @param { number } endTimeMs - Playback end position, which should usually be in (startTimeMs, duration],
     *                               -1 means that the end position is not set,
     *                               and the playback will be ended at the end of the stream.
     * @param { SeekMode } [mode] - Use the specified seek mode to jump to the playback start position,
     *                             currently support SeekMode.SEEK_PREV_SYNC and SeekMode.SEEK_CLOSEST,
     *                             other values are invalid, the default value is SeekMode.SEEK_PREV_SYNC.
     * @returns { Promise<void> } Promise used to return the result.
     * @throws { BusinessError } 401 - The parameter check failed. Return by promise.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 18
     */
    setPlaybackRange(startTimeMs: number, endTimeMs: number, mode?: SeekMode) : Promise<void>;

    /**
     * Check whether the media stream currently being played by the player supports seek continuous.
     * Should be called after {@link #prepare}.
     * @returns { boolean } true: seek continuous is supported;
     * false: seek continuous is not supported or the support status is uncertain.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 18
     */
    isSeekContinuousSupported() : boolean;

    /**
     * Get current playback position.
     * @returns { number } return the time of current playback position - millisecond(ms)
     * @throws { BusinessError } 5400102 - Operation not allowed.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 18
     */
    getPlaybackPosition() : number;

    /**
     * Enable or disable super-resolution dynamically.
     * Must enable super-resolution feature in {@link PlaybackStrategy} before calling {@link #prepare}.
     * See {@link #setPlaybackStrategy}, {@link #setMediaSource}.
     * @param { boolean } enabled - true: super-resolution enabled; false: super-resolution disabled.
     * @returns { Promise<void> } Promise used to return the result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @throws { BusinessError } 5410003 - Super-resolution not supported. Return by promise.
     * @throws { BusinessError } 5410004 - Missing enable super-resolution feature in {@link PlaybackStrategy}.
     *                                     Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 18
     */
    setSuperResolution(enabled: boolean) : Promise<void>;

    /**
     * Set video window size for super-resolution.
     * Must enable super-resolution feature in {@link PlaybackStrategy} before calling {@link #prepare}.
     * See {@link #setPlaybackStrategy}, {@link #setMediaSource}.
     * @param { number } width - width of the window.
     * @param { number } height - height of the window.
     * @returns { Promise<void> } Promise used to return the result.
     * @throws { BusinessError } 5400102 - Operation not allowed. Return by promise.
     * @throws { BusinessError } 401 - Parameter error. Return by promise.
     * @throws { BusinessError } 5410003 - Super-resolution not supported. Return by promise.
     * @throws { BusinessError } 5410004 - Missing enable super-resolution feature in {@link PlaybackStrategy}.
     *                                     Return by promise.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 18
     */
    setVideoWindowSize(width: number, height: number) : Promise<void>;

    /**
     * Media URI. Mainstream media formats are supported.
     * Network:http://xxx
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Media URI. Mainstream media formats are supported.
     * Network:http://xxx
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Media URI. Mainstream media formats are supported.
     * Network:http://xxx
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    url?: string;

    /**
     * Media file descriptor. Mainstream media formats are supported.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Media file descriptor. Mainstream media formats are supported.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Media file descriptor. Mainstream media formats are supported.
     * @type { ?AVFileDescriptor }
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    fdSrc?: AVFileDescriptor;

    /**
     * DataSource descriptor. Supports mainstream media formats.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 10
     */
    /**
     * DataSource descriptor. Supports mainstream media formats.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * DataSource descriptor. Supports mainstream media formats.
     * @type { ?AVDataSrcDescriptor }
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    dataSrc?: AVDataSrcDescriptor;

    /**
     * Whether to loop media playback.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Whether to loop media playback.
     * @type { boolean }
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    loop: boolean;

    /**
     * Describes audio interrupt mode, refer to {@link #audio.InterruptMode}. If it is not
     * set, the default mode will be used. Set it before calling the {@link #play()} in the
     * first time in order for the interrupt mode to become effective thereafter.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Describes audio interrupt mode, refer to {@link #audio.InterruptMode}. If it is not
     * set, the default mode will be used. Set it before calling the {@link #play()} in the
     * first time in order for the interrupt mode to become effective thereafter.
     * @type { ?audio.InterruptMode }
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    audioInterruptMode?: audio.InterruptMode;

    /**
     * Describes audio renderer info, refer to {@link #audio.AudioRendererInfo}. Set it before
     * calling the {@link #prepare()} in the first time in order for the audio renderer info to
     * become effective thereafter.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 10
     */
    /**
     * Describes audio renderer info, refer to {@link #audio.AudioRendererInfo}. Set it before
     * calling the {@link #prepare()} in the first time in order for the audio renderer info to
     * become effective thereafter.
     * @type { ?audio.AudioRendererInfo }
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    audioRendererInfo?: audio.AudioRendererInfo;

    /**
     * Obtains the current audio effect mode, refer to {@link #audio.AudioEffectMode}.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 10
     */
    /**
     * Obtains the current audio effect mode, refer to {@link #audio.AudioEffectMode}.
     * @type { ?audio.AudioEffectMode }
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    audioEffectMode ?: audio.AudioEffectMode;

    /**
     * Current playback position.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Current playback position.
     * @type { number }
     * @readonly
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    readonly currentTime: number;

    /**
     * Playback duration, When the data source does not support seek, it returns - 1, such as a live broadcast scenario.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Playback duration, When the data source does not support seek, it returns - 1, such as a live broadcast scenario.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Playback duration, When the data source does not support seek, it returns - 1, such as a live broadcast scenario.
     * @type { number }
     * @readonly
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    readonly duration: number;

    /**
     * Playback state.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Playback state.
     * @type { AVPlayerState }
     * @readonly
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    readonly state: AVPlayerState;

    /**
     * Video player will use this id get a surface instance.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Video player will use this id get a surface instance.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Video player will use this id get a surface instance.
     * @type { ?string }
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    surfaceId?: string;

    /**
     * Video width, valid after prepared.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Video width, valid after prepared.
     * @type { number }
     * @readonly
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    readonly width: number;

    /**
     * Video height, valid after prepared.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Video height, valid after prepared.
     * @type { number }
     * @readonly
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    readonly height: number;

    /**
     * Video scale type. By default, the {@link #VIDEO_SCALE_TYPE_FIT} will be used, for more
     * information, refer to {@link #VideoScaleType} .
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Video scale type. By default, the {@link #VIDEO_SCALE_TYPE_FIT} will be used, for more
     * information, refer to {@link #VideoScaleType} .
     * @type { ?VideoScaleType }
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    videoScaleType?: VideoScaleType;

    /**
     * Set payback speed.
     * @param { PlaybackSpeed } speed - playback speed, see @PlaybackSpeed .
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Set payback speed.
     * @param { PlaybackSpeed } speed - playback speed, see @PlaybackSpeed .
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    setSpeed(speed: PlaybackSpeed): void;

    /**
     * select a specified bitrate to playback, only valid for HLS protocol network stream. By default, the
     * player will select the appropriate bitrate according to the network connection speed. The
     * available bitrate list reported by {@link #on('availableBitrates')}. Set it to select
     * a specified bitrate. If the specified bitrate is not in the list of available bitrate, the player
     * will select the minimal and closest one from the available bitrate list.
     * @param { number } bitrate - the playback bitrate must be expressed in bits per second.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * select a specified bitrate to playback, only valid for HLS protocol network stream. By default, the
     * player will select the appropriate bitrate according to the network connection speed. The
     * available bitrate list reported by {@link #on('availableBitrates')}. Set it to select
     * a specified bitrate. If the specified bitrate is not in the list of available bitrate, the player
     * will select the minimal and closest one from the available bitrate list.
     * @param { number } bitrate - the playback bitrate must be expressed in bits per second.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    setBitrate(bitrate: number): void;

    /**
     * Set decryption session to codec module.
     * @param { drm.MediaKeySession } mediaKeySession - Handle of MediaKeySession to decrypt encrypted media.
     * @param { boolean } secureVideoPath - Secure video path required or not.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
     * <br>2. Incorrect parameter types. 3.Parameter verification failed.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 11
     */
    /**
     * Set decryption session to codec module.
     * @param { drm.MediaKeySession } mediaKeySession - Handle of MediaKeySession to decrypt encrypted media.
     * @param { boolean } secureVideoPath - Secure video path required or not.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
     * <br>2. Incorrect parameter types. 3.Parameter verification failed.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    setDecryptionConfig(mediaKeySession: drm.MediaKeySession, secureVideoPath: boolean): void;

    /**
     * Get media key system info from media source.
     * @returns { Array<drm.MediaKeySystemInfo> } MediaKeySystemInfo with PSSH.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 11
     */
    /**
     * Get media key system info from media source.
     * @returns { Array<drm.MediaKeySystemInfo> } MediaKeySystemInfo with PSSH.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    getMediaKeySystemInfos(): Array<drm.MediaKeySystemInfo>;

    /**
     * Register listens for mediaKeySystemInfoUpdate events.
     * @param { 'mediaKeySystemInfoUpdate' } type - Type of the event to listen for.
     * @param { function } callback - Callback used to listen for the mediaKeySystemInfoUpdate event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 11
     */
    /**
     * Register listens for mediaKeySystemInfoUpdate events.
     * @param { 'mediaKeySystemInfoUpdate' } type - Type of the event to listen for.
     * @param { Callback<Array<drm.MediaKeySystemInfo>> } callback - Callback used to listen for the mediaKeySystemInfoUpdate event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    on(type: 'mediaKeySystemInfoUpdate', callback: Callback<Array<drm.MediaKeySystemInfo>>): void;

    /**
     * Unregister listens for mediaKeySystemInfoUpdate events.
     * @param { 'mediaKeySystemInfoUpdate' } type - Type of the event to listen for.
     * @param { function } callback - Callback for event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 11
     */
    /**
     * Unregister listens for mediaKeySystemInfoUpdate events.
     * @param { 'mediaKeySystemInfoUpdate' } type - Type of the event to listen for.
     * @param { Callback<Array<drm.MediaKeySystemInfo>> } callback - Callback for event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    off(type: 'mediaKeySystemInfoUpdate', callback?: Callback<Array<drm.MediaKeySystemInfo>>): void;

    /**
     * Register listens for media playback stateChange event.
     * @param { 'stateChange' } type - Type of the playback event to listen for.
     * @param { function } callback - Callback used to listen for the playback stateChange event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for media playback stateChange event.
     * @param { 'stateChange' } type - Type of the playback event to listen for.
     * @param { function } callback - Callback used to listen for the playback stateChange event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Register listens for media playback stateChange event.
     * @param { 'stateChange' } type - Type of the playback event to listen for.
     * @param { OnAVPlayerStateChangeHandle } callback - Callback used to listen for the playback stateChange event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'stateChange', callback: OnAVPlayerStateChangeHandle): void;
    /**
     * Unregister listens for media playback stateChange event.
     * @param { 'stateChange' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for media playback stateChange event.
     * @param { 'stateChange' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Unregister listens for media playback stateChange event.
     * @param { 'stateChange' } type - Type of the playback event to listen for.
     * @param { OnAVPlayerStateChangeHandle } callback - Callback used to listen for stateChange event
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    off(type: 'stateChange', callback?: OnAVPlayerStateChangeHandle): void;
    /**
     * Register listens for media playback volumeChange event.
     * @param { 'volumeChange' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback volume event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for media playback volumeChange event.
     * @param { 'volumeChange' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback volume event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'volumeChange', callback: Callback<number>): void;
    /**
     * Unregister listens for media playback volumeChange event.
     * @param { 'volumeChange' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for media playback volumeChange event.
     * @param { 'volumeChange' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback volume event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @since 12
     */
    off(type: 'volumeChange', callback?: Callback<number>): void;
    /**
     * Register listens for media playback endOfStream event.
     * @param { 'endOfStream' } type - Type of the playback event to listen for.
     * @param { Callback<void> } callback - Callback used to listen for the playback end of stream.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for media playback endOfStream event.
     * @param { 'endOfStream' } type - Type of the playback event to listen for.
     * @param { Callback<void> } callback - Callback used to listen for the playback end of stream.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'endOfStream', callback: Callback<void>): void;
    /**
     * Unregister listens for media playback endOfStream event.
     * @param { 'endOfStream' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for media playback endOfStream event.
     * @param { 'endOfStream' } type - Type of the playback event to listen for.
     * @param { Callback<void> } callback - Callback used to listen for the playback end of stream.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @since 12
     */
    off(type: 'endOfStream', callback?: Callback<void>): void;
    /**
     * Register listens for media playback seekDone event.
     * @param { 'seekDone' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback seekDone event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for media playback seekDone event.
     * @param { 'seekDone' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback seekDone event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Register listens for media playback seekDone event.
     * @param { 'seekDone' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback seekDone event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'seekDone', callback: Callback<number>): void;
    /**
     * Unregister listens for media playback seekDone event.
     * @param { 'seekDone' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for media playback seekDone event.
     * @param { 'seekDone' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Unregister listens for media playback seekDone event.
     * @param { 'seekDone' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback seekDone event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    off(type: 'seekDone', callback?: Callback<number>): void;
    /**
     * Register listens for media playback speedDone event.
     * @param { 'speedDone' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback speedDone event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for media playback speedDone event.
     * @param { 'speedDone' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback speedDone event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'speedDone', callback: Callback<number>): void;
    /**
     * Unregister listens for media playback speedDone event.
     * @param { 'speedDone' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for media playback speedDone event.
     * @param { 'speedDone' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback speedDone event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @since 12
     */
    off(type: 'speedDone', callback?: Callback<number>): void;
    /**
     * Register listens for media playback setBitrateDone event.
     * @param { 'bitrateDone' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback setBitrateDone event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for media playback setBitrateDone event.
     * @param { 'bitrateDone' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback setBitrateDone event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    on(type: 'bitrateDone', callback: Callback<number>): void;
    /**
     * Unregister listens for media playback setBitrateDone event.
     * @param { 'bitrateDone' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for media playback setBitrateDone event.
     * @param { 'bitrateDone' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback setBitrateDone event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 12
     */
    off(type: 'bitrateDone', callback?: Callback<number>): void;
    /**
     * Register listens for media playback timeUpdate event.
     * @param { 'timeUpdate' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback timeUpdate event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for media playback timeUpdate event.
     * @param { 'timeUpdate' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback timeUpdate event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Register listens for media playback timeUpdate event.
     * @param { 'timeUpdate' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback timeUpdate event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'timeUpdate', callback: Callback<number>): void;
    /**
     * Unregister listens for media playback timeUpdate event.
     * @param { 'timeUpdate' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for media playback timeUpdate event.
     * @param { 'timeUpdate' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Unregister listens for media playback timeUpdate event.
     * @param { 'timeUpdate' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback timeUpdate event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    off(type: 'timeUpdate', callback?: Callback<number>): void;
    /**
     * Register listens for media playback durationUpdate event.
     * @param { 'durationUpdate' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback durationUpdate event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for media playback durationUpdate event.
     * @param { 'durationUpdate' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback durationUpdate event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'durationUpdate', callback: Callback<number>): void;
    /**
     * Unregister listens for media playback durationUpdate event.
     * @param { 'durationUpdate' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for media playback durationUpdate event.
     * @param { 'durationUpdate' } type - Type of the playback event to listen for.
     * @param { Callback<number> } callback - Callback used to listen for the playback durationUpdate event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @since 12
     */
    off(type: 'durationUpdate', callback?: Callback<number>): void;

    /**
     * Register listens for video playback buffering events.
     * @param { 'bufferingUpdate' } type - Type of the playback buffering update event to listen for.
     * @param { function } callback - Callback used to listen for the buffering update event,
	   * return BufferingInfoType and the value.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for video playback buffering events.
     * @param { 'bufferingUpdate' } type - Type of the playback buffering update event to listen for.
     * @param { OnBufferingUpdateHandler } callback - Callback used to listen for the buffering update event,
	   * return BufferingInfoType and the value.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'bufferingUpdate', callback: OnBufferingUpdateHandler): void;

    /**
     * Unregister listens for video playback buffering events.
     * @param { 'bufferingUpdate' } type - Type of the playback buffering update event to listen for.
	   * return BufferingInfoType and the value.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for video playback buffering events.
     * @param { 'bufferingUpdate' } type - Type of the playback buffering update event to listen for.
     * @param { OnBufferingUpdateHandler } callback - Callback used to listen for the buffering update event,
	   * return BufferingInfoType and the value.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    off(type: 'bufferingUpdate', callback?: OnBufferingUpdateHandler): void;
    /**
     * Register listens for start render video frame events.
     * @param { 'startRenderFrame' } type - Type of the playback event to listen for.
     * @param { Callback<void> } callback - Callback used to listen for the playback event return .
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for start render video frame events.
     * @param { 'startRenderFrame' } type - Type of the playback event to listen for.
     * @param { Callback<void> } callback - Callback used to listen for the playback event return .
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    on(type: 'startRenderFrame', callback: Callback<void>): void;
    /**
     * Unregister listens for start render video frame events.
     * @param { 'startRenderFrame' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for start render video frame events.
     * @param { 'startRenderFrame' } type - Type of the playback event to listen for.
     * @param { Callback<void> } callback - Callback used to listen for the playback event return .
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 12
     */
    off(type: 'startRenderFrame', callback?: Callback<void>): void;

    /**
     * Register listens for video size change event.
     * @param { 'videoSizeChange' } type - Type of the playback event to listen for.
     * @param { function } callback - Callback used to listen for the playback event return video size.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for video size change event.
     * @param { 'videoSizeChange' } type - Type of the playback event to listen for.
     * @param { OnVideoSizeChangeHandler } callback - Callback used to listen for the playback event return video size.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'videoSizeChange', callback: OnVideoSizeChangeHandler): void;
    /**
     * Unregister listens for video size change event.
     * @param { 'videoSizeChange' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for video size change event.
     * @param { 'videoSizeChange' } type - Type of the playback event to listen for.
     * @param { OnVideoSizeChangeHandler } callback - Callback used to listen for the playback event return video size.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    off(type: 'videoSizeChange', callback?: OnVideoSizeChangeHandler): void;
    /**
     * Register listens for audio interrupt event, refer to {@link #audio.InterruptEvent}
     * @param { 'audioInterrupt' } type - Type of the playback event to listen for.
     * @param { function } callback - Callback used to listen for the playback event return audio interrupt info.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for audio interrupt event, refer to {@link #audio.InterruptEvent}
     * @param { 'audioInterrupt' } type - Type of the playback event to listen for.
     * @param { Callback<audio.InterruptEvent> } callback - Callback used to listen for the playback event return audio interrupt info.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'audioInterrupt', callback: Callback<audio.InterruptEvent>): void;
    /**
     * Unregister listens for audio interrupt event, refer to {@link #audio.InterruptEvent}
     * @param { 'audioInterrupt' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for audio interrupt event, refer to {@link #audio.InterruptEvent}
     * @param { 'audioInterrupt' } type - Type of the playback event to listen for.
     * @param { Callback<audio.InterruptEvent> } callback - Callback used to listen for the playback event return audio interrupt info.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    off(type: 'audioInterrupt', callback?: Callback<audio.InterruptEvent>): void;
    /**
     * Register listens for available bitrate list collect completed events for HLS protocol stream playback.
     * This event will be reported after the {@link #prepare} called.
     * @param { 'availableBitrates' } type - Type of the playback event to listen for.
     * @param { function } callback - Callback used to listen for the playback event return available bitrate list.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for available bitrate list collect completed events for HLS protocol stream playback.
     * This event will be reported after the {@link #prepare} called.
     * @param { 'availableBitrates' } type - Type of the playback event to listen for.
     * @param { Callback<Array<number>> } callback - Callback used to listen for the playback event return available bitrate list.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    on(type: 'availableBitrates', callback: Callback<Array<number>>): void;
    /**
     * Unregister listens for available bitrate list collect completed events for HLS protocol stream playback.
     * This event will be reported after the {@link #prepare} called.
     * @param { 'availableBitrates' } type - Type of the playback event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for available bitrate list collect completed events for HLS protocol stream playback.
     * This event will be reported after the {@link #prepare} called.
     * @param { 'availableBitrates' } type - Type of the playback event to listen for.
     * @param { Callback<Array<number>> } callback - Callback used to listen for the playback event return available bitrate list.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    off(type: 'availableBitrates', callback?: Callback<Array<number>>): void;
    /**
     * Register listens for playback error events.
     * @param { 'error' } type - Type of the playback error event to listen for.
     * @param { ErrorCallback } callback - Callback used to listen for the playback error event.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 401 - The parameter check failed.
     * @throws { BusinessError } 801 - Capability not supported.
     * @throws { BusinessError } 5400101 - No memory.
     * @throws { BusinessError } 5400102 - Operation not allowed.
     * @throws { BusinessError } 5400103 - I/O error.
     * @throws { BusinessError } 5400104 - Time out.
     * @throws { BusinessError } 5400105 - Service died.
     * @throws { BusinessError } 5400106 - Unsupported format.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Register listens for playback error events.
     * @param { 'error' } type - Type of the playback error event to listen for.
     * @param { ErrorCallback } callback - Callback used to listen for the playback error event.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
     * <br>2. Incorrect parameter types. 3.Parameter verification failed.
     * @throws { BusinessError } 801 - Capability not supported.
     * @throws { BusinessError } 5400101 - No memory.
     * @throws { BusinessError } 5400102 - Operation not allowed.
     * @throws { BusinessError } 5400103 - I/O error.
     * @throws { BusinessError } 5400104 - Time out.
     * @throws { BusinessError } 5400105 - Service died.
     * @throws { BusinessError } 5400106 - Unsupported format.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Register listens for playback error events.
     * @param { 'error' } type - Type of the playback error event to listen for.
     * @param { ErrorCallback } callback - Callback used to listen for the playback error event.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 401 - The parameter check failed.
     * @throws { BusinessError } 801 - Capability not supported.
     * @throws { BusinessError } 5400101 - No memory.
     * @throws { BusinessError } 5400102 - Operation not allowed.
     * @throws { BusinessError } 5400103 - I/O error.
     * @throws { BusinessError } 5400104 - Time out.
     * @throws { BusinessError } 5400105 - Service died.
     * @throws { BusinessError } 5400106 - Unsupported format.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    /**
     * Register listens for playback error events.
     * @param { 'error' } type - Type of the playback error event to listen for.
     * @param { ErrorCallback } callback - Callback used to listen for the playback error event.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 401 - The parameter check failed.
     * @throws { BusinessError } 801 - Capability not supported.
     * @throws { BusinessError } 5400101 - No memory.
     * @throws { BusinessError } 5400102 - Operation not allowed.
     * @throws { BusinessError } 5400104 - Time out.
     * @throws { BusinessError } 5400105 - Service died.
     * @throws { BusinessError } 5400106 - Unsupported format.
     * @throws { BusinessError } 5411001 - IO can not find host.
     * @throws { BusinessError } 5411002 - IO connection timeout.
     * @throws { BusinessError } 5411003 - IO network abnormal.
     * @throws { BusinessError } 5411004 - IO network unavailable.
     * @throws { BusinessError } 5411005 - IO no permission.
     * @throws { BusinessError } 5411006 - IO request denied.
     * @throws { BusinessError } 5411007 - IO resource not found.
     * @throws { BusinessError } 5411008 - IO SSL client cert needed.
     * @throws { BusinessError } 5411009 - IO SSL connect fail.
     * @throws { BusinessError } 5411010 - IO SSL server cert untrusted.
     * @throws { BusinessError } 5411011 - IO unsupported request.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 14
     */
    on(type: 'error', callback: ErrorCallback): void;
    /**
     * Unregister listens for playback error events.
     * @param { 'error' } type - Type of the playback error event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 9
     */
    /**
     * Unregister listens for playback error events.
     * @param { 'error' } type - Type of the playback error event to listen for.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 11
     */
    /**
     * Unregister listens for playback error events.
     * @param { 'error' } type - Type of the playback error event to listen for.
     * @param { ErrorCallback } callback - Callback used to listen for the playback error event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @crossplatform
     * @atomicservice
     * @since 12
     */
    off(type: 'error', callback?: ErrorCallback): void;

    /**
     * Subscribes output device change event callback.
     * The event is triggered when output device change for this stream.
     * @param { 'audioOutputDeviceChangeWithInfo' } type - Type of the event to listen for.
     * @param { Callback<audio.AudioStreamDeviceChangeInfo> } callback - Callback used to listen device change event.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
     * <br>2. Incorrect parameter types. 3.Parameter verification failed.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 11
     */
    /**
     * Subscribes output device change event callback.
     * The event is triggered when output device change for this stream.
     * @param { 'audioOutputDeviceChangeWithInfo' } type - Type of the event to listen for.
     * @param { Callback<audio.AudioStreamDeviceChangeInfo> } callback - Callback used to listen device change event.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
     * <br>2. Incorrect parameter types. 3.Parameter verification failed.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    on(type: 'audioOutputDeviceChangeWithInfo', callback: Callback<audio.AudioStreamDeviceChangeInfo>): void;

    /**
     * Unsubscribes output device change event callback.
     * @param { 'audioOutputDeviceChangeWithInfo' } type - Type of the event to listen for.
     * @param { Callback<audio.AudioStreamDeviceChangeInfo> } callback - Callback used to listen device change event.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
     * <br>2. Incorrect parameter types. 3.Parameter verification failed.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 11
     */
    /**
     * Unsubscribes output device change event callback.
     * @param { 'audioOutputDeviceChangeWithInfo' } type - Type of the event to listen for.
     * @param { Callback<audio.AudioStreamDeviceChangeInfo> } callback - Callback used to listen device change event.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified.
     * <br>2. Incorrect parameter types. 3.Parameter verification failed.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    off(type: 'audioOutputDeviceChangeWithInfo', callback?: Callback<audio.AudioStreamDeviceChangeInfo>): void;

    /**
     * Subscribes listener for subtitle update event.
     * @param { 'subtitleUpdate' } type - Type of the event to listen for.
     * @param { Callback<SubtitleInfo> } callback - Callback used to listen subtitle update event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    on(type: 'subtitleUpdate', callback: Callback<SubtitleInfo>): void

    /**
     * Unsubscribes listener for subtitle update event.
     * @param { 'subtitleUpdate' } type - Type of the event to listen for.
     * @param { Callback<SubtitleInfo> } callback - Callback used to listen subtitle update event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    off(type: 'subtitleUpdate', callback?: Callback<SubtitleInfo>): void

    /**
     * Subscribes listener for track change event.
     * @param { 'trackChange' } type - Type of the event to listen for.
     * @param { OnTrackChangeHandler } callback - Callback used to listen track change event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    on(type: 'trackChange', callback: OnTrackChangeHandler): void

    /**
     * Unsubscribes listener for track change event.
     * @param { 'trackChange' } type - Type of the event to listen for.
     * @param { OnTrackChangeHandler } callback - Callback used to listen track change event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    off(type: 'trackChange', callback?: OnTrackChangeHandler): void

    /**
     * Subscribes listener for trackinfo update event.
     * @param { 'trackInfoUpdate' } type - Type of the event to listen for.
     * @param { Callback<Array<MediaDescription>> } callback - Callback used to listen trackinfo update event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    on(type: 'trackInfoUpdate', callback: Callback<Array<MediaDescription>>): void

    /**
     * Unsubscribes listener for trackinfo update event.
     * @param { 'trackInfoUpdate' } type - Type of the event to listen for.
     * @param { Callback<Array<MediaDescription>> } callback - Callback used to listen trackinfo update event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 12
     */
    off(type: 'trackInfoUpdate', callback?: Callback<Array<MediaDescription>>): void

    /**
     * Subscrips listener for audio playback amplitude update event.
     * In each event, an array of amplitude is reported, large index indicates closer to current time.
     * @param { 'amplitudeUpdate' } type - Type of the event to listen for.
     * @param { Callback<Array<number>> } callback - Callback used to listen amplitude update event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 13
     */
    on(type: 'amplitudeUpdate', callback: Callback<Array<number>>): void

    /**
     * UnSubscrips listener for audio playback amplitude update event
     * @param { 'amplitudeUpdate' } type - Type of the event to listen for.
     * @param { Callback<Array<number>> } callback - Callback used to listen amplitude update event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @since 13
     */
    off(type: 'amplitudeUpdate', callback?: Callback<Array<number>>): void

    /**
     * Subscribes listener for video SEI message event, only for live video streaming.
     * Call before the {@link #prepare}, repeated invocation overwrites the last subscribed callback and payload types.
     *
     * @param { 'seiMessageReceived' } type - Type of the playback event to listen for.
     * @param { Array<number> } payloadTypes - The subscribed payload types of the SEI message.
     * @param { OnSeiMessageHandle } callback - Callback to listen SEI message event with subscribed payload types.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 18
     */
    on(type: 'seiMessageReceived', payloadTypes: Array<number>, callback: OnSeiMessageHandle): void;

    /**
     * Unsubscribes listener for video SEI message event.
     * @param { 'seiMessageReceived' } type - Type of the playback event to listen for.
     * @param { Array<number> } payloadTypes - The payload types of the SEI message.
     *                                        Null means unsubscribe all payload types.

     * @param { OnSeiMessageHandle } callback - Callback to listen SEI message event with subscribed payload types.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 18
     */
    off(type: 'seiMessageReceived', payloadTypes?: Array<number>, callback?: OnSeiMessageHandle): void;

    /**
     * Subscribes listener for super-resolution status changed event.
     * @param { 'superResolutionChanged' } type - Type of the super-resolution event to listen for.
     * @param { OnSuperResolutionChanged } callback - Callback used to listen for the super-resolution changed event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 18
     */
    on(type:'superResolutionChanged', callback: OnSuperResolutionChanged): void;

    /**
     * Unsubscribes listener for super-resolution status changed event.
     * @param { 'superResolutionChanged' } type - Type of the super-resolution event to listen for.
     * @param { OnSuperResolutionChanged } callback - Callback used to listen for the super-resolution changed event.
     * @syscap SystemCapability.Multimedia.Media.AVPlayer
     * @atomicservice
     * @since 18
     */
    off(type:'superResolutionChanged', callback?: OnSuperResolutionChanged): void;    
  }

  /**
   * Provides player statistic info.
   *
   * @typedef PlaybackInfo
   * @syscap SystemCapability.Multimedia.Media.Core
   * @since 12
   */
  interface PlaybackInfo {
    /**
     * key:value pair, key see @PlaybackInfoKey.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 12
     */
    [key:string]: Object;
  }

  /**
   * Enumerates statistics info keys for player.
   *
   * @enum { string }
   * @syscap SystemCapability.Multimedia.Media.Core
   * @since 12
   */
  enum PlaybackInfoKey {
    /**
     * IP address of current network stream.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 12
     */
    SERVER_IP_ADDRESS = 'server_ip_address',

    /**
     * Average download rate during playing except for suspend downloading.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 12
     */
    AVG_DOWNLOAD_RATE = 'average_download_rate',

    /**
     * Current download rate of the last second except for suspend downloading.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 12
     */
    DOWNLOAD_RATE = 'download_rate',

    /**
     * Boolean value, true for current is downloading, false for suspend downloading.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 12
     */
    IS_DOWNLOADING = 'is_downloading',

    /**
     * Cached duration in milliseconds.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 12
     */
    BUFFER_DURATION = 'buffer_duration',
  }

  /**
   * Enumerates ErrorCode types, return in BusinessError::code
   *
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.Core
   * @since 8
   * @deprecated since 11
   * @useinstead ohos.multimedia.media/media.AVErrorCode
   */
  enum MediaErrorCode {
    /**
     * operation success.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 8
     * @deprecated since 11
     * @useinstead ohos.multimedia.media/media.AVErrorCode#AVERR_OK
     */
    MSERR_OK = 0,

    /**
     * malloc or new memory failed. maybe system have no memory.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 8
     * @deprecated since 11
     * @useinstead ohos.multimedia.media/media.AVErrorCode#AVERR_NO_MEMORY
     */
    MSERR_NO_MEMORY = 1,

    /**
     * no permission for the operation.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 8
     * @deprecated since 11
     * @useinstead ohos.multimedia.media/media.AVErrorCode#AVERR_OPERATE_NOT_PERMIT
     */
    MSERR_OPERATION_NOT_PERMIT = 2,

    /**
     * invalid argument.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 8
     * @deprecated since 11
     * @useinstead ohos.multimedia.media/media.AVErrorCode#AVERR_INVALID_PARAMETER
     */
    MSERR_INVALID_VAL = 3,

    /**
     * an I/O error occurred.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 8
     * @deprecated since 11
     * @useinstead ohos.multimedia.media/media.AVErrorCode#AVERR_IO
     */
    MSERR_IO = 4,

    /**
     * operation time out.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 8
     * @deprecated since 11
     * @useinstead ohos.multimedia.media/media.AVErrorCode#AVERR_TIMEOUT
     */
    MSERR_TIMEOUT = 5,

    /**
     * unknown error.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 8
     * @deprecated since 11
     * @useinstead ohos.multimedia.media/media.AVErrorCode#AVERR_INVALID_PARAMETER
     */
    MSERR_UNKNOWN = 6,

    /**
     * media service died.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 8
     * @deprecated since 11
     * @useinstead ohos.multimedia.media/media.AVErrorCode#AVERR_SERVICE_DIED
     */
    MSERR_SERVICE_DIED = 7,

    /**
     * operation is not permit in current state.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 8
     * @deprecated since 11
     * @useinstead ohos.multimedia.media/media.AVErrorCode#AVERR_INVALID_PARAMETER
     */
    MSERR_INVALID_STATE = 8,

    /**
     * operation is not supported in current version.
     * @syscap SystemCapability.Multimedia.Media.Core
     * @since 8
     * @deprecated since 11
     * @useinstead ohos.multimedia.media/media.AVErrorCode#AVERR_UNSUPPORT_CAPABILITY
     */
    MSERR_UNSUPPORTED = 9,
  }

  /**
   * Enumerates buffering info type, for network playback.
   *
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.Core
   * @since 8
   */
  /**
   * Enumerates buffering info type, for network playback.
   *
   * @enum { number }
   * @syscap SystemCapability.Multimedia.Media.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  enum BufferingInfoType {
    /**
     * begin to buffering
