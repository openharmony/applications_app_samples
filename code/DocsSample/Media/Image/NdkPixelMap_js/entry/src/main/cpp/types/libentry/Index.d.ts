/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

// [Start ndk_pixelmap_js_export_get_sync_pixelmap]
// [Start ndk_pixelmap_js_import_image]
import { image } from '@kit.ImageKit';
// [End ndk_pixelmap_js_import_image]
import { resourceManager } from '@kit.LocalizationKit';

// 同步调用，入参为资源管理器和图片资源名称，返回PixelMap
export const getSyncPixelMap: (resMgr: resourceManager.ResourceManager, src: string) => image.PixelMap;
// [End ndk_pixelmap_js_export_get_sync_pixelmap]
// [Start ndk_pixelmap_js_export_image_transformation_api]
export const testGetImageInfo: (a: image.PixelMap) => image.PixelMap;

export const testAccessPixels: (a: image.PixelMap) => image.PixelMap;

export const testUnAccessPixels: (a: image.PixelMap) => image.PixelMap;
// [End ndk_pixelmap_js_export_image_transformation_api]

export const createPixelMapTest: () => image.PixelMap;

export const transform: (a: image.PixelMap) => void;

export const EncodeImagesToFile: (a: image.PixelMap) => void;

export const EncodeImagesToBuffer: (a: image.PixelMap) => number;