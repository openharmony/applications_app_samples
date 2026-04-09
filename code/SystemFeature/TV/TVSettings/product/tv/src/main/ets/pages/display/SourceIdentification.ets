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
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { Ratio } from '../../common/Ratio';
import displaySetting from '@ohos.tvservice.displaySetting';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import lpx from '../../common/Lpx';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { promptAction, router } from '@kit.ArkUI';
import { Duration } from '../../common/constants/Duration';
import { SettingItemTvComponent } from '../../default/layout/SettingItemTvComponent';

const TAG = 'SourceIdentification'

const sourceIdentificationTypeList: Record<number, string> = {
  0: '自动识别',
  1: '按标准指定',
  2: '自定义1',
  3: '自定义2',
}

const colorGamutTypeList: Record<number, string> = {
  0: 'AUTO',
  1: 'BT2020',
  2: 'P3',
  3: 'ADOBERGB',
  4: 'BT709',
  5: 'BT601_EBU',
  6: 'BT601_SMPTE',
  7: 'NATIVE'
}

const whitePointTypeList: Record<number, string> = {
  0: 'AUTO',
  1: 'D50',
  2: 'D60',
  3: 'D63',
  4: 'D65',
  5: 'D93',
  6: 'NATIVE'
}

const OETF_TYPE_LIST: Record<number, string> = {
  0: 'AUTO',
  1: 'BT709',
  2: 'SRGB',
  3: '22',
  4: '24',
  5: '26',
  6: 'ST2084',
  7: 'HLG',
  8: 'NATIVE'
}

const colorSpaceTypeList: Record<number, string> = {
  // 0: 'AUTO',
  1: 'HDR10',
  2: 'HLG',
  3: 'HDTV',
  4: 'SRGB',
  5: 'P3_DCI',
  6: 'P3_D65',
  7: 'P3_D50',
  8: 'ADOBERGB',
  9: 'EBU',
  10: 'SMPTE_C',
  // 11: 'USER1',
  // 12: 'USER2',
  13: 'P3_PG',
  14: 'CUVA',
  15: 'NATIVE',
  16: 'IDEA_NATIVE',
}

/**
 * 片源识别
 */

@Entry
@Component
struct SourceIdentification {
  @State imageUrl: string = Ratio.resName('icon_source_identification')
  @State des: string | Resource = '设置片源类型'
  @State settingList: SettingItemTvModel[] = []
  @State settingList2: SettingItemTvModel[] = [] // 自定义才显示的列表（片源色域、片源白点、片源OETF）
  @State curType: number = 0 // 当前的片源识别类型
  @State curColorGamutType: number = 0 // 当前的片源色域
  @State curWhitePointType: number = 0 // 当前的片源白点
  @State curOetfType: number = 0 // 当前的片源OETF
  private pageTranState: boolean = false; //判断是进场动效还是出场动效
  @State isLeft: boolean = false;
  @State isTouchImg: boolean = false;
  @State focusIndex: number = -1;
  @State tipDialogTimerId: number | null = null;
  @State isShowTipDialog: boolean = false;

  onPageShow(): void {
    this.getColorManageMode()
  }

  onPageHide(): void {
    this.pageTranState = false
    if (this.tipDialogTimerId) {
      clearTimeout(this.tipDialogTimerId)
    }
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
    LogUtil.info('settings Display EntryComponent aboutToAppear in');

    let item1 = new SettingItemTvModel();
    item1.name = '片源识别';
    item1.style = SettingItemStyle.valueChange
    item1.value = sourceIdentificationTypeList[this.curType];

    let item2 = new SettingItemTvModel();
    item2.name = '色彩空间';
    item2.pageUrl = 'pages/display/ColorSpace';
    item2.setIsShow(this.curType === 1);

    this.settingList.push(item1, item2)

    let item3 = new SettingItemTvModel();
    item3.name = '片源色域';
    item3.style = SettingItemStyle.valueChange

    let item4 = new SettingItemTvModel();
    item4.name = '片源白点';
    item4.style = SettingItemStyle.valueChange

    let item5 = new SettingItemTvModel();
    item5.name = '片源OETF';
    item5.style = SettingItemStyle.valueChange

    this.settingList2.push(item3, item4, item5)

    await this.getColorManageMode()
    // 如果色彩空间模式为自定义模式，再获取3要素
    if (this.curType === 2 || this.curType === 3) {
      this.getColorManageUser(this.curType)
    }

    // 显示提示语
    this.tipDialogTimerId = setTimeout(() => {
      this.isShowTipDialog = true;
      this.tipDialogTimerId = null;
      setTimeout(() => {
        this.isShowTipDialog = false;
      }, 3000)
    }, 2000)
  }

  // 获取片源识别类型（获取色彩空间模式）
  async getColorManageMode() {
    try {
      const result: displaySetting.ColorManagementMode = await displaySetting.getColorManageMode()
      LogUtil.log(TAG + 'getColorManageMode success => ' + JSON.stringify(result));
      if (result === 0) {
        this.curType = 0
      } else if (result === 11) {
        this.curType = 2
      } else if (result === 12) {
        this.curType = 3
      } else {
        this.curType = 1
      }
      this.settingList[0].setValue(sourceIdentificationTypeList[this.curType])
      this.settingList[1].setChooseDes(colorSpaceTypeList[result])
    } catch (error) {
      LogUtil.error(TAG + 'getColorManageMode error => ' + JSON.stringify(error));
      promptAction.showToast({ message: '系统异常' })
    }
  }

  // 设置片源识别类型（设置色彩空间模式）
  async setColorManageMode() {
    let mode: number = 0
    if (this.curType === 0) {
      mode = 0
    } else if (this.curType === 1) {
      mode = 1
    } else if (this.curType === 2) {
      mode = 11
    } else if (this.curType === 3) {
      mode = 12
    }
    try {
      const result: boolean = await displaySetting.setColorManageMode(mode)
      LogUtil.log(TAG + 'setColorManageMode success => ' + JSON.stringify(result));
      if (!result) {
        promptAction.showToast({ message: '设置失败' })
      } else {
        this.settingList[1].setChooseDes(colorSpaceTypeList[mode])
      }
    } catch (error) {
      LogUtil.error(TAG + 'setColorManageMode error => ' + JSON.stringify(error));
      promptAction.showToast({ message: '系统异常' })
    }
  }

  // 获取色彩空间模式中的用户自定义模式
  async getColorManageUser(curType: number) {
    let user = 0;
    if (curType === 2) {
      user = 11
    }
    if (curType === 3) {
      user = 12
    }
    try {
      LogUtil.log(TAG + 'getColorManageUser user => ' + JSON.stringify(user));
      const result: displaySetting.ColorManage = await displaySetting.getColorManageUser(user)
      this.curColorGamutType = result.colorGamut
      this.curWhitePointType = result.whitePoint
      this.curOetfType = result.oetf
      this.settingList2[0].setValue(colorGamutTypeList[this.curColorGamutType])
      this.settingList2[1].setValue(whitePointTypeList[this.curWhitePointType])
      this.settingList2[2].setValue(OETF_TYPE_LIST[this.curOetfType])
      LogUtil.log(TAG + 'getColorManageUser success => ' + JSON.stringify(result));
    } catch (error) {
      LogUtil.error(TAG + 'getColorManageUser error => ' + JSON.stringify(error));
      promptAction.showToast({ message: '系统异常' })
    }
  }

  // 设置色彩空间模式中的用户自定义模式
  async setColorManageUser(curType: number) {
    let user = 0;
    if (curType === 2) {
      user = 11
    }
    if (curType === 3) {
      user = 12
    }
    try {
      const color: displaySetting.ColorManage = {
        colorGamut: this.curColorGamutType,
        whitePoint: this.curWhitePointType,
        oetf: this.curOetfType
      }
      LogUtil.log(TAG + 'setColorManageUser user => ' + JSON.stringify(user));
      LogUtil.log(TAG + 'setColorManageUser color => ' + JSON.stringify(color));
      const result: boolean = await displaySetting.setColorManageUser(user, color)
      LogUtil.log(TAG + 'setColorManageUser success => ' + JSON.stringify(result));
      if (!result) {
        promptAction.showToast({ message: '设置失败' })
      }
    } catch (error) {
      LogUtil.error(TAG + 'setColorManageUser error => ' + JSON.stringify(error));
      promptAction.showToast({ message: '系统异常' })
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
          Text('片源识别')
            .height(lpx(75))
            .lineHeight(lpx(75))
            .fontColor(Color.White)
            .fontSize(lpx(64))
            .fontWeight(500)
            .textAlign(TextAlign.Start)
            .margin({
              top: lpx(48),
              bottom: lpx(0),
              left: lpx(12)
            })

          Text('系统·' + AppStorage.get('displayModeType'))
            .height(lpx(35))
            .fontColor('#99ffffff')
            .fontSize(lpx(30))
            .align(Alignment.Center)
            .margin({
              right: lpx(24),
              top: lpx(36),
              bottom: lpx(36),
              left: lpx(12)
            })


          // 片源识别
          List({ space: lpx(12) }) {
            ListItem() {
              SettingItemTvComponent({
                isEnable: true,
                model: this.settingList[0],
                isLeft: this.isLeft,
                isTouchImg: this.isTouchImg,
                isFocus: this.focusIndex === 0
              })
            }
            .height(lpx(118))
            .width(lpx(868))
            .focusable(true)
            .border(this.focusIndex === 0 ? {
              width: lpx(2),
              color: Color.White,
              radius: lpx(24),
              style: BorderStyle.Solid
            } : { width: 0 })
            .defaultFocus(true)
            .onFocus(() => {
              this.focusIndex = 0
            })
            .onBlur(() => {
              this.focusIndex = -1;
            })
            .onKeyEvent(async (event) => {
              if (event.type == KeyType.Down &&
                (event.keyCode == KeyCode.KEY_DPAD_LEFT || event.keyCode === KeyCode.KEY_DPAD_RIGHT)) {
                const length = Object.keys(sourceIdentificationTypeList).length
                // 设置片源识别类型
                if (event.keyCode == KeyCode.KEY_DPAD_LEFT) { // left
                  this.curType = (this.curType - 1 + length) % length;
                }
                if (event.keyCode === KeyCode.KEY_DPAD_RIGHT) { // right
                  this.curType = (this.curType + 1) % length
                }
                this.settingList[0].setValue(sourceIdentificationTypeList[this.curType])
                // 控制色彩空间显示隐藏
                this.settingList[1].setIsShow(this.curType === 1)

                // 设置色彩空间模式
                await this.setColorManageMode()
                // 如果色彩空间模式为自定义模式，再获取3要素
                if (this.curType === 2 || this.curType === 3) {
                  this.getColorManageUser(this.curType)
                }
              }
            })

            // 色彩空间
            if (this.curType === 1) {
              ListItem() {
                SettingItemTvComponent({
                  isEnable: true,
                  model: this.settingList[1],
                  isLeft: this.isLeft,
                  isTouchImg: this.isTouchImg,
                  isFocus: this.focusIndex === 1
                })
              }
              .height(lpx(118))
              .width(lpx(868))
              .focusable(true)
              .border(this.focusIndex === 1 ? {
                width: lpx(2),
                color: Color.White,
                radius: lpx(24),
                style: BorderStyle.Solid
              } : { width: 0 })
              .defaultFocus(false)
              .onFocus(() => {
                this.focusIndex = 1
              })
              .onBlur(() => {
                this.focusIndex = -1;
              })
              .onKeyEvent((event) => {
                if (event.type === KeyType.Down && event.keyCode === KeyCode.KEY_ENTER) {
                  router.pushUrl({ url: this.settingList[1].pageUrl }, router.RouterMode.Single)
                  this.pageTranState = true;
                }
              })
            }
          }
          .scrollBar(BarState.Off)
          .width(ConfigData.WH_100_100)


          // 自定义
          if (this.curType === 2 || this.curType === 3) {
            Text('自定义')
              .height(lpx(35))
              .fontColor('#99ffffff')
              .fontSize(lpx(30))
              .align(Alignment.Center)
              .margin({
                right: lpx(24),
                top: lpx(36),
                bottom: lpx(36),
                left: lpx(12)
              })
            List({ space: lpx(12) }) {
              ForEach(this.settingList2, (item: SettingItemTvModel, index) => {
                ListItem() {
                  SettingItemTvComponent({
                    isEnable: true,
                    model: item,
                    isLeft: this.isLeft,
                    isTouchImg: this.isTouchImg,
                    isFocus: this.focusIndex === index + 2
                  })
                }
                .height(lpx(118))
                .width(lpx(868))
                .focusable(true)
                .border(this.focusIndex === index + 2 ? {
                  width: lpx(2),
                  color: Color.White,
                  radius: lpx(24),
                  style: BorderStyle.Solid
                } : { width: 0 })
                .defaultFocus(index === 0)
                .onFocus(() => {
                  this.focusIndex = index + 2
                })
                .onBlur(() => {
                  this.focusIndex = -1;
                })
                .onKeyEvent((event) => {
                  if (item.name === '片源色域' &&
                    (event.keyCode == KeyCode.KEY_DPAD_LEFT || event.keyCode === KeyCode.KEY_DPAD_RIGHT)) {
                    if (event.type == KeyType.Down) {
                      const length = Object.keys(colorGamutTypeList).length
                      // 设置片源色域
                      if (event.keyCode == KeyCode.KEY_DPAD_LEFT) { // left
                        this.curColorGamutType = (this.curColorGamutType - 1 + length) % length;
                      }
                      if (event.keyCode === KeyCode.KEY_DPAD_RIGHT) { // right
                        this.curColorGamutType = (this.curColorGamutType + 1) % length
                      }
                      this.settingList2[0].setValue(colorGamutTypeList[this.curColorGamutType])
                      // 设置自定义
                      this.setColorManageUser(this.curType)
                    }
                  }
                  if (item.name === '片源白点') {
                    if (event.type == KeyType.Down &&
                      (event.keyCode == KeyCode.KEY_DPAD_LEFT || event.keyCode === KeyCode.KEY_DPAD_RIGHT)) {
                      const length = Object.keys(whitePointTypeList).length
                      // 设置片源白点
                      if (event.keyCode == KeyCode.KEY_DPAD_LEFT) { // left
                        this.curWhitePointType = (this.curWhitePointType - 1 + length) % length;
                      }
                      if (event.keyCode === KeyCode.KEY_DPAD_RIGHT) { // right
                        this.curWhitePointType = (this.curWhitePointType + 1) % length
                      }
                      this.settingList2[1].setValue(whitePointTypeList[this.curWhitePointType])
                      // 设置自定义
                      this.setColorManageUser(this.curType)
                    }
                  }
                  if (item.name === '片源OETF') {
                    if (event.type == KeyType.Down &&
                      (event.keyCode == KeyCode.KEY_DPAD_LEFT || event.keyCode === KeyCode.KEY_DPAD_RIGHT)) {
                      const length = Object.keys(OETF_TYPE_LIST).length
                      // 设置片源OETF
                      if (event.keyCode == KeyCode.KEY_DPAD_LEFT) { // left
                        this.curOetfType = (this.curOetfType - 1 + length) % length;
                      }
                      if (event.keyCode === KeyCode.KEY_DPAD_RIGHT) { // right
                        this.curOetfType = (this.curOetfType + 1) % length
                      }
                      this.settingList2[2].setValue(OETF_TYPE_LIST[this.curOetfType])
                      // 设置自定义
                      this.setColorManageUser(this.curType)
                    }
                  }

                })
              });
            }
            .scrollBar(BarState.Off)
            .width(ConfigData.WH_100_100)
          }
        }
        .width(ConfigData.WH_48_100)
        .height(ConfigData.WH_100_100)
        .margin({ left: lpx(84) })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }

      // 提示
      if (this.isShowTipDialog) {
        Column() {
          Text('如果您不清楚正在播放的片源类型，建议您选择片源自动识别，否则可能造成片源与手动配置色彩空间不匹配，显示色彩异常')
            .fontSize(lpx(24))
            .fontWeight(500)
            .lineHeight(lpx(28))
            .fontColor('#ffffff')
            .width(lpx(264))
        }
        .backgroundColor('#404040')
        .padding(lpx(48))
        .borderRadius(lpx(24))
      }

    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
