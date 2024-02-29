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

import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent';
import common from '@ohos.app.ability.common';
import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager';
import { BusinessError } from '@ohos.base';
import geolocation from '@ohos.geoLocationManager';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import notificationManager from '@ohos.notificationManager';

const TAG: string = 'BackgroundLocation';

@Component
export struct LongTermTaskView {
  @State latitude: number = 0;
  @State longitude: number = 0;

  aboutToAppear() {
    notificationManager.requestEnableNotification().then(() => {
      console.info(`requestEnableNotification success`);
      let atManager = abilityAccessCtrl.createAtManager();
      try {
        // 定位需要先单独申请APPROXIMATELY_LOCATION权限
        atManager.requestPermissionsFromUser(getContext(this), ['ohos.permission.APPROXIMATELY_LOCATION'])
          .then((data) => {
            console.info(`data: ${JSON.stringify(data)}`);
            atManager.requestPermissionsFromUser(getContext(this), ['ohos.permission.INTERNET',
              'ohos.permission.LOCATION',
              'ohos.permission.LOCATION_IN_BACKGROUND'])
              .then((data) => {
                console.info(`data: ${JSON.stringify(data)}`);
              })
              .catch((err: BusinessError) => {
                console.info(`err: ${JSON.stringify(err)}`);
              })
          })
          .catch((err: BusinessError) => {
            console.info(`err: ${JSON.stringify(err)}`);
          })
      } catch (err) {
        console.info(`catch err->${JSON.stringify(err)}`);
      }
    }).catch((err: BusinessError) => {
      console.error(`requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
    });
  }

  // 位置变化回调
  locationChange = async (location: geolocation.Location) => {
    console.info(TAG, `locationChange location =${JSON.stringify(location)}`);
    this.latitude = location.latitude;
    this.longitude = location.longitude;
  }

  // 获取定位
  async getLocation() {
    console.info(TAG, `enter getLocation`);
    let requestInfo: geolocation.LocationRequest = {
      priority: geolocation.LocationRequestPriority.FIRST_FIX, // 快速获取位置优先
      scenario: geolocation.LocationRequestScenario.UNSET, // 未设置场景信息
      timeInterval: 1, // 上报位置信息的时间间隔
      distanceInterval: 0, // 上报位置信息的距离间隔
      maxAccuracy: 100 // 精度信息
    };
    console.info(TAG, `on locationChange before`);
    geolocation.on('locationChange', requestInfo, this.locationChange);
    console.info(TAG, `on locationChange end`);
  }

  // 开始长时任务
  startContinuousTask() {
    let context: Context = getContext(this);
    // 通知参数，指定点击长时任务通知后跳转的应用
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: (context as common.UIAbilityContext).abilityInfo.bundleName,
          abilityName: (context as common.UIAbilityContext).abilityInfo.name
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };
    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
      backgroundTaskManager.startBackgroundRunning(context,
        backgroundTaskManager.BackgroundMode.LOCATION, wantAgentObj).then(() => {
        console.info(`Succeeded in operationing startBackgroundRunning.`);
      }).catch((err: BusinessError) => {
        console.error(`Failed to operation startBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
      });
    });
  }

  // 停止长时任务
  stopContinuousTask() {
    backgroundTaskManager.stopBackgroundRunning(getContext()).then(() => {
      console.info(`Succeeded in operationing stopBackgroundRunning.`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to operation stopBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
    });
  }

  build() {
    Column() {
      Column() {
        Text(this.latitude.toString())
        Text(this.longitude.toString())
      }
      .width('100%')

      Column() {
        Button('开启定位服务')
          .onClick(() => {
            this.startContinuousTask();
            this.getLocation();
          })
        Button('关闭定位服务')
          .onClick(async () => {
            await geolocation.off('locationChange');
            this.stopContinuousTask();
          })
          .margin({ top: 10 })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

