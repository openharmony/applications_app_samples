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

import dataShare from '@ohos.data.dataShare';
import Logger from '../../common/Logger';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import formHost from '@ohos.app.form.formHost';
import prompt from '@ohos.promptAction';

const TAG = '[Sample_PublishIndex]';
let conditionCity;
let conditionID = '110000';
let conditionData = '-30 ℃';
let conditionDataToNumber;
let context;
let shenYang;
let hangZhou;
const formInstanceFilter = {
  bundleName: 'ohos.samples.formextability',
  moduleName: 'persistentProxyForm'
};

function judgeThePublishCity(cityPublishID): boolean {
  let persistentPublishID = AppStorage.Get('persistentPublishID');
  if (persistentPublishID === cityPublishID) {
    return true;
  } else {
    return false;
  }
}


function updateRDB(context): void {
  dataShare.createDataShareHelper(context, 'datashareproxy://ohos.samples.formextability', { isProxy: true })
    .then((data) => {
      Logger.info(TAG, `createDataShareHelper succeed, data :  ${JSON.stringify(data)}`);
      let dataShareHelper = data;
      let da = new dataSharePredicates.DataSharePredicates();
      da.equalTo('cityId', conditionID);
      let va = {
        'cityName': conditionCity,
        'cityTemperature': conditionData
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
    .catch((err) => {
      Logger.info(TAG, `createDataShareHelper error: code: ${err.code}, message: ${err.message} `);
    });
}

function publish(): void {
  Logger.info(TAG, 'publish called');
  formHost.getRunningFormInfosByFilter(formInstanceFilter).then((data) => {
    Logger.info(TAG, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('RunningFormInfo', JSON.stringify(data));
  }).catch((err) => {
    Logger.error(TAG, `getRunningFormInfosByFilter err is ${JSON.stringify(err)}`);
    prompt.showToast(
      { message: `publish err, getRunningFormInfosByFilter1 failed ${JSON.stringify(err)}`, duration: 5000 });
  });
}

@Entry
@Component
struct IndexSec {
  aboutToAppear() {
    context = getContext(this) as typeof context;
    shenYang = context.resourceManager.getStringSync($r('app.string.city_sy'));
    hangZhou = context.resourceManager.getStringSync($r('app.string.city_hz'));
    conditionCity = shenYang;
  }

  @StorageLink('persistentPublishID') persistentPublishID: string = '000000';
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
                    .checked(judgeThePublishCity('110000'))
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
                        this.persistentPublishID = conditionID;
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
                    .checked(judgeThePublishCity('310000'))
                    .radioStyle({
                      checkedBackgroundColor: $r('sys.color.ohos_id_color_text_primary_activated'),
                      uncheckedBorderColor: $r('sys.color.ohos_id_color_switch_outline_off'),
                      indicatorColor: $r('sys.color.ohos_id_color_foreground_contrary')
                    })
                    .onChange((isChecked: boolean) => {
                      Logger.info(TAG, `hz status is ${JSON.stringify(isChecked)}`);
                      if (isChecked) {
                        conditionID = '310000';
                        this.persistentPublishID = conditionID;
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
                  conditionData = text + ' ℃';
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
            conditionDataToNumber = conditionData.split(/[℃]/);
            if (Number(conditionDataToNumber[0]) >= -40 && Number(conditionDataToNumber[0]) <= 60) {
              Logger.info(TAG, `correct temperature is ${conditionDataToNumber[0]}`);
              publish();
              updateRDB(context);
            } else {
              Logger.info(TAG, `incorrect temperature is ${conditionDataToNumber[0]}`);
              prompt.showToast({ message: `Please enter the correct value from -40 to 60`, duration: 5000 });
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