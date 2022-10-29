/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { ThirdLevelCategory } from '../../model/CategoricalDataType'

const TRANSITION_ANIMATION: ThirdLevelCategory =
  {
    image: $r('app.media.ic_transition_animation'),
    title: $r('app.string.transition_animation'),
    childNodes: [
      {
        title: $r('app.string.page_transition'),
        url: 'pages/animations/TransitionAnimations/pageTransitionSample/PageTransitionSample'
      },
      {
        title: $r('app.string.share_element_transition'),
        url: 'pages/animations/TransitionAnimations/shareElementTransitionSample/ShareElementTransitionSample'
      }
    ]
  }

const INTERPOLATION_CALCULATION: ThirdLevelCategory =
  {
    image: $r('app.media.ic_interpolation_calculation'),
    title: $r('app.string.interpolation_calculation'),
    url: 'pages/animations/interpolationCalculationSample/InterpolationCalculationSample',
  }

// Animated classification data, second menu data
export const ANIMATION_CATEGORIES: ThirdLevelCategory[] = [TRANSITION_ANIMATION, INTERPOLATION_CALCULATION]