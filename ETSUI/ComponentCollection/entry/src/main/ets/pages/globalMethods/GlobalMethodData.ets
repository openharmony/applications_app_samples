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
      }
    ]
  }

// The global method categorizes data, second menu data
export const GLOBAL_METHOD_CATEGORIES: ThirdLevelCategory[] = [DIALOG]