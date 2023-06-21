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
import dataShare from '@ohos.data.dataShare';

const TAG = '[Modify_Condition_Index]';
let dataShareHelper;
let conditionID = '110000';

function updateCardDisplayContent(runningFormInfo): void {
  Logger.info(`${TAG} updateCardDisplayContent bundle: ${runningFormInfo.bundleName}`);
  let template = {
    predicates : {
      "list" : `select city_temper as city_temper, city_name as city_name from TBL00 where city_id = ${conditionID}`
    },
    scheduler: ""
  };
  dataShare.createDataShareHelper(globalThis.context, "datashareproxy://com.samples.PersistentProxyForm", {isProxy : true}).then((data) => {
    dataShareHelper = data;
    dataShareHelper.addTemplate("datashareproxy://com.samples.PersistentProxyForm/test", conditionID, template);
  });
  let proxies = [{"key": "datashareproxy://com.samples.PersistentProxyForm/test", "subscriberId": conditionID}];
  let formData;
  Logger.info(`${TAG}`, `formData: ${JSON.stringify(formData)}`);
  let formBinding =  formBindingData.createFormBindingData(formData);
  formBinding['proxies'] = proxies;
  formProvider.updateForm(runningFormInfo.formId, formBinding).then(() => {
    Logger.info(`${TAG}`, `update Form OK formData is ${JSON.stringify(formBinding)}`);
  }).catch((err) => {
    Logger.error(`${TAG}`, `update Form Failed ${JSON.stringify(err)}`);
  });
}

function modifyCondition(): void {
  let formInstanceFilterArkTS = {
    bundleName: 'com.samples.PersistentProxyForm',
    abilityName: 'EntryFormAbility',
    formName: 'widget',
    moduleName: 'entry'
  };
  let formInstanceFilterJS = {
    bundleName: 'com.samples.PersistentProxyForm',
    abilityName: 'EntryFormAbility',
    formName: 'widgetJS',
    moduleName: 'entry'
  };
  formHost.getRunningFormInfosByFilter(formInstanceFilterArkTS).then(data => {
    Logger.info(`${TAG}`, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('runningFormInfo', JSON.stringify(data));
    data.forEach(updateCardDisplayContent);
  }).catch((err) => {
    Logger.error(`${TAG}`, `getRunningFormInfosByFilter err is ${JSON.stringify(err)}`);
  });
  formHost.getRunningFormInfosByFilter(formInstanceFilterJS).then(data => {
    Logger.info(`${TAG}`, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('runningFormInfo', JSON.stringify(data));
    data.forEach(updateCardDisplayContent);
  }).catch((err) => {
    Logger.error(`${TAG}`, `getRunningFormInfosByFilter err is ${JSON.stringify(err)}`);
  });
}

@Entry
@Component
struct IndexThi {
  build() {
    Row() {
      Column() {
        Text('修改订阅条件')
          .fontSize(40)
          .margin({ bottom: 20 })
        Row() {
          Column() {
            Text('沈阳')
            Radio({ value: 'sy', group: 'modifyConditionGroup' }).checked(true)
              .height(50)
              .width(50)
              .onChange((isChecked: boolean) => {
                Logger.info('Radio1 status is ' + isChecked);
                if (isChecked) {
                  conditionID = '110000';
                  modifyCondition();
                }
              })
          }
          Column() {
            Text('杭州')
            Radio({ value: 'hz', group: 'modifyConditionGroup' })
              .height(50)
              .width(50)
              .onChange((isChecked: boolean) => {
                Logger.info('Radio2 status is ' + isChecked);
                if (isChecked) {
                  conditionID = '310000';
                  modifyCondition();
                }
              })
          }
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}