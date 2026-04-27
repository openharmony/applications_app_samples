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

import Log from '../../../../../../../common/src/main/ets/default/Log';
import HeadComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import AppItemComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/appItemComponent';
import SwitchComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/switchComponent';
import ConfigData from '../common/constants';
import NotificationConfigData
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/common/constants';
import { router as Router } from '@kit.ArkUI';
import NotificationListener
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/notificationListener';
import { notificationManager } from '@kit.NotificationKit';
import { AppInfo } from '../vm/notificationManagenmentViewModel'

const TAG = 'NotificationManagement-SlotSetting';
const DEFAULT_SOUND = 'file://system/etc/Light.ogg';

class SlotParams {
  public appInfo: AppInfo = new AppInfo();
  public slotInfo: notificationManager.NotificationSlot = {}
}

let slotParams: SlotParams;

@Entry
@Component
export default struct SlotSetting {
  private appInfo: AppInfo = new AppInfo();
  private slotInfo: notificationManager.NotificationSlot = {};
  @State headName: Resource = $r('app.string.notificationManagement')
  @State allowNotice: Resource = $r('app.string.allowNotification')
  @State noticeStyleBanner: Resource = $r('app.string.notificationStyle_banner')
  @State noticeSound: Resource = $r('app.string.notificationSound')
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
                  appIcon: this.appInfo.appIcon,
                  appTitle: this.appInfo.appTitle,
                  appSummary: this.appInfo.appSummary,
                  appValue: this.slotInfo.type,
                  appArrow: this.appInfo.appArrow,
                  appArrowStyle: '',
                  appUri: this.appInfo.appUri,
                  appBundleName: this.appInfo.appBundleName,
                  appUid: this.appInfo.appUid,
                  appSwitch: 3
                });
              }
              .margin({ top: $r('app.float.page_notice_part_margin_t') })
              .padding({
                left: $r('sys.float.ohos_id_max_padding_start'),
                right: $r('sys.float.ohos_id_default_padding_end')
              })

              Row() {
                SwitchComponent({
                  title: $allowNotice,
                  initializationAction: (): Promise<boolean> => this.notificationSlotEnableInit(),
                  settingAction: (params): void => this.notificationSlotEnableSet(params)
                })
              }
              .margin({ top: $r('app.float.page_notice_title_margin_t') })
              .padding({
                left: $r('sys.float.ohos_id_card_margin_start'),
                right: $r('sys.float.ohos_id_card_margin_end')
              })
              .height($r('app.float.notice_row_height'))

              Row() {
                Text($r('app.string.notificationStyle'))
                  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                  .fontSize($r('sys.float.ohos_id_text_size_body2'))
                  .fontWeight(FontWeight.Bold)
                  .width(NotificationConfigData.WH_100_100)
                  .maxLines(NotificationConfigData.MAX_LINES_1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .height($r('app.float.notice_title_height'))
              .padding({
                left: $r('sys.float.ohos_id_max_padding_start'),
                right: $r('sys.float.ohos_id_max_padding_end')
              })
              .margin({ top: $r('app.float.page_notice_part_margin_t') })
              .align(Alignment.Start)
              .visibility(this.initState ? Visibility.Visible : Visibility.Hidden);

              Row() {
                SwitchComponent({
                  title: $noticeStyleBanner,
                  initializationAction: (): Promise<boolean> => this.bannerEnableInit(),
                  settingAction: (params): void => this.bannerEnableSet(params)
                })
              }
              .padding({
                left: $r('sys.float.ohos_id_card_margin_start'),
                right: $r('sys.float.ohos_id_card_margin_end')
              })
              .margin({ top: $r('app.float.page_notice_title_margin_t') })
              .height($r('app.float.notice_row_height'))
              .visibility(this.initState ? Visibility.Visible : Visibility.Hidden);

              Row() {
                SwitchComponent({
                  title: $noticeSound,
                  initializationAction: (): Promise<boolean> => this.soundEnableInit(),
                  settingAction: (params): void => this.soundEnableSet(params)
                })
              }
              .padding({
                left: $r('sys.float.ohos_id_card_margin_start'),
                right: $r('sys.float.ohos_id_card_margin_end')
              })
              .margin({ top: $r('app.float.page_notice_row_margin_t') })
              .height($r('app.float.notice_row_height'))
              .visibility(this.initState ? Visibility.Visible : Visibility.Hidden);
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

  aboutToAppear(): void {
    slotParams = JSON.parse(JSON.stringify(Router.getParams())) as SlotParams;
    this.appInfo = slotParams.appInfo;
    this.slotInfo = slotParams.slotInfo
    Log.showDebug(TAG, `aboutToAppear  ${JSON.stringify(this.slotInfo)}`)
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
  }

  notificationSlotEnableInit() {
    Log.showDebug(TAG, `notificationSlotEnableInit`)
    return NotificationListener.isNotificationSlotEnabled({
      bundle: this.appInfo.appBundleName,
      uid: this.appInfo.appUid
    }, this.slotInfo.type,
      (data: boolean) => {
        Log.showInfo(TAG, 'notificationSlotEnableInit callback' + data);
        this.initState = data;
      });
  }

  notificationSlotEnableSet(data: boolean) {
    Log.showDebug(TAG, `notificationEnableSet data:${JSON.stringify(data)}`)
    this.initState = data;
    NotificationListener.enableNotificationSlot({
      bundle: this.appInfo.appBundleName,
      uid: this.appInfo.appUid
    }, this.slotInfo.type, data);
  }

  soundEnableInit(): Promise<boolean> {
    Log.showDebug(TAG, `soundEnableInit`)
    return new Promise((resolve, reject) => {
      let result: boolean = false;
      if (!!this.slotInfo.sound) {
        result = true;
      }
      resolve(result);
      Log.showInfo(TAG, `soundEnableInit state:${result}`)
    });
  }

  soundEnableSet(params: boolean) {
    Log.showDebug(TAG, `soundEnableSet params:${JSON.stringify(params)}`)
    if (!params) {
      this.slotInfo.sound = '';
      if (this.slotInfo.level != notificationManager.SlotLevel.LEVEL_HIGH) {
        this.slotInfo.level = notificationManager.SlotLevel.LEVEL_LOW;
      }
    } else {
      this.slotInfo.sound = DEFAULT_SOUND;
      if (this.slotInfo.level && this.slotInfo.level < notificationManager.SlotLevel.LEVEL_DEFAULT) {
        this.slotInfo.level = notificationManager.SlotLevel.LEVEL_DEFAULT
      }
    }
    this.notificationSlotSet();
  }

  bannerEnableInit(): Promise<boolean> {
    Log.showDebug(TAG, `bannerEnableInit`)
    return new Promise((resolve, reject) => {
      let result: boolean = false;
      if (this.slotInfo.level == notificationManager.SlotLevel.LEVEL_HIGH) {
        result = true;
      }
      Log.showInfo(TAG, `bannerEnableInit state:${result}`)
      resolve(result);
    });
  }

  bannerEnableSet(params: boolean) {
    Log.showDebug(TAG, `bannerEnableSet params:${JSON.stringify(params)}`)
    if (!params) {
      if (this.slotInfo.sound) {
        this.slotInfo.level = notificationManager.SlotLevel.LEVEL_DEFAULT;
      } else {
        this.slotInfo.level = notificationManager.SlotLevel.LEVEL_LOW;
      }
    } else {
      this.slotInfo.level = notificationManager.SlotLevel.LEVEL_HIGH;
    }
    this.notificationSlotSet();
  }

  notificationSlotSet() {
    Log.showDebug(TAG, `notificationSlotSet slotInfo:${JSON.stringify(this.slotInfo)}`)
    NotificationListener.notificationSlotSet({
      bundle: this.appInfo.appBundleName,
      uid: this.appInfo.appUid
    }, this.slotInfo);
  }
}