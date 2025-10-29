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

// [Start a_pop_up_window_is_used_to_notify_the_app_side_location_permission_request_message]
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';

let atManager = abilityAccessCtrl.createAtManager();

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  uiContext: UIContext = this.getUIContext();

  // 组件的生命周期函数，创建组件实例后触发
  aboutToAppear(): void {
    let context : Context | undefined = this.uiContext.getHostContext() as common.UIAbilityContext;
    if (!context) {
      console.error("context is undefined");
      return;
    }
    // 向用户请求位置权限，对整个应用生效
    atManager.requestPermissionsFromUser(context, ['ohos.permission.APPROXIMATELY_LOCATION']).then((data) => {
      console.info('data:' + JSON.stringify(data));
      console.info('data permissions:' + data.permissions);
      console.info('data authResults:' + data.authResults);
    }).catch((error: BusinessError) => {
      console.error(`Failed to request permissions from user. Code is ${error.code}, message is ${error.message}`);
    })  
  }

  build() {
    Column() {
      // Web组件的geolocationAccess属性默认为true，可以显式配置为false以禁止Web组件获取地理位置信息
      Web({ src: $rawfile('getLocation.html'), controller: this.controller })
        .geolocationAccess(true)
        .onGeolocationShow((event) => {
          // 位置权限申请通知仅对当前Web组件生效，应用内的其他Web组件不受影响
          this.uiContext.showAlertDialog({
            title: '位置权限请求',
            message: '是否允许获取位置信息',
            primaryButton: {
              value: 'cancel',
              action: () => {
                if (event) {
                  // 不允许此站点位置权限请求
                  // 注意invoke的第3个参数表示是否记住当前选择，如果传true，则下次不再弹框
                  event.geolocation.invoke(event.origin, false, false);
                }
              }
            },
            secondaryButton: {
              value: 'ok',
              action: () => {
                if (event) {
                  // 允许此站点位置权限请求
                  // 注意invoke的第3个参数表示是否记住当前选择，如果传true，则下次不再弹框
                  event.geolocation.invoke(event.origin, true, false);
                }
              }
            },
            cancel: () => {
              if (event) {
                // 不允许此站点位置权限请求
                // 注意invoke的第3个参数表示是否记住当前选择，如果传true，则下次不再弹框
                event.geolocation.invoke(event.origin, false, false);
              }
            }
          })
        })
    }
  }
}
// [End a_pop_up_window_is_used_to_notify_the_app_side_location_permission_request_message]