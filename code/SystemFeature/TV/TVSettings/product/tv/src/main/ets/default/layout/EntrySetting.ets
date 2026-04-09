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

import router from '@ohos.router';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from './SettingItemDesLayout';
import { SettingItemTvModel } from '../model/SettingItemTvModel';
import { SettingListTvComponent } from './SettingListTvComponent';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { KeyCode } from '../../common/constants/KeyCode';
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';

AppStorage.setOrCreate('isShow',1);
@Component
export struct EntryComponent {
  @State imageUrl: string = ''
  @State des: string | Resource = ''
  @State settingList: SettingItemTvModel[] = []
  @State lastClickTime: number = 0 // 记录最后一次点击时间
  private clickInterval: number = 500 // 点击间隔阈值(毫秒)，可根据需求调整
  aboutToDisappear() {
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: 0 })
    PageTransitionExit({ type: RouteType.None, duration: 0 })
  }

  aboutToAppear() {
    let setting2 = new SettingItemTvModel()
    setting2.name = '声音'
    setting2.style = SettingItemStyle.default
    setting2.pageUrl = 'pages/volume/Volume'
    setting2.imageUrl = Ratio.resName('icon_volume')
    setting2.description = '输出模式、音效模式'

    let setting3 = new SettingItemTvModel()
    setting3.name = '图像'
    setting3.style = SettingItemStyle.default
    setting3.pageUrl = 'pages/display/Display'
    setting3.imageUrl = Ratio.resName('icon_display')
    setting3.description = '图像模式、屏幕亮度、护眼模式'

    let setting4 = new SettingItemTvModel()
    setting4.name = '网络'
    setting4.style = SettingItemStyle.default
    setting4.pageUrl = 'pages/network/Network'
    setting4.imageUrl = Ratio.resName('icon_wifi')
    setting4.description = '无线网络、有线网络'

    let setting5 = new SettingItemTvModel()
    setting5.name = '蓝牙'
    setting5.style = SettingItemStyle.default
    setting5.pageUrl = 'pages/bluetooth/BluetoothDeviceEntry'
    setting5.imageUrl = Ratio.resName('icon_bluetooth')
    setting5.description = '查看蓝牙设备连接和状态'

    let setting6 = new SettingItemTvModel()
    setting6.name = '通用'
    setting6.style = SettingItemStyle.default
    setting6.pageUrl = 'pages/general/General'
    setting6.imageUrl = Ratio.resName('icon_general')
    setting6.description = '通用、输入法设置'

    let setting7 = new SettingItemTvModel()
    setting7.name = '系统'
    setting7.style = SettingItemStyle.default
    setting7.pageUrl = 'pages/system/System'
    setting7.imageUrl = Ratio.resName('icon_system')
    setting7.description = '软件更新、系统信息、设备信息'

    let setting8 = new SettingItemTvModel();
    setting8.name = '更多连接'
    setting8.style = SettingItemStyle.default
    setting8.pageUrl = 'pages/links/Links'
    setting8.imageUrl = Ratio.resName('icon_links')
    setting8.description = '更多连接'

    let setting9 = new SettingItemTvModel();
    setting9.name = '设备互传'
    setting9.style = SettingItemStyle.default
    setting9.pageUrl = 'pages/oneConnectShare/OneConnectShare'
    setting9.imageUrl = Ratio.resName('icon_share')
    setting9.description = $r('app.string.one_connect')

    this.settingList.push(setting2, setting3, setting4, setting5, setting6, setting7, setting8, setting9);

    setTimeout(() => {
      focusControl.requestFocus('设置-0')
    }, 0)
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        SettingListTvComponent({
          title: '设置',
          isShowScrollBar: false,
          settingList: this.settingList,
          onFocusHandle: (item: SettingItemTvModel) => {
            this.imageUrl = item.imageUrl
            this.des = item.description
          },
          onMouseClickHandle:(item:SettingItemTvModel)=>{
            const currentTime = new Date().getTime();
            // 判断距离上次点击是否超过设定的间隔
            if (currentTime - this.lastClickTime > this.clickInterval && AppStorage.get('isShow') == 1) {
              // 执行跳转操作
              router.pushUrl({ url: item.pageUrl }, router.RouterMode.Single)
              // 更新最后点击时间
              this.lastClickTime = currentTime;
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
}
