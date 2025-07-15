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
        Text(resource.resourceToString($r('app.string.Practical_cases')))
          .padding('15vp')
          .width('100%')
          .fontSize('25fp')
          .textAlign(TextAlign.Center)
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Using_taskpool')),
          buttonUrl: 'managers/UsingTaskPool'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Using_sendable')),
          buttonUrl: 'managers/UsingSendable'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Complex_class_instance_object_using_sendable')),
          buttonUrl: 'managers/ComplexClassInstanceObjectUsingSendable'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Concurrent_loading_modules_guide')),
          buttonUrl: 'managers/ConcurrentLoadingModulesGuide'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Global_configuration_guide')),
          buttonUrl: 'managers/GlobalConfigurationGuide'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Makeobserved_sendable')),
          buttonUrl: 'managers/MakeobservedSendable'
        });
        CommonButton({
          buttonName: resource.resourceToString($r('app.string.Waterfall_rendering')),
          buttonUrl: 'managers/WaterfallRendering'
        });
      }
      .padding('20vp')
      .width('100%')
    }.margin({ bottom: 60 })
    .width('100%')
  }
}