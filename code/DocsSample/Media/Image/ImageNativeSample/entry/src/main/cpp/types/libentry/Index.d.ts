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
import { image } from "@kit.ImageKit";

interface ImageInfo {
  width: number;
  height: number;
  bufferSize?: number;
  rowStride?: number;
  pixelStride?: number;
  timestamp?: number | bigint;
}
// sourceTest
export const createImageSource: (filePath: string) => number;
export const getImageInfo: () => number;
export const createPixelMap: () => number;
export const getFrameCount: () => number;
export const createPixelmapList: () => number;
export const getDelayTimeList: () => number;
export const releaseImageSource: () => number;
// editExif
export const getImageProperty: (key: string) => string | number;
export const modifyImageProperty: (key: string, value: string) => number;
// decodingPicture
export const setDesiredAuxiliaryPictures: (auxTypeList: image.AuxiliaryPictureType[]) => number;
export const createPictureByImageSource: (filePath: string) => number;
export const releasePictureSource: () => number;
// allocator
export const testStrideWithAllocatorType: (filePath: string) => number;
// packer
export const packToFileFromImageSourceTestJs: (fd: number) => number;
export const packToFileFromPixelmapTestJs: (fd: number) => number;
export const packToDataFromPicture: (format: string) => number;
export const packToFileFromPicture: (fd: number, format: string) => number;
// receiver
export const initImageReceiver: () => number;
export const releaseImageReceiver: () => number;
export const getReceiverImageInfo: () => Promise<ImageInfo | null>;
export const takePhoto: () => number;