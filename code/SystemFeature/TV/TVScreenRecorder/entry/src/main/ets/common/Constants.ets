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
 
export const DESTROY_FLOAT_WINDOW = 1

export class PhoneConstants {
  public static PHONE_WIDTH: number = 180;
  public static PHONE_HEIGHT: number = 160;
}
export class RecorderConstants{
  public static VIDEO_SOURCE_TYPE_SURFACE_YUV = 0;
  public static VIDEO_SOURCE_TYPE_SURFACE_ES = 1;
  public static AUDIO_SOURCE_MIC = 1;
  public static FD_PREFIX = 'fd://';
  public static TIME_LENGTH = 2;
  public static TIME_PREFIX = '0';
  public static SCREEN_RECORD_PREFIX = 'REC';
  public static VIDEO_TYPE = '.mp4';
  public static CONNECTOR = '_';
  public static VIRTUAL_SCREEN_NAME = 'screenRecorder';
  public static DEVICE_RATE = 0.6;
  public static RECORD_RESOLUTION_WIDTH = 1920;
  public static RECORD_RESOLUTION_HEIGHT = 1080;
}
export enum RecordingState {
  Idle = 0,
  Recording,
  Stopped,
  Error
};
