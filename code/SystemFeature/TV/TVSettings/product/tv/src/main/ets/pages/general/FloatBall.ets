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
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { Duration } from '../../common/constants/Duration';
import { commonEventFloatBallDataFunc } from '../../MainAbility/MainAbility';
import { BooleanPreferences } from '../../common/UserStorageManager';
import { Content } from '@kit.ArkUI';

@Entry
@Component
struct FloatBall {
  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  build() {
    Column() {
      FloatBallComponent()
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}

let preDataFlush = new BooleanPreferences(getContext(Content))
preDataFlush.initialize();

@Component
struct FloatBallComponent {
  @State imageUrl: string = Ratio.resName('float_ball')
  isShowScrollBar: boolean = false
  @State des: string = '悬浮球选项'
  @State settingList: SettingItemTvModel[] = []

  touchLastOpTime: number = 0;

  onClickHandle: (item: SettingItemTvModel) => void = () => {
  }
  onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => void = () => {
  }
  onToggleChangedHandle: (item: SettingItemTvModel, isOn: boolean) => void = () => {
  }
  onFocusHandle: (item: SettingItemTvModel) => void = () => {
  }
  @State isOn: boolean = true;

  aboutToAppear(){
    this.initFloatsItems();
    this.touchLastOpTime = Date.now();
  }

  initFloatsItems() {

    let item0 = new SettingItemTvModel();
    item0.name = '悬浮球开关';
    item0.style = SettingItemStyle.switch;
    item0.value = this.des;
    if(AppStorage.get('defaultFloatBall')!== undefined && AppStorage.get('defaultFloatBall') !== null){
      item0.isOn = AppStorage.get('defaultFloatBall') as boolean
      this.isOn = item0.isOn
      console.log('float ball AppStorage.get defaultFloatBall, item0.isOn', item0.isOn); // 输出: true
    } else {
      item0.isOn = this.isOn;
      console.log('float ball this.isOnTemp, item0.isOn', item0.isOn); // 输出: true
    }
    this.settingList.push(item0)
  }

  build() {

    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        Column(){
          SettingListTvComponent({
            settingList: this.settingList,
            title: '悬浮球',
            onClickHandle:() => {

            },
            onToggleChangedHandle:async (item: SettingItemTvModel, isOn: Boolean) => {
              console.log('float ball Current this.isOn value:', item.isOn);
              commonEventFloatBallDataFunc(item.isOn);
              await preDataFlush.saveBoolean('defaultFloatBall',item.isOn);
              AppStorage.setOrCreate('defaultFloatBall', item.isOn)
            }
          }).height(lpx(350))
        }
        .width(ConfigData.WH_52_100)
        .height(ConfigData.WH_100_100)
        .padding({ left: lpx(84) })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
