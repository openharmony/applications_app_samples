/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

export const createNativeSwiperNode: (content: Object) =>void;
export const createNativeTextNode: (content: Object) =>void;
export const createNativeNodexc: (content: Object, tag: string) => void;
export const createNativeAccessibilityNode: (content: Object) => void;
export const createNativeEmbeddedComponentNode: (content: Object) => void;
export const createAnimationCenter: (content: Object) => void;
export const createAnimationOpacity: (content: Object) => void;
export const createAnimationTranslate: (content: Object) => void;
export const createAnimationFit: (content: Object) => void;
export const createAnimationGeometry: (content: Object) => void;
export const createVisualEffectsScale: (content: Object) => void;
export const createVisualEffectsBlur: (content: Object) => void;
export const createVisualEffectsShape: (content: Object) => void;
export const destroyNativeRoot: () => void;
export const createWaterFlowNativeNode: (content: Object) => void;
export const createGridNativeNode: (content: Object) => void;
export const createScrollNativeNode: (content: Object) => void;
export const createRefreshNativeNode: (content: Object) => void;
export const createListNativeNode: (content: Object) => void;
export const createNativeCheckboxShapePage: (content: Object, type: number) => void;
export const createHoverModeAreaTypePage: (content: Object, type: number) => void;
export const createNativeButtonNode: (content: Object, type: number) => void;
export const createNativeSliderNode: (content: Object, sliderBlockStyle: number, sliderDirection: number, sliderStyle: number) => void;
export const createPublicNativeNode: (content: Object) => void;
export const createProgress: () =>void;
export const createTextPickerWithCustomContent: (type: number) =>void;
export const setProgressType: (type: number) =>void;
export const setProgressValue: (value: number) =>void;
export const createDatePicker: (type: number) =>void;
export const createCalendarPicker: (type: number) =>void;
export const createImageSize: (fit: number, size: number) =>void;
export const setImageProperties: (repeat: number, interpolation: number, mode: number) =>void;
export const setProgressLinearStyleOption: (scanEffect: boolean,
  smoothEffect: boolean, strokeWidth: number, strokeRadius: number) =>void;
export const createImageAnimatorFromDrawableDescriptor: (width: number,
  height: number, top: number, left: number, duration: number) =>void;
export const createImageAnimatorFromString: (width: number,
  height: number, top: number, left: number, duration: number) =>void;
export const getProgressLinearStyleOptionAndDestroy: () =>string;
export const getImageAnimatorFrameInfo: () =>string;
export const setContentHandle: (content: Object) =>void;
export const setUpTextCrossLanguage: (isCross: boolean) =>void;
export const clearNodes: () =>void;
export const createGridNativeNodeOnGetRectByIndex: (content: Object) => void;
export const createGridNativeNodeIrregularIndexes: (content: Object) => void;
export const createContainerNativeNode: (content: Object) => void;