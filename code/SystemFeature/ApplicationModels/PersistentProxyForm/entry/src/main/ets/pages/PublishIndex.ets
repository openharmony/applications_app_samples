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
  bundleName: 'com.samples.PersistentProxyForm',
};

function updateRDB(context): void {
  dataShare.createDataShareHelper(context, 'datashareproxy://com.samples.PersistentProxyForm', {isProxy : true}).then((data) => {
    Logger.info(TAG, `createDataShareHelper succeed, data :  ${JSON.stringify(data)}`);
    let dataShareHelper = data;
    let da = new dataSharePredicates.DataSharePredicates();
    da.equalTo('cityId', conditionID);
    let va = {
      'cityName': conditionCity,
      'cityTemper': conditionData
    };
    try {
      let uri = 'datashareproxy://com.samples.PersistentProxyForm/test';
      dataShareHelper.update(uri, da, va, (err, data) => {
        if (err !== undefined) {
          Logger.info(TAG, `update error1: code: ${err.code}, message: ${err.message} `);
          return;
        };
        Logger.info(TAG, `update succeed, data : ${data}`);
      });
      dataShareHelper.notifyChange(uri);
    } catch (err) {
      Logger.info(TAG, `update error2: code: ${err.code}, message: ${err.message} `);
    };
  }).catch((err) => {
    Logger.info(TAG, `createDataShareHelper error: code: ${err.code}, message: ${err.message} `);
  });
}

function publish(): void {
  Logger.info(TAG, 'publish called');
  formHost.getRunningFormInfosByFilter(formInstanceFilter).then(data => {
    Logger.info(TAG, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('runningFormInfo', JSON.stringify(data));
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
    context = getContext(this) as Context;
    shenYang = context.resourceManager.getStringSync($r('app.string.city_sy'));
    hangZhou = context.resourceManager.getStringSync($r('app.string.city_hz'));
    conditionCity = shenYang;
  }
  @StorageLink('runningFormInfo') runningFormInfo: string = '';
  build() {
    Row() {
      Column({ space: 150 }) {
        Column({ space: 5 }) {
          Text($r('app.string.modify_publish_data'))
            .fontColor('#182431')
            .fontSize(40)
            .lineHeight(41)
            .fontWeight('100%')
          Text(this.runningFormInfo)
            .fontSize(15)
            .margin({top:10, bottom:10})
        }
        Column() {
          Row() {
            Text($r('app.string.selection_city'))
              .fontSize(30)
            Row() {
              Column() {
                Text($r('app.string.city_sy'))
                  .fontSize(15)
                Radio({ value: 'sy', group: 'cityGroup' }).checked(true)
                  .height(30)
                  .width(30)
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
                Radio({ value: 'hz', group: 'cityGroup' })
                  .height(30)
                  .width(30)
                  .onChange((isChecked: boolean) => {
                    Logger.info(TAG, `hz status is ${JSON.stringify(isChecked)}`);
                    if (isChecked) {
                      conditionID = '310000';
                      conditionCity = hangZhou;
                    }
                  })
              }
            }
            .margin({left:10})
          }
          Row() {
            Text($r('app.string.input_temperature'))
              .fontSize(30)
              .width(200)
              .height(60)
            TextInput({ text: '-30' })
              .fontSize(30)
              .width(100)
              .height(60)
              .type(InputType.Normal)
              .onChange((text) => {
                conditionData = text + ' ℃';
              })
            Text('℃')
              .fontSize(30)
              .height(60)
          }
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