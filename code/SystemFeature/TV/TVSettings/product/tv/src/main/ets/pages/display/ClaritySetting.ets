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

import lpx from '../../common/Lpx';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import displaySetting from '@ohos.tvservice.displaySetting';
import { Duration } from '../../common/constants/Duration';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import promptAction from '@ohos.promptAction';

const TAG = 'claritySettingIndex'
const getNR: Record<number, string> = {
  0: '关闭',
  1: '低',
  2: '中',
  3: '高',
  4: '自动',
};
const getMpegNR: Record<number, string> = {
  0: '关闭',
  1: '低',
  2: '中',
  3: '高',
  4: '自动',
};

const getMemcLevelMap: Record<number, string> = {
  0: '关闭',
  1: '低',
  2: '中',
  3: '高',
  4: '自动',
};

/**
 * 显示设置
 */

@Entry
@Component
struct Display {
  @State imageUrl: string = ''
  @State des: string = ''
  @State settingList: SettingItemTvModel[] = []
  @State settingListCareful: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  // 锐利度
  @State sharpnessValue: number = 50;
  // 随机降噪
  @State denoise: string = '关闭';
  @State denoiseIndex: number = 0;
  // MPEG降噪
  @State mpegDenoise: string = '关闭';
  @State mpegDenoiseIndex: number = 0;
  //流畅度
  @State fluency: string = '低';
  @State fluencyIndex: number = 1;
  outputNRMap: Map<string, number> = new Map();

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  async aboutToAppear() {

    let item1 = new SettingItemTvModel();
    item1.name = '锐利度';
    item1.style = SettingItemStyle.valueChange;
    item1.value = this.sharpnessValue.toString();


    let item2 = new SettingItemTvModel();
    item2.name = '随机降噪';
    item2.style = SettingItemStyle.valueChange;
    item2.value = this.denoise;


    let item3 = new SettingItemTvModel();
    item3.name = 'MPEG降噪';
    item3.style = SettingItemStyle.valueChange;
    item3.value = this.mpegDenoise;

    let item4 = new SettingItemTvModel();
    item4.name = '流畅度';
    item4.style = SettingItemStyle.valueChange;
    item4.value = this.fluency;

    this.settingList.push(item1, item2, item3, item4);
  }
  onPageShow(): void {
    this.initOutputOpiton();
    this.getSharpness();
    this.getDenoise();
    this.getMPEGDenoise();
    this.getFluency();
  }

  async getSharpness() {
    try {
      let getSharpness: number = await displaySetting.getSharpness();
      LogUtil.log(TAG + 'getSharpnessSuccess=' + JSON.stringify(getSharpness));
      this.sharpnessValue=getSharpness
      this.settingList[0].setValue(getSharpness + '')
    } catch (error) {
      LogUtil.log(TAG + 'getPictureMode=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async getDenoise() {
    try {
      let mode: displaySetting.CommonLevel = await displaySetting.getNR();
      LogUtil.log(TAG + 'getNRSuccess=' + JSON.stringify(mode));
      LogUtil.log(TAG + 'getNRSuccess11=' + JSON.stringify(getNR[mode]));
      this.settingList[1].setValue(getNR[mode])
    } catch (error) {
      LogUtil.log(TAG + 'getNR=' + JSON.stringify(error));
    }
  }

  async getMPEGDenoise() {
    try {
      let mode: displaySetting.CommonLevel = await displaySetting.getMpegNR();
      LogUtil.log(TAG + 'getMpegNRSuccess=' + JSON.stringify(mode));
      LogUtil.log(TAG + 'getMpegNRSuccess11=' + JSON.stringify(getMpegNR[mode]));
      this.settingList[2].setValue(getMpegNR[mode])
    } catch (error) {
      LogUtil.log(TAG + 'getMpegNR=' + JSON.stringify(error));
    }
  }

  async getFluency() {
    try {
      let level: displaySetting.CommonLevel = await displaySetting.getMemcLevel();
      if (level == displaySetting.CommonLevel.COMMON_LEVEL_BUTT) {
        this.settingList[3].setIsShow(false);
      }
      LogUtil.log(TAG + 'getFluencySuccess=' + JSON.stringify(level));
      LogUtil.log(TAG + 'getFluencySuccess11=' + JSON.stringify(getMemcLevelMap[level]));
      this.settingList[3].setValue(getMemcLevelMap[level])
    } catch (error) {
      LogUtil.log(TAG + 'getFluency=' + JSON.stringify(error));
    }
  }

  initOutputOpiton() {
    this.outputNRMap.set('关闭', 0);
    this.outputNRMap.set('低', 1);
    this.outputNRMap.set('中', 2);
    this.outputNRMap.set('高', 3);
    this.outputNRMap.set('自动', 4);
  }

  // 数字设置
  sharpnessSetting(value: number, event: KeyEvent, min: number, max100: number) {
    if (event.keyCode == KeyCode.KEY_DPAD_LEFT && value > min) {
      return --value;
    }
    if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && value < max100) {
      return ++value;
    }
    return value
  }

  // 左右键控制事件
  stringChange(event: KeyEvent, index: number) {
    if (event.keyCode == KeyCode.KEY_DPAD_LEFT && index >= 0) {
      index--;
    }
    if (event.keyCode == KeyCode.KEY_DPAD_LEFT && index < 0) {
      index = 4;
    }
    if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && index <= 4) {
      index++;
    }
    if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && index > 4) {
      index = 0;
    }
    return index
  }

  stringChangeFluency(event: KeyEvent, index: number) {
    if (event.keyCode == KeyCode.KEY_DPAD_LEFT) {
      index--;
    }
    if (event.keyCode == KeyCode.KEY_DPAD_RIGHT) {
      index++;
    }
    index = (index + 5) % 5;
    return index;
  }

  async setSharpness() {
    try {
      LogUtil.log(TAG + 'this.sharpnessValue==:' + JSON.stringify(this.sharpnessValue));
      let setSharpness: boolean = await displaySetting.setSharpness(this.sharpnessValue); // 调用厂商api
      LogUtil.log(TAG + 'setSharpness SuccessBoolean==:' + JSON.stringify(setSharpness));
      if (!setSharpness) {
        promptAction.showToast({ message: '设置锐利度失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setSharpness=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setNR() {
    try {
      let setNR: boolean = await displaySetting.setNR(this.denoiseIndex); // 调用厂商api
      LogUtil.log(TAG + 'setNR SuccessBoolean==:' + JSON.stringify(setNR));
      if (!setNR) {
        promptAction.showToast({ message: '设置随机降噪失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setNR=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setMpegNR() {
    try {
      let setMpegNR: boolean = await displaySetting.setMpegNR(this.mpegDenoiseIndex); // 调用厂商api
      LogUtil.log(TAG + 'setMpegNR SuccessBoolean==:' + JSON.stringify(setMpegNR));
      if (!setMpegNR) {
        promptAction.showToast({ message: '设置MPEG降噪失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setMpegNR=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setFluency() {
    LogUtil.log(TAG + 'setgetFluency:' + JSON.stringify(this.fluencyIndex));
    try {
      let result: boolean = await displaySetting.setMemcLevel(this.fluencyIndex); // 调用厂商api
      LogUtil.log(TAG + 'setgetFluency SuccessBoolean==:' + JSON.stringify(result));
      if (!result) {
        promptAction.showToast({ message: '设置流畅度失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setgetFluency=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  build() {
    Stack() {
      Image($r('app.media.background_img'))
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        SettingListTvComponent({
          settingList: this.settingList,
          title: '清晰度与流畅度',
          subTitle: '系统·' + AppStorage.get('displayModeType'),
          onClickHandle: async (item: SettingItemTvModel) => {
          },
          onMouseClickHandle: async (item: SettingItemTvModel) => {
          },
          onValueChangeLeftHandle: async (item: SettingItemTvModel) => {
            let min = 0;
            let max100 = 100;
              if (item.name === '锐利度') {
                if (this.sharpnessValue>min) {
                  this.sharpnessValue--
                }
                item.setValue(this.sharpnessValue.toString());
                this.setSharpness()
              } else if (item.name === '随机降噪') {
                let select=0
                let origins: string[] = ['关闭', '低', '中', '高', '自动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    select=index
                  }
                })
                if (select>0) {
                  select--
                }
                this.denoiseIndex = select
                // 实现页面静态交互
                this.denoise = origins[this.denoiseIndex]
                item.setValue(origins[this.denoiseIndex]);
                this.setNR()
              } else if (item.name === 'MPEG降噪') {
                let select=0
                let origins: string[] = ['关闭', '低', '中', '高', '自动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    select=index
                  }
                })
                if (select>0) {
                  select--
                }
                this.mpegDenoiseIndex = select

                // 实现页面静态交互
                this.mpegDenoise = origins[this.mpegDenoiseIndex]
                item.setValue(origins[this.mpegDenoiseIndex]);
                this.setMpegNR()
              } else if (item.name === '流畅度') {
                let select=0
                let origins: string[] = ['关闭', '低', '中', '高', '自动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    select=index
                  }
                })
                if (select>0) {
                  select--
                }
                this.fluencyIndex = select

                // 实现页面静态交互
                this.fluency = origins[this.fluencyIndex]
                item.setValue(origins[this.fluencyIndex]);
                this.setFluency()
              }

          },
          onValueChangeRightHandle: async (item: SettingItemTvModel) => {
            let min = 0;
            let max100 = 100;
            if (item.name === '锐利度') {
              if (this.sharpnessValue < max100) {
                this.sharpnessValue++
              }
              item.setValue(this.sharpnessValue.toString());
              this.setSharpness()
            } else if (item.name === '随机降噪') {
              let select=0
              let origins: string[] = ['关闭', '低', '中', '高', '自动']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  select=index
                }
              })
              if (select<4) {
                select++
              }
              this.denoiseIndex = select
              // 实现页面静态交互
              this.denoise = origins[this.denoiseIndex]
              item.setValue(origins[this.denoiseIndex]);
              this.setNR()
            } else if (item.name === 'MPEG降噪') {
              let select=0
              let origins: string[] = ['关闭', '低', '中', '高', '自动']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  select=index
                }
              })
              if (select<4) {
                select++
              }
              this.mpegDenoiseIndex = select

              // 实现页面静态交互
              this.mpegDenoise = origins[this.mpegDenoiseIndex]
              item.setValue(origins[this.mpegDenoiseIndex]);
              this.setMpegNR()
            } else if (item.name === '流畅度') {
              let select=0
              let origins: string[] = ['关闭', '低', '中', '高', '自动']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  select=index
                }
              })
              if (select<4) {
                select++
              }
              this.fluencyIndex = select

              // 实现页面静态交互
              this.fluency = origins[this.fluencyIndex]
              item.setValue(origins[this.fluencyIndex]);
              this.setFluency()
            }

          },
          onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
            let min = 0;
            let max100 = 100;
            if (event.type === KeyType.Down) {
              if (item.name === '锐利度') {
                this.sharpnessValue = this.sharpnessSetting(this.sharpnessValue, event, 0, 100);
                item.setValue(this.sharpnessValue.toString());
                this.setSharpness()
              } else if (item.name === '随机降噪') {
                let origins: string[] = ['关闭', '低', '中', '高', '自动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.denoiseIndex = this.stringChange(event, index);
                  }
                })
                // 实现页面静态交互
                this.denoise = origins[this.denoiseIndex]
                item.setValue(origins[this.denoiseIndex]);
                this.setNR()
              } else if (item.name === 'MPEG降噪') {
                let origins: string[] = ['关闭', '低', '中', '高', '自动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.mpegDenoiseIndex = this.stringChange(event, index);
                  }
                })
                // 实现页面静态交互
                this.mpegDenoise = origins[this.mpegDenoiseIndex]
                item.setValue(origins[this.mpegDenoiseIndex]);
                this.setMpegNR()
              } else if (item.name === '流畅度') {
                let origins: string[] = ['关闭', '低', '中', '高', '自动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.fluencyIndex = this.stringChangeFluency(event, index);
                  }
                })
                // 实现页面静态交互
                this.fluency = origins[this.fluencyIndex]
                item.setValue(origins[this.fluencyIndex]);
                this.setFluency()
              }
            }
          }
        })
          .width(ConfigData.WH_52_100)
          .height(ConfigData.WH_100_100)
          .padding({ left: lpx(84) })
          .linearGradient({
            direction: GradientDirection.Right,
            repeating: true,
            colors: [['rgb(0,0,0)', 0.0], ['rgba(62,62,62,0.62)', 1]]
          })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
