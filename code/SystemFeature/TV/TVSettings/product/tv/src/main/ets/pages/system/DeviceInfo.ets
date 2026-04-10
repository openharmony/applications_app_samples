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
import { Duration } from '../../common/constants/Duration';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import aboutDeviceModel from '../../model/aboutDeviceImpl/AboutDeviceModel';

const TAG='DeviceInfo'

@Entry
@Component
struct DeviceInfo {
  @State imageUrl: string = Ratio.resName('')
  @State des: string = '设备信息'
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
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
            title: '设备信息',
          })
            .width(ConfigData.WH_100_100)
            .height(ConfigData.WH_100_100)
            .margin(0)
        }
      }
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear() {
    let item1 = new SettingItemTvModel()
    item1.name = '屏幕参数'
    item1.chooseDes = aboutDeviceModel.getDisplayDPI();
    item1.style = SettingItemStyle.info

    let item2 = new SettingItemTvModel()
    item2.name = '处理器'
    let hardware = aboutDeviceModel.getHardwareModel();
    if (hardware === 'Hi3781V735DEMC') {
      hardware = 'Hi3781V735'
    }
    // 转成大写
    item2.chooseDes = hardware.toUpperCase();
    item2.style = SettingItemStyle.info

    let item3 = new SettingItemTvModel()
    item3.name = '总存储'
    item3.chooseDes = aboutDeviceModel.getDeviceTotalBytes();
    item3.style = SettingItemStyle.info

    let item4 = new SettingItemTvModel()
    item4.name = '已用存储'
    item4.chooseDes = aboutDeviceModel.getDeviceUsedBytes();
    item4.style = SettingItemStyle.info

    let item5 = new SettingItemTvModel()
    item5.name = '运行内存'
    item5.chooseDes = aboutDeviceModel.getRuntimeMemory();
    item5.style = SettingItemStyle.info

    this.settingList.push(item1, item2, item3, item4, item5);
  }
}
