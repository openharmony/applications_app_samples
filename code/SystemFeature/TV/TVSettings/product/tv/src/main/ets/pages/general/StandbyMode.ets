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

import { BusinessError } from '@kit.BasicServicesKit';
import { KeyCode } from '../../common/constants/KeyCode';
import { Ratio } from '../../common/Ratio';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingBackground } from '../../default/layout/SettingBackground';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { PreferencesUtil } from '../../staticSubscriber/PreferencesUtil';
import { Duration } from '../../common/constants/Duration';
import lpx from '../../common/Lpx';
import { commonEventScreenOffTimeDataFunc, commonScreenOffTimeEvents } from '../../MainAbility/MainAbility';
import settings from '@ohos.settings';
import { PowerConfigJson, suspendSourcesManager ,SuspendSource} from '../../common/SuspendSourcesManager';

const TAG = '[StandbyMode]'
const SETTING_POWER_SUSPEND_SOURCES_KEY: string = 'settings.power.suspend_sources';
@Entry
@Component
struct StandbyMode {
  context= getContext(this);
  itemParam: string = '0';
  imageUrl: string = Ratio.resName('standby_mode')
  mSuspendSourceArr: SuspendSource[] =[]

  @State standbyModeList: SettingItemTvModel[] = [];
  displayArr: string[] = [];

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
    .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
    .slide(SlideEffect.Right)
  }
  // 2--STR ,3--熄屏  ,4-- 关机 :与索引值相差2


  aboutToAppear() {
    let configJsonStr = settings.getValueSync(
      globalThis.settingsAbilityContext as Context,
      SETTING_POWER_SUSPEND_SOURCES_KEY,
      ''
    );
    this.mSuspendSourceArr = suspendSourcesManager.parseConfig(configJsonStr);
    this.itemParam=(this.mSuspendSourceArr[0].action-2).toString()
    try {
      this.displayArr = ['STR','熄屏','关机']
      this.displayArr.forEach((itemName, index) => {
        let model = new SettingItemTvModel();
          model.name = itemName;
          model.itemParam = index.toString();
          model.style = SettingItemStyle.singleChoose;
          model.setIsSelect(index === Number(this.itemParam));
          this.standbyModeList.push(model);
      })

    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      console.error(` standby_mode_failed, code: ${code}, message: ${message}.`);
    }
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        Column() {
          SettingListTvComponent({
            settingList: this.standbyModeList,
            title: $r('app.string.standby_mode'),
            onMouseClickHandle:((item: SettingItemTvModel)=>{
                let newPowerKeyAction = Number(item.itemParam)+2;
              console.log(' this.itemParam', this.itemParam)
            let newConfigJsonStr=suspendSourcesManager.updateSuspendSource('powerkey',newPowerKeyAction,
              this.mSuspendSourceArr[0].delayMs)
                try {
                  settings.setValueSync(
                    globalThis.settingsAbilityContext as Context,
                    SETTING_POWER_SUSPEND_SOURCES_KEY,
                    newConfigJsonStr
                  )
                } catch (err) {
                  console.log(TAG, 'setScreenOffTime err:' + JSON.stringify(err));
                }
            })
          })
        }
        .width(ConfigData.WH_52_100)
        .margin({ left: lpx(84) })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: $r('app.string.standby_mode') })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }.width(ConfigData.WH_100_100)
  }
}
