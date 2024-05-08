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
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import formInfo from '@ohos.app.form.formInfo';
import formObserver from '@ohos.app.form.formObserver';
import prompt from '@ohos.promptAction';
import resourceManager from '@ohos.resourceManager';
import { ValuesBucket, ValueType } from '@ohos.data.ValuesBucket';
import Logger from '../../common/Logger';

const TAG = '[Sample_PublishIndex]';
let conditionCity: string;
let conditionID: ValueType = '110000';
let conditionData = '-30 ℃';
let context: common.UIAbilityContext;
let shenYang: string;
let hangZhou: string;
const formInstanceFilter: formInfo.FormProviderFilter = {
  bundleName: 'ohos.samples.formextability',
  moduleName: 'persistentProxyForm'
};

function updateRDB(context: common.UIAbilityContext): void {
  dataShare.createDataShareHelper(context, 'datashareproxy://ohos.samples.formextability', { isProxy: true })
    .then((data: dataShare.DataShareHelper) => {
      Logger.info(TAG, `createDataShareHelper succeed, data :  ${JSON.stringify(data)}`);
      let dataShareHelper = data;
      let da = new dataSharePredicates.DataSharePredicates();
      da.equalTo('cityId', conditionID);
      let va: ValuesBucket = {
        cityName: conditionCity,
        cityTemperature: conditionData
      };
      try {
        let uri = 'datashareproxy://ohos.samples.formextability/test';
        dataShareHelper.update(uri, da, va, (err, data) => {
          if (err !== undefined) {
            Logger.info(TAG, `update error1: code: ${err.code}, message: ${err.message} `);
            prompt.showToast(
              { message: `publish err: ${JSON.stringify(err)}`, duration: 5000 });
            return;
          }
          Logger.info(TAG, `update succeed, data : ${data}`);
          prompt.showToast(
            { message: `publish success ${conditionCity} ${conditionData}`, duration: 5000 });
        });
        dataShareHelper.notifyChange(uri);
      } catch (err) {
        Logger.info(TAG, `update error2: code: ${err.code}, message: ${err.message} `);
      }
    })
    .catch((err: base.BusinessError<void>) => {
      Logger.info(TAG, `createDataShareHelper error: code: ${err.code}, message: ${err.message} `);
    });
}

function publish(): void {
  Logger.info(TAG, 'publish called');
  formObserver.getRunningFormInfosByFilter(formInstanceFilter).then((data: Array<formInfo.RunningFormInfo>) => {
    Logger.info(TAG, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('RunningFormInfo', JSON.stringify(data));
  }).catch((err: base.BusinessError<void>) => {
    Logger.error(TAG, `getRunningFormInfosByFilter err is ${JSON.stringify(err)}`);
    prompt.showToast(
      { message: `publish err, getRunningFormInfosByFilter1 failed ${JSON.stringify(err)}`, duration: 5000 });
  });
}

@Entry
@Component
struct IndexSec {
  private inputText: string = '';

  aboutToAppear() {
    context = getContext(this) as common.UIAbilityContext;
    let syTemp = $r('app.string.city_sy');
    let hzTemp = $r('app.string.city_hz');
    let citySy: resourceManager.Resource = {
      bundleName: syTemp.bundleName,
      moduleName: syTemp.moduleName,
      id: syTemp.id
    };
    let cityHz: resourceManager.Resource = {
      bundleName: hzTemp.bundleName,
      moduleName: hzTemp.moduleName,
      id: hzTemp.id
    };
    shenYang = context.resourceManager.getStringSync(citySy);
    hangZhou = context.resourceManager.getStringSync(cityHz);
    conditionCity = shenYang;
  }

  @StorageLink('RunningFormInfo') RunningFormInfo: string = '';
  @State focus: boolean = false;

  build() {
    Row() {
      Column({ space: 200 }) {
        Column({ space: 5 }) {
          Text($r('app.string.modify_publish_data'))
            .fontColor('#182431')
            .fontSize(40)
            .lineHeight(41)
            .fontWeight('100%')
        }

        Column() {
          Column() {
            Row() {
              Text($r('app.string.selection_city'))
                .fontSize(30)
              Row() {
                Column() {
                  Text($r('app.string.city_sy'))
                    .fontSize(15)
                    .margin({ bottom: 10 })
                  Radio({ value: 'sy', group: 'cityGroup' })
                    .checked(true)
                    .height(24)
                    .width(24)
                    .radioStyle({
                      checkedBackgroundColor: $r('sys.color.ohos_id_color_text_primary_activated'),
                      uncheckedBorderColor: $r('sys.color.ohos_id_color_switch_outline_off'),
                      indicatorColor: $r('sys.color.ohos_id_color_foreground_contrary')
                    })
                    .onChange((isChecked: boolean) => {
                      Logger.info(TAG, `sy status is ${JSON.stringify(isChecked)}`);
                      if (isChecked) {
                        conditionID = '110000';
                        conditionCity = shenYang;
                      }
                    })
                }

                Column() {
                  Text($r('app.string.city_hz'))
                    .fontSize(15)
                    .margin({ bottom: 10 })
                  Radio({ value: 'hz', group: 'cityGroup' })
                    .height(24)
                    .width(24)
                    .radioStyle({
                      checkedBackgroundColor: $r('sys.color.ohos_id_color_text_primary_activated'),
                      uncheckedBorderColor: $r('sys.color.ohos_id_color_switch_outline_off'),
                      indicatorColor: $r('sys.color.ohos_id_color_foreground_contrary')
                    })
                    .onChange((isChecked: boolean) => {
                      Logger.info(TAG, `hz status is ${JSON.stringify(isChecked)}`);
                      if (isChecked) {
                        conditionID = '310000';
                        conditionCity = hangZhou;
                      }
                    })
                }
                .margin({ left: 20 })
              }
              .margin({ left: 10 })
            }

            Row() {
              Text($r('app.string.input_temperature'))
                .fontSize(30)
                .width(200)
                .height(60)
              TextInput({ text: '-30' })
                .fontSize(20)
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .width(100)
                .height(40)
                .type(InputType.Normal)
                .borderRadius(16)
                .backgroundColor($r('sys.color.ohos_id_color_text_field_sub_bg'))
                .onChange((text) => {
                  this.inputText = text;
                })
              Text('℃')
                .fontSize(30)
                .height(60)
            }
          }
          .alignItems(HorizontalAlign.Start)

          Button() {
            Text($r('app.string.published_data'))
              .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontWeight(FontWeight.Bold)
          }
          .width(220)
          .height(40)
          .type(ButtonType.Capsule)
          .margin({ top: 20 })
          .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
          .backgroundColor($r('sys.color.ohos_id_color_component_activated'))
          .onClick(() => {
            if (Number(this.inputText) >= -40 && Number(this.inputText) <= 60) {
              Logger.info(TAG, `correct temperature is ${this.inputText}`);
              conditionData = this.inputText + ' ℃';
              publish();
              updateRDB(context);
            } else {
              Logger.info(TAG, `incorrect temperature is ${this.inputText}`);
              prompt.showToast({ message: 'Please enter the correct value from -40 to 60', duration: 5000 });
            }
          })
        }
        .height('30%')
      }
      .width('100%')
    }
    .height('100%')
  }
}