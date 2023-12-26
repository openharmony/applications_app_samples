/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import hilog from '@ohos.hilog';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import { ValuesBucket } from '@ohos.data.ValuesBucket';

let storage = new LocalStorage();
const TAG: string = 'Index';
const DOMAIN_NUMBER: number = 0xFF00;
let dsHelper: dataShare.DataShareHelper | undefined = undefined;
let dataShareHelper: dataShare.DataShareHelper | undefined = undefined;
let conditionID = '111';
let context: Context;

@Entry(storage)
@Component
struct Index {
  aboutToAppear() {
    context = getContext(this) as Context;
  }

  onPublishCallback(err: BusinessError, node: dataShare.PublishedDataChangeNode): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onPublishCallback');
    promptAction.showToast({
      message: $r('app.string.update_processdata_success')
    });
  }

  publishProcessData(): void {
    let uri = ('datashareproxy://com.samples.widgetupdatebyproxy.DataShare');

    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onWindowStageCreate');
    try {
      dataShare.createDataShareHelper(context, uri, {
        isProxy: true
      }, (err: BusinessError, data: dataShare.DataShareHelper) => {
        if (err !== undefined) {
          hilog.error(DOMAIN_NUMBER, TAG, `createDataShareHelper error: code: ${err.code}, message: ${err.message} `);
          return;
        }
        hilog.info(DOMAIN_NUMBER, TAG, `createDataShareHelper succeed, data: ${JSON.stringify(data)}`);
        dsHelper = data;

        // 构建两条数据，第一条为免配置的数据，仅自己使用
        let dataArray: Array<dataShare.PublishedItem> = [
          {
            key: 'city', subscriberId: '11', data: 'xian'
          },
          {
            key: 'datashareproxy://com.samples.widgetupdatebyproxy/weather',
            subscriberId: '11',
            data: JSON.stringify('Qing')
          }];
        // 发布数据
        try {
          hilog.info(DOMAIN_NUMBER, TAG, 'dataArray length is:', dataArray.length);
          if (dsHelper !== undefined) {
            let result: Promise<Array<dataShare.OperationResult>> = (dsHelper as dataShare.DataShareHelper).publish(dataArray, 'com.samples.widgetupdatebyproxy');
            hilog.info(DOMAIN_NUMBER, TAG, `result of publish is ${JSON.stringify(result)}`);
          }
          else {
            hilog.info(DOMAIN_NUMBER, TAG, `publish dsHelper is undefined`);
          }
        } catch (e) {
          hilog.error(DOMAIN_NUMBER, TAG, `publish error + ${JSON.stringify(e)}`);
          promptAction.showToast({
            message: $r('app.string.update_process_data_error')
          });
        };

        let uris: Array<string> = ['city', 'datashareproxy://com.samples.widgetupdatebyproxy/weather'];
        if (dsHelper !== undefined) {
          let result: Array<dataShare.OperationResult> = (dsHelper as dataShare.DataShareHelper).on('publishedDataChange', uris, '11', this.onPublishCallback);
          hilog.info(DOMAIN_NUMBER, TAG, `result of on is ${JSON.stringify(result)}`);
        }
        else {
          hilog.info(DOMAIN_NUMBER, TAG, 'dsHelper is undefined');
        }
      });
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(DOMAIN_NUMBER, TAG, `createDataShareHelper error: code: ${code}, message: ${message} `);
    };
  }

  updateRDB(): void {
    dataShare.createDataShareHelper(context, 'datashareproxy://com.samples.widgetupdatebyproxy', { isProxy: true })
      .then((data: dataShare.DataShareHelper) => {
        hilog.info(DOMAIN_NUMBER, TAG, `createDataShareHelper succeed, data :  ${JSON.stringify(data)}`);
        let dataShareHelper: dataShare.DataShareHelper = data;
        let da: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
        da.equalTo('cityId', conditionID);
        let va: ValuesBucket = {
          'cityId': '111',
          'type': 'Snow'
        };

        try {
          let uri = 'datashareproxy://com.samples.widgetupdatebyproxy/test';
          dataShareHelper.update(uri, da, va, (err: BusinessError, data: number) => {
            if (err !== undefined) {
              hilog.info(DOMAIN_NUMBER, TAG, `update error1: code: ${err.code}, message: ${err.message} `);
              promptAction.showToast({
                message: ($r('app.string.update_persisdata_error'))
              });
              return;
            };
            hilog.info(DOMAIN_NUMBER, TAG, `update succeed, data : ${data}`);
            promptAction.showToast({
              message: ($r('app.string.update_persisdata_success'))
            });
          });
          dataShareHelper.notifyChange(uri);
        } catch (err) {
          hilog.info(DOMAIN_NUMBER, TAG, `update error2: code: ${err.code}, message: ${err.message} `);
          promptAction.showToast({
            message: ($r('app.string.update_persisdata_error'))
          });
        };
      }).catch((err: BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, `createDataShareHelper error: code: ${err.code}, message: ${err.message} `);
    });
  }

  publishPersistentData(): void {
    const valueBucket: ValuesBucket = {
      'cityId': '111',
      'type': 'Snow'
    }
    let uri = ('datashare:///com.samples.widgetupdatebyproxy.DataShare');
    try {
      dataShare.createDataShareHelper(context, uri, { isProxy: true })
        .then((data: dataShare.DataShareHelper) => {
          dataShareHelper = data;
          if (dataShareHelper !== undefined) {
            // 插入一条数据
            (dataShareHelper as dataShare.DataShareHelper).insert(uri, valueBucket, (err: BusinessError, data: number) => {
              if (err !== undefined) {
                hilog.error(DOMAIN_NUMBER, TAG, 'insert error: code:' + JSON.stringify(err) + data);
                return;
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'insert succeed, data : ' + data);
              // 更新数据
              this.updateRDB();
            });
          }
        });
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(DOMAIN_NUMBER, TAG, `createDataShareHelper error: code: ${code}, message: ${message} `);
    };
  }

  build() {
    Column() {
      Column() {
        Text($r('app.string.process_widget_update'))
          .fontSize('20vp')
          .textAlign(TextAlign.Center)
        Button() {
          Text($r('app.string.ProcessEntryAbility'))
            .fontSize(16)
            .fontColor('#FFFFFF')
            .opacity(0.9)
        }
        .width('624px')
        .height(48)
        .type(ButtonType.Capsule)
        .backgroundColor('#027DFB')
        .borderRadius(16)
        .onClick(() => {
          this.publishProcessData();
        })
        .margin(5)
      }.width('100%')
      .margin({ top: '70%' })
      .alignItems(HorizontalAlign.Center)

      Column() {
        Text($r('app.string.persistent_widget_update'))
          .fontSize('20vp')
          .textAlign(TextAlign.Center)
        Button() {
          Text($r('app.string.PersisEntryAbility'))
            .fontSize(16)
            .fontColor('#FFFFFF')
            .opacity(0.9)
        }
        .width('624px')
        .height(48)
        .type(ButtonType.Capsule)
        .backgroundColor('#027DFB')
        .borderRadius(16)
        .onClick(() => {
          this.publishPersistentData();
        })
        .margin(5)
      }.width('100%')
      .margin({ top: '10%' })
      .alignItems(HorizontalAlign.Center)
    }.width('100%').height('100%')
  }
}