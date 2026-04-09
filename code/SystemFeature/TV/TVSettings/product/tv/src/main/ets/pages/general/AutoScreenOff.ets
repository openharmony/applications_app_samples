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

export const SCREEN_OFF_PREFERENCE_NAME: string = 'auto_screen_off_preference';
export const SCREEN_OFF_KEY_SWITCH: string = 'auto_screen_off_switch';
export const SCREEN_OFF_KEY_SINGLE_ITEM: string = 'auto_screen_off_item';
export const DEFAULT_SWITCH_ITEM_VALUE: string = '1';
export const DEFAULT_SCREEN_OFF_TIME: number = -1;
export const DEFAULT_HOURS_OF_SCREEN_OFF: number = 0.5;
export const SCREEN_OFF_TIME: string = 'screenOffTime'

const HOURS_TO_SECOND: number = 60;
const SECOND_TO_MILLISECOND: number = 1000;
const TAG = '[AutoScreenOff]'

@Entry
@Component
struct AutoScreenOff {
  @State isSwitchOn: boolean = true;
  itemParam: string = '1';
  imageUrl: string = Ratio.resName('auto_screenoff_detail')
  @State switchList: SettingItemTvModel[] = [];
  @State screenOffTimeList: SettingItemTvModel[] = [];
  displayArr: string[] = [];

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  aboutToAppear() {
    let switchParam = PreferencesUtil.getParam(getContext(), SCREEN_OFF_PREFERENCE_NAME, SCREEN_OFF_KEY_SWITCH);
    this.isSwitchOn = switchParam === DEFAULT_SWITCH_ITEM_VALUE;
    this.itemParam = PreferencesUtil.getParam(getContext(), SCREEN_OFF_PREFERENCE_NAME, SCREEN_OFF_KEY_SINGLE_ITEM);
    commonEventScreenOffTimeDataFunc(this.isSwitchOn)
    commonScreenOffTimeEvents(getScreenOffTime(this.itemParam).toString())
    settings.setValueSync(
      globalThis.settingsAbilityContext as Context,
      SCREEN_OFF_KEY_SWITCH,
      this.isSwitchOn ? '1' : '0'
    )
    settings.setValueSync(globalThis.settingsAbilityContext as Context, SCREEN_OFF_TIME, this.itemParam.toString())
    console.debug(TAG, 'aboutToAppear isSwitchOn = ' + this.isSwitchOn + ',itemParam =' + this.itemParam);
    try {
      this.displayArr = getContext().resourceManager.getStringArrayValueSync($r('app.strarray.screen_off_time').id);
      this.displayArr.forEach((itemName, index) => {
        let model = new SettingItemTvModel();
        model.name = itemName;
        if (itemName === this.displayArr[0]) {
          model.style = SettingItemStyle.switch;
          model.setIsOn(this.isSwitchOn);
          this.switchList.push(model);
        } else {
          model.itemParam = index.toString();
          model.style = SettingItemStyle.singleChoose;
          model.setIsSelect(index === Number(this.itemParam));
          this.screenOffTimeList.push(model);
        }
      })
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      console.error(`AutoScreenOff getStringArrayValueSync failed, code: ${code}, message: ${message}.`);
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
            settingList: this.switchList,
            isAutoScreeOff:true,
            title: $r('app.string.auto_screen_off'),
            onToggleChangedHandle: (item: SettingItemTvModel, isOn: boolean) => {
              console.debug(TAG, 'Toggle Change: ' + item.name + ',isOn = ' + isOn);
              this.isSwitchOn = isOn;
              if (!this.isSwitchOn) {
                PreferencesUtil.setParam(getContext(), SCREEN_OFF_PREFERENCE_NAME, SCREEN_OFF_KEY_SWITCH, '0');
                commonEventScreenOffTimeDataFunc(false)
                settings.setValueSync(
                  globalThis.settingsAbilityContext as Context,
                  SCREEN_OFF_TIME,
                  DEFAULT_SCREEN_OFF_TIME.toString()
                )
                settings.setValueSync(globalThis.settingsAbilityContext as Context, SCREEN_OFF_KEY_SWITCH, '0')
              } else {
                PreferencesUtil.setParam(getContext(), SCREEN_OFF_PREFERENCE_NAME, SCREEN_OFF_KEY_SWITCH,
                  DEFAULT_SWITCH_ITEM_VALUE);
                commonEventScreenOffTimeDataFunc(true)
                settings.setValueSync(globalThis.settingsAbilityContext as Context, SCREEN_OFF_KEY_SWITCH, '1')
                settings.setValueSync(
                  globalThis.settingsAbilityContext as Context,
                  SCREEN_OFF_TIME,
                  getScreenOffTime(this.itemParam).toString()
                )
              }
            },
          }).height(lpx(350))

          SettingListTvComponent({
            settingList: this.screenOffTimeList,
            title: '',
            isAutoScreeOff:true,
            onMouseClickHandle:(item: SettingItemTvModel) => {
                this.itemParam = item.itemParam;
                let time = getScreenOffTime(this.itemParam);
                console.log(TAG, 'current screenOff time：' + time + '__item:' + item.itemParam)
                try {
                  settings.setValueSync(globalThis.settingsAbilityContext as Context, SCREEN_OFF_TIME, time.toString())
                  commonScreenOffTimeEvents(time.toString())
                } catch (err) {
                  console.log(TAG, 'setScreenOffTime err:' + JSON.stringify(err));
                }
                PreferencesUtil.setParam(getContext(), SCREEN_OFF_PREFERENCE_NAME, SCREEN_OFF_KEY_SINGLE_ITEM,
                  this.itemParam);
                console.debug(TAG,
                  'SingleItem Change:' + item.name + ', time = ' + time + ',itemParam = ' + this.itemParam);
            },
            onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
              if (event.keyCode === KeyCode.KEY_ENTER && event.type === KeyType.Up) {

              }
            }
          })
            .visibility(this.isSwitchOn ? Visibility.Visible : Visibility.Hidden)
        }
        .width(ConfigData.WH_52_100)
        .margin({ left: ($r('app.float.settings_list_left_margin')) })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: $r('app.string.auto_screen_off') })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }.width(ConfigData.WH_100_100)
  }
}

export default function getScreenOffTime(itemParam: string): number {
  console.debug(TAG, 'getScreenOffTime, itemParam = ' + itemParam);
  let numberOfHours: number = DEFAULT_HOURS_OF_SCREEN_OFF;
  switch (itemParam) {
    case '1':
      numberOfHours = 0.5;
      break;
    case '2':
      numberOfHours = 1;
      break;
    case '3':
      numberOfHours = 2;
      break;
    case '4':
      numberOfHours = 4;
      break;
    case '5':
      numberOfHours = 6;
      break;
    default:
      break;
  }
  console.debug(TAG, 'getScreenOffTime, numberOfHours = ' + numberOfHours);
  return numberOfHours * HOURS_TO_SECOND * HOURS_TO_SECOND * SECOND_TO_MILLISECOND;
}
