/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import deviceDialog_concurrency_test from './DeviceDialog.concurrency.test';
import deviceDialog_detail_test from './DeviceDialog.detail.test';
import deviceDialog_test from './DeviceDialog.test';
import eventUtil_concurrency_test from './EventUtil.concurrency.test';
import eventUtil_detail_test from './EventUtil.detail.test';
import eventUtil_test from './EventUtil.test';
import musicConstants_concurrency_test from './MusicConstants.concurrency.test';
import musicConstants_detail_test from './MusicConstants.detail.test';
import musicConstants_test from './MusicConstants.test';
import musicSharedDefinition_concurrency_test from './MusicSharedDefinition.concurrency.test';
import musicSharedDefinition_detail_test from './MusicSharedDefinition.detail.test';
import musicSharedDefinition_test from './MusicSharedDefinition.test';
import pointerUtil_concurrency_test from './PointerUtil.concurrency.test';
import pointerUtil_detail_test from './PointerUtil.detail.test';
import pointerUtil_test from './PointerUtil.test';

export default function commontestTest(): void {
  deviceDialog_concurrency_test();
  deviceDialog_detail_test();
  deviceDialog_test();
  eventUtil_concurrency_test();
  eventUtil_detail_test();
  eventUtil_test();
  musicConstants_concurrency_test();
  musicConstants_detail_test();
  musicConstants_test();
  musicSharedDefinition_concurrency_test();
  musicSharedDefinition_detail_test();
  musicSharedDefinition_test();
  pointerUtil_concurrency_test();
  pointerUtil_detail_test();
  pointerUtil_test();
}
