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

// [Start ndk_implement_node_api]
// Index.d.ts
export enum PiPControlGroup {
  VIDEO_PLAY_VIDEO_PREVIOUS_NEXT = 101,
  VIDEO_PLAY_FAST_FORWARD_BACKWARD = 102,
  VIDEO_CALL_MICROPHONE_SWITCH = 201,
  VIDEO_CALL_HANG_UP_BUTTON = 202,
  VIDEO_CALL_CAMERA_SWITCH = 203,
  VIDEO_CALL_MUTE_SWITCH = 204,
  VIDEO_MEETING_HANG_UP_BUTTON = 301,
  VIDEO_MEETING_CAMERA_SWITCH = 302,
  VIDEO_MEETING_MUTE_SWITCH = 303,
  VIDEO_MEETING_MICROPHONE_SWITCH = 304,
  VIDEO_LIVE_VIDEO_PLAY_PAUSE = 401,
  VIDEO_LIVE_MUTE_SWITCH = 402,
}
export interface PiPConfig {
  mainWindowId: number;
  pipTemplateType: number;
  width: number;
  height: number;
  controlGroup: Array<PiPControlGroup>;
}
export declare const createPip: (config: PiPConfig) => number;
export declare const startPip: (controllerId: number) => number;
export declare const registerStartPip: (controllerId: number, jsCallback: Function) => number;
export declare const deletePip: (controllerId: number) => number;
export declare const stopPip: (controllerId: number) => number;
export declare const registerLifecycleListener: (controllerId: number, jsCallback: Function) => number;
// [End ndk_implement_node_api]