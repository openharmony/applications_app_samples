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

import { ThirdLevelCategory } from '../../model/CategoricalDataType'

const AUXILIARY: ThirdLevelCategory =
  {
    image: $r('app.media.ic_auxiliary'),
    title: $r('app.string.auxiliary'),
    childNodes: [
      {
        title: $r('app.string.auxiliary_badge'),
        url: 'pages/components/auxiliary/badgeSample/BadgeSample'
      },
      {
        title: $r('app.string.scroll_bar'),
        url: 'pages/components/auxiliary/scrollbarSample/ScrollBarSample'
      },
      {
        title: $r('app.string.auxiliary_refresh'),
        url: 'pages/components/auxiliary/refreshSample/RefreshSample'
      },
      {
        title: $r('app.string.auxiliary_panel'),
        url: 'pages/components/auxiliary/panelSample/PanelSample'
      },
      {
        title: $r('app.string.auxiliary_alphabetIndexer'),
        url: 'pages/components/auxiliary/alphabetIndexerSample/AlphabetIndexerSample'
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
      },
      {
        title: $r('app.string.checkbox_checkboxgroup'),
        url: 'pages/components/buttonAndSelection/checkboxSample/CheckboxSample'
      },
      {
        title: $r('app.string.text_picker'),
        url: 'pages/components/buttonAndSelection/textPickerSample/TextPickerSample'
      },
      {
        title: $r('app.string.time_picker'),
        url: 'pages/components/buttonAndSelection/timePickerSample/TimePickerSample'
      },
      {
        title: $r('app.string.counter_name'),
        url: 'pages/components/buttonAndSelection/counterSample/CounterSample'
      },
      {
        title: $r('app.string.rating_name'),
        url: 'pages/components/buttonAndSelection/ratingSample/RatingSample'
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
      },
      {
        title: $r('app.string.loading_progress'),
        url: 'pages/components/informationPresentationAndDynamicEffects/loadingProgressSample/LoadingProgressSample'
      },
      {
        title: $r('app.string.marquee_name'),
        url: 'pages/components/informationPresentationAndDynamicEffects/marqueeSample/MarqueeSample'
      },
      {
        title: $r('app.string.text_timer'),
        url: 'pages/components/informationPresentationAndDynamicEffects/textTimerSample/TextTimerSample'
      },
      {
        title: $r('app.string.text_clock'),
        url: 'pages/components/informationPresentationAndDynamicEffects/textclockSample/TextClockSample'
      },
      {
        title: $r('app.string.progress_name'),
        url: 'pages/components/informationPresentationAndDynamicEffects/progressSample/ProgressSample'
      },
      {
        title: $r('app.string.gauge_name'),
        url: 'pages/components/informationPresentationAndDynamicEffects/gaugeSample/GaugeSample'
      },
      {
        title: $r('app.string.data_panel'),
        url: 'pages/components/informationPresentationAndDynamicEffects/dataPanelSample/DataPanelSample'
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
      },
      {
        title: $r('app.string.rich_text'),
        url: 'pages/components/textAndInput/richTextSample/RichTextSample'
      }
    ]
  }

const SCOLL_SWIPE: ThirdLevelCategory =
  {
    image: $r('app.media.ic_blank_and_divider'),
    title: $r('app.string.scroll_swiper'),
    childNodes: [
      {
        title: $r('app.string.scroll_name'),
        url: 'pages/components/scrollAndSwipe/scrollSample/ScrollSample'
      },
      {
        title: $r('app.string.swiper_name'),
        url: 'pages/components/scrollAndSwipe/swipeSample/SwipeSample'
      }
    ]
  }

export const COMPONENT_CATEGORIES: ThirdLevelCategory[] =
  [
    BLANK_AND_DIVIDER,
    BUTTON_AND_SELECTION,
    SCOLL_SWIPE,
    INFORMATION_PRESENTATION_AND_DYNAMIC_EFFECTS,
    TEXT_AND_INPUT,
    AUXILIARY
  ]
// 辅助/AlphabetIndexerSampleData
export let alphabetIndexerDataB: Resource[] = [$r('app.string.alphabetindexer_bu'), $r('app.string.alphabetindexer_bai'), $r('app.string.alphabetindexer_bao'), $r('app.string.alphabetindexer_bi'), $r('app.string.alphabetindexer_bing')]

export let alphabetIndexerDataC: Resource[] = [$r('app.string.alphabetindexer_cao'), $r('app.string.alphabetindexer_cheng'), $r('app.string.alphabetindexer_chen'), $r('app.string.alphabetindexer_cui')]

export let alphabetIndexerDataL: Resource[] = [$r('app.string.alphabetindexer_liu'), $r('app.string.alphabetindexer_li'), $r('app.string.alphabetindexer_lou'), $r('app.string.alphabetindexer_liang'), $r('app.string.alphabetindexer_lei'), $r('app.string.alphabetindexer_lv'), $r('app.string.alphabetindexer_liu3'), $r('app.string.alphabetindexer_lu')]

export let letterValue: string[] = ['#', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
  'H', 'I', 'J', 'K', 'L', 'M', 'N',
  'O', 'P', 'Q', 'R', 'S', 'T', 'U',
  'V', 'W', 'X', 'Y', 'Z']
// 辅助/panerSampleData
export let fruitArray: Resource[] = [$r('app.string.checkbox_apple'), $r('app.string.checkbox_banbana'), $r('app.string.checkbox_cherries'), $r('app.string.checkbox_durian')]

// 信息展示与动效/dataPanelSample
export let panelData: number[] = [10, 10, 30, 10, 10, 20]
// 文本与输入/span
export let selectData: Resource[] = [$r('app.string.span_decoration_none'), $r('app.string.span_decoration_linethrough'), $r('app.string.span_decoration_underline'), $r('app.string.span_decoration_overline')]