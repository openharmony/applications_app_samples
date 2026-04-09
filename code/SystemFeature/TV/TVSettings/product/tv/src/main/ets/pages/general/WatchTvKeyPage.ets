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
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { Duration } from '../../common/constants/Duration';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import displaySetting from '@ohos.tvservice.displaySetting';
import { KeyCode } from '../../common/constants/KeyCode';
import { WatchTvKeyModel } from '../../model/general/WatchTvKeyModel';

const TAG = '[watchTvSource] '

const WATCH_TV_SOURCE_TO_NAME: Record<number, string> = {
  0: 'MEDIA',
  1: 'HDMI1',
  2: 'HDMI2',
  3: 'HDMI3',
  4: 'HDMI4',
  5: 'CVBS1',
  6: 'DTMB',
  7: 'DVBC',
  8: 'DVBT',
  9: 'CAST',
  10: 'GRAPHIC',
  11: 'NETWORK',
  12: 'BUTT',

};

const WATCH_TV_NAME_TO_SOURCE: Record<string, number> = {
  'MEDIA': 0,
  'HDMI1': 1,
  'HDMI2': 2,
  'HDMI3': 3,
  'HDMI4': 4,
  'CVBS1': 5,
  'DTMB': 6,
  'DVBC': 7,
  'DVBT': 8,
  'CAST': 9,
  'GRAPHIC': 10,
  'NETWORK': 11,
  'BUTT': 12,
};


@Entry
@Component
struct WatchTvKeyPage {
  private pageTranState: boolean = false; //判断是进场动效还是出场动效
  @State imageUrl: string = Ratio.resName('icon_inputsource') // 右侧图标哦
  @State des: string | Resource = '' //$r('app.string.set_image_type') // 右侧图标下发的介绍
  @State settingList: SettingItemTvModel[] = []


  async aboutToAppear() {
    LogUtil.log(TAG + 'aboutToAppear');
    try {
      let sourceArray: displaySetting.SourceType[] = await displaySetting.GetSupportSourceList();
      for (let i = 0; i < sourceArray.length; i++) {

        let sourceType: displaySetting.SourceType = sourceArray[i];
        if (sourceType >= displaySetting.SourceType.SOURCE_HDMI1 &&
          sourceType <= displaySetting.SourceType.SOURCE_HDMI4) {
          let item = new SettingItemTvModel();
          item.name = WATCH_TV_SOURCE_TO_NAME[sourceType];
          item.style = SettingItemStyle.singleChoose;
          item.description = WATCH_TV_SOURCE_TO_NAME[sourceType];
          this.settingList.push(item);
        }
      }
    } catch (e) {

    }

    // 初始化时读当前STBSource
    this.updateWatchTvSourceInfo();
    LogUtil.log(TAG + 'aboutToAppear end');
  }

  onPageShow(): void {

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

  updateWatchTvSourceInfo() {
    let source: number = WatchTvKeyModel.getWatchTvSource();
    if (source >= 0) {
      for (let i = 0; i < this.settingList.length; i++) {
        if (this.settingList[i].name == WATCH_TV_SOURCE_TO_NAME[source]) {
          LogUtil.log(TAG + 'updateSTBSourceInfo' + source + ' setIsSelect:true');
          this.settingList[i].setIsSelect(true);
        }
      }
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
          title: $r('app.string.watch_tv_key_title'),
          onFocusHandle: (item: SettingItemTvModel) => {
            this.imageUrl = item.imageUrl;
            this.des = item.description;
          },
          onMouseClickHandle: (item: SettingItemTvModel) => {
              //UX默认的onKeyEvent里，settingListTvComponent先写了UI处理，最后调用onKeyEventHandle
              //所以这个地方写非通用的特殊UX逻辑，以及调用data相关的接口即可
              for (let i = 0; i < this.settingList.length; i++) {
                if (this.settingList[i].name == item.name) {
                  WatchTvKeyModel.setWatchTvSource(WATCH_TV_NAME_TO_SOURCE[item.name]);
                }
              }
          },
          onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
            if (event.keyCode === KeyCode.KEY_ENTER && event.type === KeyType.Up) {

            }
          },
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
