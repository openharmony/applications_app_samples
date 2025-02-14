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

export const handleScopeTest: () => string; // napi_open_handle_scope、napi_close_handle_scope

export const handleScope: () => string;

export const escapableHandleScopeTest: () => string; // napi_open_escapable_handle_scope、napi_close_escapable_handle_scope、napi_escape_handle

export const createReference: () => Object | void; // napi_add_finalizer

export const useReference: () => Object | void;

export const deleteReference: () => string | void;