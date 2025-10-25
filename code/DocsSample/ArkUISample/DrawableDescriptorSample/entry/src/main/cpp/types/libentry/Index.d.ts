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
import image from '@ohos.multimedia.image';
import resourceManager from '@ohos.resourceManager';

export const createFromPixelMap: (pMap: image.PixelMap) => number;
export const createFromAnimatedPixelMap: (pMap: image.PixelMap, size: number) => void;
export const disposeDrawable: (imagePixelMapId: number) => void;
export const setAnimationDuration: (imagePixelMapId: number, duration: number) => void;
export const getAnimationDuration: (imagePixelMapId: number) => number;
export const setAnimationIteration: (imagePixelMapId: number, iteration: number) => void;
export const getAnimationIteration: (imagePixelMapId: number) => number;
export const createNodePage: (content: Object, resmgr: resourceManager.ResourceManager) =>number;