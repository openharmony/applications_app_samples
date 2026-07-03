/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 * Common constants for all features.
 */
export class CommonConstants {
  /**
   * Preference saved key.
   */
  public static readonly PREFERENCES_KEY_PRIVACY: string = 'isPrivacy';
  /**
   * Preference saved file name.
   */
  public static readonly PREFERENCES_FILE_NAME: string = 'myStore';
  /**
   * Launcher page count down.
   */
  public static readonly LAUNCHER_DELAY_TIME: number = 1500;
  /**
   * Image logo top margin.
   */
  public static readonly LAUNCHER_IMAGE_MARGIN_TOP: string = '8%';
  /**
   * launcher title text top margin.
   */
  public static readonly LAUNCHER_TEXT_TITLE_MARGIN_TOP: string = '50%';
  /**
   * launcher button top margin.
   */
  public static readonly LAUNCHER_BTN_MARGIN_TOP: string = '30%';
  /**
   * launcher privacy text top margin.
   */
  public static readonly LAUNCHER_PRIVACY_MARGIN_TOP: string = '10%';
  /**
   * The percentage of the full width.
   */
  public static readonly FULL_WIDTH_PERCENT: string = '100%';
  /**
   * The percentage of the full height.
   */
  public static readonly FULL_HEIGHT_PERCENT: string = '100%';
  public static readonly EIGHTY_PERCENT: string = '80%';
  /**
   * the animation duration
   */
  public static readonly ANIMATION_DURATION = 2000;
  /**
   * 设备库默认图标
   */
  public static readonly DEFAULT_DEVICE_ICON: Resource = $r('app.media.ic_gate');
  /**
   * 用户数据库名
   */
  public static readonly USERDATA: string = 'userData';
}