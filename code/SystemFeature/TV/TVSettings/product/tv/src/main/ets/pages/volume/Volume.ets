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
/**
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
import { Ratio } from '../../common/Ratio';
import lpx from '../../common/Lpx';
import router from '@ohos.router';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { KeyCode } from '../../common/constants/KeyCode';
import Audio from '@ohos.multimedia.audio';
import { VolumeModel, registerObserver, getAudioManager } from '../../model/volumeControlImpl/VolumeControlModel';
import settings from '@ohos.settings';
import audioSetting from '@ohos.tvservice.audioSetting';
import { Duration } from '../../common/constants/Duration';
import { promptAction } from '@kit.ArkUI';

const TAG = 'VolumeIndex'

const audioManager: Audio.AudioManager = getAudioManager();
/**
 * 声音设置
 */
@Entry
@Component
struct Volume {
  volumeModel: VolumeModel = new VolumeModel(Audio.AudioVolumeType.MEDIA)
  @State imageUrl: string = Ratio.resName('icon_volume')
  @State des: string | Resource = $r('app.string.select_sound_output_mode')
  @State settingList: SettingItemTvModel[] = []
  @StorageLink('volume_media') @Watch('onVolumeChange') volumeMedia: number = 2;
  @StorageLink('outPut') outPut: string = '本机扬声器';
  @State effect: string = '自动'
  @StorageLink('isVolumeOn') isVolumeOn: boolean = false
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
  onVolumeChange() {
    for(let i=0;i<this.settingList.length;i++){
      if (this.settingList[i].name == '音量') {
        this.settingList[i].setValue(this.volumeMedia.toString());
        break;
      }
    }
  }

  aboutToAppear() {
    registerObserver();
    audioManager.on('deviceChange', async (data: Audio.DeviceChangeAction) => {
      if (data.type === Audio.DeviceChangeType.CONNECT) {
        let outDeviceList = data.deviceDescriptors.filter(device => {
          return device.deviceRole === Audio.DeviceRole.OUTPUT_DEVICE
        })
        outDeviceList.forEach(async device => {
          if (device.deviceType === Audio.DeviceType.BLUETOOTH_A2DP) {
            AppStorage.setOrCreate('outPut', '蓝牙');
            this.settingList[0].setChooseDes(this.outPut);
            await audioSetting.setAudioChannelType(audioSetting.AudioChannelType.AUDIO_CHANNEL_BLUETOOTH);
          }
        })
      } else {
        // 断开后重新查找输出设备
        setTimeout(() => {
          this.getOutput();
        }, 100)
      }
    })
    this.init();
  }
  onPageShow(): void {
    this.getEffect() //音效
    this.getOutput() //输出设备
  }

  async getEffect() {
      try {
        let getAudioEffect: audioSetting.AudioEffectMode = await audioSetting.getAudioEffect();
        LogUtil.log(TAG + 'getAudioEffectSucess===' + getAudioEffect);
        if (getAudioEffect == 0) {
          this.effect = '自动'
        } else if (getAudioEffect == 1) {
          this.effect = '标准'
        } else if (getAudioEffect == 2) {
          this.effect = '影院'
        } else if (getAudioEffect == 3) {
          this.effect = '音乐'
        } else if (getAudioEffect== 4) {
          this.effect = '新闻'
        } else if (getAudioEffect== 5) {
          this.effect = '自定义音效'
        } else if (getAudioEffect == -1) {
          this.settingList[2].setIsEnable(false);
          this.settingList[2].setIsDisableFocus(true);
          this.effect = '关闭';
        }
        this.settingList[2].setChooseDes(this.effect);
        AppStorage.setOrCreate('effect',this.effect);
      } catch (error) {
        LogUtil.log(TAG + 'getAudioEffectFailed=' + JSON.stringify(error));
        this.effect = '自动'
        this.settingList[2].setChooseDes(this.effect);
        AppStorage.setOrCreate('effect',this.effect);
      }
  }

  async getOutput() {
      try {
        let getAudioDev:audioSetting.AudioChannelType= await audioSetting.getAudioChannelType();
        LogUtil.log(TAG + 'getAudioChannelTypeSucess=' + JSON.stringify(getAudioDev));
        if(getAudioDev==4){
          this.outPut = 'S/PDIF'
        } else if(getAudioDev==3){
          this.outPut = 'HDMI(ARC)'
        } else if(getAudioDev==0){
          this.outPut = '本机扬声器'
        } else if(getAudioDev==2){
          this.outPut = '蓝牙'
        }
        this.settingList[0].setChooseDes(this.outPut);
      } catch (error) {
        LogUtil.log(TAG + 'getAudioChannelTypeFailed=' + JSON.stringify(error));
        promptAction.showToast({ message: $r('app.string.tips_in_development') })
        this.outPut = ''
        this.settingList[0].setChooseDes(this.outPut);
      }
  }

  init() {
    let setting1 = new SettingItemTvModel();
    setting1.name = '输出';
    setting1.chooseDes = this.outPut;
    setting1.style = SettingItemStyle.default
    setting1.pageUrl = 'pages/volume/OutPut';
    setting1.description = $r('app.string.select_sound_output_mode');

    let setting2 = new SettingItemTvModel();
    setting2.name = '音量';
    setting2.style = SettingItemStyle.valueChange
    setting2.value = this.volumeMedia.toString();
    setting2.description = $r('app.string.adjust_the_volume_of_the_TV');

    let setting3 = new SettingItemTvModel();
    setting3.name = '音效';
    setting3.style = SettingItemStyle.default
    setting3.chooseDes = this.effect;
    setting3.pageUrl = 'pages/volume/Effects';
    setting3.description = $r('app.string.select_modes_based_on_content_to_enhance_auditory_enjoyment');

    let setting4 = new SettingItemTvModel();
    setting4.name = '按键音';
    setting4.isOn = this.isVolumeOn
    setting4.style = SettingItemStyle.switch
    setting4.description = $r('app.string.controlling_the_sound_feedback_of_the_TV');

    this.settingList.push(setting1, setting2, setting3, setting4);

  }

  onChange() {

  }

  async setKeyToneEnable(setKeyToneEnableBoolean:boolean){
    try {
      let setKeyToneEnable: boolean = await audioSetting.setKeyToneEnable(setKeyToneEnableBoolean); // 调用厂商api
      LogUtil.log(TAG + 'setKeyToneEnable SuccessBoolean==:' + JSON.stringify(setKeyToneEnable));
      if (!setKeyToneEnable) {
        promptAction.showToast({ message: `设置${setKeyToneEnableBoolean ? '开启' : '关闭'}按键音失败` })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setKeyToneEnable=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
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
          title: '声音',
          onMouseClickHandle: (item: SettingItemTvModel) => {
            router.pushUrl({
              url: item.pageUrl
            })
            this.pageTranState = true
          },
          onValueChangeLeftHandle:(item: SettingItemTvModel)=>{
            let origin = parseInt(item.value)
            if (origin > 0) {
              origin--;
            }
            item.setValue(origin.toString())
            //使用系统api设置音量调节
            this.volumeModel.setVolume(origin);
          },
          onValueChangeRightHandle:(item: SettingItemTvModel)=>{
            let origin = parseInt(item.value)
            if (origin < 15) {
              origin++;
            }
            item.setValue(origin.toString())
            this.volumeModel.setVolume(origin);
          },
          onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {

            if (item.name === '音量') {
              if (event.type == KeyType.Down) {
                if (event.keyCode == KeyCode.KEY_DPAD_LEFT) { // left
                  let origin = parseInt(item.value)
                  if (origin > 0) {
                    origin--;
                  }
                  item.setValue(origin.toString())
                  //使用系统api设置音量调节
                  this.volumeModel.setVolume(origin);
                }

                if (event.keyCode === KeyCode.KEY_DPAD_RIGHT) { // right
                  let origin = parseInt(item.value)
                  if (origin < 15) {
                    origin++;
                  }
                  item.setValue(origin.toString())
                  this.volumeModel.setVolume(origin);
                }
              }
            }
          },
          onFocusHandle: (item: SettingItemTvModel) => {
            this.des = item.description
          },
          onToggleChangedHandle: (item: SettingItemTvModel, isOn: boolean) => {
            if (item.isOn) {
              AppStorage.setOrCreate('isVolumeOn', true)
              this.setKeyToneEnable(true)
            } else {
              AppStorage.setOrCreate('isVolumeOn', false)
              this.setKeyToneEnable(false)
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
