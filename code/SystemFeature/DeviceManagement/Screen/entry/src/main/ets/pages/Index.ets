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
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import { DisplayDevice } from '../common/DisplayDevice';
import Logger from '../model/Logger';

const TAG: string = 'IndexPage';

@Entry
@Component
struct Index {
  aboutToAppear(){
    try {
      let mainContext: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('mainContext');
      mainContext!.resourceManager.getStringValue($r('app.string.yes').id).then((value: string) => {
        AppStorage.setOrCreate('yes', value);
        Logger.info(TAG, "getStringValue value" + value);
      }).catch((error: BusinessError) => {
        Logger.info(TAG, "getStringValue promise error is " + error);
      });

      mainContext!.resourceManager.getStringValue($r('app.string.no').id).then((value: string) => {
        AppStorage.setOrCreate('no', value);
        Logger.info(TAG, "getStringValue value " + value);
      }).catch((error: BusinessError) => {
        Logger.info(TAG, "getStringValue promise error is " + error);
      });
    } catch (error) {
      Logger.error(TAG, `callback getStringValue failed, error code: ${error.code}, message: ${error.message}.`)
    }
  }
  build() {
    Column() {
      DisplayDevice()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F1F1')
  }
}
