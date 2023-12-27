/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

export const initCamera:(surfaceId: string, focusMode: number, cameraDeviceIndex: number) => number;
export const startPhotoOrVideo: (modeFlag: string, videoId: string, photoId: string) => number;
export const videoOutputStart: () => number;
export const setZoomRatio: (a: number) => number;
export const takePicture: () => number;
export const takePictureWithSettings: (setting: Capture_Setting) => number;
export const hasFlash: (a: number) => number;
export const isVideoStabilizationModeSupported: (a: number) => number;
export const isExposureModeSupported:(a: number) => number;
export const isMeteringPoint: (a: number, b: number) => number;
export const isExposureBiasRange: (a: number) => number;
export const isFocusModeSupported: (a: number) => number;
export const isFocusPoint: (a: number, b: number) => number;
export const getVideoFrameWidth: () => number;
export const getVideoFrameHeight: () => number;
export const getVideoFrameRate: () => number;
export const videoOutputStopAndRelease: () => number;
export const releaseCamera: () => number;
export const releaseSession: () => number;


interface Capture_Setting {
    quality: number;
    rotation: number;
    mirror: boolean;
    latitude: number;
    longitude: number;
    altitude: number;
}