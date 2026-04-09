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
import lpx from '../../common/Lpx';
import router from '@ohos.router';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvComponent } from '../../default/layout/SettingItemTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import displaySetting from '@ohos.tvservice.displaySetting';
import promptAction from '@ohos.promptAction';
import { Duration } from '../../common/constants/Duration';

const TAG = 'brightnessIndex'
const getDciLevelMap: Record<number, string> = {
  0: '关闭',
  1: '低',
  2: '中',
  3: '高',
};

interface gammaTypeMap {
  gammaType: number,
  text: number
}

const gammaMap: gammaTypeMap[] = [
  { gammaType: 0, text: 1.8 },
  { gammaType: 1, text: 1.9 },
  { gammaType: 2, text: 2.0 },
  { gammaType: 3, text: 2.1 },
  { gammaType: 4, text: 2.2 },
  { gammaType: 5, text: 2.3 },
  { gammaType: 6, text: 2.4 },
  { gammaType: 7, text: 2.5 },
  { gammaType: 8, text: 2.6 }
];


@Entry
@Component
struct Display {
  @State imageUrl: string = ''
  @State des: string = ''
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  // 亮度
  @State brightnessValue: number = 100;
  // 峰值亮度
  @State peakBrightnessValue: string = '关闭'
  @State peakBrightnessIndex: number = 0;
  // 对比度
  @State contrastValue: number = 0;
  // 伽马
  @State gamma: number = 10;
  // 黑色级别
  @State blackValue: number = 0;
  // 动态对比度
  @State dynamicContrast: string = '关闭'
  @State contrastIndex: number = 0;
  // 动态背光
  @State dynamicBacklight: boolean = true
  private context: Context = getContext(this);

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  async aboutToAppear() {
    let item1 = new SettingItemTvModel();
    item1.name = '亮度';
    item1.style = SettingItemStyle.valueChange;
    item1.value = this.brightnessValue.toString();

    let item7 = new SettingItemTvModel();
    item7.name = '峰值亮度';
    item7.style = SettingItemStyle.valueChange;
    item7.value = this.peakBrightnessValue;


    let item2 = new SettingItemTvModel();
    item2.name = '对比度';
    item2.style = SettingItemStyle.valueChange;
    item2.value = this.contrastValue.toString();

    let item3 = new SettingItemTvModel();
    item3.name = '伽马';
    item3.style = SettingItemStyle.valueChange;

    const findGammaIndex = gammaMap.findIndex((item) => item.gammaType === this.gamma)
    if (findGammaIndex !== -1) {
      this.gamma = findGammaIndex
      item3.value = gammaMap[this.gamma].text.toFixed(1);
    }


    let item4 = new SettingItemTvModel();
    item4.name = '黑色级别';
    item4.style = SettingItemStyle.valueChange;
    item4.value = this.blackValue.toString();
    item4.isShow = false


    let item5 = new SettingItemTvModel();
    item5.name = '动态对比度';
    item5.style = SettingItemStyle.valueChange;
    item5.value = this.dynamicContrast;


    let item6 = new SettingItemTvModel();
    item6.name = '动态背光';
    item6.style = SettingItemStyle.switch;
    item6.isOn = this.dynamicBacklight;
    this.settingList.push(item1, item2, item3, item4, item5, item6);
  }

  onPageShow(): void {
    // 初始化时读硬件数据
    this.getBrightnessValue();
    this.getContrastValue();
    this.getGamma();
    this.getBlack();
    this.getDynamicContrast();
    this.getBackLightInfo();
  }

  async getGamma() {
    try {
      let getGammaType: number = await displaySetting.getGammaType()
      LogUtil.log(TAG + 'getGammaTypeSuccess=' + JSON.stringify(getGammaType));

      const findGammaIndex = gammaMap.findIndex((item) => item.gammaType === getGammaType)
      if (findGammaIndex !== -1) {
        this.gamma = findGammaIndex
        this.settingList[2].setValue(gammaMap[this.gamma].text.toFixed(1))
      }

    } catch (error) {
      LogUtil.log(TAG + 'getGammaTypeValue=' + JSON.stringify(error));
    }
  }

  async getBlack() {
    try {
      let getBacklight: number = await displaySetting.getBacklight()
      LogUtil.log(TAG + 'getBacklightSuccess=' + JSON.stringify(getBacklight));
      this.settingList[3].setValue(getBacklight + '')
      this.blackValue = getBacklight
    } catch (error) {
      LogUtil.log(TAG + 'getBacklightValue=' + JSON.stringify(error));
    }
  }

  async getDynamicContrast() {
    try {
      let getDciLevel: displaySetting.CommonLevel = await displaySetting.getDciLevel()
      LogUtil.log(TAG + 'getDciLevelSuccess=' + JSON.stringify(getDciLevel));
      LogUtil.log(TAG + 'getDciLevelSuccess11=' + JSON.stringify(getDciLevelMap[getDciLevel]));
      this.settingList[4].setValue(getDciLevelMap[getDciLevel])
    } catch (error) {
      LogUtil.log(TAG + 'getDciLevelValue=' + JSON.stringify(error));
    }
  }

  async getBackLightInfo() {
    try {
      let isDynamicBacklightSupport: boolean = await displaySetting.isDynamicBacklightSupport();
      if (isDynamicBacklightSupport) {
        let getIsDynamicBacklight: number = await displaySetting.isDynamicBacklight()
        LogUtil.log(TAG + 'getIsDynamicBacklightSuccess=' + JSON.stringify(getIsDynamicBacklight));
        this.settingList[5].setIsOn(getIsDynamicBacklight === 1 ? true : false)
        this.dynamicBacklight = getIsDynamicBacklight === 1 ? true : false
      } else {
        this.settingList[5].setIsShow(false);
      }
    } catch (error) {
      LogUtil.log(TAG + 'getIsDynamicBacklightValue=' + JSON.stringify(error));
      this.settingList[5].setIsOn(false)
      this.dynamicBacklight=false
    }
  }

  // 读硬件亮度
  async getBrightnessValue() {
    try {
      this.brightnessValue = await displaySetting.getBrightness()
      LogUtil.log(TAG + 'getBrightnessValueSuccess=' + JSON.stringify(this.brightnessValue));
      this.settingList[0].setValue(this.brightnessValue.toString())
    } catch (error) {
      LogUtil.log(TAG + 'getBrightnessValue=' + JSON.stringify(error));
    }
  }

  // 读硬件对比度
  async getContrastValue() {
    try {
      this.contrastValue = await displaySetting.getContrast()
      this.settingList[1].setValue(this.contrastValue.toString())
    } catch (error) {
      LogUtil.log(TAG + 'getContrastValue=' + JSON.stringify(error));
    }
  }

  // 数字设置
  numberSetting(value: number, event: KeyEvent, min: number, max100: number) {
    if (event.keyCode === KeyCode.KEY_DPAD_LEFT && value > min) {
      return --value;
    }
    if (event.keyCode === KeyCode.KEY_DPAD_RIGHT && value < max100) {
      return ++value;
    }
    return value
  }

  // 左右键控制事件
  stringChange(event: KeyEvent, index: number) {
    if (event.keyCode === KeyCode.KEY_DPAD_LEFT && index >= 0) {
      index--;
    }
    if (event.keyCode === KeyCode.KEY_DPAD_LEFT && index < 0) {
      index = 3;
    }
    if (event.keyCode === KeyCode.KEY_DPAD_RIGHT && index <= 3) {
      index++;
    }
    if (event.keyCode === KeyCode.KEY_DPAD_RIGHT && index > 3) {
      index = 0;
    }
    return index
  }

  async setOutputBrightness() {
    try {
      let setBrightness: boolean = await displaySetting.setBrightness(this.brightnessValue); // 调用厂商api
      LogUtil.log(TAG + 'setOutputBrightness SuccessBoolean==:' + JSON.stringify(setBrightness));
      if (!setBrightness) {
        promptAction.showToast({ message: '设置亮度失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setBrightness=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setOutputContrast() {
    try {
      let setContrastValue: boolean = await displaySetting.setContrast(this.contrastValue); // 调用厂商api
      LogUtil.log(TAG + 'setContrastValue SuccessBoolean==:' + JSON.stringify(setContrastValue));
      if (!setContrastValue) {
        promptAction.showToast({ message: '设置对比度失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setContrastValue=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setOutputGrammaType() {
    try {
      const setGammaType = gammaMap[this.gamma].gammaType;
      LogUtil.log(TAG + 'setSetGammaType this.gamma==:' + JSON.stringify(this.gamma));
      LogUtil.log(TAG + 'setSetGammaType setGammaType==:' + JSON.stringify(setGammaType));
      let setSetGammaType: boolean = await displaySetting.setGammaType(setGammaType); // 调用厂商api
      LogUtil.log(TAG + 'setSetGammaType SuccessBoolean==:' + JSON.stringify(setSetGammaType));
      if (!setSetGammaType) {
        promptAction.showToast({ message: '设置伽马失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setSetGammaType=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setBlack() {
    try {
      let setBlackValue: boolean = await displaySetting.setBacklight(this.blackValue); // 调用厂商api
      LogUtil.log(TAG + 'setBlackValue SuccessBoolean==:' + JSON.stringify(setBlackValue));
      if (!setBlackValue) {
        promptAction.showToast({ message: '设置黑色级别失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setBlackValue=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setOutputDciLevel() {
    try {
      let setDciLevelValue: boolean = await displaySetting.setDciLevel(this.contrastIndex); // 调用厂商api
      LogUtil.log(TAG + 'setDciLevelValue SuccessBoolean==:' + JSON.stringify(setDciLevelValue));
      if (!setDciLevelValue) {
        promptAction.showToast({ message: '设置动态对比度失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setDciLevelValue=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async enableDynamicBacklight() {
    try {
      let setEnableDynamicBacklight: boolean = await displaySetting.enableDynamicBacklight(); // 调用厂商api
      LogUtil.log(TAG + 'setEnableDynamicBacklight SuccessBoolean==:' + JSON.stringify(setEnableDynamicBacklight));
      if (!setEnableDynamicBacklight) {
        promptAction.showToast({ message: '设置开启动态背光失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setEnableDynamicBacklight=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async disableDynamicBacklight() {
    try {
      let setDisableDynamicBacklight: boolean = await displaySetting.disableDynamicBacklight(); // 调用厂商api
      LogUtil.log(TAG + 'setDisableDynamicBacklight SuccessBoolean==:' + JSON.stringify(setDisableDynamicBacklight));
      if (!setDisableDynamicBacklight) {
        promptAction.showToast({ message: '设置关闭动态背光失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setDisableDynamicBacklight=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async peaksetOutputBrightness() {
    try {
      LogUtil.log(TAG + 'setthis.peakBrightnessIndex==:' + JSON.stringify(this.peakBrightnessIndex));
      let setBoostPeakLevel: boolean = await displaySetting.setBoostPeakLevel(this.peakBrightnessIndex); // 调用厂商api
      LogUtil.log(TAG + 'setBoostPeakLevel SuccessBoolean==:' + JSON.stringify(setBoostPeakLevel));
      if (!setBoostPeakLevel) {
        promptAction.showToast({ message: '设置峰值亮度失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setBoostPeakLevelError=' + JSON.stringify(error));
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
          title: '亮度设置',
          subTitle: '系统·' + AppStorage.get('displayModeType'),
          onClickHandle: async (item: SettingItemTvModel) => {
          },
          onToggleChangedHandle:(item: SettingItemTvModel, isOn: boolean) => {
            if (item.name === '动态背光') {
              this.dynamicBacklight = !this.dynamicBacklight;
              LogUtil.log(TAG + 'this.dynamicBacklight Boolean==:' + JSON.stringify(this.dynamicBacklight));
              if (this.dynamicBacklight) {
                this.enableDynamicBacklight();
              } else {
                this.disableDynamicBacklight();
              }
            }
          },
          onMouseClickHandle: async (item: SettingItemTvModel) => {
          },
          onValueChangeLeftHandle: async (item: SettingItemTvModel) => {
            let min = 0;
            let max100 = 100;
            let minGamma = 0;
            let maxGamma = gammaMap.length;
            if (item.name === '亮度') {
              if (this.brightnessValue > min) {
                this.brightnessValue--
              }
              item.setValue(this.brightnessValue.toString());
              this.setOutputBrightness();
            } else if (item.name === '峰值亮度') {
              let select = 0
              let origins: string[] = ['关闭', '低', '中', '高']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  select = index
                }
                if (select > 0) {
                  select--
                }
                this.peakBrightnessIndex = select
              })
              this.peakBrightnessValue = origins[this.peakBrightnessIndex];
              item.setValue(origins[this.peakBrightnessIndex]);
              this.peaksetOutputBrightness()
            } else if (item.name === '对比度') {
              if (this.contrastValue > min) {
                this.contrastValue--
              }
              item.setValue(this.contrastValue.toString());
              this.setOutputContrast();
            } else if (item.name === '伽马') {
              if (this.gamma > minGamma && this.gamma < maxGamma) {
                this.gamma -= 1;
              }
              item.setValue(gammaMap[this.gamma].text.toFixed(1));
              this.setOutputGrammaType();
            } else if (item.name === '黑色级别') {
              if (this.blackValue > min) {
                this.blackValue--
              }
              item.setValue(this.blackValue.toString());
              this.setBlack();
            } else if (item.name === '动态对比度') {
              let select = 0
              let origins: string[] = ['关闭', '低', '中', '高']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  select = index
                }
              })
              if (select > 0) {
                select--
              }
              this.contrastIndex = select
              this.dynamicContrast = origins[this.contrastIndex];
              item.setValue(origins[this.contrastIndex]);
              this.setOutputDciLevel();
            }

          },
          onValueChangeRightHandle: async (item: SettingItemTvModel) => {
            let min = 0;
            let max100 = 100;
            let minGamma = 0;
            let maxGamma = gammaMap.length;
            if (item.name === '亮度') {
              if (this.brightnessValue < max100) {
                this.brightnessValue++
              }
              item.setValue(this.brightnessValue.toString()); // 页面显示值修改
              this.setOutputBrightness();
            } else if (item.name === '峰值亮度') {
              let select = 0
              let origins: string[] = ['关闭', '低', '中', '高']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  select = index
                }
                if (select < 3) {
                  select++
                }
                this.peakBrightnessIndex = select
              })
              // 实现静态交互
              this.peakBrightnessValue = origins[this.peakBrightnessIndex];
              item.setValue(origins[this.peakBrightnessIndex]);
              this.peaksetOutputBrightness()
            } else if (item.name === '对比度') {
              if (this.contrastValue < max100) {
                this.contrastValue++
              }
              item.setValue(this.contrastValue.toString()); // 页面显示值修改
              this.setOutputContrast();
            } else if (item.name === '伽马') {
              if (this.gamma >= minGamma && this.gamma < maxGamma) {
                this.gamma += 1;
              }
              item.setValue(gammaMap[this.gamma].text.toFixed(1)); // 页面显示值修改
              this.setOutputGrammaType();
            } else if (item.name === '黑色级别') {
              if (this.blackValue < max100) {
                this.blackValue++
              }
              item.setValue(this.blackValue.toString()); // 页面显示值修改
              // 调用厂商api
              this.setBlack();
            } else if (item.name === '动态对比度') {
              let select = 0
              let origins: string[] = ['关闭', '低', '中', '高']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  select = index
                }
              })
              if (select < 3) {
                select++
              }

              this.contrastIndex = select
              // 实现静态交互
              this.dynamicContrast = origins[this.contrastIndex];
              item.setValue(origins[this.contrastIndex]);
              this.setOutputDciLevel();
            }

          },
          onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
            let min = 0;
            let max100 = 100;
            let minGamma = 0;
            let maxGamma = gammaMap.length;
            if (event.keyCode !== KeyCode.KEY_ENTER) {
              if (event.keyCode !== KeyCode.KEY_DPAD_UP) {
                if (event.keyCode !== KeyCode.KEY_DPAD_DOWN) {
                  if (event.type === KeyType.Down) {
                    if (item.name === '亮度') {
                      this.brightnessValue = this.numberSetting(this.brightnessValue, event, min, max100); // 调公共方法修改值
                      item.setValue(this.brightnessValue.toString()); // 页面显示值修改
                      this.setOutputBrightness();
                    } else if (item.name === '峰值亮度') {
                      let origins: string[] = ['关闭', '低', '中', '高']
                      origins.forEach((originItem, index) => {
                        if (item.value === originItem) {
                          this.peakBrightnessIndex = this.stringChange(event, index);
                        }
                      })
                      // 实现静态交互
                      this.peakBrightnessValue = origins[this.peakBrightnessIndex];
                      item.setValue(origins[this.peakBrightnessIndex]);
                      this.peaksetOutputBrightness()
                    } else if (item.name === '对比度') {
                      this.contrastValue = this.numberSetting(this.contrastValue, event, min, max100); // 调公共方法修改值
                      item.setValue(this.contrastValue.toString()); // 页面显示值修改
                      this.setOutputContrast();
                    } else if (item.name === '伽马') {
                      if (event.keyCode === KeyCode.KEY_DPAD_LEFT && this.gamma > minGamma) {
                        this.gamma -= 1;
                      }
                      if (event.keyCode === KeyCode.KEY_DPAD_RIGHT && this.gamma < maxGamma) {
                        this.gamma += 1;
                      }
                      item.setValue(gammaMap[this.gamma].text.toFixed(1)); // 页面显示值修改
                      this.setOutputGrammaType();
                    } else if (item.name === '黑色级别') {
                      this.blackValue = this.numberSetting(this.blackValue, event, min, max100); // 调公共方法修改值
                      item.setValue(this.blackValue.toString()); // 页面显示值修改
                      // 调用厂商api
                      this.setBlack();
                    } else if (item.name === '动态对比度') {
                      let origins: string[] = ['关闭', '低', '中', '高']
                      origins.forEach((originItem, index) => {
                        if (item.value === originItem) {
                          this.contrastIndex = this.stringChange(event, index);
                        }
                      })
                      // 实现静态交互
                      this.dynamicContrast = origins[this.contrastIndex];
                      item.setValue(origins[this.contrastIndex]);
                      this.setOutputDciLevel();
                    }
                  }
                }
              }
            }
            if (event.type === KeyType.Down && event.keyCode === KeyCode.KEY_ENTER) {
              if (item.name === '动态背光') {
                this.dynamicBacklight = !this.dynamicBacklight;
                LogUtil.log(TAG + 'this.dynamicBacklight Boolean==:' + JSON.stringify(this.dynamicBacklight));
                if (this.dynamicBacklight) {
                  this.enableDynamicBacklight();
                } else {
                  this.disableDynamicBacklight();
                }
              }
            }
          }
        })
          .width(ConfigData.WH_52_100)
          .height(ConfigData.WH_100_100)
          .padding({
            left: lpx(84)
          })
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
