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
let context;
let dataShareHelper;
let uri = ('datashareproxy://com.samples.processproxyform');
let conditionCity = '';
let conditionID = '110000';
let conditionData = '-30 ℃';
let formInstanceFilter = {
  bundleName: 'com.samples.processproxyform'
};

function updateCardDisplayContent(runningFormInfo): void {
  Logger.info(`${TAG}`, `updateCardDisplayContent bundle: ${runningFormInfo.bundleName}`);
  dataShare.createDataShareHelper(context, uri, { isProxy: true }, (err, dataHelper) => {
    Logger.info(`${TAG}`, `dataShareHelper err: ${err}`, `data: ${dataShareHelper}`);
    dataShareHelper = dataHelper;
    if (err !== undefined) {
      Logger.error(`${TAG}`, `createDataShareHelper error code: ${err.code}`, `message: ${err.message} `);
      prompt.showToast({ message: `createDataShareHelper:` + err.message, duration: 5000 });
    } else {
      let publishedItemData : Array<dataShare.PublishedItem> = [
        {key: 'cityName', data: JSON.stringify(conditionCity), subscriberId: conditionID},
        {key: 'cityTemper', data: JSON.stringify(conditionData), subscriberId: conditionID}
      ];
      dataShareHelper.publish(publishedItemData, 'com.samples.processproxyform').then((data) => {
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

  aboutToAppear() {
    context = getContext(this) as any;
    conditionCity = context.resourceManager.getStringSync($r('app.string.city_sy'));
  }

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
                    Logger.info(`${TAG}`, `sy status is ${JSON.stringify(isChecked)}`);
                    if (isChecked) {
                      conditionID = '110000';
                      conditionCity = context.resourceManager.getStringSync($r('app.string.city_sy'));
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
                    Logger.info(`${TAG}`, `hz status is ${JSON.stringify(isChecked)}`);
                    if (isChecked) {
                      conditionID = '310000';
                      conditionCity = context.resourceManager.getStringSync($r('app.string.city_hz'));
                    }
                  })
              }
            }
            .margin({left:10})
          }
          Row() {
            Text($r('app.string.input_temper'))
              .fontSize(30)
              .width(200)
              .height(60)
            TextInput({ text: '-30' })
              .fontSize(30)
              .width(100)
              .height(60)
              .type(InputType.Normal)
              .onChange((text) => {
                conditionData = text;
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
              if (Number(conditionData) >= -40 && Number(conditionData) <= 60) {
                Logger.info(`${TAG}`, `correct temperature is ${conditionData}`);
                publish();
              } else {
                Logger.info(`${TAG}`, `incorrect temperature is ${conditionData}`);
                prompt.showToast({ message: `Please enter the correct value from -40 to 60`, duration: 5000 });
              }
            })
        }
        .alignItems(HorizontalAlign.Start)
        .height('30%')
      }
      .width('100%')
    }
    .height('100%')
  }
}