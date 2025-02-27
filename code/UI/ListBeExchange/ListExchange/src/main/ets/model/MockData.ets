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

import { ListInfo } from './ListInfo';

// Mock数据
export const MEMO_DATA: ListInfo[] = [
  new ListInfo($r('app.media.list_exchange_ic_public_cards_filled'), '账户余额'),
  new ListInfo($r('app.media.list_exchange_ic_public_cards_filled2'), 'xx银行储蓄卡（1234）'),
  new ListInfo($r('app.media.list_exchange_ic_public_cards_filled3'), 'xx银行储蓄卡（1238）'),
  new ListInfo($r('app.media.list_exchange_ic_public_cards_filled4'), 'xx银行储蓄卡（1236）')
];