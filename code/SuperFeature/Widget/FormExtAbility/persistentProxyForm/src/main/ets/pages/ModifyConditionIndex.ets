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

import base from '@ohos.base';
import common from '@ohos.app.ability.common';
import dataShare from '@ohos.data.dataShare';
import formBindingData from '@ohos.app.form.formBindingData';
import formInfo from '@ohos.app.form.formInfo';
import formObserver from '@ohos.app.form.formObserver';
import formProvider from '@ohos.app.form.formProvider';
import Logger from '../../common/Logger';
import { getPersistentConditionID, savePersistentConditionID } from '../../common/StatePersistence';

const TAG = '[Sample_ModifyConditionIndex]';
let dataShareHelper: dataShare.DataShareHelper;
let conditionID = '110000';
let context: common.UIAbilityContext;

function updateCardDisplayContent(runningFormInfo: formInfo.RunningFormInfo): void {
  Logger.info(`TAG updateCardDisplayContent bundle: ${runningFormInfo.bundleName}`);
  let template: dataShare.Template = {
    predicates: {
      list: `select cityTemperature as cityTemperature, cityName as cityName from TBL00 where cityId = ${conditionID}`
    },
    scheduler: ''
  };
  dataShare.createDataShareHelper(context, 'datashareproxy://ohos.samples.formextability', { isProxy: true })
    .then((data: dataShare.DataShareHelper) => {
      dataShareHelper = data;
      dataShareHelper.addTemplate('datashareproxy://ohos.samples.formextability/test', conditionID, template);
    });

  class ProxiesType {
    key: string = '';
    subscriberId: string = '';
  };

  let proxies = [{
    key: 'datashareproxy://ohos.samples.formextability/test',
    subscriberId: conditionID
  } as ProxiesType];
  let formData: string = '';
  Logger.info(TAG, `formData: ${JSON.stringify(formData)}`);
  let formBinding = formBindingData.createFormBindingData(formData);
  formBinding['proxies'] = proxies;
  formProvider.updateForm(runningFormInfo.formId, formBinding).then(() => {
    Logger.info(TAG, `update Form OK formData is ${JSON.stringify(formBinding)}`);
  }).catch((err: base.BusinessError<void>) => {
    Logger.error(TAG, `update Form Failed ${JSON.stringify(err)}`);
  });
}

function modifyCondition(): void {
  let formInstanceFilterArkTS: formInfo.FormProviderFilter = {
    bundleName: 'ohos.samples.formextability',
    abilityName: 'EntryFormAbility',
    formName: 'persistentWidget',
    moduleName: 'persistentProxyForm'
  };
  let formInstanceFilterJS: formInfo.FormProviderFilter = {
    bundleName: 'ohos.samples.formextability',
    abilityName: 'EntryFormAbility',
    formName: 'persistentWidgetJS',
    moduleName: 'persistentProxyForm'
  };
  formObserver.getRunningFormInfosByFilter(formInstanceFilterArkTS).then((data: Array<formInfo.RunningFormInfo>) => {
    Logger.info(TAG, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('runningFormInfo', JSON.stringify(data));
    data.forEach(updateCardDisplayContent);
  }).catch((err: base.BusinessError<void>) => {
    Logger.error(TAG, `getRunningFormInfosByFilter err is ${JSON.stringify(err)}`);
  });
  formObserver.getRunningFormInfosByFilter(formInstanceFilterJS).then((data: Array<formInfo.RunningFormInfo>) => {
    Logger.info(TAG, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('runningFormInfo', JSON.stringify(data));
    data.forEach(updateCardDisplayContent);
  }).catch((err: base.BusinessError<void>) => {
    Logger.error(TAG, `getRunningFormInfosByFilter err is ${JSON.stringify(err)}`);
  });
}

@Entry
@Component
struct IndexThi {
  @State persistentConditionID: string = '';
  @State persistentSwitchFlag: boolean = true;

  aboutToAppear() {
    context = getContext(this) as common.UIAbilityContext;
    this.persistentConditionID = getPersistentConditionID(context);
    if (typeof this.persistentConditionID !== 'string' || this.persistentConditionID === '') {
      this.persistentConditionID = '110000'
    }
    this.persistentSwitchFlag = this.persistentConditionID.localeCompare('110000') === 0;
    Logger.debug(TAG, `persistentSwitchFlag : ${JSON.stringify(this.persistentSwitchFlag)}`);
  }

  aboutToDisappear() {
    savePersistentConditionID(context, this.persistentConditionID);
  }

  build() {
    Row() {
      Column({ space: 150 }) {
        Text($r('app.string.subscription_conditions'))
          .fontColor('#182431')
          .fontSize(40)
          .lineHeight(41)
          .fontWeight('Bold')
        Column() {
          Text($r('app.string.modify_subscription_conditions'))
            .fontSize(28)
            .margin({ bottom: 20 })
          Row() {
            Flex({ justifyContent: FlexAlign.SpaceEvenly }) {
              Column() {
                Text($r('app.string.city_sy'))
                  .margin({ bottom: 10 })
                Radio({ value: 'sy', group: 'modifyConditionGroup' })
                  .checked(this.persistentSwitchFlag)
                  .height(24)
                  .width(24)
                  .radioStyle({
                    checkedBackgroundColor: $r('sys.color.ohos_id_color_text_primary_activated'),
                    uncheckedBorderColor: $r('sys.color.ohos_id_color_switch_outline_off'),
                    indicatorColor: $r('sys.color.ohos_id_color_foreground_contrary')
                  })
                  .onChange((isChecked: boolean) => {
                    Logger.info('firstRadio status is ' + isChecked);
                    if (isChecked) {
                      conditionID = '110000';
                      this.persistentConditionID = conditionID;
                      modifyCondition();
                    }
                  })
              }

              Column() {
                Text($r('app.string.city_hz'))
                  .margin({ bottom: 10 })
                Radio({ value: 'hz', group: 'modifyConditionGroup' })
                  .checked(!this.persistentSwitchFlag)
                  .height(24)
                  .width(24)
                  .radioStyle({
                    checkedBackgroundColor: $r('sys.color.ohos_id_color_text_primary_activated'),
                    uncheckedBorderColor: $r('sys.color.ohos_id_color_switch_outline_off'),
                    indicatorColor: $r('sys.color.ohos_id_color_foreground_contrary')
                  })
                  .onChange((isChecked: boolean) => {
                    Logger.info('secondRadio status is ' + isChecked);
                    if (isChecked) {
                      conditionID = '310000';
                      this.persistentConditionID = conditionID;
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