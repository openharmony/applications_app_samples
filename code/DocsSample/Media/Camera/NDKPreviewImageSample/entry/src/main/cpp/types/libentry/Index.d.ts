/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { camera } from "@kit.CameraKit";

// export const changeSceneMode: (mode: number) => number;

export const initCamera: (previewSurfaceId: string, previewSurfaceIdSlave: string, videoSurfaceId: string, sceneMode: number, cameraPosition: number) => number;

export const releaseCamera: () => number;

export const takePicture: (rotation: number) => number;

export const saveCurPhoto: () => number;

export const setBufferCb: (callback: (arrayBuffer: ArrayBuffer) => void) => void;

export const setFoldCb: (callback: (foldStatusInfo: camera.FoldStatusInfo) => void) => void;

export const updateRotateForCamera: (rotation: number) => void;

export const getVideoRotation: (deviceDegree: number) => number;

export const startVideoOutput: (videoId: string) => number;

export const stopVideoOutput: () => number;

