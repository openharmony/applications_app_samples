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

const TAG = '[Push_Index]';
let conditionCity = '沈阳';
let conditionID = '110000';
let conditionData = '-30 ℃';
const formInstanceFilter = {
  bundleName: 'com.samples.PersistentProxyForm',
};

function updateRDB(): void {
  dataShare.createDataShareHelper(globalThis.context.getApplicationContext(), "datashareproxy://com.samples.PersistentProxyForm", {isProxy : true}).then((data) => {
    Logger.info(`${TAG}`, `createDataShareHelper succeed, data :  ${JSON.stringify(data)}`);
    let dataShareHelper = data;
    let da = new dataSharePredicates.DataSharePredicates();
    da.equalTo("city_id", conditionID);
    const va = {
      "city_name": conditionCity,
      "city_temper": conditionData
    };
    try {
      let uri = "datashareproxy://com.samples.PersistentProxyForm/test";
      dataShareHelper.update(uri, da, va, (err, data) => {
        if (err != undefined) {
          Logger.info(`${TAG}`, `update error1: code: ${err.code}, message: ${err.message} `);
          return;
        };
        Logger.info(`${TAG}`, `update succeed, data : ${data}`);
      });
      dataShareHelper.notifyChange(uri);
    } catch (err) {
      Logger.info(`${TAG}`, `update error2: code: ${err.code}, message: ${err.message} `);
    };
  }).catch((err) => {
    Logger.info(`${TAG}`, `createDataShareHelper error: code: ${err.code}, message: ${err.message} `);
  });
}

function publish(): void {
  Logger.info(`${TAG}`, `publish called`);
  formHost.getRunningFormInfosByFilter(formInstanceFilter).then(data => {
    Logger.info(`${TAG}`, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('runningFormInfo', JSON.stringify(data));
  }).catch((err) => {
    Logger.error(`${TAG}`, `getRunningFormInfosByFilter err is ${JSON.stringify(err)}`);
    prompt.showToast(
      { message: `publish err, getRunningFormInfosByFilter1 failed ${JSON.stringify(err)}`, duration: 5000 });
  });
}

@Entry
@Component
struct IndexSec {
  @State temperatureDATA: string = '-30 ℃';
  @StorageLink('runningFormInfo') runningFormInfo: string = '';
  build() {
    Row() {
      Column() {
        Row() {
          Text('城市选择')
            .fontSize(40)
          Column() {
            Text('沈阳')
              .fontSize(10)
            Radio({ value: 'sy', group: 'cityGroup' }).checked(true)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                Logger.info(`${TAG}`, `sy status is ${JSON.stringify(isChecked)}`);
                if (isChecked) {
                  conditionID = '110000';
                  conditionCity = '沈阳';
                }
              })
          }
          Column() {
            Text('杭州')
              .fontSize(10)
            Radio({ value: 'hz', group: 'cityGroup' })
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                Logger.info(`${TAG}`, `hz status is ${JSON.stringify(isChecked)}`);
                if (isChecked) {
                  conditionID = '310000';
                  conditionCity = '杭州';
                };
              })
          }
        }
        Column() {
          Text('选择数据: ' + this.temperatureDATA)
            .fontSize(40)
          Row() {
            Column() {
              Text('-30 ℃')
                .fontSize(10)
              Radio({ value: 'data1', group: 'DataGroup' }).checked(true)
                .height(30)
                .width(30)
                .onChange((isChecked: boolean) => {
                  Logger.info(`${TAG}`, `data1 status is ${JSON.stringify(isChecked)}`);
                  if (isChecked) {
                    conditionData = '-30 ℃';
                    this.temperatureDATA = conditionData;
                  }
                })
            }
            Column() {
              Text('-15 ℃')
                .fontSize(10)
              Radio({ value: 'data2', group: 'DataGroup' })
                .height(30)
                .width(30)
                .onChange((isChecked: boolean) => {
                  Logger.info(`${TAG}`, `data2 status is ${JSON.stringify(isChecked)}`);
                  if (isChecked) {
                    conditionData = '-15 ℃';
                    this.temperatureDATA = conditionData;
                  };
                })
            }
            Column() {
              Text('0 ℃')
                .fontSize(10)
              Radio({ value: 'data3', group: 'DataGroup' })
                .height(30)
                .width(30)
                .onChange((isChecked: boolean) => {
                  Logger.info(`${TAG}`, `data3 status is ${JSON.stringify(isChecked)}`);
                  if (isChecked) {
                    conditionData = '0 ℃';
                    this.temperatureDATA = conditionData;
                  }
                })
            }
            Column() {
              Text('15 ℃')
                .fontSize(10)
              Radio({ value: 'data4', group: 'DataGroup' })
                .height(30)
                .width(30)
                .onChange((isChecked: boolean) => {
                  Logger.info(`${TAG}`, `data4 status is ${JSON.stringify(isChecked)}`);
                  if (isChecked) {
                    conditionData = '15 ℃';
                    this.temperatureDATA = conditionData;
                  }
                })
            }
            Column() {
              Text('30 ℃')
                .fontSize(10)
              Radio({ value: 'data5', group: 'DataGroup' })
                .height(30)
                .width(30)
                .onChange((isChecked: boolean) => {
                  Logger.info(`${TAG}`, `data5 status is ${JSON.stringify(isChecked)}`);
                  if (isChecked) {
                    conditionData = '30 ℃';
                    this.temperatureDATA = conditionData;
                  };
                })
            }
          }
        }
        Button('发布数据')
          .fontSize(40)
          .type(ButtonType.Capsule)
          .margin({ top: 20 })
          .backgroundColor('#0D9FFB')
          .onClick(() => {
            publish()
            updateRDB()
          })
        Text(' ')
          .fontSize(10)
        Text(this.runningFormInfo)
          .fontSize(15)
      }
      .width('100%')
    }
    .height('100%')
  }
}