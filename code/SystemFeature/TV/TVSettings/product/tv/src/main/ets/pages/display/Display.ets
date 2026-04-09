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
const pictureModeMap: Record<number, string> = {
  8: '自动',
  1: '鲜艳',
  0: '标准',
  2: '电影',
  3: '体育',
  6: '电脑',
  4: '照片',
  5: '游戏',
  7: '大师模式'
};

/**
 * 显示设置
 */
@Entry
@Component
struct Display {
  @State imageUrl: string = Ratio.resName('icon_display') // 右侧图标哦
  @State des: string | Resource = $r('app.string.set_image_type') // 右侧图标下发的介绍
  @State settingList: SettingItemTvModel[] = [] // 左侧列表
  // 图像模式
  @StorageLink('displayMode') @Watch('modeChange') displayMode: string = ''
  //亮度
  @State brightnessValue: number = 100;
  // 护眼模式开关
  @State protectEys1: string = '已开启'
  private pageTranState: boolean = false; //判断是进场动效还是出场动效

  modeChange() {
    for (let i = 0; i < this.settingList.length; i++) {
      if (this.settingList[i].name === '图像模式') {
        this.settingList[i].setChooseDes(this.displayMode);
      }
    }
  }

  onPageHide(): void {
    this.pageTranState = false
  }

  onPageShow(): void {
    // 初始化时读硬件数据
    this.getImageInfo();
    this.getBrightnessValue();
    this.getEyeInfo();
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

  async aboutToAppear() {
    let item1 = new SettingItemTvModel();
    item1.name = '图像模式';
    item1.pageUrl = 'pages/display/PhotoSetting'
    item1.chooseDes = this.displayMode;

    let item2 = new SettingItemTvModel();
    item2.name = '背光亮度'
    item2.value = this.brightnessValue.toString();
    item2.style = SettingItemStyle.valueChange

    let item3 = new SettingItemTvModel();
    item3.name = '护眼模式'
    item3.style = SettingItemStyle.default
    item3.pageUrl = 'pages/display/NightLight'
    item3.chooseDes = this.protectEys1

    let item5 = new SettingItemTvModel();
    item5.name = '更多设置';
    item5.style = SettingItemStyle.info;
    item5.isNeedBg = false
    item5.isDisableFocus = true

    let item4 = new SettingItemTvModel();
    item4.name = '高级图像设置'
    item4.pageUrl = 'pages/display/HighSetting'

    this.settingList.push(item1, item2, item3, item5, item4);

  }

  async getEyeInfo() {
    try {
      let mode: displaySetting.ColorTempMode = await displaySetting.getColorTempType();
      LogUtil.log(TAG + 'getColorTempType=' + JSON.stringify(mode));
      const isProtectEys = mode === 2;
      this.protectEys1 = isProtectEys ? '已开启' : '已关闭'
      this.settingList[2].setChooseDes(this.protectEys1)
    } catch (error) {
      LogUtil.log(TAG + 'getColorTempType err =' + JSON.stringify(error));
      this.protectEys1 = '已开启'
      this.settingList[2].setChooseDes('已开启')
    }
  }

  async getImageInfo() {
    try {
      let mode: displaySetting.PictureMode = await displaySetting.getPictureMode();
      LogUtil.log(TAG + 'getPictureModeSuccess=' + JSON.stringify(mode));
      LogUtil.log(TAG + 'getPictureModeSuccess11=' + JSON.stringify(pictureModeMap[mode]));
      this.settingList[0].setChooseDes(pictureModeMap[mode])
      AppStorage.setOrCreate('displayMode', pictureModeMap[mode]);
    } catch (error) {
      LogUtil.log(TAG + 'getPictureMode=' + JSON.stringify(error));
      this.settingList[0].setChooseDes('自动')
      AppStorage.setOrCreate('displayMode', '自动');
    }
  }

  async getBrightnessValue() {
    try {
      this.brightnessValue = await displaySetting.getBacklight()
      LogUtil.log(TAG + 'getBacklightValue Success=' + JSON.stringify(this.brightnessValue));
      this.settingList[1].setValue(this.brightnessValue.toString())
    } catch (error) {
      LogUtil.log(TAG + 'getBacklightValue=' + JSON.stringify(error));
    }
  }

  async setOutputBrightness() {
    try {
      LogUtil.log(TAG + 'setBacklight value==:' + this.brightnessValue);
      let setBacklight: boolean = await displaySetting.setBacklight(this.brightnessValue); // 调用厂商api
      LogUtil.log(TAG + 'setBacklight SuccessBoolean==:' + JSON.stringify(setBacklight));
      if (!setBacklight) {
        promptAction.showToast({ message: '设置背光亮度失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setBacklight=' + JSON.stringify(error));
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
          title: '图像',
          onMouseClickHandle: (item: SettingItemTvModel) => {
            if (item.name === '护眼模式') {
              this.imageUrl = Ratio.resName('icon_eye')
              this.des = $r('app.string.eye_protection_mode_reduce_blue_light_soft_display')

                router.pushUrl({ url: item.pageUrl }, router.RouterMode.Single)
                this.pageTranState = true

            }
            if (item.name === '图像模式' || item.name === '高级图像设置') {
              this.imageUrl = Ratio.resName('icon_display')
              if (item.name === '高级图像设置') {
                this.des = $r('app.string.customize_current_image_mode_parameters')
              } else {
                this.des = $r('app.string.set_image_type')
              }

                if (item.name === '高级图像设置') {
                  AppStorage.setOrCreate('displayModeType', this.displayMode);
                } else {
                  AppStorage.setOrCreate('displayModeType', '');
                }
                router.pushUrl({ url: item.pageUrl }, router.RouterMode.Single)
                this.pageTranState = true

            }
          },
          onValueChangeLeftHandle:(item: SettingItemTvModel)=>{
            let min = 0;
            let max100 = 100;
            if (item.name === '背光亮度') {
              this.imageUrl = Ratio.resName('icon_light')
              this.des = $r('app.string.display_blacklight')
                let origin = this.brightnessValue;
                if ( origin > min) {
                  origin--;
                  this.brightnessValue = origin;
                  item.setValue(origin.toString());
                  this.setOutputBrightness();
                }

            }
          },
          onValueChangeRightHandle:(item: SettingItemTvModel)=>{
            let min = 0;
            let max100 = 100;
            if (item.name === '背光亮度') {
              this.imageUrl = Ratio.resName('icon_light')
              this.des = $r('app.string.display_blacklight')

                let origin = this.brightnessValue;

                if (origin < max100) {
                  origin++;
                  this.brightnessValue = origin;
                  item.setValue(origin.toString());
                  this.setOutputBrightness();
                }
            }
          },
          onKeyEventHandle: async (item: SettingItemTvModel, event: KeyEvent) => {
            let min = 0;
            let max100 = 100;
            if (item.name === '护眼模式') {
              this.imageUrl = Ratio.resName('icon_eye')
              this.des = $r('app.string.eye_protection_mode_reduce_blue_light_soft_display')
              if (event.keyCode === KeyCode.KEY_ENTER) {
                router.pushUrl({ url: item.pageUrl }, router.RouterMode.Single)
                this.pageTranState = true
              }
            }
            if (item.name === '图像模式' || item.name === '高级图像设置') {
              this.imageUrl = Ratio.resName('icon_display')
              if (item.name === '高级图像设置') {
                this.des = $r('app.string.customize_current_image_mode_parameters')
              } else {
                this.des = $r('app.string.set_image_type')
              }
              if (event.keyCode === KeyCode.KEY_ENTER) {
                if (item.name === '高级图像设置') {
                  AppStorage.setOrCreate('displayModeType', this.displayMode);
                } else {
                  AppStorage.setOrCreate('displayModeType', '');
                }
                router.pushUrl({ url: item.pageUrl }, router.RouterMode.Single)
                this.pageTranState = true
              }
            }
            if (item.name === '背光亮度') {
              this.imageUrl = Ratio.resName('icon_light')
              this.des = $r('app.string.display_blacklight')
              if (event.type === KeyType.Down) {
                let origin = this.brightnessValue;
                if (event.keyCode == KeyCode.KEY_DPAD_LEFT && origin > min) {
                  origin--;
                  this.brightnessValue = origin;
                  item.setValue(origin.toString());
                  this.setOutputBrightness();
                }
                if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && origin < max100) {
                  origin++;
                  this.brightnessValue = origin;
                  item.setValue(origin.toString());
                  this.setOutputBrightness();
                }
              }
            }
          },
          onFocusHandle: (item: SettingItemTvModel) => {
            if (item.name === '护眼模式') {
              this.imageUrl = Ratio.resName('icon_eye')
              this.des = $r('app.string.eye_protection_mode_reduce_blue_light_soft_display')
            }
            if (item.name === '图像模式' || item.name === '高级图像设置') {
              this.imageUrl = Ratio.resName('icon_display')
              if (item.name === '高级图像设置') {
                this.des = $r('app.string.customize_current_image_mode_parameters')
              } else {
                this.des = $r('app.string.set_image_type')
              }
            }
            if (item.name === '背光亮度') {
              this.imageUrl = Ratio.resName('icon_light')
              this.des = $r('app.string.display_blacklight')
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
