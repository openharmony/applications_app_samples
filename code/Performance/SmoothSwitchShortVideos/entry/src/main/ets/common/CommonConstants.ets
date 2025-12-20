/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

export class CommonConstants {
  /**
   * Video source url.
   * XX.XX.XX.XX: your pc ip address
   */
  static readonly VIDEO_SOURCE: string[] = [
    'http://XX.XX.XX.XX:5000/video1',
    'http://XX.XX.XX.XX:5000/video2',
    'http://XX.XX.XX.XX:5000/video3',
    'http://XX.XX.XX.XX:5000/video4',
    'http://XX.XX.XX.XX:5000/video5',
    'http://XX.XX.XX.XX:5000/video6'
  ];
  /**
   * Track thickness size min.
   */
  static readonly TRACK_SIZE_MIN: number = 4;
  /**
   * Track thickness borderRadius.
   */
  static readonly TRACK_BORDER_RADIUS: number = 2;
  /**
   * Track thickness size max.
   */
  static readonly TRACK_SIZE_MAX: number = 6;
  /**
   * The surface width.
   */
  static readonly SURFACE_WIDTH: number = 1920;
  /**
   * The surface height.
   */
  static readonly SURFACE_HEIGHT: number = 1080;
}