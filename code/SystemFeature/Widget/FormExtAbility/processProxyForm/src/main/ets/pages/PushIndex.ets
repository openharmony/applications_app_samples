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
import formInfo from '@ohos.app.form.formInfo';
import formObserver from '@ohos.app.form.formObserver';
import prompt from '@ohos.promptAction';
import Logger from '../../common/Logger';

const TAG = '[Sample_PushIndex]';
let context: common.UIAbilityContext;
let dataShareHelper: dataShare.DataShareHelper;
let uri = ('datashareproxy://ohos.samples.formextability');
let conditionCity = '';
let conditionID = '110000';
let conditionData = '-30 ℃';
let formInstanceFilter: formInfo.FormProviderFilter = {
  bundleName: 'ohos.samples.formextability',
  moduleName: 'processProxyForm'
};

function updateCardDisplayContent(runningFormInfo: formInfo.RunningFormInfo): void {
  Logger.info(TAG, `updateCardDisplayContent bundle: ${runningFormInfo.bundleName}`);
  dataShare.createDataShareHelper(context, uri, { isProxy: true }, (err, dataHelper) => {
    Logger.info(TAG, `dataShareHelper err: ${err}`, `data: ${dataShareHelper}`);
    dataShareHelper = dataHelper;
    if (err !== undefined) {
      Logger.error(TAG, `createDataShareHelper error code: ${err.code}`, `message: ${err.message} `);
      prompt.showToast({ message: 'createDataShareHelper:' + err.message, duration: 5000 });
    } else {
      let publishedItemData: Array<dataShare.PublishedItem> = [
        { key: 'cityName', data: JSON.stringify(conditionCity), subscriberId: conditionID },
        { key: 'cityTemperature', data: JSON.stringify(conditionData), subscriberId: conditionID }
      ];
      dataShareHelper.publish(publishedItemData, 'ohos.samples.formextability').then((data: Object) => {
        Logger.info(TAG, `publish success, data is ${JSON.stringify(data)}`);
        prompt.showToast(
          { message: `publish success ${conditionCity} ${conditionData}`, duration: 5000 });
      }).catch((err: base.BusinessError<void>) => {
        Logger.error(TAG, `publish error: ${JSON.stringify(err)}`);
        prompt.showToast({ message: `publish err: ${JSON.stringify(err)}`, duration: 5000 });
      });
    }
  });
}

function publish(): void {
  Logger.info(TAG, 'publish called');
  formObserver.getRunningFormInfosByFilter(formInstanceFilter).then((data: Array<formInfo.RunningFormInfo>) => {
    Logger.info(TAG, `getRunningFormInfosByFilter data: ${JSON.stringify(data)}`);
    AppStorage.SetOrCreate('runningFormInfo', JSON.stringify(data));
    data.forEach(updateCardDisplayContent);
  }).catch((err: base.BusinessError<void>) => {
    Logger.error(TAG, `getRunningFormInfosByFilter err is ${JSON.stringify(err)}`);
    prompt.showToast(
      { message: `publish err, getRunningFormInfosByFilter failed ${JSON.stringify(err)}`, duration: 5000 });
  });
}

@Entry
@Component
struct IndexSec {
  @StorageLink('runningFormInfo') runningFormInfo: string = '';
  @State focus: boolean = false;

  aboutToAppear() {
    context = getContext(this) as common.UIAbilityContext;
    conditionCity = context.resourceManager.getStringSync($r('app.string.city_sy'));
  }

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
                      indicatorColor: $r('sys.color.ohos_fa_foreground_contrary'),
                      uncheckedBorderColor: $r('sys.color.ohos_id_color_switch_outline_off') })
                    .onChange((isChecked: boolean) => {
                      Logger.info(TAG, `sy status is ${JSON.stringify(isChecked)}`);
                      if (isChecked) {
                        conditionID = '110000';
                        conditionCity = context.resourceManager.getStringSync($r('app.string.city_sy'));
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
                      indicatorColor: $r('sys.color.ohos_fa_foreground_contrary'),
                      uncheckedBorderColor: $r('sys.color.ohos_id_color_switch_outline_off') })
                    .onChange((isChecked: boolean) => {
                      Logger.info(TAG, `hz status is ${JSON.stringify(isChecked)}`);
                      if (isChecked) {
                        conditionID = '310000';
                        conditionCity = context.resourceManager.getStringSync($r('app.string.city_hz'));
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
                  conditionData = text;
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
          .height(40)
          .width(220)
          .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
          .backgroundColor($r('sys.color.ohos_id_color_component_activated'))
          .type(ButtonType.Capsule)
          .margin({ top: 20 })
          .onClick(() => {
            if (Number(conditionData) >= -40 && Number(conditionData) <= 60) {
              Logger.info(TAG, `correct temperature is ${conditionData}`);
              publish();
            } else {
              Logger.info(TAG, `incorrect temperature is ${conditionData}`);
              prompt.showToast({ message: 'Please enter the correct value from -40 to 60', duration: 5000 });
            }
          })
        }
        .alignItems(HorizontalAlign.Center)
        .height('30%')
      }
      .width('100%')
    }
    .height('100%')
  }
}