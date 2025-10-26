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



export interface NapiCallback {
  fromNapiCallWithStringParam(value: string):void;
}
export const setNapiCallback: (callback: NapiCallback) => void;
export const setCustomDialog: (nodeType: number, nodeValue: number) => number;
export const Close: () => void;
export const CloseCustomDialog: () => void;
export const openCustomDialog: () => void;
export const setNativeDialog: (nodeType: number, nodeValue: number) => number;
export const openNativeDialog: () => void;
export const resetDialogController: () => void;
export const mainPageController: (node: NodeContent) => void;
export const mainPageOption: (node: NodeContent) => void;
export const mainPageLifecycle: (node: NodeContent) => void;
export const disposeController: () => void;
export const disposeOption: () => void;
export const disposeLifecycle: () => void;