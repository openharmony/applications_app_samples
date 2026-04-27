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
import { CustomDialogContentStyle, SettingItemStyle } from '../../common/constants/StyleConstants';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { KeyCode } from '../../common/constants/KeyCode';
import { Ratio } from '../../common/Ratio';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import aboutDeviceModel from '../../model/aboutDeviceImpl/AboutDeviceModel';
import promptAction from '@ohos.promptAction';
import settings from '@ohos.settings';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { Duration } from '../../common/constants/Duration';

const TAG = 'systemInfo'

/**
 * 设备信息
 */
@Entry
@Component
struct systemInfo {
  @State imageUrl: string = Ratio.resName('icon_system')
  @State des: string = '系统信息'
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  @StorageLink('deviceName') deviceName: string = ''
  @State originalDeviceName: string = ''
  private content: DialogContent = new DialogContent('设备名称', this.deviceName, '', '', 692, 400);
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: (): void => this.onCancel(),
      confirm: (): void => this.onConfirm(),
      content: this.content,
      contentStyle: CustomDialogContentStyle.titleInput
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  onConfirm() {
    if (this.content.getTextInputValue() == '') {
      promptAction.showToast({ message: '设备名称无变化' })
      return;
    }
    if (this.content.getTextInputValue().length > 30) {
      promptAction.showToast({
        message: '自定义名称超长',
        duration: 2000,
        bottom: globalThis.screenHeight / 4
      })
      return;
    }
    aboutDeviceModel.setDeviceName(this.content.getTextInputValue());
    this.deviceName = this.content.getTextInputValue()
    this.content.content = this.deviceName
    AppStorage.setOrCreate('deviceName', this.deviceName)
    this.settingList[1].setChooseDes(this.deviceName)
    settings.setValueSync(
      getContext(),
      settings.general.DEVICE_NAME,
      this.deviceName,
      settings.domainName.DEVICE_SHARED
    )
    systemParameterEnhance.setSync('persist.dlnadmr.friendlyname', this.deviceName)
    this.dialogController.close();
  }

  onCancel() {
    this.dialogController.close();
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  aboutToAppear() {
    this.getDeviceName()
    let item1 = new SettingItemTvModel()
    item1.name = '型号'
    item1.chooseDes = aboutDeviceModel.getDeviceName();
    item1.style = SettingItemStyle.info
    let item2 = new SettingItemTvModel()
    item2.name = '设备名称'
    item2.chooseDes = this.deviceName;
    item2.style = SettingItemStyle.default
    let item3 = new SettingItemTvModel()
    item3.name = '版本号'
    item3.chooseDes = aboutDeviceModel.getSoftwareVersion();
    item3.style = SettingItemStyle.info
    this.settingList.push(item1, item2, item3);

    this.content.content = this.deviceName

  }

  getDeviceName() {
    let deviceName =
      settings.getValueSync(getContext(), settings.general.DEVICE_NAME, '', settings.domainName.DEVICE_SHARED)
    if (deviceName !== '') {
      this.deviceName = deviceName
    } else {
      this.deviceName = aboutDeviceModel.getDeviceName()
    }
  }

  build() {
    Column() {
      Stack() {
        SettingBackground()
          .position({ x: 0, y: 0 })
          .height(ConfigData.WH_100_100)
          .width(ConfigData.WH_100_100)

        Row() {
          SettingListTvComponent({
            settingList: this.settingList,
            isAlignCenter: true,
            title: '系统信息',
            onMouseClickHandle: (item: SettingItemTvModel) => {
              if (item.name == '设备名称'){
                this.dialogController.open();
              }
            },
          })
            .width(ConfigData.WH_100_100)
            .height(ConfigData.WH_100_100)
            .margin(0)

        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}



