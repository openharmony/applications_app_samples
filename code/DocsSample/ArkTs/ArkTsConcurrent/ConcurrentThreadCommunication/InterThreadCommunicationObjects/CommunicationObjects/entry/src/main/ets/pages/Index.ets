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

// [Start pass_obj_example]
import { CommonButton } from '../util/CommonButton';
import resource from '../util/resource';

@Entry
@Component
struct Index {
  aboutToAppear() {
  }

  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        Text(resource.resourceToString($r('app.string.Communication_Objects')))
          .padding('15vp')
          .width('100%')
          .fontSize('25fp')
          .textAlign(TextAlign.Center)
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Normal_Object')),
          buttonUrl: 'managers/NormalObject'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.ArrayBuffer_Object')),
          buttonUrl: 'managers/ArrayBufferObject'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.SharedArrayBuffer_Object')),
          buttonUrl: 'managers/SharedArrayBufferObject'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Transferabled_Object')),
          buttonUrl: 'managers/TransferabledObject'
        });
      }
      .padding('20vp')
      .width('100%')
    }.margin({ bottom: 60 })
    .width('100%')
  }
}
// [End pass_obj_example]
