/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import formProvider from '@ohos.app.form.formProvider';
import formBindingData from '@ohos.app.form.formBindingData';
import Logger from '../logger/Logger';

let conditionID = '110000';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State bundleName: string = 'com.example.formprovider';
  @State abilityName: string = 'EntryFormAbility';
  @State moduleName: string = 'entry';
  @State formName: string = 'widget';
  @State dimension: FormDimension = FormDimension.Dimension_2_2;
  @State formId: number = 0;
  @State bundleNameAppStore: string = 'com.ohos.hag.famanager';
  @State abilityNameAppStore: string = 'EntryFormAbility';
  @State moduleNameAppStore: string = 'entry';
  @State formNameAppStore: string = 'widget';
  @State dimensionAppStore: FormDimension = FormDimension.Dimension_2_2;
  @State formIdAppStore: number = 0;
  @State addArkTsButtonId: string = 'addArkTsCard';
  @State addJsButtonId: string = 'addJsCard';

  build() {
    Row() {
      Column() {
        Button() {
          Text($r('app.string.add_arkTsCard'))
            .fontColor(Color.White)
            .fontSize(17)
        }
        .id(this.addArkTsButtonId)
        .width(220)
        .height(60)
        .onClick(() => {
          let want = {
            abilityName: 'EntryFormAbility',
            parameters: {
              'ohos.extra.param.key.form_dimension': FormDimension.Dimension_2_2,
              'ohos.extra.param.key.form_name': 'widget',
              'ohos.extra.param.key.module_name': 'entry'
            }
          };
          let weather = [
            { 'city': '沈阳', 'temperature': '-10 ℃' },
            { 'city': '杭州', 'temperature': '10 ℃' }
          ];
          let infoData = {
            ['110000']: { weather: JSON.stringify(weather[0]) },
            ['310000']: { weather: JSON.stringify(weather[1]) }
          };
          let formData = JSON.stringify(infoData[conditionID]);
          let bindingData = formBindingData.createFormBindingData(formData);
          let proxies = [{key: 'weather', subscriberid: conditionID}];
          bindingData['proxies'] = proxies;
          Logger.debug(`RequestPublishForm want: ${JSON.stringify(want)}`);
          Logger.debug(`RequestPublishForm bindingData: ${JSON.stringify(bindingData)}`);
          formProvider.requestPublishForm(want, bindingData).then((str) => {
            Logger.debug(`RequestPublishForm success : ${str}`);
          }).catch((err) => {
            Logger.debug(`RequestPublishForm failed : ${err}`);
          });
          Logger.debug('=====> want is ' + JSON.stringify(want));
        })
        Text("")
          .height(25)
        Button() {
          Text($r('app.string.add_jsCard'))
            .fontColor(Color.White)
            .fontSize(17)
        }
        .id(this.addJsButtonId)
        .width(220)
        .height(60)
        .onClick(() => {
          let want = {
            abilityName: 'EntryFormAbility',
            parameters: {
              'ohos.extra.param.key.form_dimension': FormDimension.Dimension_2_2,
              'ohos.extra.param.key.form_name': 'JsWidget',
              'ohos.extra.param.key.module_name': 'entry'
            }
          };
          let weather = [
            { 'city': '沈阳', 'temperature': '-10 ℃' },
            { 'city': '杭州', 'temperature': '10 ℃' }
          ];
          let infoData = {
            ['110000']: { weather: JSON.stringify(weather[0]) },
            ['310000']: { weather: JSON.stringify(weather[1]) }
          };
          let formData = JSON.stringify(infoData[conditionID]);
          let bindingData = formBindingData.createFormBindingData(formData);
          let proxies = [{key: 'weather', subscriberid: conditionID}];
          bindingData['proxies'] = proxies;
          Logger.debug(`RequestPublishForm want: ${JSON.stringify(want)}`);
          Logger.debug(`RequestPublishForm bindingData: ${JSON.stringify(bindingData)}`);
          formProvider.requestPublishForm(want, bindingData).then((str) => {
            Logger.debug(`RequestPublishForm success : ${str}`);
          }).catch((err) => {
            Logger.debug(`RequestPublishForm failed : ${err}`);
          });
          Logger.debug('=====> want is ' + JSON.stringify(want));
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}