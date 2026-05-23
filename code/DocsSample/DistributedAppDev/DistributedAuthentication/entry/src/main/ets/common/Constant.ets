/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

let context = getContext();

interface DistributedFilterOptionListType {
  isOnlineItemList: string[],
  isTrustedItemList: string[],
  authFormItemList: string[],
  rangeItemList: string[]
}

export const DISTRIBUTED_FILTER_OPTION_LIST: DistributedFilterOptionListType = {
  isOnlineItemList: [
    context.resourceManager.getStringSync($r('app.string.no_filter')),
    context.resourceManager.getStringSync($r('app.string.online')),
    context.resourceManager.getStringSync($r('app.string.offline')),
  ],
  isTrustedItemList: [
    context.resourceManager.getStringSync($r('app.string.no_filter')),
    context.resourceManager.getStringSync($r('app.string.credible')),
    context.resourceManager.getStringSync($r('app.string.incredible')),
  ],
  authFormItemList: [
    context.resourceManager.getStringSync($r('app.string.no_filter')),
    context.resourceManager.getStringSync($r('app.string.identical_account')),
    context.resourceManager.getStringSync($r('app.string.across_account')),
    context.resourceManager.getStringSync($r('app.string.no_account')),
  ],
  rangeItemList: [
    context.resourceManager.getStringSync($r('app.string.no_filter')),
    '50',
    '80',
    '100'
  ]
};