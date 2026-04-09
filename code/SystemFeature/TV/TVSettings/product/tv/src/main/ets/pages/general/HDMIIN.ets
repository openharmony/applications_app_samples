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
import displaySetting from '@ohos.tvservice.displaySetting';
const TAG = 'HDMIIN'
interface HDMIINInfo {
  name: string;
  status: boolean;
  visibility: boolean;
}
@Entry
@Component
struct HDMIIN {
  @State imageUrl: string = Ratio.resName('icon_inputsource')
  @State des: string = 'HDMI输入'
  @State settingList: SettingItemTvModel[] = []
  @State dynamicBacklight: boolean = false
  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  async aboutToAppear() {
    let getSupportUsbList: HDMIINInfo[] = AppStorage.get<HDMIINInfo[]>('GetSupportHDMIINList') || [];
    console.log(JSON.stringify(getSupportUsbList), 'displaySetting GetSupportHDMIINList aboutToAppear')
    getSupportUsbList.forEach(item => {
      let model = new SettingItemTvModel();
      model.name = item.name;
      model.style = SettingItemStyle.switch;
      model.isOn = item.status; // 直接使用接口的状态
      this.settingList.push(model);
    })
  }
  async setAllHDMITXEnable(i:number,enable:boolean) {
    try {
      const setCecStatus: boolean = await displaySetting.HDMIRXEnable(i,enable);
      LogUtil.log(TAG + `displaySetting.HDMIRXEnable= SuccessBoolean${i}==:` + JSON.stringify(setCecStatus));
      // 更新状态对象
      if(!setCecStatus){
        promptAction.showToast({ message: `设置HDMI${Number(i)}输入开关失败` });
      }
    } catch (error) {
      LogUtil.log(TAG + `displaySetting.HDMIRXEnable= fail=` + JSON.stringify(error));
      promptAction.showToast({ message: `设置HDMI${Number(i)}输入接口报错` });
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
          title: 'HDMI输入',
          onToggleChangedHandle:async (item: SettingItemTvModel, isOn?: boolean)=> {
            console.log('displaySetting enter')
            // 获取当前项的索引
            const index = this.settingList.findIndex(settingItem => settingItem.name === item.name);
            if (index !== -1) {
              // 切换开关状态：当前是开就关，当前是关就开
              const newState = this.settingList[index].isOn;
              if (item.name === 'HDMI1') {
                console.log(newState + '', 'displaySetting  HDMI1')
                await this.setAllHDMITXEnable(1, newState);
              } else if (item.name === 'HDMI2') {
                console.log(newState + '', 'displaySetting  HDMI2')
                await this.setAllHDMITXEnable(2, newState);
              } else if (item.name === 'HDMI3') {
                console.log(newState + '', 'displaySetting  HDMI3')
                await this.setAllHDMITXEnable(3, newState);
              } else if (item.name === 'HDMI4') {
                console.log(newState + '', 'displaySetting  HDMI4')
                await this.setAllHDMITXEnable(4, newState);
              }
            }
          },
          onKeyEventHandle: async (item: SettingItemTvModel, event: KeyEvent) => {
            if (event.type == KeyType.Down && event.keyCode == KeyCode.KEY_ENTER) {

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
