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
import router from '@ohos.router';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import lpx from '../../common/Lpx';
import settings from '@ohos.settings';
import audioSetting from '@ohos.tvservice.audioSetting';
import promptAction from '@ohos.promptAction';
import { Duration } from '../../common/constants/Duration';
import { SettingItemTvComponent } from '../../default/layout/SettingItemTvComponent';
import { EventUtil } from '../../common/EventUtil';
import { sound } from '../../model/keyVolumeImpl/KeyControl';
import hueModel from '../../model/display/HueMode';

const TAG = 'outPutIndex'
const getDciLevelMap: Record<number, string> = {
  0: 'PCM',
  1: '源码',
  3: '自动',
};
const getSpdifModeMap: Record<number, string> = {
  0: 'PCM',
  1: '源码',
  2: '自动',
};

@Entry
@Component
struct OutPut {
  @StorageLink('isVolumeOn') isVolumeOn: boolean = false
  isFirstTouchEvent: boolean = true;
  @State listKey: string = 'listKey'
  isFocusable: boolean = true
  isAmplifying: Boolean = false
  @State isLeft: boolean = false;
  @State isTouchImg: boolean = false;
  private scroller: Scroller = new Scroller()
  subTitle: string | Resource = '';
  isAlignCenter: Boolean = false //内容、标题是否水平居中
  title: string | Resource = '输出';
  @State imageUrl: string = Ratio.resName('icon_volume')
  @State des: string = '选择声音输出方式'
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  outPutOptionMap: Map<string, number> = new Map();
  @StorageLink('outPut') @Watch('outPutChange') outPut: string = '本机扬声器';
  @State dynamicContrast: string = 'PCM'
  @State contrastIndex: number = 0;
  @StorageLink('bluetoothOutput') @Watch('bluetoothOutputChange') bluetoothOutput: string = ''
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
    this.init()
    this.initOutputOption()
  }

  initOutputOption() {
    this.outPutOptionMap.set('本机扬声器', 0);
    this.outPutOptionMap.set('S/PDIF', 4);
    this.outPutOptionMap.set('HDMI(ARC)', 3);
  }

  init() {
    let setting0 = new SettingItemTvModel();
    setting0.name = '本机扬声器';
    setting0.isSelect = false;
    setting0.style = SettingItemStyle.singleChoose

    let setting1 = new SettingItemTvModel();
    setting1.name = 'S/PDIF';
    setting1.isSelect = false;
    setting1.style = SettingItemStyle.singleChoose


    let setting2 = new SettingItemTvModel();
    setting2.name = 'HDMI(ARC)';
    setting2.isSelect = false;
    setting2.style = SettingItemStyle.singleChoose

    this.settingList.push(setting0, setting1, setting2);

    let setting4 = new SettingItemTvModel();
    setting4.name = '选择蓝牙设备';
    setting4.style = SettingItemStyle.default;
    setting4.pageUrl = 'pages/volume/BluetoothOutput'
    setting4.chooseDes = this.bluetoothOutput == '' ? '' : this.bluetoothOutput + '已连接';

    let item5 = new SettingItemTvModel();
    item5.name = '更多设置';
    item5.style = SettingItemStyle.info;
    item5.isNeedBg = false
    item5.isDisableFocus = true

    let item6 = new SettingItemTvModel();
    item6.name = '数字输出';
    item6.style = SettingItemStyle.valueChange;
    item6.value = this.dynamicContrast;

    this.settingList.push(setting4, item5, item6);
  }

  outPutChange(changedPropertyName: string) {
    if (this.outPut == 'HDMI(ARC)'||this.outPut == 'S/PDIF') {
      this.settingList[4].setStyle(5)
      this.settingList[5].setStyle(2)
      this.getDynamicContrast();
    } else {
      this.settingList[4].setStyle(10)
      this.settingList[5].setStyle(10)
    }
  }

  onPageShow(): void {
    this.getOutput() //输出设备
  }

  async getOutput() {
    try {
      let getAudioDev: audioSetting.AudioChannelType = await audioSetting.getAudioChannelType();
      LogUtil.log(TAG + 'getAudioChannelTypeSucess=' + JSON.stringify(getAudioDev));
      if (getAudioDev == 4) {
        this.outPut = 'S/PDIF'
        this.settingList[0].setIsSelect(false)
        this.settingList[1].setIsSelect(true)
        this.settingList[2].setIsSelect(false)
        this.settingList[4].setStyle(5)
        this.settingList[5].setStyle(2)
        this.getDynamicContrast();
        this.settingList[3].setChooseDes('')
      } else if (getAudioDev == 3) {
        this.outPut = 'HDMI(ARC)'
        this.settingList[0].setIsSelect(false)
        this.settingList[1].setIsSelect(false)
        this.settingList[2].setIsSelect(true)
        this.settingList[4].setStyle(5)
        this.settingList[5].setStyle(2)
        this.getDynamicContrast();
        this.settingList[3].setChooseDes('')
      } else if (getAudioDev == 0) {
        this.outPut = '本机扬声器'
        this.settingList[0].setIsSelect(true)
        this.settingList[1].setIsSelect(false)
        this.settingList[2].setIsSelect(false)
        this.settingList[4].setStyle(10)
        this.settingList[5].setStyle(10)
        this.settingList[3].setChooseDes('')
      } else if (getAudioDev == 2) {
        this.outPut = '蓝牙'
        this.settingList[0].setIsSelect(false)
        this.settingList[1].setIsSelect(false)
        this.settingList[2].setIsSelect(false)
        this.settingList[4].setStyle(10)
        this.settingList[5].setStyle(10)
        if (hueModel.getHue()) {
          LogUtil.log(TAG + 'hueModel.getHue=' + hueModel.getHue());
          this.bluetoothOutput = hueModel.getHue().split('#')[1];
          AppStorage.setOrCreate('bluetoothOutputId', hueModel.getHue().split('#')[0]);
        }
        this.settingList[3].setChooseDes(this.bluetoothOutput == '' ? '' : this.bluetoothOutput + '已连接')
      }
    } catch (error) {
      LogUtil.log(TAG + 'getAudioChannelTypeFailed=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
      this.outPut = ''
      this.settingList[0].setIsSelect(false)
      this.settingList[1].setIsSelect(false)
      this.settingList[2].setIsSelect(false)
      this.settingList[4].setStyle(10)
      this.settingList[5].setStyle(10)
      this.settingList[3].setChooseDes('')
    }
  }

  async getDynamicContrast() {
    if(this.outPut == 'HDMI(ARC)'){
      try {
        let getDciLevel: audioSetting.SoundArcModeType = await audioSetting.getArcMode()
        LogUtil.log(TAG + 'getArcModeSuccess=' + JSON.stringify(getDciLevel));
        LogUtil.log(TAG + 'getArcModeSuccess11=' + JSON.stringify(getDciLevelMap[getDciLevel]));
        this.dynamicContrast = getDciLevelMap[getDciLevel]
        this.settingList[5].setValue(getDciLevelMap[getDciLevel])
      } catch (error) {
        LogUtil.log(TAG + 'getArcMode=' + JSON.stringify(error));
        this.dynamicContrast = 'PCM'
        this.settingList[5].setValue('PCM')
      }
    } else if(this.outPut == 'S/PDIF'){
      try {
        let getSpdifMode: audioSetting.SoundSpdifModeType = await audioSetting.getSpdifMode()
        LogUtil.log(TAG + 'getSpdifModeSuccess=' + JSON.stringify(getSpdifMode));
        LogUtil.log(TAG + 'getSpdifModeSuccess11=' + JSON.stringify(getSpdifModeMap[getSpdifMode]));
        this.dynamicContrast = getSpdifModeMap[getSpdifMode]
        this.settingList[5].setValue(getSpdifModeMap[getSpdifMode])
      } catch (error) {
        LogUtil.log(TAG + 'getSpdifMode=' + JSON.stringify(error));
        this.dynamicContrast = 'PCM'
        this.settingList[5].setValue('PCM')
      }
    }
  }

  bluetoothOutputChange(changedPropertyName: string) {
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

  async setAudioEffect(name1: string) {
    console.log(this.outPut,'999999')
    if(this.outPut == 'HDMI(ARC)'){
      try {
        if (name1 == '数字输出') {
          let setAudioEffect: boolean = await audioSetting.setArcMode(this.dynamicContrast == 'PCM' ? 0 :
            this.dynamicContrast == '源码' ? 1 : this.dynamicContrast == '自动' ? 3 : 4);
          LogUtil.log(TAG + 'setArcMode SuccessBoolean==:' + JSON.stringify(setAudioEffect));
          if (!setAudioEffect) {
            promptAction.showToast({ message: `设置HDMI(ARC)${name1}失败` })
          }
        }
      } catch (error) {
        LogUtil.log(TAG + 'setArcModeFailed=' + JSON.stringify(error));
        promptAction.showToast({ message: $r('app.string.tips_in_development') })
      }
    } else if(this.outPut == 'S/PDIF'){
      try {
        if (name1 == '数字输出') {
          let setSpdifMode: boolean = await audioSetting.setSpdifMode(this.dynamicContrast == 'PCM' ? 0 :
            this.dynamicContrast == '源码' ? 1 : this.dynamicContrast == '自动' ? 2 : 4);
          LogUtil.log(TAG + 'setSpdifMode SuccessBoolean==:' + JSON.stringify(setSpdifMode));
          if (!setSpdifMode) {
            promptAction.showToast({ message: `设置S/PDIF${name1}失败` })
          }
        }
      } catch (error) {
        LogUtil.log(TAG + 'setSpdifModeFailed=' + JSON.stringify(error));
        promptAction.showToast({ message: $r('app.string.tips_in_development') })
      }
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
              title: '输出',
              onClickHandle: (item: SettingItemTvModel) => {
              },
              onMouseClickHandle: (item: SettingItemTvModel) => {
                if (item.name != '选择蓝牙设备') {
                  if (item.name != '数字输出') {
                    this.bluetoothOutput = ''
                    this.settingList[3].setChooseDes('');
                    AppStorage.setOrCreate('bluetoothOutputId', '');
                    this.outPut = item.name;
                    this.setAudioOutputType(this.outPutOptionMap.get(item.name) as number)
                  }
                }
                router.pushUrl({
                  url: item.pageUrl
                })
                this.pageTranState = true
              },
              onValueChangeLeftHandle: (item: SettingItemTvModel) => {
                if (item.name == '数字输出') {
                  let origins: string[] = ['PCM', '源码', '自动']
                  if (item.value == 'PCM') {
                    this.contrastIndex = 2
                  } else if (item.value == '源码') {
                    this.contrastIndex = 0
                  } else if (item.value == '自动') {
                    this.contrastIndex = 1
                  }
                  this.dynamicContrast = origins[this.contrastIndex];
                  item.setValue(origins[this.contrastIndex]);
                  this.setAudioEffect(item.name)
                }
              },
              onValueChangeRightHandle: (item: SettingItemTvModel) => {
                if (item.name == '数字输出') {
                  let origins: string[] = ['PCM', '源码', '自动']
                  if (item.value == 'PCM') {
                    this.contrastIndex = 1
                  } else if (item.value == '源码') {
                    this.contrastIndex = 2
                  } else if (item.value == '自动') {
                    this.contrastIndex = 0
                  }
                  this.dynamicContrast = origins[this.contrastIndex];
                  item.setValue(origins[this.contrastIndex]);
                  this.setAudioEffect(item.name)
                }
              },
              onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
                if (item.pageUrl && event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up) {
                  router.pushUrl({
                    url: item.pageUrl
                  })
                  this.pageTranState = true
                }
                if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Up && item.name != '选择蓝牙设备') {
                  if (item.name != '数字输出') {
                    this.bluetoothOutput = ''
                    this.settingList[3].setChooseDes('');
                    AppStorage.setOrCreate('bluetoothOutputId', '');
                    this.outPut = item.name;
                    this.setAudioOutputType(this.outPutOptionMap.get(item.name) as number)
                  }
                }
                if (event.keyCode == KeyCode.KEY_DPAD_LEFT && event.type === KeyType.Up) {
                  if (item.name == '数字输出') {
                    let origins: string[] = ['PCM', '源码', '自动']
                    if (item.value == 'PCM') {
                      this.contrastIndex = 2
                    } else if (item.value == '源码') {
                      this.contrastIndex = 0
                    } else if (item.value == '自动') {
                      this.contrastIndex = 1
                    }
                    this.dynamicContrast = origins[this.contrastIndex];
                    item.setValue(origins[this.contrastIndex]);
                    this.setAudioEffect(item.name)
                  }
                }
                if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && event.type === KeyType.Up) {
                  if (item.name == '数字输出') {
                    let origins: string[] = ['PCM', '源码', '自动']
                    if (item.value == 'PCM') {
                      this.contrastIndex = 1
                    } else if (item.value == '源码') {
                      this.contrastIndex = 2
                    } else if (item.value == '自动') {
                      this.contrastIndex = 0
                    }
                    this.dynamicContrast = origins[this.contrastIndex];
                    item.setValue(origins[this.contrastIndex]);
                    this.setAudioEffect(item.name)
                  }
                }
              },
              onFocusHandle: (item: SettingItemTvModel) => {
                if (item.name == '数字输出') {
                  this.imageUrl = Ratio.resName('icon_volume')
                  this.des = '由HDMI线连接的音频输出设备进行发声'
                } else {
                  this.imageUrl = Ratio.resName('icon_volume')
                  this.des = '选择声音输出方式'
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
