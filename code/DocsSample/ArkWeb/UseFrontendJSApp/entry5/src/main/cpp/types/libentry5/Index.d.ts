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

// [Start the_arkts_interface_is_exposed_on_the_node_api_side]
export const nativeWebInit: (webName: string) => void;
export const createWebMessagePorts: (webName: string) => void;
export const postMessage: (webName: string) => void;
export const postNoneMessage: (webName: string) => void;
export const setMessageEventHandler: (webName: string) => void;
export const closeMessagePort: (webName: string) => void;
export const destroyMessagePort: (webName: string) => void;
export const postBufferMessage: (webName: string) => void;
export const destroyNullMessagePort: (webName: string) => void;
export const setMessageEventHandlerThread: (webName: string) => void;
export const postMessageThread: (webName: string) => void;
// [End the_arkts_interface_is_exposed_on_the_node_api_side]