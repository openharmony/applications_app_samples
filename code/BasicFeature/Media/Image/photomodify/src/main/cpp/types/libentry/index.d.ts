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

import image from "@ohos.multimedia.image";

export const CreateDecodingOptions: () => image.DecodingOptions;
export const CreateFromUri: (uri: string) => image.ImageSource;
export const CreateFromFd: (fd: number) => image.ImageSource;
export const CreateFromData: (buf: ArrayBufferLike) => image.ImageSource;
export const CreateFromRawFile: (fd: number, offset: number, length: number) => image.ImageSource;
export const CreatePixelMap: (source: image.ImageSource, options: image.DecodingOptions) => image.PixelMap;

export const CreatePackingOptions: () => image.PackingOption;
export const PackingOptionsSetMimeType: (packing:image.PackingOption, mimeType:String) => number;
export const PackingOptionsSetQuality: (packing:image.PackingOption, mimeType:number) => number;
export const PackerCreate: () => image.ImagePacker;
export const PackToDataFromImageSource: (packer:image.ImagePacker, packing:image.PackingOption,
                                         source: image.ImageSource, buffer:ArrayBuffer) => number;
export const PackToDataFromPixelMap: (packer:image.ImagePacker, packing:image.PackingOption,
                                      source: image.PixelMap | number, buffer:ArrayBuffer) => number;
export const PackToFileFromImageSource: (packer:image.ImagePacker, packing:image.PackingOption,
                                         source: image.ImageSource, fd:number) => number;
export const PackToFileFromPixelMap: (packer:image.ImagePacker, packing:image.PackingOption,
                                      source: image.PixelMap | number, fd:number) => number;
