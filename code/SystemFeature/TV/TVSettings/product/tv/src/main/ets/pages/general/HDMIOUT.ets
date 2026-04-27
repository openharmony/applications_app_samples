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

import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { KeyCode } from '../../common/constants/KeyCode';
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { Duration } from '../../common/constants/Duration';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import promptAction from '@ohos.promptAction';
import hdmitxSetting from '@ohos.tvservice.hdmitxSetting';
const TAG = 'HDMIOUT'
interface HDMIOUTInfo {
  name: string;
  status: boolean;
  visibility: boolean;
}
@Entry
@Component
struct HDMIOUT {
  @State imageUrl: string = Ratio.resName('icon_inputsource')
  @State des: string = 'HDMI输出'
  @State settingList: SettingItemTvModel[] = []
  @State dynamicBacklight: boolean = false
  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  async aboutToAppear() {
    let getSupportUsbList: HDMIOUTInfo[] = AppStorage.get<HDMIOUTInfo[]>('GetSupportHDMIOUTList') || [];
    console.log(JSON.stringify(getSupportUsbList), 'hdmitxSetting GetSupportHDMIOUTList aboutToAppear')
    getSupportUsbList.forEach(item => {
      let model = new SettingItemTvModel();
      model.name = item.name;
      model.style = SettingItemStyle.switch;
      model.isOn = item.status; // 直接使用接口的状态
      this.settingList.push(model);
    })
  }
  async setAllHDMITXEnable(i: number, enable: boolean) {
    try {
      const setCecStatus: boolean = await hdmitxSetting.HDMITXEnable(i, enable);
      LogUtil.log(TAG + `hdmitxSetting.HDMITXEnable= SuccessBoolean${i}==:` + JSON.stringify(setCecStatus));
      if (!setCecStatus) {
        promptAction.showToast({ message: `设置HDMI${Number(i) + 1}输出开关失败` });
      }
    } catch (error) {
      LogUtil.log(TAG + `hdmitxSetting.HDMITXEnable fail=` + JSON.stringify(error));
      promptAction.showToast({ message: `设置HDMI${Number(i) + 1}输出接口报错` });
    }
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
          title: 'HDMI输出',
          onToggleChangedHandle: async (item: SettingItemTvModel, isOn?: boolean) => {
            console.log('hdmitxSetting enter')
            const index = this.settingList.findIndex(settingItem => settingItem.name === item.name);
            if (index !== -1) {
              const newState = this.settingList[index].isOn;
              if (item.name === 'HDMI1') {
                console.log(newState + '', 'hdmitxSetting  HDMI1')
                await this.setAllHDMITXEnable(0, newState);
              } else if (item.name === 'HDMI2') {
                console.log(newState + '', 'hdmitxSetting  HDMI2')
                await this.setAllHDMITXEnable(1, newState);
              } else if (item.name === 'HDMI3') {
                console.log(newState + '', 'hdmitxSetting  HDMI3')
                await this.setAllHDMITXEnable(2, newState);
              } else if (item.name === 'HDMI4') {
                console.log(newState + '', 'hdmitxSetting  HDMI4')
                await this.setAllHDMITXEnable(3, newState);
              }
            }
          },
          onKeyEventHandle: async (item: SettingItemTvModel, event: KeyEvent) => {
            if (event.type === KeyType.Down && event.keyCode === KeyCode.KEY_ENTER) {

            }
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
