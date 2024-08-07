/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';
import { NormalButtonComponent } from './component/normalButtonComponent';
import { HeadComponent, HeadComponentController } from './component/headComponent';
import { CommonEventValue } from '../utils/CommonEventValue';
import { promptAction } from '@kit.ArkUI';
import { CommonEventManagerHelper } from '../utils/CommonEventManagerHelper';
import { common } from '@kit.AbilityKit';
import { DataPreferencesHelper } from '../utils/DataPreferencesHelper';

@Entry
@Component
struct MainPage {
  @State wifiStatus: string | Resource =  $r('app.string.enabled');
  @State activeStatus: string | Resource = $r('app.string.no_active');
  @State result: string = '';
  private controller: HeadComponentController = {
    title: $r('app.string.app_name'),
    needBack: true
  };
  private isFirstActivated = true;
  private commonEventManagerHelper = new CommonEventManagerHelper();
  private context = getContext(this) as common.UIAbilityContext;
  private dataPreferenceHelper: DataPreferencesHelper | null = null;
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      CommonEventValue.EVENT_RESULT,
    ],
  };

  aboutToAppear(): void {
    if (this.dataPreferenceHelper == null) {
      this.dataPreferenceHelper = new DataPreferencesHelper(this.context.getApplicationContext());
    }
    let activeStatus = this.dataPreferenceHelper.get(DataPreferencesHelper.EXTRA_ACTIVE_STATUS, '');
    if (activeStatus.length != 0) {
      this.activeStatus = activeStatus;
      this.isFirstActivated = false;
    }
    this.handleResult();
    this.emitEvent(CommonEventValue.EVENT_QUERY_WIFI_STATUS);
  }

  private isNeedToShowToast(action: () => void) {
    if (this.isFirstActivated) {
      promptAction.showToast({
        message: $r('app.string.please_use_hdc_active_device'),
        duration: 2000
      });
    } else {
      action();
    }
  }

  private handleResult() {
    this.commonEventManagerHelper.createSubscriber(this.subscribeInfo, (err, data) => {
      switch (data.code) {
        case CommonEventValue.STATUS_ACTIVE:
          this.activeStatus = data.data as string;
          this.isFirstActivated = false;
          break;
        case CommonEventValue.STATUS_WIFI:
          this.wifiStatus = data.data as string;
          break;
        case CommonEventValue.STATUS_RESULT:
          this.result = data.data as string;
          break;
      }
    });
  }

  aboutToDisappear(): void {
    this.commonEventManagerHelper.unsubscribe();
  }

  private async emitEvent(event: string) {
    commonEventManager.publish(event, (err: BusinessError) => {
      if (err) {
        Logger.error(`PublishCallBack err = ${JSON.stringify(err)}`);
      } else {
        Logger.info(`Publish success`);
      }
    });
  }

  build() {
    Column() {
      HeadComponent({
        controller: this.controller
      })
      Row() {
        Flex({ alignItems: ItemAlign.Start }) {
          Text($r('app.string.active_status'))
            .fontSize(15)
            .margin({ left: 10 })
            .maxLines(1)
            .width(120)
          Text(this.activeStatus)
            .fontSize(15)
        }
      }
      .margin({ top: 15 })

      Row() {
        Flex({ alignItems: ItemAlign.Center }) {
          NormalButtonComponent({ btnText: $r('app.string.enable_admin') })
            .onClick(() => {
              promptAction.showToast({
                message: $r('app.string.please_use_hdc_active_device'),
                duration: 2000
              });
            })
            .margin({ right: 5 })
            .id('enable_admin_id')

          NormalButtonComponent({ btnText: $r('app.string.disable_admin') })
            .onClick(() => {
              this.isNeedToShowToast(() => {
                this.emitEvent(CommonEventValue.EVENT_DISABLE_ADMIN);
              });
            })
            .margin({ left: 5 })
            .id('disable_admin_id')
        }
        .margin({ left: 10, right: 10 })
      }
      .margin({ top: 15 })

      Row() {
        Flex({ alignItems: ItemAlign.Start }) {
          Text($r('app.string.current_wifi_status'))
            .fontSize(15)
            .margin({ left: 10 })
            .maxLines(1)
            .width(120)
          Text(this.wifiStatus)
            .fontSize(15)
        }
      }
      .margin({ top: 15 })

      Row() {
        Flex({ alignItems: ItemAlign.Center }) {
          NormalButtonComponent({ btnText: $r('app.string.enable_wifi') })
            .onClick(() => {
              this.isNeedToShowToast(() => {
                this.emitEvent(CommonEventValue.EVENT_ENABLE_WIFI);
              });
            })
            .margin({ right: 5 })
            .id('enable_wifi_id')

          NormalButtonComponent({ btnText: $r('app.string.disable_wifi') })
            .onClick(() => {
              this.isNeedToShowToast(() => {
                this.emitEvent(CommonEventValue.EVENT_DISABLE_WIFI);
              });
            })
            .margin({ left: 5 })
            .id('disable_wifi_id')
        }
        .margin({ left: 10, right: 10 })
      }
      .margin({ top: 15 })

      Row() {
        Flex({ alignItems: ItemAlign.Start }) {
          Text($r('app.string.operate_device'))
            .fontSize(15)
            .margin({ left: 10 })
            .maxLines(1)
            .width(120)
        }
      }
      .margin({ top: 15 })

      Row() {
        NormalButtonComponent({ btnText: $r('app.string.reboot') })
          .onClick(() => {
            this.isNeedToShowToast(() => {
              this.emitEvent(CommonEventValue.EVENT_REBOOT);
            });
          })
          .margin({ left: 10, right: 10 })
          .id('reboot_device_id')
      }
      .margin({ top: 15 })

      Row() {
        Flex({ alignItems: ItemAlign.Start }) {
          Text($r('app.string.execute_result'))
            .fontSize(15)
            .margin({ left: 10 })
            .maxLines(1)
            .width(50)
          Text(this.result)
            .fontSize(15)
        }
      }
      .margin({ top: 15 })
    }.backgroundColor($r('sys.color.white'))
  }
}