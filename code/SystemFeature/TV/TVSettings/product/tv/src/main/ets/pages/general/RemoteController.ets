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

import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { it } from '@ohos/hypium';
import { promptAction, router } from '@kit.ArkUI';
import remoteControl from '@ohos.multimodalInput.remoteControl';
import { Duration } from '../../common/constants/Duration';

const TAG = 'REMOTECONTROLLER'

@Entry
@Component
struct RemoteController {
  @State imageUrl: string = Ratio.resName('icon_remoteController')
  isShowScrollBar: boolean = false
  @State des: string = '蓝牙遥控器'
  @State focusIndex: number = -1
  @State sensitivityList: string[] = ['低', '中', '高'] //指向遥控器灵敏度
  @State sensitivityIndex: number = 1; //指向遥控器灵敏度索引
  @State controllerMac: string = '' //指向遥控器的mac地址;
  @State controllerVersion: string = '' //指向遥控器的版本信息
  @StorageProp('BatteryLevel') controllerBatteryLevel: number = 50 //当前电量
  @Watch ('ispointchange') @StorageLink('isConPoint') isPoint: boolean = false //是否是指向遥控器
  @State settingList: SettingItemTvModel[] = []
  @StorageLink('isCharge') isCharge: boolean = false //是否充电
  private pageTranState: boolean = false; //判断是进场动效还是出场动效
  onClickHandle: (item: SettingItemTvModel) => void = () => {
  }
  onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => void = () => {
  }
  onFocusHandle: (item: SettingItemTvModel) => void = () => {
  }

  ispointchange() {
    console.debug(TAG, 'REMOTECONTROLLER ispoint' + this.isPoint)
    this.initRemoteControllerList();
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
    //判断指向遥控器是否连接
    if (this.isPoint) {
      this.getRemoteControllerMac()
      this.getRemoteControllerVision()
    }
    this.initRemoteControllerList();


  }

  aboutToDisappear(): void {

  }

  onPageHide(): void {
    this.pageTranState = false
  }

  initRemoteControllerList() {
    this.settingList = [];
    if (this.isPoint) { //指向遥控器
      //获取遥控器灵敏度
      this.getRemoteControllerSensitivity()
      let item0 = new SettingItemTvModel();
      item0.name = '光标灵敏度';
      item0.style = SettingItemStyle.valueChange;
      item0.value = this.sensitivityList[this.sensitivityIndex];

      let item1 = new SettingItemTvModel();
      item1.name = '切换遥控器指引';
      item1.pageUrl = 'pages/general/PairGuidance';
      item1.imageUrl = Ratio.resName('icon_remoteController');
      item1.description = '切换遥控器指引';
      item1.style = SettingItemStyle.default;

      let item2 = new SettingItemTvModel();
      item2.name = '指向遥控器连接';
      item2.pageUrl = 'pages/general/ControllerCon';
      item2.imageUrl = Ratio.resName('icon_remoteController');
      item2.description = '指向遥控器连接';
      item2.style = SettingItemStyle.default;

      this.settingList.push(item0, item1, item2)


    } else { //蓝牙遥控器
      let item1 = new SettingItemTvModel();
      item1.name = '切换遥控器指引';
      item1.pageUrl = 'pages/general/PairGuidance'
      item1.imageUrl = Ratio.resName('icon_remoteController')
      item1.description = '切换遥控器指引'
      item1.style = SettingItemStyle.default;

      let item2 = new SettingItemTvModel();
      item2.name = '指向遥控器连接';
      item2.pageUrl = 'pages/general/ControllerCon';
      item2.imageUrl = Ratio.resName('icon_remoteController');
      item2.description = '指向遥控器连接';
      item2.style = SettingItemStyle.default;

      this.settingList.push(item1,item2)
    }
  }

  /**
   * 查询指向遥控器的电量
   */
  getRemoteControllerBattery() {
    let battery = remoteControl.getRemoteControlBatteryValueSync();
    this.controllerBatteryLevel = battery;
    console.log(TAG, '当前的指向遥控器的电量为：' + battery);
  }

  /**
   * 获取指向遥控器的光标灵敏度
   */
  getRemoteControllerSensitivity() {
    let sensitivity = remoteControl.getRemoteControlSensitivitySync()
    this.sensitivityIndex = sensitivity
    console.log(TAG, '当前指向遥控器的灵敏度为：' + this.sensitivityIndex)
  }

  /**
   * 设置指向遥控器的光标灵敏度
   */
  setRemoteControllerSensitivity(val: number) {
    remoteControl.setRemoteControlSensitivitySync(val);
  }

  /**
   * 获取指向遥控器的mac地址
   */
  getRemoteControllerMac() {
    this.controllerMac = remoteControl.getRemoteControlMacSync();
    console.log(TAG, '当前的指向遥控器的mac地址：' + this.controllerMac);
  }

  /**
   * 获取指向遥控器的版本信息
   */
  getRemoteControllerVision() {
    this.controllerVersion = remoteControl.getRemoteControlVersionSync();
    console.log(TAG, '当前的指向遥控器的版本号：' + this.controllerVersion);
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
            settingList: this.settingList,
            title: '遥控器',
            onMouseClickHandle: (item: SettingItemTvModel) => {
              router.pushUrl({
                url: item.pageUrl
              }, router.RouterMode.Single)
              this.pageTranState = true;
            },
            onValueChangeLeftHandle: (item: SettingItemTvModel) => {
              console.log('onValueChangeLeftHandle-->',item.name);
              if (item.name === '光标灵敏度') {
                let sensitivityIndex = remoteControl.getRemoteControlSensitivitySync()
                this.sensitivityIndex = sensitivityIndex as number;
                if (this.sensitivityIndex > 0) {
                  this.sensitivityIndex--;
                  remoteControl.setRemoteControlSensitivitySync(this.sensitivityIndex)
                  item.setValue(this.sensitivityList[this.sensitivityIndex])
                  console.log(TAG, '当前灵敏度：' + this.sensitivityList[this.sensitivityIndex])
                }
              }
            },
            onValueChangeRightHandle: (item: SettingItemTvModel) => {
              console.log('onValueChangeRightHandle-->',item.name);
              if (item.name === '光标灵敏度') {
                let sensitivityIndex = remoteControl.getRemoteControlSensitivitySync()
                this.sensitivityIndex = sensitivityIndex as number;
                if (this.sensitivityIndex < 2) {
                  this.sensitivityIndex++;
                  remoteControl.setRemoteControlSensitivitySync(this.sensitivityIndex)
                  item.setValue(this.sensitivityList[this.sensitivityIndex])
                  console.log(TAG, '当前灵敏度：' + this.sensitivityList[this.sensitivityIndex])
                }
              }
            },
            onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
              if (item.name === '光标灵敏度') {
                if (event.keyCode == KeyCode.KEYCODE_DPAD_LEFT && event.type == KeyType.Up) {
                  let sensitivityIndex = remoteControl.getRemoteControlSensitivitySync()
                  this.sensitivityIndex = sensitivityIndex as number;
                  if (this.sensitivityIndex > 0) {
                    this.sensitivityIndex--;
                    remoteControl.setRemoteControlSensitivitySync(this.sensitivityIndex)
                    item.setValue(this.sensitivityList[this.sensitivityIndex])
                    console.log(TAG, '当前灵敏度：' + this.sensitivityList[this.sensitivityIndex])
                  }

                } else if (event.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && event.type == KeyType.Up) {
                  let sensitivityIndex = remoteControl.getRemoteControlSensitivitySync()
                  this.sensitivityIndex = sensitivityIndex as number;
                  if (this.sensitivityIndex < 2) {
                    this.sensitivityIndex++;
                    remoteControl.setRemoteControlSensitivitySync(this.sensitivityIndex)
                    item.setValue(this.sensitivityList[this.sensitivityIndex])
                    console.log(TAG, '当前灵敏度：' + this.sensitivityList[this.sensitivityIndex])
                  }
                }
              } else {
                if ((event.keyCode == KeyCode.KEYCODE_ENTER || event.keyCode == KeyCode.KEYCODE_DPAD_CENTER) &&
                  event.type == KeyType.Up) {
                  router.pushUrl({
                    url: item.pageUrl
                  }, router.RouterMode.Single)
                  this.pageTranState = true;
                }
              }
            }
          })

        }
        .width(ConfigData.WH_52_100)
        .height(ConfigData.WH_100_100)
        .padding({ left: lpx(84) })


        if (this.isPoint) {
          Column() {
            Stack() {
              Progress({ value: this.controllerBatteryLevel, total: 100, type: ProgressType.Ring })
                .width('420lpx')
                .style({ strokeWidth: '36lpx', status: ProgressStatus.PROGRESSING })
                .backgroundColor('#33ffffff')
                .color('#d964bb5c')
              Column({ space: '12lpx' }) {
                Text(this.controllerBatteryLevel + '%')
                  .fontSize('96lpx')
                  .lineHeight('113lpx')
                  .fontWeight(200)
                  .fontColor('#dbffffff')

                Text(this.isCharge ? '充电中 ⚡' : '电池电量')
                  .fontSize('24lpx')
                  .lineHeight('28lpx')
                  .fontWeight(500)
                  .fontColor('#99ffffff')
              }
            }

            Text('版本号:' + this.controllerVersion)
              .fontColor('rgba(255, 255, 255, 0.60)')
              .fontSize(lpx(30))
              .lineHeight(lpx(35))
              .margin({
                top: lpx(60)

              })
            Text('MAC地址：' + this.controllerMac)
              .fontColor('rgba(255, 255, 255, 0.60)')
              .fontSize(lpx(30))
              .lineHeight(lpx(35))
              .margin({
                top: lpx(60)
              })
          }
          .width('100%')
          .height('100%')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
        } else {
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
