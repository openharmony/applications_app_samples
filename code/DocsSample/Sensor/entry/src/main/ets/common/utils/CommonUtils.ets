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

import Logger from './Logger';
import CommonConstants from '../constants/CommonConstants';

/**
 * This is a pop-up window tool class, which is used to encapsulate dialog code.
 * Developers can directly invoke the methods in.
 */
export class CommonUtils {
  textPickerDialog(sensorItems: string[], sensorNameCallback: (sensorName: string) => void) {
    TextPickerDialog.show({
      range: sensorItems,
      selected: 0,
      onAccept: (result: TextPickerResult) => {
        sensorNameCallback(result.value.toString());
        Logger.info(CommonConstants.MY_TAG, result.value.toString());
      },
      onCancel: () => {
        Logger.info(CommonConstants.MY_TAG, 'TextPickerDialog onCancel');
      }
    });
  }
}

export default new CommonUtils();