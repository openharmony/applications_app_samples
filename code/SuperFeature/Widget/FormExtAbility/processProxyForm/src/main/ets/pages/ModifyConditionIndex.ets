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

import formProvider from '@ohos.app.form.formProvider';
import formBindingData from '@ohos.app.form.formBindingData';
import formHost from '@ohos.app.form.formHost';
import Logger from '../../common/Logger';

const TAG = '[Sample_ModifyConditionIndex]';
let conditionID = '110000';

function updateCardDisplayContent(runningFormInfo): void {
  Logger.info(TAG, `updateCardDisplayContent bundle: ${runningFormInfo.bundleName}`);
  let proxies = [
    {
      'key': 'cityName',
      'subscriberId': conditionID
    },
    {
      'key': 'cityTemperature',
      'subscriberId': conditionID
    }
  ];
  let formBinding = formBindingData.createFormBindingData();
  formBinding['proxies'] = proxies;
  formProvider.updateForm(runningFormInfo.formId, formBinding).then(() => {
    Logger.info(TAG, `update Form OK formData is ${JSON.stringify(formBinding)}`);
  }).catch((err) => {
    Logger.error(TAG, `update Form Failed ${JSON.stringify(err)}`);
  });
}

function modifyCondition(): void {
  let formInstanceFilter = {
    bundleName: 'ohos.samples.formextability',
    moduleName: 'processProxyForm'
  };
  formHost.getRunningFormInfosByFilter(formInstanceFilter).then((data) => {
    Logger.info(TAG, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('runningFormInfo', JSON.stringify(data));
    data.forEach(updateCardDisplayContent);
  }).catch((err) => {
    Logger.error(TAG, `getRunningFormInfosByFilter err is ${JSON.stringify(err)}`);
  });
}

@Entry
@Component
struct IndexThi {
  build() {
    Row() {
      Column({ space: 150 }) {
        Text($r('app.string.subscription_conditions'))
          .fontColor('#182431')
          .fontSize(40)
          .lineHeight(41)
          .fontWeight('100%')
        Column() {
          Text($r('app.string.modify_subscription_conditions'))
            .fontSize(28)
            .margin({ bottom: 20 })
          Row() {
            Flex({ justifyContent: FlexAlign.SpaceEvenly }) {
              Column() {
                Text($r('app.string.city_sy'))
                  .margin({ bottom :10 })
                Radio({ value: 'sy', group: 'modifyConditionGroup' })
                  .height(24)
                  .width(24)
                  .radioStyle({
                    checkedBackgroundColor: $r('sys.color.ohos_id_color_text_primary_activated'),
                    indicatorColor: $r('sys.color.ohos_fa_foreground_contrary'),
                    uncheckedBorderColor: $r('sys.color.ohos_id_color_switch_outline_off') })
                  .onChange((isChecked: boolean) => {
                    Logger.info('firstRadio status is ' + isChecked);
                    if (isChecked) {
                      conditionID = '110000';
                      modifyCondition();
                    }
                  })
              }

              Column() {
                Text($r('app.string.city_hz'))
                  .margin({ bottom :10 })
                Radio({ value: 'hz', group: 'modifyConditionGroup' })
                  .height(24)
                  .width(24)
                  .radioStyle({
                    checkedBackgroundColor: $r('sys.color.ohos_id_color_text_primary_activated'),
                    indicatorColor: $r('sys.color.ohos_fa_foreground_contrary'),
                    uncheckedBorderColor: $r('sys.color.ohos_id_color_switch_outline_off') })
                  .onChange((isChecked: boolean) => {
                    Logger.info('secondRadio status is ' + isChecked);
                    if (isChecked) {
                      conditionID = '310000';
                      modifyCondition();
                    }
                  })
              }
            }
          }
          .width('70%')
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}