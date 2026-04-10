/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { SettingBackground } from '../../default/layout/SettingBackground';
import { Ratio } from '../../common/Ratio';
import router from '@ohos.router';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { KeyCode } from '../../common/constants/KeyCode';
import lpx from '../../common/Lpx';
import { CustomDialogContentStyle } from '../../common/constants/StyleConstants';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import RestoreFactorySettingsController from '../../controller/restoreFactorySettings/RestoreFactorySettingsController';
import promptAction from '@ohos.promptAction';
import update from '@ohos.update';
import { Duration } from '../../common/constants/Duration';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG = 'System'

/**
 * 系统设置
 */

@Entry
@Component
struct System {
  @State imageUrl: string = Ratio.resName('icon_system')
  @State des: string | Resource = $r('app.string.software_update')
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  private resetController: RestoreFactorySettingsController = new RestoreFactorySettingsController();
  private content: DialogContent =
    new DialogContent('确认恢复出厂设置？', '此操作会将系统设置参数恢复至默认值', '', '', 692, 332);
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: (): void => this.cancelReset(),
      confirm: (): void => this.resetDevice(),
      content: this.content,
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })
  private upgradeInfo: update.UpgradeInfo = {
    upgradeApp: 'com.ohos.settings',
    businessType: {
      vendor: update.BusinessVendor.PUBLIC,
      subType: 1
    }
  };
  private otaUpdater: update.Updater = update.getOnlineUpdater(this.upgradeInfo);
  private pageTranState: boolean = false; //判断是进场动效还是出场动效
  resetDevice() {
    try {
      LogUtil.info(TAG + `RestoreFactory:restore factory settiigns begin.....`)
      this.resetController.restoreFactorySettings();
      LogUtil.info(TAG + `RestoreFactory:restore factory settings end.....`)
    } catch (err) {
      LogUtil.info(TAG + 'RestoreFactory:resetDevice error' + JSON.stringify(err));
      promptAction.showToast({
        message: '恢复出厂设置失败'
      })
    } finally {
      this.dialogController.close();
    }
  }

  cancelReset() {
    this.dialogController.close();
  }

  onPageHide(): void {
    this.pageTranState = false
  }

  pageTransition() {
    if (this.pageTranState) {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
    } else {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
    }
  }

  // 获取当前版本信息
  getCurrentVersionInfo() {
    let versionInfo: string | Resource = ''
    try {
      let res = systemParameterEnhance.getSync('const.product.software.version')
      versionInfo = getContext(this).resourceManager.getStringByNameSync('current_version') + '：' + res
    } catch (err) {
      versionInfo = $r('app.string.software_update');
      LogUtil.error(TAG + '系统版本未获取到' + JSON.stringify(err))
    }
    return versionInfo
  }

  aboutToAppear() {
    LogUtil.info(TAG + 'SystemSettings EntryComponent aboutToAppear in');

    let setting1 = new SettingItemTvModel()
    setting1.name = '软件更新'
    setting1.pageUrl = 'pages/system/SoftwareUpdate';
    setting1.description = $r('app.string.software_update');
    setting1.description = this.getCurrentVersionInfo()

    let setting2 = new SettingItemTvModel()
    setting2.name = '时间和日期'
    setting2.pageUrl = 'pages/system/TimeAndDate'
    setting2.description = $r('app.string.set_system_time_and_date');

    let setting3 = new SettingItemTvModel()
    setting3.name = '恢复出厂设置'
    setting3.description = $r('app.string.restore_to_factory_settings_and_information');

    let setting4 = new SettingItemTvModel();
    setting4.name = '系统信息';
    setting4.pageUrl = 'pages/system/SystemInfo'
    setting4.description = $r('app.string.view_system_information');

    let setting5 = new SettingItemTvModel();
    setting5.name = '设备信息';
    setting5.pageUrl = 'pages/system/DeviceInfo'
    setting5.description = $r('app.string.view_device_information');

    let setting6 = new SettingItemTvModel();
    setting6.name = '状态信息';
    setting6.pageUrl = 'pages/system/StateInfo'
    setting6.description = $r('app.string.view_status_information');

    this.settingList.push(setting1, setting2, setting3, setting4, setting5, setting6)
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        SettingListTvComponent({
          settingList: this.settingList,
          title: '系统',
          onMouseClickHandle:(item: SettingItemTvModel)=>{
            if (item.name == '恢复出厂设置') {
              this.dialogController.open();
            } else {
              router.pushUrl({ url: item.pageUrl }, router.RouterMode.Single)
              this.pageTranState = true
            }
          },
          onFocusHandle: (item: SettingItemTvModel) => {
            this.des = item.description;
          }
        })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
          .margin({ left: lpx(84) })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
