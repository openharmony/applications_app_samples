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

export const createSubscribeInfo: () => boolean;
export const destroySubscribeInfo: () => boolean;
export const createSubscriber: () => boolean;
export const destroySubscriber: () => boolean;
export const subscribe: () => boolean;
export const unsubscribe: () => boolean;
export const publish: () => boolean;
export const publishWithInfo: () => boolean;
export const abortCommonEvent: () => boolean;
export const clearAbortCommonEvent: () => boolean;

export const getSubscribeInfoState: () => boolean;
export const getSubscriberState: () => boolean;
export const getSubscribeState: () => boolean;
export const getPublishedEvents: () => string[];
export const clearAllStates: () => boolean;
export const setPublishInfo: () => boolean;
export const destroyPublishInfo: () => boolean;
export const getParameters: () => boolean;
export const setToSubscriber: () => boolean;
export const getFromSubscriber: () => boolean;