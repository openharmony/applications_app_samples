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
