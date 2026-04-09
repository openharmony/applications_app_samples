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
import colorTemperatureModel from '../../model/display/ColorTemperatureMode';
import colorTemperatureSettingModel from '../../model/display/ColorTemperatureSettingMode';
import displaySetting from '@ohos.tvservice.displaySetting';
import promptAction from '@ohos.promptAction';
import { Duration } from '../../common/constants/Duration';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
const TAG = 'colorSettingIndex'
const pictureModeMap: Record<number, string> = {
  0: '设定值',
  2: '护眼色温',
};
const pictureModeMaps: Record<number, string> = {
  6000: '正白',
  3000: '暖黄',
  4500: '暖白',
};
const CUSTOM_COLOR_TEMPERATURE_VALUES: number[] = [
  5000, 5500, 6000, 6300, 6500, 7000, 7500, 8000, 8500,
  9000, 9300, 9500, 10000, 10500, 11000, 11500, 12000
]


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
  // 饱和度
  @State saturationValue: number = 0;
  // 色调
  @State hue: number = 40;
  // 色调调节方式
  @State @Watch('arrChange') colorTemperatureStyle: string = '护眼色温';
  // 护眼色温index
  @State styleIndex: number = 0;
  // 色温值
  @State colorTemperature: string = '正白';
  @State colorTemperatureIndex: number = 0;
  // 色温精细调节
  @State red: number = 0
  @State green: number = 1
  @State blue: number = 2
  @State colorTemperaArr: string[] = [];

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  getColorTempTypeValue(): number {
    return this.styleIndex == 0 ? 2 : 0
  }

  getEyeProtectTypeValue(): number {
    if (this.colorTemperatureIndex == 0) {
      return 6000
    } else if (this.colorTemperatureIndex == 1) {
      return 3000
    } else if (this.colorTemperatureIndex == 2) {
      return 4500
    }
    return 0
  }

 async aboutToAppear() {

    let item1 = new SettingItemTvModel();
    item1.name = '饱和度';
    item1.style = SettingItemStyle.valueChange;
    item1.value = this.saturationValue.toString();

    let item2 = new SettingItemTvModel();
    item2.name = '色调';
    item2.style = SettingItemStyle.valueChange;
    item2.value = this.hue.toString();

    let item3 = new SettingItemTvModel();
    item3.name = '色温调节方式';
    item3.style = SettingItemStyle.valueChange;
    item3.value = this.colorTemperatureStyle;

    let item4 = new SettingItemTvModel();
    item4.name = '色温值';
    item4.style = SettingItemStyle.valueChange;
    item4.value = this.colorTemperature;

    let item5 = new SettingItemTvModel();
    item5.name = '色温精细调节:';
    item5.style = SettingItemStyle.info;
    item5.isNeedBg = false
    item5.isDisableFocus = true

    let item6 = new SettingItemTvModel();
    item6.name = '红';
    item6.style = SettingItemStyle.valueChange;
    item6.value = this.red.toString();

    let item7 = new SettingItemTvModel();
    item7.name = '绿';
    item7.style = SettingItemStyle.valueChange;
    item7.value = this.green.toString();

    let item8 = new SettingItemTvModel();
    item8.name = '蓝';
    item8.style = SettingItemStyle.valueChange;
    item8.value = this.blue.toString();

    this.settingList.push(item1, item2, item3, item4, item5, item6, item7, item8);

  }
  onPageShow(): void {
    // 初始化时读硬件数据
    this.getSaturation();
    this.getHue();
    this.getColorTemperatureStyle();
    this.getRed();
    this.getGreen();
    this.getBlue();
  }
  async getColorTemperatureStyle(){
    try {
      let mode:displaySetting.ColorTempMode = await displaySetting.getColorTempType();
      LogUtil.log(TAG + 'getColorTempTypeSuccess=' + JSON.stringify(mode));
      LogUtil.log(TAG + 'getColorTempTypeSuccess11=' + JSON.stringify(pictureModeMap[mode]));
      this.colorTemperatureStyle = pictureModeMap[mode]
      this.settingList[2].setValue(pictureModeMap[mode]);
      if (pictureModeMap[mode] == '护眼色温') {
        try {
          let mode:displaySetting.EyeProtectMode = await displaySetting.getEyeProtectType();
          LogUtil.log(TAG + 'getEyeProtectTypeSuccess=' + JSON.stringify(mode));
          LogUtil.log(TAG + 'getEyeProtectTypeSuccess11=' + JSON.stringify(pictureModeMaps[mode]));
          this.settingList[3].setValue(pictureModeMaps[mode]);
        } catch (error) {
          LogUtil.log(TAG + 'getEyeProtectTypeSuccess=' + JSON.stringify(error));
          this.settingList[3].setValue('正白');
        }
      } else {
        try {
          let mode:displaySetting.ColorTempPoint = await displaySetting.getColorTempParamStep();
          LogUtil.log(TAG + 'getColorTempParamStepSuccess=' + JSON.stringify(mode));
          this.settingList[3].setValue(mode + 'K');
        } catch (error) {
          LogUtil.log(TAG + 'getColorTempParamStepSuccess=' + JSON.stringify(error));
          this.settingList[3].setValue('5000K');
        }
      }
    } catch (error) {
      LogUtil.log(TAG + 'getColorTempTypeSuccess=' + JSON.stringify(error));
      this.colorTemperatureStyle = '护眼色温'
      this.settingList[2].setValue('护眼色温');
    }
  }


  async getRed(){
    try {
      let getColorTempCali:displaySetting.ColorTempParam = await displaySetting.getColorTempCali()
      LogUtil.log(TAG + 'getColorTempCaliSuccess=' + JSON.stringify(getColorTempCali));
      this.settingList[5].setValue(getColorTempCali.redGain + '');
      this.red = getColorTempCali.redGain;
    } catch (error) {
      LogUtil.log(TAG + 'getColorTempCali=' + JSON.stringify(error));
    }
  }

  async getGreen(){
    try {
      let getColorTempCali:displaySetting.ColorTempParam = await displaySetting.getColorTempCali()
      LogUtil.log(TAG + 'getColorTempCaliSuccess=' + JSON.stringify(getColorTempCali));
      this.settingList[6].setValue(getColorTempCali.greenGain + '');
      this.green = getColorTempCali.greenGain;
    } catch (error) {
      LogUtil.log(TAG + 'getColorTempCali=' + JSON.stringify(error));
    }
  }
  async getBlue(){
    try {
      let getColorTempCali:displaySetting.ColorTempParam = await displaySetting.getColorTempCali()
      LogUtil.log(TAG + 'getColorTempCaliSuccess=' + JSON.stringify(getColorTempCali));
      this.settingList[7].setValue(getColorTempCali.blueGain + '');
      this.blue = getColorTempCali.blueGain;
    } catch (error) {
      LogUtil.log(TAG + 'getColorTempCali=' + JSON.stringify(error));
    }
  }



  // 获取饱和度
  async getSaturation() {
    try {
      this.saturationValue = await displaySetting.getSaturation()
      this.settingList[0].setValue(this.saturationValue.toString());
    } catch (error) {
      LogUtil.log(TAG + 'getSaturationValue=' + JSON.stringify(error));
    }
  }

  // 获取色调
  async getHue() {
    try {
      this.hue = await displaySetting.getDisplayHue()
      this.settingList[1].setValue(this.hue.toString());
    } catch (error) {
      LogUtil.log(TAG + 'getDisplayHueValue=' + JSON.stringify(error));
    }
  }

  // 色温调节方式的监听
  async arrChange() {
    if (this.colorTemperatureStyle === '护眼色温') {
      this.colorTemperaArr = ['正白', '暖黄', '暖白']
      this.colorTemperature =await colorTemperatureModel.getColorTemperature();
    } else {
      this.colorTemperaArr = ['5000K', '5500K', '6000K',  '6300K', '6500K', '7000K', '7500K',
        '8000K', '8500K', '9000K','9300K', '9500K', '10000K', '10500K', '11000K', '11500K', '12000K'];
      this.colorTemperature =await colorTemperatureSettingModel.getColorTemperatureSetting();
    }
    this.settingList.forEach(item => {
      if (item.name === '色温值') {
        item.setValue(this.colorTemperature);
      }
    })
    this.settingList.forEach(item => {
      this.colorTemperaArr.forEach((originItem, index) => {
        if (item.value === originItem) {
          this.colorTemperatureIndex = index
        }
      })
    })
  }

  // 色温值change事件
  colorTemperatureChange(event: KeyEvent, index: number) {
    if (this.colorTemperatureStyle === '护眼色温') {
      if (event.keyCode == KeyCode.KEY_DPAD_LEFT && index >= 0) {
        index--;
      }
      if (event.keyCode == KeyCode.KEY_DPAD_LEFT && index < 0) {
        index = 2;
      }
      if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && index <= 2) {
        index++;
      }
      if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && index > 2) {
        index = 0;
      }
    } else {
      if (event.keyCode == KeyCode.KEY_DPAD_LEFT && index >= 0) {
        index--;
      }
      if (event.keyCode == KeyCode.KEY_DPAD_LEFT && index < 0) {
        index = 16;
      }
      if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && index <= 16) {
        index++;
      }
      if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && index > 16) {
        index = 0;
      }
    }
    return index
  }

  // 饱和度,色调的公共方法
  zeroTo100Change(value: number, event: KeyEvent, min: number, max100: number) {
    if (event.keyCode == KeyCode.KEY_DPAD_LEFT && value > min) {
      return --value;
    }
    if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && value < max100) {
      return ++value;
    }
    return value
  }

  // 红绿蓝
  colorChange(value: number, event: KeyEvent, min: number, max100: number) {
    if (event.keyCode == KeyCode.KEY_DPAD_LEFT && value > min) {
      return --value;
    }
    if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && value < max100) {
      return ++value;
    }
    return value
  }

  async setOutputSaturation() {
    try {
      let setSaturationValue:boolean=await displaySetting.setSaturation(this.saturationValue); // 调用厂商api
      LogUtil.log(TAG+'setSaturationValue SuccessBoolean==:'+JSON.stringify(setSaturationValue));
      if(!setSaturationValue){
        promptAction.showToast({ message: '设置饱和度失败' })
      }
    } catch (error){
      LogUtil.log(TAG + 'setSaturationValue=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setDisplayHue() {
    try {
      let setDisplayHue:boolean=await displaySetting.setDisplayHue(this.hue); // 调用厂商api
      LogUtil.log(TAG+'setDisplayHueValue SuccessBoolean==:'+JSON.stringify(setDisplayHue));
      if(!setDisplayHue){
        promptAction.showToast({ message: '设置色调失败' })
      }
    } catch (error){
      LogUtil.log(TAG + 'setDisplayHueValue=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  async setColorTempType(color:number) {
    try {
      let setColorTempParamStep:boolean=await displaySetting.setColorTempParamStep(color); // 调用厂商api
      LogUtil.log(TAG+'setColorTempParamStep SuccessBoolean==:'+JSON.stringify(setColorTempParamStep));
      if(!setColorTempParamStep){
        promptAction.showToast({ message: '设置设定值色温值失败' })
      }
    } catch (error){
      LogUtil.log(TAG + 'setColorTempParamStep=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }
  async setColorTempCali(){
    LogUtil.log(TAG+'setColorTempCaliValue==:'+JSON.stringify(this.red));
    LogUtil.log(TAG+'setColorTempCaliValue1==:'+JSON.stringify(this.green));
    LogUtil.log(TAG+'setColorTempCaliValue2==:'+JSON.stringify(this.blue));
    try {
      let getColorTempCali:displaySetting.ColorTempParam=await displaySetting.getColorTempCali();
      LogUtil.log(TAG + 'getColorTempCaliSuccess1=' + JSON.stringify(getColorTempCali));
      let setColorTempCaliValue:boolean=await displaySetting.setColorTempCali({
        redGain: this.red,
        greenGain:this.green,
        blueGain: this.blue,
        redOffset: getColorTempCali.redOffset,
        greenOffset: getColorTempCali.greenOffset,
        blueOffset: getColorTempCali.blueOffset,
      }); // 调用厂商api
      LogUtil.log(TAG+'setColorTempCaliValue SuccessBoolean==:'+JSON.stringify(setColorTempCaliValue));
      if(!setColorTempCaliValue){
        promptAction.showToast({ message: '设置色温精细调节失败' })
      }
    } catch (error){
      LogUtil.log(TAG + 'setColorTempCaliValue=' + JSON.stringify(error));
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
          title: '色彩设置',
          onClickHandle: async (item: SettingItemTvModel) => {
          },
          onMouseClickHandle: async (item: SettingItemTvModel) => {
          },
          onValueChangeLeftHandle: async (item: SettingItemTvModel) => {
            let min = 0;
            let max100 = 100;
            let minColor = -20;
            let maxColor = 20
              if (item.name === '饱和度') {
                if (this.saturationValue>min) {
                  this.saturationValue--
                }
                item.setValue(this.saturationValue.toString());
                this.setOutputSaturation() // 调用厂商api
              } else if (item.name === '色调') {
                if (this.hue>min) {
                  this.hue--
                }
                item.setValue(this.hue.toString());
                this.setDisplayHue() // 调用厂商api
              } else if (item.name === '色温调节方式') {
                let origins: string[] = ['护眼色温', '设定值']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.styleIndex = index
                  }
                })
                if (this.styleIndex==1) {
                  this.styleIndex=0
                }
                this.colorTemperatureStyle = origins[this.styleIndex];
                item.setValue(this.colorTemperatureStyle);
                try {
                  LogUtil.log(TAG+'this.styleIndex==:'+JSON.stringify(this.styleIndex));
                  let setColorTempTypeValue: boolean =
                    await displaySetting.setColorTempType(this.getColorTempTypeValue()); // 调用厂商api
                  LogUtil.log(
                    TAG + 'setColorTempTypeValue SuccessBoolean==:' + JSON.stringify(setColorTempTypeValue)
                  );
                  if(!setColorTempTypeValue){
                    promptAction.showToast({ message: '设置色温调节方式失败' })
                  }
                } catch (error){
                  LogUtil.log(TAG + 'setColorTempTypeValue=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              } else if (item.name === '色温值') {
                let select=0
                let origins: string[]
                if (this.colorTemperatureStyle === '护眼色温') {
                  origins = ['正白', '暖黄', '暖白']
                  // 暖黄是3000 暖白是4000
                } else {
                  origins = ['5000K', '5500K', '6000K',  '6300K', '6500K', '7000K', '7500K',
                    '8000K', '8500K', '9000K','9300K', '9500K', '10000K', '10500K', '11000K', '11500K', '12000K'];
                }
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    select=index
                  }
                })
                if (select>0) {
                  select--
                }
                this.colorTemperatureIndex = select
                this.colorTemperature = origins[this.colorTemperatureIndex];
                item.setValue(this.colorTemperature);
                if (this.colorTemperatureStyle === '护眼色温') {
                  try {
                    let setEyeProtectTypeValue: boolean =
                      await displaySetting.setEyeProtectType(this.getEyeProtectTypeValue()); // 调用厂商api
                    LogUtil.log(
                      TAG + 'setEyeProtectTypeValue SuccessBoolean==:' + JSON.stringify(setEyeProtectTypeValue)
                    );
                    if(!setEyeProtectTypeValue){
                      promptAction.showToast({ message: '设置护眼色温色温值失败' })
                    }
                  } catch (error){
                    LogUtil.log(TAG + 'setEyeProtectTypeValue=' + JSON.stringify(error));
                    promptAction.showToast({ message: $r('app.string.tips_in_development') })
                  }
                  colorTemperatureModel.setColorTemperature(this.colorTemperature)
                } else {
                  // DCI是6300 d93是9300
                  this.setColorTempType(CUSTOM_COLOR_TEMPERATURE_VALUES[this.colorTemperatureIndex]);
                  colorTemperatureSettingModel.setColorTemperatureSetting(this.colorTemperature)
                }
              } else if (item.name === '红') {
                if (this.red > minColor) {
                  this.red--
                }
                item.setValue(this.red.toString());
                this.setColorTempCali();
              } else if (item.name === '绿') {
                if (this.green > minColor) {
                  this.green--
                }
                item.setValue(this.green.toString());
                this.setColorTempCali();
              } else if (item.name === '蓝') {
                if (this.blue > minColor) {
                  this.blue--
                }
                item.setValue(this.blue.toString());
                this.setColorTempCali();
              }

          },
          onValueChangeRightHandle: async (item: SettingItemTvModel) => {
              let min = 0;
              let max100 = 100;
              let minColor = -20;
              let maxColor = 20
              if (item.name === '饱和度') {
                if (this.saturationValue < max100) {
                  this.saturationValue++
                }
                item.setValue(this.saturationValue.toString());
                this.setOutputSaturation() // 调用厂商api
              } else if (item.name === '色调') {
                if (this.hue < max100) {
                  this.hue++
                }
                item.setValue(this.hue.toString());
                this.setDisplayHue() // 调用厂商api
              } else if (item.name === '色温调节方式') {
                let origins: string[] = ['护眼色温', '设定值']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.styleIndex = index
                  }
                })
                if (this.styleIndex==0) {
                  this.styleIndex=1
                }
                this.colorTemperatureStyle = origins[this.styleIndex];
                item.setValue(this.colorTemperatureStyle);
                try {
                  LogUtil.log(TAG+'this.styleIndex==:'+JSON.stringify(this.styleIndex));
                  let setColorTempTypeValue: boolean =
                    await displaySetting.setColorTempType(this.getColorTempTypeValue()); // 调用厂商api
                  LogUtil.log(
                    TAG + 'setColorTempTypeValue SuccessBoolean==:' + JSON.stringify(setColorTempTypeValue)
                  );
                  if(!setColorTempTypeValue){
                    promptAction.showToast({ message: '设置色温调节方式失败' })
                  }
                } catch (error){
                  LogUtil.log(TAG + 'setColorTempTypeValue=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              } else if (item.name === '色温值') {
                let select=0
                let origins: string[]
                if (this.colorTemperatureStyle === '护眼色温') {
                  origins = ['正白', '暖黄', '暖白']
                  // 暖黄是3000 暖白是4000
                } else {
                  origins = ['5000K', '5500K', '6000K',  '6300K', '6500K', '7000K', '7500K',
                    '8000K', '8500K', '9000K','9300K', '9500K', '10000K', '10500K', '11000K', '11500K', '12000K'];
                }
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    select=index
                  }
                })
                if (select<origins.length-1) {
                  select++
                }
                this.colorTemperatureIndex = select
                this.colorTemperature = origins[this.colorTemperatureIndex];
                item.setValue(this.colorTemperature);
                if (this.colorTemperatureStyle === '护眼色温') {
                  try {
                    let setEyeProtectTypeValue: boolean =
                      await displaySetting.setEyeProtectType(this.getEyeProtectTypeValue()); // 调用厂商api
                    LogUtil.log(
                      TAG + 'setEyeProtectTypeValue SuccessBoolean==:' + JSON.stringify(setEyeProtectTypeValue)
                    );
                    if(!setEyeProtectTypeValue){
                      promptAction.showToast({ message: '设置护眼色温色温值失败' })
                    }
                  } catch (error){
                    LogUtil.log(TAG + 'setEyeProtectTypeValue=' + JSON.stringify(error));
                    promptAction.showToast({ message: $r('app.string.tips_in_development') })
                  }
                  colorTemperatureModel.setColorTemperature(this.colorTemperature)
                } else {
                  // DCI是6300 d93是9300
                  this.setColorTempType(CUSTOM_COLOR_TEMPERATURE_VALUES[this.colorTemperatureIndex]);
                  colorTemperatureSettingModel.setColorTemperatureSetting(this.colorTemperature)
                }
              } else if (item.name === '红') {
                if (this.red < maxColor) {
                  this.red++
                }
                item.setValue(this.red.toString());
                this.setColorTempCali();
              } else if (item.name === '绿') {
                if (this.green < maxColor) {
                  this.green++
                }
                item.setValue(this.green.toString());
                this.setColorTempCali();
              } else if (item.name === '蓝') {
                if (this.blue < maxColor) {
                  this.blue++
                }
                item.setValue(this.blue.toString());
                this.setColorTempCali();
              }


          },
          onKeyEventHandle: async (item: SettingItemTvModel, event: KeyEvent) => {
            let min = 0;
            let max100 = 100;
            let minColor = -20;
            let maxColor = 20
            if(event.keyCode !== KeyCode.KEY_ENTER){
              if(event.keyCode !== KeyCode.KEY_DPAD_UP){
                if(event.keyCode !== KeyCode.KEY_DPAD_DOWN){
                  if (event.type === KeyType.Down) {
                    if (item.name === '饱和度') {
                      this.saturationValue = this.zeroTo100Change(this.saturationValue, event, min, max100);
                      item.setValue(this.saturationValue.toString());
                      this.setOutputSaturation() // 调用厂商api
                    } else if (item.name === '色调') {
                      this.hue = this.zeroTo100Change(this.hue, event, min, max100);
                      item.setValue(this.hue.toString());
                      this.setDisplayHue() // 调用厂商api
                    } else if (item.name === '色温调节方式') {
                      let origins: string[] = ['护眼色温', '设定值']
                      origins.forEach((originItem, index) => {
                        if (item.value === originItem) {
                          this.styleIndex = index
                        }
                      })
                      if (event.keyCode == KeyCode.KEY_DPAD_LEFT && this.styleIndex >= 0) {
                        this.styleIndex--;
                      }
                      if (event.keyCode == KeyCode.KEY_DPAD_LEFT && this.styleIndex < 0) {
                        this.styleIndex = 1;
                      }
                      if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && this.styleIndex <= 1) {
                        this.styleIndex++;
                      }
                      if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && this.styleIndex > 1) {
                        this.styleIndex = 0;
                      }
                      this.colorTemperatureStyle = origins[this.styleIndex];
                      item.setValue(this.colorTemperatureStyle);
                      try {
                        LogUtil.log(TAG+'this.styleIndex==:'+JSON.stringify(this.styleIndex));
                        let setColorTempTypeValue: boolean =
                          await displaySetting.setColorTempType(this.getColorTempTypeValue()); // 调用厂商api
                        LogUtil.log(
                          TAG + 'setColorTempTypeValue SuccessBoolean==:' + JSON.stringify(setColorTempTypeValue)
                        );
                        if(!setColorTempTypeValue){
                          promptAction.showToast({ message: '设置色温调节方式失败' })
                        }
                      } catch (error){
                        LogUtil.log(TAG + 'setColorTempTypeValue=' + JSON.stringify(error));
                        promptAction.showToast({ message: $r('app.string.tips_in_development') })
                      }
                    } else if (item.name === '色温值') {
                      let origins: string[]
                      if (this.colorTemperatureStyle === '护眼色温') {
                        origins = ['正白', '暖黄', '暖白']
                        // 暖黄是3000 暖白是4000
                      } else {
                        origins = ['5000K', '5500K', '6000K',  '6300K', '6500K', '7000K', '7500K',
                          '8000K', '8500K', '9000K','9300K', '9500K', '10000K', '10500K', '11000K', '11500K', '12000K'];
                      }
                      origins.forEach((originItem, index) => {
                        if (item.value === originItem) {
                          this.colorTemperatureIndex = this.colorTemperatureChange(event, index);
                        }
                      })
                      this.colorTemperature = origins[this.colorTemperatureIndex];
                      item.setValue(this.colorTemperature);
                      if (this.colorTemperatureStyle === '护眼色温') {
                        try {
                          let setEyeProtectTypeValue: boolean =
                            await displaySetting.setEyeProtectType(this.getEyeProtectTypeValue()); // 调用厂商api
                          LogUtil.log(
                            TAG + 'setEyeProtectTypeValue SuccessBoolean==:' + JSON.stringify(setEyeProtectTypeValue)
                          );
                          if(!setEyeProtectTypeValue){
                            promptAction.showToast({ message: '设置护眼色温色温值失败' })
                          }
                        } catch (error){
                          LogUtil.log(TAG + 'setEyeProtectTypeValue=' + JSON.stringify(error));
                          promptAction.showToast({ message: $r('app.string.tips_in_development') })
                        }
                        colorTemperatureModel.setColorTemperature(this.colorTemperature)
                      } else {
                        // DCI是6300 d93是9300
                        this.setColorTempType(CUSTOM_COLOR_TEMPERATURE_VALUES[this.colorTemperatureIndex]);
                        colorTemperatureSettingModel.setColorTemperatureSetting(this.colorTemperature)
                      }
                    } else if (item.name === '红') {
                      this.red = this.colorChange(this.red, event, minColor, maxColor)
                      item.setValue(this.red.toString());
                      this.setColorTempCali();
                    } else if (item.name === '绿') {
                      this.green = this.colorChange(this.green, event, minColor, maxColor)
                      item.setValue(this.green.toString());
                      this.setColorTempCali();
                    } else if (item.name === '蓝') {
                      this.blue = this.colorChange(this.blue, event, minColor, maxColor)
                      item.setValue(this.blue.toString());
                      this.setColorTempCali();
                    }
                  }
                }
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
