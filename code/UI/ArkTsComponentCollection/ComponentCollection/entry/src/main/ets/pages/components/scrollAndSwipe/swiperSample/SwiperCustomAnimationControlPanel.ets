/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { CommonItemSelect, CommonSwitcher } from '../../../../common/AttributeModificationTool';

@Component
export struct CustomAnimationPropertiesControlPanel {
  @Link changeOpacity: boolean;
  @Link changeScale: boolean;
  @Link closeTwoPagesTogether: boolean;
  @Link cancelDefaultTranslate: boolean;
  @Link customAnimationAutoPlay: boolean;
  @Link customAnimationDuration: number;
  @Link customAnimationCurve: string;

  build() {
    Column() {
      CommonSwitcher({
        bool: $changeOpacity,
        name: $r('app.string.swiper_custom_property_opacity'),
        testID: `custom_swiper_001`
      })

      Divider()

      CommonSwitcher({
        bool: $changeScale,
        name: $r('app.string.swiper_custom_property_scale'),
        testID: `custom_swiper_002`
      })

      Divider()

      CommonSwitcher({
        bool: $closeTwoPagesTogether,
        name: $r('app.string.swiper_close_two_pages_together'),
        testID: `custom_swiper_003`
      })

      Divider()

      CommonSwitcher({
        bool: $cancelDefaultTranslate,
        name: $r('app.string.swiper_cancel_default_translate'),
        testID: `custom_swiper_004`
      })

      Divider()

      CommonSwitcher({
        bool: $customAnimationAutoPlay,
        name: $r('app.string.swiper_property_auto_play'),
        testID: `custom_swiper_005`
      })

      Divider()

      CommonItemSelect({
        name: $r('app.string.swiper_properties_duration'),
        selects: ['400', '1000', '2000'],
        callback: (index, str) => {
          this.customAnimationDuration = Number.parseInt(str);
        },
        testId:`custom_swiper_006`
      })

      Divider()

      CommonItemSelect({
        name: $r('app.string.swiper_custom_property_curve'),
        selects: ['Linear', 'Ease', 'FastOutSlowIn', 'Sharp', 'Rhythm', 'Smooth', 'Friction'],
        callback: (index, str) => {
          this.customAnimationCurve = str;
        },
        testId:`custom_swiper_007`
      })
    }
  }
}