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
import { lang, collections } from '@kit.ArkTS';
import { Layout } from 'entry/ets/turbotrans_JSON/layout';
import { Serializable, SerialName } from '@hadss/turbo-trans-core';

// [Start tranferabledObject_SendableLayout_toOrigin]
@Sendable
export class SendableLayout implements lang.ISendable {
  public type: string = '';
  public arr: collections.Array<number> = new collections.Array();

  toOrigin(): Layout {
    const origin = new Layout();
    origin.type = this.type;
    origin.arr = new Array(...this.arr);
    return origin;
  }
// [End tranferabledObject_SendableLayout_toOrigin]
}
