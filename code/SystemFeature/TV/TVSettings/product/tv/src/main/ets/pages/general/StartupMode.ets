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

import { BusinessError, settings } from '@kit.BasicServicesKit';
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
import displaySetting from '@ohos.tvservice.displaySetting';

const TAG = '[startupMode]'


@Entry
@Component
struct StartupMode {

  itemParam: string = '0';
  imageUrl: string = Ratio.resName('startup_mode')

  @State startupModeList: SettingItemTvModel[] = [];
  displayArr: string[] = [];
  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

   aboutToAppear() {
      // 开机0 ,待机1 ,记忆2
    const itemParamNumber=AppStorage.get<number>('startupMode')
     if(itemParamNumber){
       this.itemParam = itemParamNumber!.toString()
     }
    try {
      this.displayArr = ['开机','待机','记忆']
      this.displayArr.forEach((itemName, index) => {
        let model = new SettingItemTvModel();
        model.name = itemName;
        model.itemParam = index.toString();
        model.style = SettingItemStyle.singleChoose;
        model.setIsSelect(index === Number(this.itemParam));
        this.startupModeList.push(model);
      })
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      console.error(TAG,`code: ${code}, message: ${message}.`);
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
              settingList: this.startupModeList,
              title: $r('app.string.startup_mode'),
              onMouseClickHandle: (async (item: SettingItemTvModel) => {
                let itemMode = Number(item.itemParam);
                console.log('hsq this.itemParam', this.itemParam)
                try {
                  await displaySetting.setPowerOnMode(itemMode)
                } catch (err) {
                  console.log(TAG, 'setScreenOffTime err:' + JSON.stringify(err));
                }
              })

            })
          }
          .width(ConfigData.WH_52_100)
          .margin({ left: lpx(84) })

          SettingItemDesLayout({ imageUrl: this.imageUrl, des: $r('app.string.startup_mode') })
            .width(ConfigData.WH_48_100)
            .height(ConfigData.WH_100_100)
        }
    }.width(ConfigData.WH_100_100)
  }
}
