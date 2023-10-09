/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
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
import Logger from '../../utils/Logger';

let context: common.Context;

@Component
export struct SecLocationButton {
  @State message: string = '';
  @Link location: string;

  @State textTitle: string = '';
  @State textValue: string = '';
  @State backColor: Resource = $r('app.color.button_default_bg_color');
  @State textColor: Resource = $r('app.color.start_window_background');
  @State image: Resource = $r('app.media.position');

  aboutToDisappear() {
    try {
      context.resourceManager.getStringByName("User_authorized").then(value => {
        this.textTitle = value;
      }).catch ((error: string) => {
        Logger.info('promise, getCurrentLocation: error=' + error);
      });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      Logger.error(`promise getStringByName failed, error code: ${e.code}, message: ${e.message}.`);
    }
    try {
      context.resourceManager.getStringByName("Loading_positioning").then(value => {
        this.textValue = value;
      }).catch ((error: string) => {
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
        this.location = JSON.stringify(result);
      }).catch ((error: string) => {
          this.promptAction(JSON.stringify(error));
          Logger.info('promise, getCurrentLocation: error=' + JSON.stringify(error));
        });
    } catch (error) {
      this.promptAction(JSON.stringify(error.message));
      let e: BusinessError = error as BusinessError;
      Logger.error(`promise getStringByName failed, error code: ${e.code}, message: ${e.message}.`);
    }
  }

  promptAction( message : string ) {
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
    Row() {
      LocationButton()
        .onClick((event: ClickEvent, result: LocationButtonOnClickResult) => {
          if(result == LocationButtonOnClickResult.SUCCESS){
            this.getLocation();
          }
          Logger.error('SecLocationButton onClick result ' + result);
        })
    }
    .id('locationButton')
  }
}
