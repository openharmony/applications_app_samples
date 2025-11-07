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

// [Start navigation_index_import]
import { common } from '@kit.AbilityKit';
// [End navigation_index_import]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'NavigationIndex';
const DOMAIN = 0x0000;
// [Start navigation_index_component]
@Entry
@Component
struct NavigationIndex {
  @State hideAbility: string = 'hideAbility'

  build() {
    Row() {
      Column() {
        Text(this.hideAbility)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            let wantParam: Record<string, Object> = {
              'sceneType': 1,
              'destinationLatitude': 32.060844,
              'destinationLongitude': 118.78315,
              'destinationName': 'xx市xx路xx号',
              'destinationPoiIds': {
                1: '1001', // key为1代表花瓣地图，value需为花瓣地图POI
                2: '2002', // key为2代表高德地图，value需为高德地图POI
                3: '3003'  // key为3代表百度地图，value需为百度地图POI
              } as Record<number, string>,
              'originName': 'xx City xx Park',
              'originLatitude': 31.060844,
              'originLongitude': 120.78315,
              'originPoiIds': {
                1: '1101', // key为1代表花瓣地图，value需为花瓣地图POI
                2: '2202', // key为2代表高德地图，value需为高德地图POI
                3: '3303'  // key为3代表百度地图，value需为百度地图POI
              } as Record<number, string>,
              'vehicleType': 0
            };
            let abilityStartCallback: common.AbilityStartCallback = {
              onError: (code: number, name: string, message: string) => {
                hilog.error(DOMAIN, TAG, `onError code ${code} name: ${name} message: ${message}`);
              },
              onResult: (result) => {
                hilog.info(DOMAIN, TAG, `onResult result: ${JSON.stringify(result)}`);
              }
            }

            context.startAbilityByType('navigation', wantParam, abilityStartCallback,
              (err) => {
                if (err) {
                  hilog.error(DOMAIN, TAG, `startAbilityByType fail, err: ${JSON.stringify(err)}`);
                } else {
                  hilog.info(DOMAIN, TAG, `success`);
                }
              });
          });
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End navigation_index_component]