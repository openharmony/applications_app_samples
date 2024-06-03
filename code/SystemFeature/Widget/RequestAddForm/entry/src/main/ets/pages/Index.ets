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

import base from '@ohos.base';
import formProvider from '@ohos.app.form.formProvider';
import formBindingData from '@ohos.app.form.formBindingData';
import Want from '@ohos.app.ability.Want';
import Logger from '../logger/Logger';

let conditionID = '110000';

@Entry
@Component
struct Index {
  @State abilityName: string = 'EntryFormAbility';
  @State addArkTsButtonId: string = 'addArkTsCard';
  @State addJsButtonId: string = 'addJsCard';

  build() {
    Row() {
      Column() {
        Button() {
          Text($r('app.string.add_arkTsCard'))
            .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .fontWeight(FontWeight.Bold)
        }
        .id(this.addArkTsButtonId)
        .width(220)
        .height(40)
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_component_activated'))
        .onClick(() => {
          let want: Want = {
            abilityName: 'EntryFormAbility',
            parameters: {
              'ohos.extra.param.key.form_dimension': FormDimension.Dimension_2_2,
              'ohos.extra.param.key.form_name': 'widget',
              'ohos.extra.param.key.module_name': 'entry'
            }
          };
          let bindingData = formBindingData.createFormBindingData();
          let proxies = [{ key: 'weather', subscriberid: conditionID } as formBindingData.ProxyData];
          bindingData['proxies'] = proxies;
          Logger.debug(`RequestPublishForm want: ${JSON.stringify(want)}`);
          formProvider.requestPublishForm(want, bindingData).then((str: string) => {
            Logger.debug(`RequestPublishForm success : ${str}`);
          }).catch((err: base.BusinessError<void>) => {
            Logger.debug(`RequestPublishForm failed : ${err}`);
          });
          Logger.debug('=====> want is ' + JSON.stringify(want));
        })

        Button() {
          Text($r('app.string.add_jsCard'))
            .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .fontWeight(FontWeight.Bold)
        }
        .margin({
          top: 20
        })
        .id(this.addJsButtonId)
        .width(220)
        .height(40)
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_component_activated'))
        .onClick(() => {
          let want: Want = {
            abilityName: 'EntryFormAbility',
            parameters: {
              'ohos.extra.param.key.form_dimension': FormDimension.Dimension_2_2,
              'ohos.extra.param.key.form_name': 'JsWidget',
              'ohos.extra.param.key.module_name': 'entry'
            }
          };
          let bindingData = formBindingData.createFormBindingData();
          Logger.debug(`RequestPublishForm want: ${JSON.stringify(want)}`);
          formProvider.requestPublishForm(want, bindingData).then((str: string) => {
            Logger.debug(`RequestPublishForm success : ${str}`);
          }).catch((err: base.BusinessError<void>) => {
            Logger.debug(`RequestPublishForm failed : ${err}`);
          });
          Logger.debug('=====> want is ' + JSON.stringify(want));
        })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width('100%')
    }
    .height('100%')
  }
}