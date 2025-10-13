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
// [Start native-bundle-guidelines_001]
export const add: (a: number, b: number) => number;
export const getCurrentApplicationInfo: () => object;   // 新增暴露方法 getCurrentApplicationInfo
export const getAppId: () => string;                    // 新增暴露方法 getAppId
export const getAppIdentifier: () => string;            // 新增暴露方法 getAppIdentifier
export const getMainElementName: () => object;          // 新增暴露方法 getMainElementName
export const getCompatibleDeviceType: () => string;     // 新增暴露方法 getCompatibleDeviceType
export const isDebugMode: () => string;                 // 新增暴露方法 isDebugMode
export const getModuleMetadata: () => object;           // 新增暴露方法 getModuleMetadata


