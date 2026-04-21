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

export const initPlayer: () => void;

export const loadSongInfo: (fileName: string, songFd: number, songFileSize: number, songFileOffset: number) => void;

export const playSong: () => void;

export const pauseSong: () => void;

export const stopSong: () => void;

export const seekPlaySong: (timeStamp: number) => void;

export const setPlayingSpeed: (speed: number) => void;

export const getPlayingVolume: () => number;

export const setPlayingVolume: (volume: number) => void;

export const setSilentMode: (isSilentMode: boolean) => void;

export const setEffectMode: (isEffectOn: boolean) => void;

export const releasePlayer: () => void;

export const onPlayStatus: (cbFn: (state: number) => void) => void;

export const getProgress: () => number;

export const getSongDuration: () => number;

export const getRemainingTime: () => number;