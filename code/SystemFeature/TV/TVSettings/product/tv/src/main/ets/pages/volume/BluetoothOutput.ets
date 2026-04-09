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
import { CustomDialogContentStyle, SettingItemStyle, SourcetoolConstants } from '../../common/constants/StyleConstants';
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import router from '@ohos.router';
import BluetoothDevice from '../../model/bluetoothImpl/BluetoothDevice';
import { SettingItemTvComponent } from '../../default/layout/SettingItemTvComponent';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import EntryComponent from '../../default/layout/EntryComponent';
import { DeviceType, ProfileConnectionState } from '../../model/bluetoothImpl/BluetoothModel';
import BluetoothDeviceController from '../../controller/bluetooth/BluetoothDeviceController';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import { getDeviceIconPath } from '../bluetooth/BluetoothDeviceEntry';
import { sound } from '../../model/keyVolumeImpl/KeyControl';
import { Duration } from '../../common/constants/Duration';
import { EventUtil } from '../../common/EventUtil';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import audioSetting from '@ohos.tvservice.audioSetting';
import { promptAction } from '@kit.ArkUI';
import hueModel from '../../model/display/HueMode';

const TAG = 'BluetoothOutput'

@Entry
@Component
struct BluetoothOutput {
  @StorageLink('isVolumeOn') isVolumeOn: boolean = false
  @State imageUrl: string = Ratio.resName('icon_bluetooth')
  @State des: string = '查看附近可用的蓝牙设备'
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  private scroller: Scroller = new Scroller()
  @State isOne: boolean = true
  private controller: BluetoothDeviceController = new BluetoothDeviceController();
  @StorageLink('bluetoothPairedDevices') @Watch('onPairedDevicesChange') pairedDevices: BluetoothDevice[] = [];
  @State pairedDevicesList: SettingItemTvModel[] = []
  @State isLeft: boolean = false;
  @State isTouchImg: boolean = false;
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

  onPairedDevicesChange() {
    console.log('lzh onPairedDevicesChange')
    this.pairedDevicesList = []
    const bluetoothOutputId: string = AppStorage.get('bluetoothOutputId') || '';
    this.pairedDevices
      .filter((item: BluetoothDevice) => {
        return item.connectionState === ProfileConnectionState.STATE_CONNECTED
      })
      .forEach((item: BluetoothDevice) => {
        console.log('lzh onPairedDevicesChange forEach item ' + JSON.stringify(item))
        let model: SettingItemTvModel = new SettingItemTvModel();
        model.name = item.deviceName;
        model.value = item.deviceId;
        model.setIsSelect(bluetoothOutputId === model.value);
        model.style = SettingItemStyle.singleChoose;
        this.pairedDevicesList.push(model);
      })
    if (this.pairedDevicesList.length <= 0) {
      AppStorage.setOrCreate('bluetoothOutput', '');
      AppStorage.setOrCreate('bluetoothOutputId', '');
      this.getOutput() //输出设备
      hueModel.setHue('')
    } else {
      if (this.pairedDevicesList.some(obj => obj.isSelect == true)) {
        LogUtil.log(TAG + '存在选中');
        hueModel.setHue(AppStorage.get('bluetoothOutputId') + '#' + AppStorage.get('bluetoothOutput'));
      } else {
        LogUtil.log(TAG + '没选中');
        //没选中
        AppStorage.setOrCreate('bluetoothOutput', '');
        AppStorage.setOrCreate('bluetoothOutputId', '');
        this.getOutput() //输出设备
        hueModel.setHue('')
      }
    }
  }

  aboutToAppear(): void {
    let setting1 = new SettingItemTvModel();
    setting1.name = '查找设备';
    setting1.style = SettingItemStyle.default;
    setting1.pageUrl = 'pages/bluetooth/BluetoothDeviceEntry';
    this.settingList.push(setting1)

    this.controller.initData().subscribe();
  }

  aboutToDisappear(): void {
    this.controller.unsubscribe();
  }

  async getOutput() {
    try {
      let getAudioDev: audioSetting.AudioChannelType = await audioSetting.getAudioChannelType();
      LogUtil.log(TAG + 'getAudioChannelTypeSucess=' + JSON.stringify(getAudioDev));
      this.setAudioOutputType(getAudioDev);
    } catch (error) {
      LogUtil.log(TAG + 'getAudioChannelTypeFailed=' + JSON.stringify(error));
      this.setAudioOutputType(0)
    }
  }

  async setAudioOutputType(value: number) {
    LogUtil.log(TAG + 'valueNumber' + JSON.stringify(value));
    try {
      let setAudioDev: boolean = await audioSetting.setAudioChannelType(value);
      LogUtil.log(TAG + 'setAudioChannelTypeSuccess= SuccessBoolean==:' + JSON.stringify(setAudioDev));
      if (!setAudioDev) {
        promptAction.showToast({ message: '设置声音输出失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setAudioChannelTypeFail=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  build() {
    Column() {
      Stack() {
        SettingBackground()
          .position({ x: 0, y: 0 })
          .height(ConfigData.WH_100_100)
          .width(ConfigData.WH_100_100)

        Row() {
          Column() {
            Column() {
              Text('选择蓝牙设备')
                .height(lpx(75))
                .lineHeight(lpx(75))
                .fontColor(Color.White)
                .fontSize(lpx(64))
                .fontWeight(500)
                .textAlign(TextAlign.Start)
                .margin({
                  top: lpx(48),
                  bottom: lpx(48),
                  left: lpx(12)
                })

              List({ space: lpx(24), scroller: this.scroller }) {
                ForEach(this.settingList, (item: SettingItemTvModel, index: number) => {
                  ListItem() {
                    SettingItemTvComponent({
                      model: item,
                      isFocus: this.focusIndex === index && this.isOne,
                      isLeft: this.isLeft,
                      isTouchImg: this.isTouchImg,
                    })
                  }
                  .height(this.focusIndex === index && this.isOne ? lpx(118) : lpx(98))
                  .width(lpx(868))
                  .borderRadius(lpx(18))
                  .border(this.focusIndex === index && this.isOne ? {
                    width: lpx(2),
                    color: Color.White,
                    radius: lpx(24),
                    style: BorderStyle.Solid
                  } : { width: 0 })
                  .focusable(true)
                  .defaultFocus(index === 0 ? true : false)
                  .onFocus(() => {
                    this.isOne = true
                    LogUtil.info('onFocus itemName: ' + item.name);
                    this.focusIndex = index
                    // 滚动
                    this.scroller.scrollToIndex(index)
                  })
                  .onBlur(() => {
                    this.focusIndex = -1
                  })
                  .onKeyEvent((event) => {
                    if (!event) {
                      return;
                    }
                    if (this.isVolumeOn) {
                      sound.playAudio()
                    }
                    if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up) {
                      router.pushUrl({ url: item.pageUrl })
                      this.pageTranState = true
                    }
                  })
                  .onHover(() => {
                    this.focusIndex = index
                  })
                  .onClick(()=>{
                    router.pushUrl({ url: item.pageUrl })
                    this.pageTranState = true
                  })
                  .onTouch((event) => {
                    if (!event) {
                      return;
                    }
                    if (!EventUtil.isTouchEvent(event)) {
                      return;
                    }
                    if (event.sourceTool !== SourceTool.Pen &&
                      event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                      return;
                    }
                    if (this.isVolumeOn) {
                      sound.playAudio()
                    }
                    router.pushUrl({ url: item.pageUrl })
                  })
                })
              }
              .width(ConfigData.WH_100_100)
            }
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Start)

            Text($r('app.string.bluetooth_paired_devices'))
              .fontColor('rgba(255, 255, 255, 0.9)')
              .fontSize(lpx(24))
              .lineHeight(lpx(28))
              .textAlign(TextAlign.Start)
              .width(ConfigData.WH_100_100)
              .padding({
                top: lpx(24),
                left: lpx(12),
                bottom: lpx(12)
              })

            SettingListTvComponent({
              settingList: this.pairedDevicesList,
              title: '',
              onClickHandle: (item: SettingItemTvModel) => {
              },
              onKeyEventHandle: async (item: SettingItemTvModel, event: KeyEvent) => {
                if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up) {
                  try {
                    let setAudioDev: boolean = await audioSetting.setAudioChannelType(2);
                    LogUtil.log(TAG + 'setAudioChannelTypeSuccess= SuccessBoolean==:' + JSON.stringify(setAudioDev));
                    AppStorage.setOrCreate('bluetoothOutput', item.name);
                    AppStorage.setOrCreate('bluetoothOutputId', item.value);
                    if (!setAudioDev) {
                      AppStorage.setOrCreate('bluetoothOutput', '');
                      AppStorage.setOrCreate('bluetoothOutputId', '');
                      promptAction.showToast({ message: '设置声音输出失败' })
                    }
                  } catch (error) {
                    AppStorage.setOrCreate('bluetoothOutput', '');
                    AppStorage.setOrCreate('bluetoothOutputId', '');
                    LogUtil.log(TAG + 'setAudioChannelTypeFail=' + JSON.stringify(error));
                    promptAction.showToast({ message: $r('app.string.tips_in_development') })
                  }
                }
              },
              onFocusHandle: (item: SettingItemTvModel) => {
              }
            })

          }
          .width(ConfigData.WH_50_100)
          .height(ConfigData.WH_100_100)
          .margin({ left: lpx(84) })

          SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
            .width(ConfigData.WH_50_100)
            .height(ConfigData.WH_100_100)
        }
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
