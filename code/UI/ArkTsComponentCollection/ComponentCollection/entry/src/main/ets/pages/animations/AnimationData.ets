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
      },
      {
        title: $r('app.string.Multiplex_interface'),
        url: 'pages/animations/TransitionAnimations/multiplexSample/MultiplexSample',
      },
      {
        title: $r('app.string.Floating_window'),
        url: 'pages/animations/TransitionAnimations/floatingSample/FloatingWindowSample',
      },
      {
        title: $r('app.string.Folder_expansion'),
        url: 'pages/animations/TransitionAnimations/folderSample/FolderSample',
      },
      {
        title: $r('app.string.System_icon'),
        url: 'pages/animations/TransitionAnimations/systemIcon/SystemIcon',
      },
      {
        title: $r('app.string.Shop_card_expansion'),
        url: 'pages/animations/TransitionAnimations/shopSample/ShopCardSample',
      },
      {
        title: $r('app.string.Gallery_card_expansion'),
        url: 'pages/animations/TransitionAnimations/gallerySample/GalleryCardSample',
      },
      {
        title: $r('app.string.component_transition'),
        url: 'pages/animations/TransitionAnimations/componentTransitionSample/ComponentTransitionSample',
      },
      {
        title: $r('app.string.layout_animation_expansion'),
        url: 'pages/animations/TransitionAnimations/layoutAnimationSample/LayoutAnimationSample',
      },
      {
        title: $r('app.string.size_transition_expansion'),
        url: 'pages/animations/TransitionAnimations/sizeTransitionSample/SizeTransitionSample',
      },
      {
        title: $r('app.string.side_bar_effects_title'),
        url: 'pages/animations/TransitionAnimations/sideBarTransitionSample/SideBarTransitionSample',
      }
    ]
  }

const INTERPOLATION_CALCULATION: ThirdLevelCategory =
  {
    image: $r('app.media.ic_interpolation_calculation'),
    title: $r('app.string.interpolation_calculation'),
    url: 'pages/animations/interpolationCalculationSample/InterpolationCalculationSample',
  }

const ANIMATE_TO: ThirdLevelCategory =
  {
    image: $r('app.media.ic_animations_animateto'),
    title: $r('app.string.animate_to'),
    url: 'pages/animations/animateToSample/AnimateToSample'
  }

const ANIMATION_ATTRIBUTE: ThirdLevelCategory =
  {
    image: $r('app.media.ic_animations_animation'),
    title: $r('app.string.attribute_animation'),
    url: 'pages/animations/animationSample/AnimationSample'
  }

const MOTION_PATH: ThirdLevelCategory =
  {
    image: $r('app.media.ic_animations_path'),
    title: $r('app.string.motion_path'),
    url: 'pages/animations/motionPathSample/MotionPathSample'
  }

// Animated classification data, second menu data
export const ANIMATION_CATEGORIES: ThirdLevelCategory[] = [TRANSITION_ANIMATION, INTERPOLATION_CALCULATION, ANIMATE_TO, ANIMATION_ATTRIBUTE, MOTION_PATH]