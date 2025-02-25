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

import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';

let context = getContext(this) as common.UIAbilityContext;
let atManager = abilityAccessCtrl.createAtManager();

// 向用户请求位置权限设置。
atManager.requestPermissionsFromUser(context, ['ohos.permission.APPROXIMATELY_LOCATION']).then((data) => {
  console.info('data:' + JSON.stringify(data));
  console.info('data permissions:' + data.permissions);
  console.info('data authResults:' + data.authResults);
}).catch((error: BusinessError) => {
  console.error(`Failed to request permissions from user. Code is ${error.code}, message is ${error.message}`);
})

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Web({ src: $rawfile('getLocation.html'), controller: this.controller })
        .geolocationAccess(true)
        .onGeolocationShow((event) => { // 地理位置权限申请通知
          AlertDialog.show({
            title: 'Location permission requests',
            message: 'Whether to allow access to location information',
            primaryButton: {
              value: 'cancel',
              action: () => {
                if (event) {
                  event.geolocation.invoke(event.origin, false, false); // 不允许此站点地理位置权限请求
                }
              }
            },
            secondaryButton: {
              value: 'ok',
              action: () => {
                if (event) {
                  event.geolocation.invoke(event.origin, true, false); // 允许此站点地理位置权限请求
                }
              }
            },
            cancel: () => {
              if (event) {
                event.geolocation.invoke(event.origin, false, false); // 不允许此站点地理位置权限请求
              }
            }
          })
        })
    }
  }
}
