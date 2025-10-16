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

export { addAsset } from './add';
export { removeAsset } from './remove';
export { updateAsset } from './update';
export { queryAssetPlaintext, queryAssetAttribute, queryBatchAssetAttributes } from './query';
export { addUserAuthAsset } from './add_auth';
export { removeUserAuthAsset } from './remove_auth';
export { queryUserAuthAsset } from './query_auth';
export { addGroupAsset } from './add_group';
export { removeGroupAsset } from './remove_group';
export { updateGroupAsset } from './update_group';
export { queryGroupAssetPlaintext, queryGroupAssetAttribute } from './query_group';
export { addSyncAsset, querySyncResult } from './sync';