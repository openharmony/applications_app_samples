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
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { Ratio } from '../../common/Ratio';
import displaySetting from '@ohos.tvservice.displaySetting';
import promptAction from '@ohos.promptAction';
import { Duration } from '../../common/constants/Duration';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import settings from '@ohos.settings';

const TAG = 'displayIndex'
const getEyeProtectTypeMap: Record<number, string> = {
  6000: '低',
  4500: '中',
  3000: '高',
};
const eyeProtectDesc = '多方位保护您的视力健康，您可根据习惯进行调整'
const blueLightDesc = '开启后，屏幕变暖，减少蓝光刺激，缓解视觉疲劳，开启后将关闭“自然色彩”'
const filterLevelDesc = '可调节蓝光过滤的不同等级'

/**
 * 显示设置
 */
@Entry
@Component
struct NightLight {
  @State imageUrl: string = Ratio.resName('icon_eye') // 右侧图标哦
  @State des: string | Resource = eyeProtectDesc // 右侧图标下发的介绍
  @State settingList: SettingItemTvModel[] = [] // 左侧列表
  // 护眼模式开关
  @State @Watch('protectEysChange') protectEys: boolean = true
  @State eyeProtectStepIndex: number = 0;

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  getEyeProtectValue(): number {
    if (this.eyeProtectStepIndex == 0) {
      return 6000
    } else if (this.eyeProtectStepIndex == 1) {
      return 4500
    } else if (this.eyeProtectStepIndex == 2) {
      return 3000
    }
    return 0
  }

  protectEysChange() {
    console.log(JSON.stringify(this.protectEys), 'this.protectEys SuccessBoolean15555')
    for (let i = 0; i < this.settingList.length; i++) {
      if (this.settingList[i].name === '蓝光过滤' || this.settingList[i].name === '护眼模式') {
        this.settingList[i].setIsOn(this.protectEys)
      }
      this.settingList[3].setIsDisableFocus(!this.protectEys)
      this.settingList[3].setIsEnable(this.protectEys)
    }
  }

  async aboutToAppear() {
    let item3 = new SettingItemTvModel();
    item3.name = '护眼模式'
    item3.style = SettingItemStyle.switch
    item3.isOn = this.protectEys;

    let item6 = new SettingItemTvModel();
    item6.name = '更多设置';
    item6.style = SettingItemStyle.info;
    item6.isNeedBg = false
    item6.isDisableFocus = true

    let item7 = new SettingItemTvModel();
    item7.name = '蓝光过滤'
    item7.style = SettingItemStyle.switch
    item7.isOn = this.protectEys;

    let item5 = new SettingItemTvModel();
    item5.name = '过滤等级';
    item5.style = SettingItemStyle.valueChange;
    item5.value = getEyeProtectTypeMap[this.getEyeProtectValue()];
    item5.isEnable = this.protectEys
    item5.isDisableFocus = !this.protectEys

    this.settingList.push(item3, item6, item7, item5);
    this.getEyeProtectStatus();
    this.getEyeProtectType();
  }

  // 获取护眼模式状态
  async getEyeProtectStatus() {
    try {
      let mode: displaySetting.ColorTempMode = await displaySetting.getColorTempType();
      LogUtil.log(TAG + 'getColorTempType=' + JSON.stringify(mode));
      this.protectEys = mode === 2;
      this.settingList[0].setIsOn(this.protectEys);
      this.settingList[2].setIsOn(this.protectEys);
      this.settingList[3].setIsEnable(this.protectEys);
      this.settingList[3].setIsDisableFocus(!this.protectEys);
    } catch (error) {
      LogUtil.log(TAG + 'getColorTempType err =' + JSON.stringify(error));
      this.protectEys = true
      this.settingList[0].setIsOn(this.protectEys);
      this.settingList[2].setIsOn(this.protectEys);
      this.settingList[3].setIsEnable(this.protectEys);
      this.settingList[3].setIsDisableFocus(!this.protectEys);
    }
  }

  async getEyeProtectType() {
    try {
      let colorType: number = await displaySetting.getEyeProtectType()
      LogUtil.log(TAG + 'getEyeProtectType=' + JSON.stringify(colorType));
      LogUtil.log(TAG + 'getEyeProtectTypeSuccess11=' + JSON.stringify(getEyeProtectTypeMap[colorType]));
      this.settingList[3].setValue(getEyeProtectTypeMap[colorType])
    } catch (error) {
      LogUtil.log(TAG + 'getEyeProtectType err =' + JSON.stringify(error));
    }
  }

  async setEyeProtectType() {
    try {
      let result: boolean = await displaySetting.setEyeProtectType(this.getEyeProtectValue()); // 调用厂商api
      LogUtil.log(TAG + 'setDciLevelValue SuccessBoolean==:' + JSON.stringify(result));
      if (!result) {
        promptAction.showToast({ message: '设置过滤等级失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setEyeProtectType=' + JSON.stringify(error));
      promptAction.showToast({ message: $r('app.string.tips_in_development') })
    }
  }

  // 左右键控制事件
  stringChange(event: KeyEvent, index: number) {
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
    return index
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
          title: '护眼模式',
          onToggleChangedHandle:async (item: SettingItemTvModel,is:boolean) => {
            if (item.name === '护眼模式') {
              this.des = eyeProtectDesc
              this.protectEys = !this.protectEys;
              LogUtil.log(TAG + 'this.protectEys SuccessBoolean==:' + JSON.stringify(this.protectEys));
              if (this.protectEys) {
                try {
                  let setEnableEyeProtected: boolean = await displaySetting.enableEyeProtected(); // 调用厂商api
                  LogUtil.log(TAG + 'setEnableEyeProtected SuccessBoolean==:' +
                  JSON.stringify(setEnableEyeProtected));
                  if (!setEnableEyeProtected) {
                    promptAction.showToast({ message: '设置开启护眼模式失败' })
                  }
                } catch (error) {
                  LogUtil.log(TAG + 'setEnableEyeProtected=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              } else {
                try {
                  let setDisableEyeProtected: boolean = await displaySetting.disableEyeProtected(); // 调用厂商api
                  LogUtil.log(TAG + 'setDisableEyeProtected SuccessBoolean==:' +
                  JSON.stringify(setDisableEyeProtected));
                  if (!setDisableEyeProtected) {
                    promptAction.showToast({ message: '设置关闭护眼模式失败' })
                  }
                } catch (error) {
                  LogUtil.log(TAG + 'setDisableEyeProtected=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              }

            }
            if (item.name === '蓝光过滤') {
              this.des = blueLightDesc
              this.protectEys = !this.protectEys;
              LogUtil.log(TAG + 'this.protectEys SuccessBoolean1==:' + JSON.stringify(this.protectEys));
              if (this.protectEys) {
                try {
                  let setEnableEyeProtected: boolean = await displaySetting.enableEyeProtected(); // 调用厂商api
                  LogUtil.log(TAG + 'setEnableEyeProtected SuccessBoolean==:' +
                  JSON.stringify(setEnableEyeProtected));
                  if (!setEnableEyeProtected) {
                    promptAction.showToast({ message: '设置开启蓝光过滤失败' })
                  }
                } catch (error) {
                  LogUtil.log(TAG + 'setEnableEyeProtected=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              } else {
                try {
                  let setDisableEyeProtected: boolean = await displaySetting.disableEyeProtected(); // 调用厂商api
                  LogUtil.log(TAG + 'setDisableEyeProtected SuccessBoolean==:' +
                  JSON.stringify(setDisableEyeProtected));
                  if (!setDisableEyeProtected) {
                    promptAction.showToast({ message: '设置关闭蓝光过滤失败' })
                  }
                } catch (error) {
                  LogUtil.log(TAG + 'setDisableEyeProtected=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              }

            }

          },
          onClickHandle: async (item: SettingItemTvModel) => {
            if (item.name === '护眼模式') {
              this.des = eyeProtectDesc
              this.protectEys = !this.protectEys;
              LogUtil.log(TAG + 'this.protectEys SuccessBoolean==:' + JSON.stringify(this.protectEys));
              if (this.protectEys) {
                try {
                  let setEnableEyeProtected: boolean = await displaySetting.enableEyeProtected(); // 调用厂商api
                  LogUtil.log(TAG + 'setEnableEyeProtected SuccessBoolean==:' +
                  JSON.stringify(setEnableEyeProtected));
                  if (!setEnableEyeProtected) {
                    promptAction.showToast({ message: '设置开启护眼模式失败' })
                  }
                } catch (error) {
                  LogUtil.log(TAG + 'setEnableEyeProtected=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              } else {
                try {
                  let setDisableEyeProtected: boolean = await displaySetting.disableEyeProtected(); // 调用厂商api
                  LogUtil.log(TAG + 'setDisableEyeProtected SuccessBoolean==:' +
                  JSON.stringify(setDisableEyeProtected));
                  if (!setDisableEyeProtected) {
                    promptAction.showToast({ message: '设置关闭护眼模式失败' })
                  }
                } catch (error) {
                  LogUtil.log(TAG + 'setDisableEyeProtected=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              }

            }
            if (item.name === '蓝光过滤') {
              this.des = blueLightDesc
              this.protectEys = !this.protectEys;
              LogUtil.log(TAG + 'this.protectEys SuccessBoolean1==:' + JSON.stringify(this.protectEys));
              if (this.protectEys) {
                try {
                  let setEnableEyeProtected: boolean = await displaySetting.enableEyeProtected(); // 调用厂商api
                  LogUtil.log(TAG + 'setEnableEyeProtected SuccessBoolean==:' +
                  JSON.stringify(setEnableEyeProtected));
                  if (!setEnableEyeProtected) {
                    promptAction.showToast({ message: '设置开启蓝光过滤失败' })
                  }
                } catch (error) {
                  LogUtil.log(TAG + 'setEnableEyeProtected=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              } else {
                try {
                  let setDisableEyeProtected: boolean = await displaySetting.disableEyeProtected(); // 调用厂商api
                  LogUtil.log(TAG + 'setDisableEyeProtected SuccessBoolean==:' +
                  JSON.stringify(setDisableEyeProtected));
                  if (!setDisableEyeProtected) {
                    promptAction.showToast({ message: '设置关闭蓝光过滤失败' })
                  }
                } catch (error) {
                  LogUtil.log(TAG + 'setDisableEyeProtected=' + JSON.stringify(error));
                  promptAction.showToast({ message: $r('app.string.tips_in_development') })
                }
              }

            }

          },
          onMouseClickHandle: async (item: SettingItemTvModel) => {
          },
          onValueChangeLeftHandle: (item: SettingItemTvModel) => {
            if (item.name === '过滤等级') {
              this.des = filterLevelDesc
              let select = 0
              let origins: string[] = ['低', '中', '高']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  select = index
                }
              })
              select--
              if (select < 0) {
                select = 2
              }
              this.eyeProtectStepIndex = select
              // 实现静态交互
              item.setValue(origins[this.eyeProtectStepIndex]);
              this.setEyeProtectType();
            }
          },
          onValueChangeRightHandle: (item: SettingItemTvModel) => {
            if (item.name === '过滤等级') {
              this.des = filterLevelDesc
              let select = 0
              let origins: string[] = ['低', '中', '高']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  select = index
                }
              })
              select++
              if (select > 2) {
                select = 0
              }
              this.eyeProtectStepIndex = select
              // 实现静态交互
              item.setValue(origins[this.eyeProtectStepIndex]);
              this.setEyeProtectType();
            }
          },
          onKeyEventHandle:  (item: SettingItemTvModel, event: KeyEvent) => {


            if (item.name === '过滤等级') {
              this.des = filterLevelDesc
              if (event.type === KeyType.Up) {
                let origins: string[] = ['低', '中', '高']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.eyeProtectStepIndex = this.stringChange(event, index);
                  }
                })


                // 实现静态交互
                item.setValue(origins[this.eyeProtectStepIndex]);
                this.setEyeProtectType();
              }
            }
          },
          onFocusHandle: (item: SettingItemTvModel) => {
            if (item.name === '护眼模式') {
              this.des = eyeProtectDesc
            }
            if (item.name === '蓝光过滤') {
              this.des = blueLightDesc
            }
            if (item.name === '过滤等级') {
              this.des = filterLevelDesc
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
