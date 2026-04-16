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
 * Constants for player area.
 */
export class PlayerConstants {
  /**
   * The font size of the singer is smaller.
   */
  static readonly FONT_REDUCE: number = 4;
  /**
   * The layout weight of player control.
   */
  static readonly LAYOUT_WEIGHT_PLAYER_CONTROL: number = 1;
  /**
   * The display priority is 1.
   */
  static readonly DISPLAY_PRIORITY_ONE: number = 1;
  /**
   * The display priority is 2.
   */
  static readonly DISPLAY_PRIORITY_TWO: number = 2;
  /**
   * The display priority is 3.
   */
  static readonly DISPLAY_PRIORITY_THREE: number = 3;
  /**
   * The rotate is 360.
   */
  static readonly ROTATE: number = 360;
  /**
   * The animation duration is 3000.
   */
  static readonly ANIMATION_DURATION: number = 3000;
  /**
   * The value of iterations.
   */
  static readonly ITERATIONS: number = -1;
  /**
   * The value of font weight.
   */
  static readonly FONT_WEIGHT_700: number = 700;
  /**
   * The value of font weight.
   */
  static readonly FONT_WEIGHT_500: number = 500;
  /**
   * The value of font family.
   */
  static readonly FONT_FAMILY_BLACK: string = 'HarmonyHeiTi';
  /**
   * The value of font family.
   */
  static readonly FONT_FAMILY_BOLD: string = 'HarmonyHeiTi-Bold';
  /**
   * The value of font family.
   */
  static readonly FONT_FAMILY_MEDIUM: string = 'HarmonyHeiTi-Medium';
  /**
   * The value of encoding.
   */
  static readonly ENCODING: string = 'utf-8';
  /**
   * The value of back ground image width and height.
   */
  static readonly BACK_IMAGE: string = '120%';
  /**
   * Set the image blur level.
   */
  static readonly IMAGE_BLUR: number = 15;
}

export enum MusicPlayMode {
  SINGLE_CYCLE = 0,
  ORDER = 1,
  RANDOM = 2
}

export const PlayModeSwitchList = [MusicPlayMode.ORDER, MusicPlayMode.RANDOM, MusicPlayMode.SINGLE_CYCLE];

export enum AudioPlayerState {
  IDLE,
  INITIALIZED,
  LOAD,
  PREPARED,
  PLAY,
  PAUSE,
  STOP,
  ERROR,
  COMPLETED,
  RELEASED,
  PROGRESS_SPEED,
  TIME_UPDATE,
  VOLUME_CHANGE,
  UNKNOWN
}

export const firstSongTitle = 'Dream It Possible';

export const firstSongSinger = 'Delacey';

export const SELECT_MUSIC_INDEX = 'selectIndex';

export const TOTAL_MS_NUMBER_NUMBER_DURATION = 'totalMsDuration';

export const TOTAL_TIME_STRING_NUMBER_DURATION = 'totalTimeDuration';

export const SILENT_ID = 'silentId';

export const VOLUME_ID = 'volumeId';

export const EFFECT_ID = 'effectId';

export const DEFAULT_VOLUME = 1;

export class Options {
  public offset?: number;
  public length?: number;
}