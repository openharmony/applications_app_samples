/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import { image } from "@kit.ImageKit";

export const packToDataPixelMap: (inData: ArrayBufferLike, outPath: string) => number;
export const packPixelMapToFile: (inPath: string, outFD: number) => number;
export const packToFileImageSource: (inFD: number, outFD: number) => number;
export const packToDataImageSource: (inRawFD: number, inFrom: number, inLen: number, outPath: string) => number;
// Picture decoding
export const createPictureByImageSource: (path: string) => number;
export const createDecodingOptions: () => number;
export const getDesiredAuxiliaryPictures: () => number;
export const setDesiredAuxiliaryPictures: (DesiredAuxiliaryPictures: image.AuxiliaryPictureType[]) => number;
export const releaseDecodingOptions: () => number;
// Picture encoding
export const packToDataPicture: (outPath: string) => number;
export const packToFilePicture: (fd: number) => number;
