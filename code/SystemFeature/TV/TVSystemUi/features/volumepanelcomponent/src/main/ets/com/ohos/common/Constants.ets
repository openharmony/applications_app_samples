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
 

export default class Constants {
  public static readonly DEFAULT_MAX_VOLUME = 15;
  public static readonly DEFAULT_MIN_VOLUME = 0;
  public static readonly DEFAULT_MUTE_STATUS = false;
  public static readonly DEFAULT_SHOW_STATUS = true;
  public static readonly HOLD_SHOW = false;
  public static readonly HOLD_TIME = 2000;
  public static readonly VOLUME_PANEL_DIVIDER_HEIGHT = 1;
}

export enum AudioVolumeType {
  public VOICE_CALL = 0,
  public RINGTONE = 2,
  public MEDIA = 3,
  public VOICE_ASSISTANT = 9,
  public ALL = 100,
}

export interface VolumeInfo {
  public volumeType: AudioVolumeType;
  public volume: number;
  public isMute: boolean;
  public updateUi: boolean;
}