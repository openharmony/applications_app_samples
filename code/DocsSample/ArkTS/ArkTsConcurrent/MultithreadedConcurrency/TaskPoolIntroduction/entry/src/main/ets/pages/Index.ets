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

// [StartExclude main_page]
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
        Text(resource.resourceToString($r('app.string.Task_pool')))
          .padding('15vp')
          .width('100%')
          .fontSize('25fp')
          .textAlign(TextAlign.Center)
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Notes')),
          buttonUrl: 'managers/notes'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Instruction')),
          buttonUrl: 'managers/instruction'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.General_use')),
          buttonUrl: 'managers/generaluse'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Return_promise')),
          buttonUrl: 'managers/returnpromise'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Custom_classes')),
          buttonUrl: 'managers/customclasses'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Asynchronous_functions')),
          buttonUrl: 'managers/asynchronousfunctions'
        });
      }
      .padding('20vp')
      .width('100%')
    }.margin({ bottom: 60 })
    .width('100%')
  }
}
// [EndExclude main_page]
