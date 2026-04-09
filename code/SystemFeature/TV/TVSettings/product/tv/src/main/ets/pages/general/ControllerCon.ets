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
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { ColorMetrics, LengthMetrics, promptAction, router } from '@kit.ArkUI';
import { Duration } from '../../common/constants/Duration';
import remoteControl from '@ohos.multimodalInput.remoteControl';
import { inputDevice, KeyCode } from '@kit.InputKit';

const TAG='PAIRGUIDANCE'
const VENDOR = 0x000d
const PRODUCT = 0x3840
const VENDOR1 = 0xbda
const PRODUCT1 = 0x8773

@Entry
@Component
struct ControllerCon {
  @State imageUrl: string = Ratio.resName('icon_remoteController')
  @State des: string = '指向遥控器遥控器';
  @StorageProp('isConPoint') @Watch('focusChange') isPoint: boolean = false //是否是指向遥控器
  // @State isPoint: boolean = false //是否是指向遥控器
  @StorageProp('connVal') connVal: number = -1 // 遥控器连接状态枚举
  @State receiverBtSwitchStatus: boolean = false; //接收端蓝牙扫描是否打开
  @State isDeleteRemoteControlPair : boolean = false //遥控器配对信息是否删除
  @State isConn: boolean = false //是否连接上指向遥控器
  @State isConnDes: string = '' //
  @StorageProp('isReport') isReport: boolean = false //指向遥控器接收器是否插入
  @State deviceId: number[] = []; //接收器id
  @State focusIndex: number = -1; //索引判断

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  aboutToAppear(): void {
    if (!this.isReport) {
      this.getDeviceID()
    }
  }

  aboutToDisappear(): void {

  }

  onPageShow(): void {

  }

  onPageHide(): void {

  }

  focusChange() {
    focusControl.requestFocus('firstKey')
    console.log(TAG, 'ispoint: ' + this.isPoint + ' conval: ' + this.connVal)
  }


  /**
   * 获取接收端蓝牙扫描状态
   */
  getRemoteControllerReceiverBtSwitchStatus() {
    let receiverBtSwitchStatus: number = remoteControl.getRemoteControlReceiverBtSwitchStatusSync();
    if (receiverBtSwitchStatus == 0) {
      this.receiverBtSwitchStatus = false;
    } else {
      this.receiverBtSwitchStatus = true;
    }
    console.log(TAG, '当前指向遥控器接收器蓝牙扫描状态：' + this.receiverBtSwitchStatus) //0为未打开扫描开关，1为扫描开关已经打开
  }

  /**
   * 打开接收端蓝牙扫描
   */
  setRemoteControllerReceiverBtSwitchStatusOn() {
    let onInfo: number = remoteControl.ReceiverBtSwitchStatus.RECEIVER_BT_ON
    remoteControl.setRemoteControlReceiverBtSwitchStatusSync(onInfo);
    this.getRemoteControllerReceiverBtSwitchStatus()
    promptAction.showToast({ message: '蓝牙扫描开关已打开', duration: 1000 })
  }

  /**
   * 打开接收端蓝牙扫描
   */
  deleteRemoteControlPairSync() {
    let isDeleteRemoteControlPair: number = 1;
    isDeleteRemoteControlPair = remoteControl.deleteRemoteControlPairSync();
    console.debug(TAG, 'deleteRemoteControlPairSync result: ' + isDeleteRemoteControlPair) //0代表删除配对信息成功，-1代表删除信息失败
    if (isDeleteRemoteControlPair == 0) {
      this.isDeleteRemoteControlPair = true;
    } else if (isDeleteRemoteControlPair == -1) {
      this.isDeleteRemoteControlPair = false;
    }
  }

  /**
   * get report device ID
   */
  getDeviceID() {
    try {
      inputDevice.getDeviceList().then((ids: number[]) => {
        ids.forEach((val) => {
          if (!this.isReport) {
            this.isReportIn(val.valueOf())
          } else {
            return;
          }
        })
        console.log(TAG, `Device id list: ${JSON.stringify(ids)}`);
      });
    } catch (error) {
      console.log(TAG, `Failed to get device id list, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }

  /**
   * 接收器是否插入
   */
  isReportIn(deviceId: number) {
    console.log(TAG, 'remote controller deviceId：' + deviceId)
    let deviceData: inputDevice.InputDeviceData = inputDevice.getDeviceInfoSync(deviceId);
    if (deviceData) {
      if (deviceData.vendor == VENDOR && deviceData.product == PRODUCT) {
        console.log(TAG, `遥控器接收器已插入`);
        this.isReport = true;
        this.getRemoteControllerReceiverBtSwitchStatus()
        return;
      } else {
        this.isReport = false;
        console.log(TAG, `遥控器接收器未插入`);
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
        Column() {
          Text('遥控器连接状态：' + (this.isPoint ? '已连接' : (this.connVal == 0 ? '未配对' : '配对未连接')))
            .fontSize(lpx(48))
            .fontWeight(700)
            .fontColor('#dbffffff')
            .letterSpacing(lpx(4))
            .margin({ bottom: lpx(20), top: lpx(20) })
          Text('指向遥控器连接步骤：')
            .fontSize(lpx(48))
            .fontWeight(700)
            .fontColor('#dbffffff')
            .letterSpacing(lpx(4))
          Text('更换遥控器或接收器后按序执行操作：')
            .fontSize(lpx(30))
            .fontWeight(500)
            .fontColor('#99ffffff')
            .letterSpacing(lpx(4))
            .margin({ top: lpx(20) })

          Column() {
            Text('1.删除配对信息')
              .fontSize(lpx(30))
              .fontWeight(500)
              .fontColor(this.isPoint ? '#50FFFFFF' : '#dbffffff')
              .maxLines(2)
              .letterSpacing(lpx(4))
              .padding(lpx(8))
              .focusable(true)
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
          }
          .backgroundColor('#33ffffff')
          .key('firstKey')
          .margin({ bottom: lpx(20), top: lpx(20) })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .width(lpx(300))
          .focusable(true)
          .defaultFocus(true)
          .onFocus(() => {
            this.focusIndex = 0;
          })
          .onBlur(() => {
            this.focusIndex = -1;
          })
          .border({
            width: this.focusIndex == 0 ? 2 : 0,
            color: Color.White,
            radius: 10,
          })
          .onClick(()=>{
            if (!this.isPoint && this.isReport) {
              if (this.isDeleteRemoteControlPair) {
                promptAction.showToast({ message: '已删除配对信息', duration: 1000 })
              } else {
                promptAction.showToast({ message: '正在删除配对信息', duration: 1000 })
                this.deleteRemoteControlPairSync()
              }
            }
            if (!this.isReport) {
              promptAction.showToast({ message: '请先插入指向遥控器接收器', duration: 1000 })
            }
          })

          Column() {
            Text('2.开启蓝牙扫描')
              .fontSize(lpx(30))
              .fontWeight(500)
              .fontColor(this.isPoint ? '#50FFFFFF' : '#dbffffff')
              .maxLines(2)
              .letterSpacing(lpx(4))
              .padding(lpx(8))
              .focusable(true)
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
          }
          .backgroundColor('#33ffffff')
          .margin({ bottom: lpx(20) })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .width(lpx(300))
          .focusable(true)
          .onFocus(() => {
            this.focusIndex = 1;
          })
          .onBlur(() => {
            this.focusIndex = -1;
          })
          .border({
            width: this.focusIndex == 1 ? 2 : 0,
            color: Color.White,
            radius: 10,
          })
          .onClick(()=>{
            if (!this.isPoint && this.isReport) {
              if (this.receiverBtSwitchStatus) {
                promptAction.showToast({ message: '蓝牙扫描开关已打开', duration: 1000 })
              } else {
                if (this.isDeleteRemoteControlPair) {
                  promptAction.showToast({ message: '打开蓝牙扫描开关中', duration: 1000 })
                  this.setRemoteControllerReceiverBtSwitchStatusOn()
                } else {
                  promptAction.showToast({ message: '请先删除配对信息', duration: 1000 })
                }

              }
            }
            if (!this.isReport) {
              promptAction.showToast({ message: '请先插入指向遥控器接收器', duration: 1000 })
            }
          })

          Column({ space: lpx(20) }) {
            Text('请按照以下步骤依次操作: ' +
              '\n' + '-- 正常连接只执行第一、四步操作；' +
              '\n' + '-- 第二、三步操作仅在更换遥控器或接收器后执行；')
              .fontSize(lpx(30))
              .fontWeight(500)
              .fontColor('#99ffffff')
              .letterSpacing(lpx(4))
              .lineSpacing(LengthMetrics.lpx(5))
              .margin({ left: 8 })
            Text('1.插入指向遥控器接收器--' + (this.isReport ? '已插入' : '未插入'))
              .fontSize(lpx(34))
              .fontWeight(500)
              .fontColor(this.isPoint ? '#50FFFFFF' : '#dbffffff')
              .maxLines(2)
              .letterSpacing(lpx(2))
              .padding(8)
              .focusable(false)
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
            Text('2.删除配对信息(更换遥控器或接收器后执行)--' + (this.isDeleteRemoteControlPair ? '已删除' : '未删除'))
              .fontSize(lpx(34))
              .fontWeight(500)
              .fontColor(this.isPoint ? '#50FFFFFF' : '#dbffffff')
              .maxLines(2)
              .letterSpacing(lpx(2))
              .padding(8)
              .focusable(false)
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
            Text('3.开启蓝牙扫描(更换遥控器或接收器后执行)--' + (this.receiverBtSwitchStatus ? '已打开' : '未打开'))
              .fontSize(lpx(34))
              .fontWeight(500)
              .fontColor(this.isPoint ? '#50FFFFFF' : '#dbffffff')
              .maxLines(2)
              .letterSpacing(lpx(2))
              .padding(8)
              .focusable(false)
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
            Text('4.同时按下指向遥控器菜单键和Home键5s')
              .fontSize(lpx(34))
              .fontWeight(500)
              .fontColor(this.isPoint ? '#50FFFFFF' : '#dbffffff')
              .maxLines(2)
              .letterSpacing(lpx(2))
              .padding(8)
              .focusable(false)
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width(ConfigData.WH_55_100)
        .height(ConfigData.WH_100_100)
        .padding({ left: lpx(84), right: lpx(84) })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: '指向遥控器' })
          .width(ConfigData.WH_45_100)
          .height(ConfigData.WH_100_100)
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
