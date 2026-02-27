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
import { image } from '@kit.ImageKit';
import { AsyncCallback } from '@kit.BasicServicesKit';

export const initCamera:(surfaceId: string, focusMode: number, cameraDeviceIndex: number) => number;
export const startPhoto: (degree: number) => number;
export const setZoomRatio: (a: number) => number;
export const hasFlash: (a: number) => number;
export const isExposureModeSupported:(a: number) => number;
export const isMeteringPoint: (a: number, b: number) => number;
export const isExposureBiasRange: (a: number) => number;
export const isFocusPoint: (a: number, b: number) => number;
export const releaseCamera: () => number;
export const releaseSession: () => number;
export const setPhotoOutputCallback: (isSinglePhoto: boolean) => number;
export const getPixelMap: (packingPath: number, imageMimeType: string) => number;
export const isSingle: () => number;

interface Capture_Setting {
    quality: number;
    rotation: number;
    mirror: boolean;
    latitude: number;
    longitude: number;
    altitude: number;
}