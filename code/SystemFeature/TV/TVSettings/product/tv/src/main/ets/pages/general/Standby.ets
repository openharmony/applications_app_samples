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
import {power} from '@kit.BasicServicesKit';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemStyle, SourcetoolConstants } from '../../common/constants/StyleConstants';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingBackground } from '../../default/layout/SettingBackground';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';

import { Duration } from '../../common/constants/Duration';
import lpx from '../../common/Lpx';
import { commonEventScreenOffTimeDataFunc, commonScreenOffTimeEvents } from '../../MainAbility/MainAbility';
import { EventUtil } from '../../common/EventUtil';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

export const SCREEN_OFF_PREFERENCE_NAME: string = 'auto_screen_off_preference';
export const SCREEN_OFF_KEY_SWITCH: string = 'auto_screen_off_switch';
export const SCREEN_OFF_KEY_SINGLE_ITEM: string = 'auto_screen_off_item';
export const DEFAULT_SWITCH_ITEM_VALUE: string = '1';
export const DEFAULT_SCREEN_OFF_TIME: number = -1;
export const DEFAULT_HOURS_OF_SCREEN_OFF: number = 0.5;
export const SCREEN_OFF_TIME: string = 'screenOffTime'

const TAG = '[Standby]'

@Entry
@Component
struct Standby {
  @State isSwitchOn: boolean = true;
  itemParam: string = '1';
  imageUrl: string = Ratio.resName('standby')
  @State switchList: SettingItemTvModel[] = [];
  @State screenOffTimeList: SettingItemTvModel[] = [];
  displayArr: string[] = [];
  @State focusIndex: number = -1

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  aboutToAppear() {

  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)
Row() {
  Column() {
    Text($r('app.string.standby'))
      .height(lpx(75))
      .lineHeight(lpx(75))
      .fontColor(Color.White)
      .fontSize(lpx(64))
      .fontWeight(FontWeight.Medium)
      .textAlign(TextAlign.Start)
      .margin({
        top: lpx(48),
        bottom: lpx(56),
        left: lpx(12)
      })

    Text('STR待机')
      .focusBox({
        margin: LengthMetrics.lpx(8),
        strokeColor: ColorMetrics.rgba(255, 255, 255,1),
        strokeWidth: LengthMetrics.lpx(2)
      })
      .margin({
        left: lpx(8)
      })
    .textAlign(TextAlign.Center)
    .fontSize(lpx(36))
    .fontColor(this.focusIndex === 1 ? 'rgba(0, 0, 0, 0.86)' : '#50FFFFFF')
    .height(lpx(100))
    .width(lpx(852))
    .border({
      radius: lpx(18)

    })
    .focusable(true)
    .defaultFocus(true)
    .onFocus(() => {
      this.focusIndex = 1
    })
    .onBlur(() => {
      this.focusIndex = -1
    })

    .backgroundColor(this.focusIndex == 1 ? 'rgba(255,255,255,0.86)' : 'rgba(255,255,255,0.2)')
    .onHover(() => {
      this.focusIndex = 1;
    })

    .onTouch(async (event) => {
      if (!EventUtil.isTouchEvent(event)) {
        return;
      }
      if (event.sourceTool !== SourceTool.Pen &&
        event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
        return;
      }

    })
    .onClick(async () => {
      this.focusIndex = 1;
      console.log('熊壮power.suspend')
      power.suspend(true)
    })

  }
  .height('100%')
  .alignItems(HorizontalAlign.Start)
  .justifyContent(FlexAlign.Start)
  .width(ConfigData.WH_52_100)
  .margin({ left: lpx(84) })

  SettingItemDesLayout({ imageUrl: this.imageUrl, des: $r('app.string.standby') })
    .width(ConfigData.WH_48_100)
    .height(ConfigData.WH_100_100)
}

    }.width(ConfigData.WH_100_100)

  }
}