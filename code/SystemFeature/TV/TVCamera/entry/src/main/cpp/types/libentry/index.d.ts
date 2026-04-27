/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export const initCamera:(surfaceId: string, focusMode: number, cameraDeviceID: string,isVideo?:boolean) => number;
export const initCameraManager:() => number;
export const startPhotoOrVideo: (modeFlag: string, videoId: string, photoId: string, cameraDeviceID: string) => number;
export const videoOutputStart: (cameraDeviceID: string, enableMirror: boolean) => number;
export const setZoomRatio: (a: number, cameraDeviceID: string) => number;
export const takePicture: ( cameraDeviceID: string) => number;
export const takePictureWithSettings: (setting: Capture_Setting,cameraDeviceID: string) => number;
export const setPhotoSettings: (setting: Capture_Setting,cameraDeviceID: string) => number;
export const hasFlash: (a: number, cameraDeviceID: string) => number;
export const isVideoStabilizationModeSupported: (a: number, cameraDeviceID: string) => number;
export const isExposureModeSupported:(a: number, cameraDeviceID: string) => number;
export const isMeteringPoint: (a: number, b: number, cameraDeviceID: string) => number;
export const isExposureBiasRange: (a: number, cameraDeviceID: string) => number;
export const isFocusModeSupported: (a: number, cameraDeviceID: string) => number;
export const isFocusPoint: (a: number, b: number, cameraDeviceID: string) => number;
export const getVideoFrameWidth: (cameraDeviceID: string) => number;
export const getVideoFrameHeight: (cameraDeviceID: string) => number;
export const getVideoFrameRate: (cameraDeviceID: string) => number;
export const videoOutputStopAndRelease: (cameraDeviceID: string) => number;
export const releaseCamera: (cameraDeviceID: string) => number;
export const releaseSession: (cameraDeviceID: string) => number;
export const resolutionPhoto: (resolutionPhoto: string) => number;
export const resolutionVedio: (resolutionVedio: string) => number;
export const watermarkPhotoPic: (photoPicPath: string) => number;
export const watermarkPhotoFont: (photoFontStr: string) => number;
export const watermarkVedioPic: (vedioPicPath: string) => number;
export const watermarkVedioFont: (vedioFontStr: string) => number;
export const cameraStatusCallBack:(callback:(cameraId:string,status:CameraStatus)=>void)=>void;


interface Capture_Setting {
    quality: number;
    rotation: number;
    mirror: boolean;
    latitude: number;
    longitude: number;
    altitude: number;
}
export enum CameraStatus {
    CAMERA_STATUS_APPEAR = 0,
    CAMERA_STATUS_DISAPPEAR = 1,
    CAMERA_STATUS_AVAILABLE = 2,
    CAMERA_STATUS_UNAVAILABLE = 3
}