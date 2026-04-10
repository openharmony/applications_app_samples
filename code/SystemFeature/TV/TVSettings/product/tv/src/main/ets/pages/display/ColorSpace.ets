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
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import lpx from '../../common/Lpx';
import { Duration } from '../../common/constants/Duration';
import displaySetting from '@ohos.tvservice.displaySetting';
import { promptAction } from '@kit.ArkUI';

const TAG = 'ColorSpace'

const colorSpaceTypeList: Record<number, string> = {
  // 0: 'AUTO',
  1: 'HDR10',
  2: 'HLG',
  3: 'HDTV',
  4: 'SRGB',
  5: 'P3_DCI',
  6: 'P3_D65',
  7: 'P3_D50',
  8: 'ADOBERGB',
  9: 'EBU',
  10: 'SMPTE_C',
  // 11: 'USER1',
  // 12: 'USER2',
  13: 'P3_PG',
  14: 'CUVA',
  15: 'NATIVE',
  16: 'IDEA_NATIVE',
}

@Entry
@Component
struct ColorSpace {
  @State imageUrl: string = Ratio.resName('icon_source_identification')
  @State des: string = '设置色彩空间'
  @State settingList: SettingItemTvModel[] = []
  private pageTranState: boolean = false; //判断是进场动效还是出场动效

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

  aboutToAppear() {
    LogUtil.info('colorSpace: EntryComponent aboutToAppear in');
    this.init()
  }

  init() {
    Object.keys(colorSpaceTypeList).forEach((key, index) => {
      let model: SettingItemTvModel = new SettingItemTvModel();
      model.name = colorSpaceTypeList[key].toString();
      model.value = key;
      model.style = SettingItemStyle.singleChoose;
      this.settingList.push(model);
    });

    this.getColorManageMode()
  }

  // 设置色彩空间模式
  async setColorManageMode(mode: number) {
    try {
      LogUtil.log(TAG + 'setColorManageMode mode => ' + JSON.stringify(mode));
      const result: boolean = await displaySetting.setColorManageMode(mode)
      LogUtil.log(TAG + 'setColorManageMode success => ' + JSON.stringify(result));
      if (!result) {
        promptAction.showToast({ message: '设置失败' })
      } else {
        const idx = this.settingList.findIndex((model) => {
          return Number(model.value) === mode
        })
        LogUtil.log(TAG + 'setColorManageMode idx => ' + JSON.stringify(idx));
        if (idx > -1) {
          this.settingList[idx].setIsSelect(true);
        }
      }
    } catch (error) {
      LogUtil.error(TAG + 'setColorManageMode error => ' + JSON.stringify(error));
      promptAction.showToast({ message: '系统异常' })
    }
  }

  // 获取色彩空间模式
  async getColorManageMode() {
    try {
      const result: displaySetting.ColorManagementMode = await displaySetting.getColorManageMode()
      LogUtil.log(TAG + 'getColorManageMode success => ' + JSON.stringify(result));
      const idx = this.settingList.findIndex((model) => {
        return Number(model.value) === result
      })
      LogUtil.log(TAG + 'getColorManageMode idx => ' + JSON.stringify(idx));
      if (idx > -1) {
        this.settingList[idx].setIsSelect(true);
      }
    } catch (error) {
      LogUtil.error(TAG + 'getColorManageMode error => ' + JSON.stringify(error));
      promptAction.showToast({ message: '系统异常' })
    }
  }

  build() {
    Column() {
      Column() {
        Stack() {
          SettingBackground()
            .position({ x: 0, y: 0 })
            .height(ConfigData.WH_100_100)
            .width(ConfigData.WH_100_100)

          Row() {
            SettingListTvComponent({
              settingList: this.settingList,
              title: '色彩空间',
              subTitle: '系统·' + AppStorage.get('displayModeType'),
              onClickHandle: (item: SettingItemTvModel) => {
              },
              onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
                if (event.type == KeyType.Down && event.keyCode === KeyCode.KEY_ENTER) {
                  this.setColorManageMode(Number(item.value))
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

      }
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
    }
  }
}
