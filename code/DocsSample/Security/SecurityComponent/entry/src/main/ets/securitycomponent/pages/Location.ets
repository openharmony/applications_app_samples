/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { geoLocationManager } from '@kit.LocationKit';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

// 获取当前位置信息
function getCurrentLocationInfo() {
  const requestInfo: geoLocationManager.LocationRequest = {
    'priority': geoLocationManager.LocationRequestPriority.FIRST_FIX,
    'scenario': geoLocationManager.LocationRequestScenario.UNSET,
    'timeInterval': 1,
    'distanceInterval': 0,
    'maxAccuracy': 0
  };
  try {
    geoLocationManager.getCurrentLocation(requestInfo)
      .then((location: geoLocationManager.Location) => {
        promptAction.showToast({ message: JSON.stringify(location) });
      })
      .catch((err: BusinessError) => {
        console.error(`Failed to get current location. Code is ${err.code}, message is ${err.message}`);
        promptAction.showToast({ message: $r('app.string.get_location_failed') });
      });
  } catch (err) {
    console.error(`Failed to get current location. Code is ${err.code}, message is ${err.message}`);
    promptAction.showToast({ message: $r('app.string.get_location_failed') });
  }
}

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column({ space: 10 }) {
        LocationButton({
          icon: LocationIconStyle.LINES,
          text: LocationDescription.CURRENT_LOCATION,
          buttonType: ButtonType.Normal
        })
          .padding({
            top: 12,
            bottom: 12,
            left: 24,
            right: 24
          })
          .onClick((event: ClickEvent, result: LocationButtonOnClickResult) => {
            if (result === LocationButtonOnClickResult.SUCCESS) {
              // 免去权限申请和权限请求等环节，获得临时授权，获取位置信息授权
              getCurrentLocationInfo();
            } else {
              promptAction.showToast({ message: $r('app.string.get_location_failed') });
            }
          })
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor(0xF1F3F5)
  }
}