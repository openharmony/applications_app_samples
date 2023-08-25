/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { CommonItemSlider, CommonItemSelect, CommonSwitcher } from '../../../../common/AttributeModificationTool';

@Component
export struct PropertiesControlPanel {
  @Link isDisableSwipe: boolean;
  @Link itemSpace: number;
  @Link isVertical: boolean;
  @Link duration: number;
  @Link loop: boolean;
  @Link autoPlay: boolean;
  @Link interval: number;
  @Link nextMarginLength: number;
  @Link prevMarginLength: number;

  build() {
    Column() {
      CommonSwitcher({
        bool: $isDisableSwipe,
        name: $r('app.string.swiper_properties_disable_swipe'),
        testID: `swiper_001`
      })

      CommonSwitcher({
        bool: $isVertical,
        name: $r('app.string.swiper_properties_vertical'),
        testID: `swiper_002`
      })

      CommonSwitcher({
        name: $r('app.string.swiper_properties_loop'),
        bool: $loop,
        testID: `swiper_003`
      })

      CommonSwitcher({
        name: $r('app.string.swiper_properties_auto_play'),
        bool: $autoPlay,
        testID: `swiper_004`
      })

      CommonItemSlider({
        changeValue: $itemSpace,
        name: $r('app.string.swiper_properties_item_space'),
        min: 100,
        max: 300,
        step: 100,
        testId:"swiper_005"
      })

      CommonItemSlider({
        changeValue: $nextMarginLength,
        min: 0,
        max: 50,
        name: $r('app.string.swiper_next_margin'),
        testId:"swiper_008"
      })

      CommonItemSlider({
        changeValue: $prevMarginLength,
        min: 0,
        max: 50,
        name: $r('app.string.swiper_previous_margin'),
        testId:"swiper_009"
      })

      CommonItemSelect({
        name: $r('app.string.swiper_properties_duration'),
        selects: ['400', '1000', '2000'],
        callback: (index, str) => {
          this.duration = parseInt(str)
        },
        testId:`swiper_006`
      })

      CommonItemSelect({
        name: $r('app.string.swiper_properties_interval'),
        selects: ['1000', '2000', '3000'],
        callback: (index, str) => {
          this.interval = parseInt(str)
        },
        testId:`swiper_007`
      })
    }
  }
}