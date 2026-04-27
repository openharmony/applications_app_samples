/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

//import Window from '@ohos.window';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import HeadComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import AppItemComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/appItemComponent';
import SwitchComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/switchComponent';
import SlotLstComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/slotLstComponent';
import ConfigData from '../common/constants';
import { router as Router } from '@kit.ArkUI'
import notificationListener, { EnableListener }
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/notificationListener';
import { notificationManager } from '@kit.NotificationKit';
import { AppInfo } from '../vm/notificationManagenmentViewModel'

const TAG = 'NotificationManagement-SetEnable';

let appInfo: AppInfo;

@Entry
@Component
export default struct SetEnable {
  // private listeners: EnableListener[] = [];
  @State headName:Resource = $r('app.string.notificationManagement');
  @State allowNotice:Resource = $r('app.string.allowNotification');
  @State slotLst: notificationManager.NotificationSlot[] = [];
  @State initState: boolean = false;
  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
        GridContainer({
          columns: 12,
          sizeType: SizeType.Auto,
          gutter: vp2px(1) === 2 ? '12vp' : '0vp',
          margin: vp2px(1) === 2 ? '12vp' : '0vp'
        }) {
          Row() {
            Column() {
              HeadComponent({ headName: $headName, isActive: true });
              Row() {
                AppItemComponent({
                  appIcon: appInfo.appIcon,
                  appTitle: appInfo.appTitle,
                  appSummary: appInfo.appSummary,
                  appValue: 0,
                  appArrow: appInfo.appArrow,
                  appArrowStyle: '',
                  appUri: appInfo.appUri,
                  appBundleName: appInfo.appBundleName,
                  appUid: appInfo.appUid,
                  appSwitch: 2
                });
              }
              .margin({ top: $r('app.float.page_notice_part_margin_t'), right: $r('app.float.page_margin_r') })
              .padding({
                left: $r('sys.float.ohos_id_max_padding_start'),
                right: $r('sys.float.ohos_id_default_padding_end')
              })


              Row() {
                SwitchComponent({
                  title: $allowNotice,
                  initializationAction: (): Promise<boolean> => this.switchComponentInit(),
                  settingAction: (params): void => this.switchComponentSet(params),
                })
              }
              .margin({ top: $r('app.float.page_notice_title_margin_t')})
              .padding({
                left: $r('sys.float.ohos_id_default_padding_start'),
                right: $r('sys.float.ohos_id_default_padding_end')
              })
              .height($r('app.float.notice_row_height'))

              if (this.initState && this.slotLst?.length > 0) {
                Row() {
                  SlotLstComponent({ appInfo: appInfo ,slotLst: $slotLst})
                }
                .align(Alignment.Start)
              }
            }
            .width(ConfigData.WH_100_100)
            .height(ConfigData.WH_100_100)
            .useSizeType({
              xs: { span: 12, offset: 0 }, sm: { span: 12, offset: 0 },
              md: { span: 12, offset: 0 }, lg: { span: 8, offset: 2 }
            });
          }
          .width(ConfigData.WH_100_100)
          .height(ConfigData.WH_100_100);
        }
      }
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
    }
    .width(ConfigData.WH_100_100)
  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
    appInfo = JSON.parse(JSON.stringify(Router.getParams())) as AppInfo
    appInfo.slotSettingUrl = 'pages/slotSetting'
    notificationListener.subscribeEnableChanged();
    Log.showInfo(TAG, `aboutToAppear end`);
  }

  onPageShow (): void{
    Log.showInfo(TAG, `onPageShow`);
    notificationManager.getSlotsByBundle({ bundle: appInfo.appBundleName, uid: appInfo.appUid }, (err, data) => {
      this.slotLst  = [];
      data.forEach((val, idx, array) => {
        this.slotLst.push(val);
      })
    })
  }

  aboutToDisappear(): void{
    Log.showInfo(TAG, `aboutToDisappear`)
    this.slotLst  = [];
    notificationListener.unsubscribeEnableChanged();
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
  }

  switchComponentInit() {
    Log.showDebug(TAG, `switchComponentInit`)
    return notificationListener.isNotificationEnabled(
      { bundle: appInfo.appBundleName, uid: appInfo.appUid }, (data: boolean) => {
      Log.showDebug(TAG, 'switchComponentInit callback' + data);
      this.initState = data;
    });
  }

  switchComponentSet(params: boolean) {
    Log.showDebug(TAG, `switchComponentSet`)
    this.initState = params;
    notificationListener.enableNotification({ bundle: appInfo.appBundleName, uid: appInfo.appUid }, params);
  }
}