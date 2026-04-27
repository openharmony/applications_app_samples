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
declare namespace dmrnapi {
    export enum PlayerStates{
        PLAYER_STATE_ERROR = 0,
        PLAYER_IDLE = 1,
        PLAYER_INITIALIZED = 2,
        PLAYER_PREPARING = 3,
        PLAYER_PREPARED = 4,
        PLAYER_STARTED = 5,
        PLAYER_PAUSED = 6,
        PLAYER_STOPPED = 7,
        PLAYER_PLAYBACK_COMPLETE = 8,
        PLAYER_RELEASED = 9,
        PLAYER_BUFFERING = 10
    }

    function DmrOpen(): number;
    function DmrClose(): number;
    function Play(): number;
    function Pause(): number;
    function Stop(): number;
    function Forward(second: number): number;
    function Backward(second: number): number;
    function SetSurfaceId(surfaceId: string): number;
    function GetPlayerStatus(): number;
    function GetPosition(): number;
    function GetDuration(): number;
    function Seek(second: number): number;
    function ResgisterDlnaPlayerAsync(object:object):Promise<number>;
    function GetDlnaDeviceName(): string;
    function SetDlnaDeviceName(deviceName: string): number;
    function GetDmrState(): number;
    function RegisterRemoteDiedListener(): number;
    function GetVolume(): number[];
    function SetVolume(volume: number): number;

}
export default dmrnapi;
