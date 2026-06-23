/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { camera } from '@kit.CameraKit';

export class CommonConstants {
  /**
   * Full size.
   */
  static readonly FULL_SIZE: string = '100%'
  /**
   * Default width.
   */
  static readonly DEFAULT_WIDTH: number = 1920
  /**
   * Default height.
   */
  static readonly DEFAULT_HEIGHT: number = 1080
  /**
   * Button width.
   */
  static readonly BUTTON_WIDTH: number = 100
  /**
   * Duration.
   */
  static readonly DURATION: number = 2000
  /**
   * The distance between toast dialog box and the bottom of screen.
   */
  static readonly BOTTOM: number = 200
  /**
   * Image width.
   */
  static readonly IMAGE_WIDTH: number = 50
  /**
   * Image height.
   */
  static readonly IMAGE_HEIGHT: number = 50
  /**
   * Video mime type.
   */
  static readonly VIDEO_MIMETYPE: string[] = ['HDRVivid', 'H264', 'H265']
  /**
   * Video resolution.
   */
  static readonly VIDEO_RESOLUTION: string[] = ['4K', '1080P', '720P']
  /**
   * Video framerate.
   */
  static readonly VIDEO_FRAMERATE: string[] = ['30Fps', '60Fps']
  /**
   * Video recorderInfo.
   */
  static readonly RECORDER_INFO: string[][] = [
    CommonConstants.VIDEO_MIMETYPE, CommonConstants.VIDEO_RESOLUTION, CommonConstants.VIDEO_FRAMERATE
  ]
  /**
   * Default value.
   */
  static readonly DEFAULT_VALUE: number = 0
  /**
   * Video avc mime type.
   */
  static readonly MIME_VIDEO_AVC: string = 'video/avc'
  /**
   * Video hevc mime type.
   */
  static readonly MIME_VIDEO_HEVC: string = 'video/hevc'
  /**
   * 10M bitrate.
   */
  static readonly BITRATE_VIDEO_10M: number = 10 * 1024 * 1024
  /**
   * 20M bitrate.
   */
  static readonly BITRATE_VIDEO_20M: number = 20 * 1024 * 1024
  /**
   * 30M bitrate.
   */
  static readonly BITRATE_VIDEO_30M: number = 30 * 1024 * 1024
  /**
   * 30 FPS.
   */
  static readonly FRAMERATE_VIDEO_30FPS: number = 30
  /**
   * 60 FPS.
   */
  static readonly FRAMERATE_VIDEO_60FPS: number = 60
  /**
   * Row space.
   */
  static readonly ROW_SPACE: number = 10
  /**
   * Default picker item height.
   */
  static readonly DEFAULT_PICKER_ITEM_HEIGHT: number = 30
  /**
   * Selected text style font size.
   */
  static readonly SELECTED_TEXT_STYLE_FONT_SIZE: number = 15
  /**
   * The number corresponding to true.
   */
  static readonly TRUE: number = 1
  /**
   * The number corresponding to false.
   */
  static readonly FALSE: number = 0
  /**
   * 4K video width.
   */
  static readonly VIDEO_WIDTH_4K: number = 3840
  /**
   * 1080P video width.
   */
  static readonly VIDEO_WIDTH_1080P: number = 1920
  /**
   * 720P video width.
   */
  static readonly VIDEO_WIDTH_720P: number = 1280
  /**
   * 4K video height.
   */
  static readonly VIDEO_HEIGHT_4K: number = 2160
  /**
   * 1080P video height.
   */
  static readonly VIDEO_HEIGHT_1080P: number = 1080
  /**
   * 720P video height.
   */
  static readonly VIDEO_HEIGHT_720P: number = 720
  /**
   * Album, photo, video, and camera switch icons size.
   */
  static readonly ICON_SIZE: number = 200;
  /**
   * Bottom position.
   */
  static readonly BOTTOM_POSITION: number = 0.8
  /**
   * PX.
   */
  static readonly PX: string = 'px';
  /**
   * Default profile.
   */
  static readonly DEFAULT_PROFILE: camera.Profile = {
    format: camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP,
    size: {
      width: 1920,
      height: 1080
    }
  };
}