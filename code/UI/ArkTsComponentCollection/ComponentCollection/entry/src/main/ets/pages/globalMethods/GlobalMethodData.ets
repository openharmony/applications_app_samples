/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

const DIALOG: ThirdLevelCategory =
  {
    image: $r('app.media.ic_dialog'),
    title: $r('app.string.dialog'),
    childNodes: [
      {
        title: $r('app.string.alert_dialog'),
        url: 'pages/globalMethods/dialogs/alertDialogSample/AlertDialogSample'
      },
      {
        title: $r('app.string.custom_dialog'),
        url: 'pages/globalMethods/dialogs/customDialogSample/CustomDialogSample'
      },
      {
        title: $r('app.string.date_picker_dialog'),
        url: 'pages/globalMethods/dialogs/dateDialogSample/DateDialogSample'
      },
      {
        title: $r('app.string.time_picker_dialog'),
        url: 'pages/globalMethods/dialogs/timeDialogSample/TimeDialogSample'
      },
      {
        title: $r('app.string.action_sheet_dialog'),
        url: 'pages/globalMethods/dialogs/actionSheetDialogSample/ActionSheetDialogSample'
      },
      {
        title: $r('app.string.text_picker_dialog'),
        url: 'pages/globalMethods/dialogs/textPickerDialogSample/TextPickerDialogSample'
      }
    ]
  }

const MENU: ThirdLevelCategory =
  {
    image: $r('app.media.ic_global_menu'),
    title: $r('app.string.global_menu'),
    url: 'pages/globalMethods/dialogs/menuSample/MenuSample',
  }

const BINDSHEET: ThirdLevelCategory =
  {
    image: $r('app.media.ic_bindSheet'),
    title: $r('app.string.global_bindSheet_menu'),
    url: 'pages/globalMethods/dialogs/bindSheetSample/BindSheetSample',
  }

const POPUP: ThirdLevelCategory =
  {
    image: $r('app.media.ic_popUp'),
    title: $r('app.string.global_popUp_menu'),
    url: 'pages/globalMethods/dialogs/popUpSample/PopUpSample',
  }

// The global method categorizes data, second menu data
export const GLOBAL_METHOD_CATEGORIES: ThirdLevelCategory[] = [DIALOG,MENU, BINDSHEET, POPUP]