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
import formHost from '@ohos.app.form.formHost';
import prompt from '@ohos.promptAction';
import Logger from '../../common/Logger';

const TAG = '[Push_Index]';
let dataShareHelper;
let version = 10;
let uri = ('datashareproxy://com.samples.processproxyform');
let conditionCity = '沈阳';
let conditionID = '110000';
let conditionData = '-30 ℃';
let formInstanceFilter = {
  bundleName: 'com.samples.processproxyform'
};

function updateCardDisplayContent(runningFormInfo): void {
  Logger.info(`${TAG}`, `updateCardDisplayContent bundle: ${runningFormInfo.bundleName}`);
  dataShare.createDataShareHelper(globalThis.context, uri, { isProxy: true }, (err, dataHelper) => {
    Logger.info(`${TAG}`, `dataShareHelper err: ${err}`, `data: ${dataShareHelper}`);
    dataShareHelper = dataHelper;
    if (err !== undefined) {
      Logger.error(`${TAG}`, `createDataShareHelper error code: ${err.code}`, `message: ${err.message} `);
      prompt.showToast({ message: `createDataShareHelper:` + err.message, duration: 5000 });
    } else {
      let publishedItemData : Array<dataShare.PublishedItem> = [
        {key: 'city_name', data: JSON.stringify(conditionCity), subscriberId: conditionID},
        {key: 'city_temper', data: JSON.stringify(conditionData), subscriberId: conditionID}
      ];
      dataShareHelper.publish(publishedItemData, runningFormInfo.hostBundleName, version).then((data) => {
        Logger.info(`${TAG}`, `publish success, data is ${JSON.stringify(data)}`);
        prompt.showToast(
          { message: `publish success ${conditionCity} ${conditionData} ${conditionID}`, duration: 5000 });
      }).catch((err) => {
        Logger.error(`${TAG}`, `publish error: ${JSON.stringify(err)}`);
        prompt.showToast({ message: `publish err: ${JSON.stringify(err)}`, duration: 5000 });
      });
    }
  });
}

function publish(): void {
  Logger.info(`${TAG}`, `publish called`);
  formHost.getRunningFormInfosByFilter(formInstanceFilter).then(data => {
    Logger.info(`${TAG}`, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('runningFormInfo', JSON.stringify(data));
    data.forEach(updateCardDisplayContent);
  }).catch((err) => {
    Logger.error(`${TAG}`, `getRunningFormInfosByFilter err is ${JSON.stringify(err)}`);
    prompt.showToast(
      { message: `publish err, getRunningFormInfosByFilter failed ${JSON.stringify(err)}`, duration: 5000 });
  });
}

@Entry
@Component
struct IndexSec {
  @StorageLink('runningFormInfo') runningFormInfo: string = '';
  build() {
    Row() {
      Column({ space: 200 }) {
        Column({ space: 5 }) {
          Text($r('app.string.modify_publish_data'))
            .fontColor('#182431')
            .fontSize(30)
            .lineHeight(41)
            .fontWeight(500)
        }
        Column() {
          Row() {
            Text($r('app.string.selection_city'))
              .fontSize(40)
            Column() {
              Text($r('app.string.city_sy'))
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
              Text($r('app.string.city_hz'))
                .fontSize(10)
              Radio({ value: 'hz', group: 'cityGroup' })
                .height(30)
                .width(30)
                .onChange((isChecked: boolean) => {
                  Logger.info(`${TAG}`, `hz status is ${JSON.stringify(isChecked)}`);
                  if (isChecked) {
                    conditionID = '310000';
                    conditionCity = '杭州';
                  }
                })
            }
          }
          Row() {
            Text('请输入温度：')
              .fontSize(30)
              .width(200)
              .height(60)
            TextInput({ text: '-30' })
              .fontSize(30)
              .width(100)
              .height(60)
              .type(InputType.Normal)
              .onChange((text) => {
                if (Number(text) > -40 && Number(text) < 60) {
                  conditionData = text + ' ℃';
                } else {
                  prompt.showToast({ message: `Please enter the correct temperature`, duration: 5000 });
                }
              })
            Text('℃')
              .fontSize(30)
              .height(60)
          }
          Button($r('app.string.published_data'))
            .fontSize(30)
            .width(300)
            .type(ButtonType.Capsule)
            .margin({ top: 20 })
            .backgroundColor('#0D9FFB')
            .onClick(() => {
              publish()
            })
          Text(' ')
            .fontSize(10)
          Text(this.runningFormInfo)
            .fontSize(15)
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}