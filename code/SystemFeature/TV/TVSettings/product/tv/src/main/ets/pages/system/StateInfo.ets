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
import { Duration } from '../../common/constants/Duration';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import aboutDeviceModel from '../../model/aboutDeviceImpl/AboutDeviceModel';
import BluetoothModel from '../../model/bluetoothImpl/BluetoothModel';
import displaySetting from '@ohos.tvservice.displaySetting';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'StateInfo'

@Entry
@Component
struct StateInfo {
  @State imageUrl: string = Ratio.resName('')
  @State des: string = '状态信息'
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  @StorageLink('wifiMac') @Watch('update') wifiMac: string = ''

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  async aboutToAppear() {
    let item1 = new SettingItemTvModel()
    item1.name = '序列号'
    item1.chooseDes = '获取失败'
    displaySetting.getSN((err:BusinessError,sn:string)=>{
      if (err) {
        console.error('获取SN失败，error ',JSON.stringify(err))
        return
      }
      item1.chooseDes = sn.toUpperCase()
    })

    item1.style = SettingItemStyle.info

    let item2 = new SettingItemTvModel()
    item2.name = '设备无线MAC地址'
    item2.chooseDes = aboutDeviceModel.getdeviceMacAddress().toUpperCase();
    item2.style = SettingItemStyle.info

    let item3 = new SettingItemTvModel()
    item3.name = '设备有线MAC地址'
    item3.chooseDes = '';
    item3.style = SettingItemStyle.info

    let item4 = new SettingItemTvModel()
    item4.name = '设备蓝牙MAC地址'
    item4.chooseDes =
      BluetoothModel.isStateOn() ? aboutDeviceModel.getBluetoothMac().toUpperCase() : $r('app.string.BluetoothMacInfo');
    item4.style = SettingItemStyle.info

    this.settingList.push(item1, item2, item3, item4);

    this.updateMAC()
  }

  update() {
    this.settingList[1].setChooseDes(this.wifiMac)
  }

   updateMAC(){
      aboutDeviceModel.getEthMac().then(mac =>{
        let MAC=mac.toUpperCase()
        this.settingList[2].setChooseDes(MAC)
      })
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
            title: '状态信息',
            onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
              if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Down) {
              }
            }
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
}
