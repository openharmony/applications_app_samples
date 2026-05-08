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
// [Start transferableObject_Layout]
import { Serializable, SerialName } from '@hadss/turbo-trans-core';
// [StartExclude transferableObject_Layout]
import { collections } from '@kit.ArkTS';
// [EndExclude transferableObject_Layout]

@Serializable({ generateSendable: true})
export class Layout {
  @SerialName({ name: 'type'})
  public type: string = '';
  @SerialName({ name: 'arr'})
  public arr: number[] = [];
}
// [End transferableObject_Layout]

@Sendable
export class LayoutS {
  public type: string = '';
  public arr: collections.Array<number> = new collections.Array();
}