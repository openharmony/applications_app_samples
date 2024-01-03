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

import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import geoLocationManager from '@ohos.geoLocationManager';
import promptAction from '@ohos.promptAction';
import Logger from '../utils/Logger';
import router from '@ohos.router';

let context: common.Context;

@Component
export struct LocationControl {
  @State latitude: number = 0;
  @State longitude: number = 0;
  @State str: string = '';
  @State message: string = '';
  @State textTitle: string = '';
  @State textValue: string = '';
  @StorageLink('location') storLocation: string = '';

  aboutToDisappear() {
    try {
      context.resourceManager.getStringByName("User_authorized").then(value => {
        this.textTitle = value;
      }).catch((error: string) => {
        Logger.info('promise, getCurrentLocation: error=' + error);
      });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      Logger.error(`promise getStringByName failed, error code: ${e.code}, message: ${e.message}.`);
    }
    try {
      context.resourceManager.getStringByName("Loading_positioning").then(value => {
        this.textValue = value;
      }).catch((error: string) => {
        Logger.info('promise, getCurrentLocation: error=' + JSON.stringify(error));
      });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      Logger.error(`promise getStringByName failed, error code: ${e.code}, message: ${e.message}.`);
    }
  }

  onCancel() {
    Logger.info('Callback when the first button is clicked');
  }

  getLocation(): void {
    let requestInfo: Record<string, number | boolean> = {
      'priority': geoLocationManager.LocationRequestPriority.FIRST_FIX,
      'scenario': geoLocationManager.LocationRequestScenario.UNSET,
      'maxAccuracy': 0,
    };
    try {
      // 得到当前定位信息经纬度
      geoLocationManager.getCurrentLocation(requestInfo).then((result) => {
        Logger.info('current location: ' + JSON.stringify(result));
        this.latitude = Number.parseInt(JSON.stringify(result.latitude))
        this.longitude = Number.parseInt(JSON.stringify(result.longitude))
        //得到当前经纬度的城市信息
        geoLocationManager.getAddressesFromLocation({
          "latitude": this.latitude,
          "longitude": this.longitude,
          "maxItems": 1
        }).then((outcome) => {
          this.str = JSON.stringify(outcome[0].subAdministrativeArea);
          Logger.info('current city' + JSON.stringify(outcome))
          this.str = this.str.replace("\"", "")
          this.storLocation = this.str.replace("\"", "")
        }).catch((error: string) => {
          this.promptAction(JSON.stringify(error));
          Logger.info('promise,getCurrentCity:error=' + JSON.stringify(error))
        });

      }).catch((error: string) => {
        this.promptAction(JSON.stringify(error));
        Logger.info('promise, getCurrentLocation: error=' + JSON.stringify(error));
      });
    } catch (error) {
      this.promptAction(JSON.stringify(error.message));
      let e: BusinessError = error as BusinessError;
      Logger.error(`promise getStringByName failed, error code: ${e.code}, message: ${e.message}.`);
    }
  }

  promptAction(message: string) {
    this.message = message;
    try {
      promptAction.showToast({
        message: message,
        duration: 60000,
      });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      Logger.error(`promise getStringByName failed, error code: ${e.code}, message: ${e.message}.`);
    }
  }

  build() {
    Column() {
      LocationButton({ icon: LocationIconStyle.FULL_FILLED, buttonType: ButtonType.Circle })
        .padding(15)
        .onClick((event: ClickEvent, result: LocationButtonOnClickResult) => {
          this.getLocation();
          router.pushUrl(
            {
              url: 'pages/SameCityListPage',
              params: {
                currentIndex: 1
              }
            }
          )
        })
    }
    .id('lcoationButton')
  }
}
