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

const AUXILIARY: ThirdLevelCategory =
  {
    image: $r('app.media.ic_auxiliary'),
    title: $r('app.string.auxiliary'),
    childNodes: [
      {
        title: $r('app.string.auxiliary_badge'),
        url: 'pages/components/auxiliary/badgeSample/BadgeSample'
      }
    ]
  }

const BUTTON_AND_SELECTION: ThirdLevelCategory =
  {
    image: $r('app.media.ic_button_and_selection'),
    title: $r('app.string.button_and_selection'),
    childNodes: [
      {
        title: $r('app.string.button_title'),
        url: 'pages/components/buttonAndSelection/buttonSample/ButtonSample'
      },
      {
        title: $r('app.string.date_picker_title'),
        url: 'pages/components/buttonAndSelection/datePickerSample/DatePickerSample'
      },
      {
        title: $r('app.string.radio_title'),
        url: 'pages/components/buttonAndSelection/radioSample/RadioSample'
      },
      {
        title: $r('app.string.select_title'),
        url: 'pages/components/buttonAndSelection/selectSample/SelectSample'
      },
      {
        title: $r('app.string.slider_title'),
        url: 'pages/components/buttonAndSelection/sliderSample/SliderSample'
      },
      {
        title: $r('app.string.toggle_title'),
        url: 'pages/components/buttonAndSelection/toggleSample/ToggleSample'
      }
    ]
  }

const BLANK_AND_DIVIDER: ThirdLevelCategory =
  {
    image: $r('app.media.ic_blank_and_divider'),
    title: $r('app.string.blank_and_divider'),
    childNodes: [
      {
        title: $r('app.string.divider_title'),
        url: 'pages/components/blankAndDivider/dividerSample/DividerSample'
      }
    ]
  }

const INFORMATION_PRESENTATION_AND_DYNAMIC_EFFECTS: ThirdLevelCategory =
  {
    image: $r('app.media.ic_information_presentation_and_dynamic_effects'),
    title: $r('app.string.information_presentation_and_dynamic_effects'),
    childNodes: [
      {
        title: $r('app.string.qrcode_title'),
        url: 'pages/components/informationPresentationAndDynamicEffects/qrCodeSample/QRCodeSample'
      }
    ]
  }

const TEXT_AND_INPUT: ThirdLevelCategory =
  {
    image: $r('app.media.ic_text_and_input'),
    title: $r('app.string.text_and_input'),
    childNodes: [
      {
        title: $r('app.string.span_title'),
        url: 'pages/components/textAndInput/spanSample/SpanSample'
      },
      {
        title: $r('app.string.text_input_title'),
        url: 'pages/components/textAndInput/textInputSample/TextInputSample',
      },
      {
        title: $r('app.string.text_title'),
        url: 'pages/components/textAndInput/textSample/TextSample'
      }
    ]
  }

export const COMPONENT_CATEGORIES: ThirdLevelCategory[] =
  [
    BLANK_AND_DIVIDER,
    BUTTON_AND_SELECTION,
    INFORMATION_PRESENTATION_AND_DYNAMIC_EFFECTS,
    TEXT_AND_INPUT,
    AUXILIARY
  ]