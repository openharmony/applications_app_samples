/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { SecondLevelCategory, ThirdLevelCategory } from '../../model/CategoricalDataType'

const GRAPHIC_TRANSFORMATION: ThirdLevelCategory[] =
  [
    {
      image: $r('app.media.ic_prop_background'),
      title: $r('app.string.prop_background'),
      url: 'pages/universal/properties/backgroundSample/BackgroundSample'
    },
    {
      image: $r('app.media.ic_prop_border'),
      title: $r('app.string.prop_border'),
      url: 'pages/universal/properties/borderSample/BorderSample'
    },
    {
      image: $r('app.media.ic_prop_font'),
      title: $r('app.string.prop_font'),
      url: 'pages/universal/properties/fontSample/FontSample'
    },
    {
      image: $r('app.media.ic_prop_size'),
      title: $r('app.string.prop_size'),
      url: 'pages/universal/properties/sizeSample/SizeSample'
    },
    {
      image: $r('app.media.ic_graphic_transformation'),
      title: $r('app.string.graphic_transformation'),
      childNodes: [
        {
          title: $r('app.string.graphic_transformation_rotate'),
          url: 'pages/universal/properties/rotateSample/RotateSample'
        },
        {
          title: $r('app.string.graphic_transformation_translate'),
          url: 'pages/universal/properties/translateSample/TranslateSample'
        }
      ]
    },
    {
      image: $r('app.media.ic_display'),
      title: $r('app.string.components_display'),
      url: "pages/universal/properties/displaySample/DisplaySample"
    },
    {
      image: $r('app.media.ic_interaction'),
      title: $r('app.string.components_interaction'),
      url: "pages/universal/properties/interactionSample/InteractionSample"
    },
    {
      image: $r('app.media.ic_image_effects'),
      title: $r('app.string.components_effects'),
      url: "pages/universal/properties/effectsSample/EffectsSample"
    }
  ]

const COMMON_EVENTS: ThirdLevelCategory[] =
  [
    {
      image: $r('app.media.ic_click_event'),
      title: $r('app.string.click_event'),
      url: 'pages/universal/events/clickEventSample/ClickEventSample'
    },
    {
      image: $r('app.media.ic_event_touch'),
      title: $r('app.string.touch_event'),
      url: 'pages/universal/events/touchEventSample/TouchEventSample'
    },
    {
      image: $r('app.media.ic_event_area_change'),
      title: $r('app.string.component_area_change_event'),
      url: 'pages/universal/events/areaChangeEventSample/AreaChangeEventSample'
    }
  ]

// Generic categorical data, second menu data
export const UNIVERSAL_CATEGORIES: SecondLevelCategory[] =
  [
    { title: $r('app.string.common_events'), childNodes: COMMON_EVENTS },
    { title: $r('app.string.common_properties'), childNodes: GRAPHIC_TRANSFORMATION }
  ]

// univesal/properties/DisplaySample
export let locationTypes: { value: Resource }[] =
  [
    { value: $r('app.string.components_display_center') },
    { value: $r('app.string.components_display_topstart') },
    { value: $r('app.string.components_display_topend') },
    { value: $r('app.string.components_display_top') },
    { value: $r('app.string.components_display_start') },
    { value: $r('app.string.components_display_end') },
    { value: $r('app.string.components_display_bottomstart') },
    { value: $r('app.string.components_display_bottom') },
    { value: $r('app.string.components_display_bottomend') }
  ]

export let visibileTypes: { value: Resource }[] =
  [
    { value: $r('app.string.components_display_visible') },
    { value: $r('app.string.components_display_hidden') },
    { value: $r('app.string.components_display_none') },
  ]

// univesal/properties/InteractionSample
export let placementsNameData = ['TopLeft', 'Top', 'TopRight', 'RightTop', 'Right', 'RightBottom', 'LeftTop', 'Left', 'LeftBottom', 'BottomLeft', 'Bottom', 'BottomRight']
export let hitTestModeNameData = ['Default', 'Block', 'Transparent', 'None']
export let hoverEffectNameData = ['None', 'Highlight', 'Auto', 'Scale']