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
// [Start HttpInterceptor_defining_function_types]
export const AddReadOnlyResponseInterceptor: () => number;
export const RemoveReadOnlyResponseInterceptor: () => number;
export const StartReadOnlyResponseInterceptors: () => number;
export const StopReadOnlyResponseInterceptors: () => number;
export const RemoveAllReadOnlyResponseInterceptors: () => number;
export const AddModifyRequestInterceptor: () => number;
export const RemoveModifyRequestInterceptor: () => number;
export const StartModifyRequestInterceptors: () => number;
export const StopModifyRequestInterceptors: () => number;
export const RemoveAllModifyRequestInterceptors: () => number;
export const AddModifyResponseInterceptor: () => number;
export const RemoveModifyResponseInterceptor: () => number;
export const StartModifyResponseInterceptors: () => number;
export const StopModifyResponseInterceptors: () => number;
export const RemoveAllModifyResponseInterceptors: () => number;
// [End HttpInterceptor_defining_function_types]