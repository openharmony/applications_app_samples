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
export default interface DlnaService {
    onPositionChanged(position: number, duration: number, callback: OnPositionChangedCallback): void;
    onPlayerStatusChanged(playerStatus: number, callback: OnPlayerStatusChangedCallback): void;
    onVolumeChanged(volume: number, maxVolume: number, callback: OnVolumeChangedCallback): void;
    onPlayerError(callback: OnPlayerErrorCallback): void;
}
export type OnPositionChangedCallback = (errCode: number, returnValue: number) => void;
export type OnPlayerStatusChangedCallback = (errCode: number, returnValue: number) => void;
export type OnVolumeChangedCallback = (errCode: number, volume: number, maxVolume: number) => void;
export type OnPlayerErrorCallback = (errCode: number, returnValue: number) => void;
export type PositionCallback = (position: number, duration: number) => void ;
export type VolumeCallback = (volume: number, maxVolume: number) => void ;
export type StatusCallback = (playFlag: boolean) => void ;
