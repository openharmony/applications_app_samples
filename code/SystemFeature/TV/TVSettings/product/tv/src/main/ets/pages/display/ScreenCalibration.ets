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
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { KeyCode } from '../../common/constants/KeyCode';
import { Ratio } from '../../common/Ratio';
import { CustomDialogContentStyle, SettingItemStyle } from '../../common/constants/StyleConstants';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import { Duration } from '../../common/constants/Duration';
import { promptAction } from '@kit.ArkUI';
import displaySetting from '@ohos.tvservice.displaySetting';

const TAG = 'ScreenCalibration'

const GAMMA_CALI_POINT_LIST: Record<number, string> = {
  0: '1',
  1: '2',
  2: '3',
  3: '4',
  4: '5',
  5: '6',
  6: '7',
  7: '8',
  8: '9',
  9: '10',
}

/**
 * 屏幕校准
 */

@Entry
@Component
struct ScreenCalibration {
  @State imageUrl: string = Ratio.resName('icon_display')
  @State testImg: PixelMap | null = null
  @State des: string | Resource = ''
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = 0
  @State cubeColor: number = 0
  @State point: number = 0 // 点
  @State pointGammaList: displaySetting.GammaCaliParam[] = []
  private content: DialogContent =
    new DialogContent('确认恢复默认值?', '此操作会将屏幕校准参数恢复至默认值', '', '', 692, 332);
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: () => {
        this.dialogController.close();
      },
      confirm: async () => {
        this.restore10PointGamma();
        this.dialogController.close();
      },
      content: this.content,
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })
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
    LogUtil.info('settings Display EntryComponent aboutToAppear in');

    let item1 = new SettingItemTvModel();
    item1.name = '校准方法';
    item1.imageUrl = Ratio.resName('icon_display')
    item1.chooseDes = '十点伽马校准'
    item1.focusIndex = 0
    item1.description = '校准方法'
    item1.arrowVisible = Visibility.None

    let item2 = new SettingItemTvModel();
    item2.name = '调节点';
    item2.imageUrl = ''
    item2.style = SettingItemStyle.valueChange
    item2.focusIndex = 1

    let item3 = new SettingItemTvModel();
    item3.name = '红';
    item3.imageUrl = ''
    item3.style = SettingItemStyle.valueChange
    item3.focusIndex = 2

    let item4 = new SettingItemTvModel();
    item4.name = '绿';
    item4.imageUrl = ''
    item4.style = SettingItemStyle.valueChange
    item4.focusIndex = 3

    let item5 = new SettingItemTvModel();
    item5.name = '蓝';
    item5.imageUrl = ''
    item5.style = SettingItemStyle.valueChange
    item5.focusIndex = 4

    let item6 = new SettingItemTvModel();
    item6.name = '恢复默认值';
    item6.imageUrl = ''
    item6.focusIndex = 5

    this.settingList.push(item1, item2, item3, item4, item5, item6);



  }
  onPageShow(): void {
    this.get10PointGamma()
  }

  // 设置十点伽马校准
  async set10PointGamma(point: number) {
    const parm: displaySetting.GammaCaliParam = {
      colorR: this.pointGammaList[point].colorR,
      colorG: this.pointGammaList[point].colorG,
      colorB: this.pointGammaList[point].colorB,
    }
    LogUtil.log(TAG + 'set10PointGamma parm => ' + JSON.stringify(parm));
    try {
      const result: boolean = await displaySetting.set10PointGamma(point, parm)
      if (result) {
        LogUtil.log(TAG + 'set10PointGamma success => ' + JSON.stringify(result));
      } else {
        promptAction.showToast({ message: '设置失败' })
      }
    } catch (error) {
      LogUtil.error(TAG + 'set10PointGamma error => ' + JSON.stringify(error));
      promptAction.showToast({ message: '系统异常' })
    }
  }

  // 获取十点伽马校准
  async get10PointGamma() {
    try {
      const result: displaySetting.GammaCaliParam[] = await displaySetting.get10PointGamma()
      LogUtil.log(TAG + 'get10PointGamma success => ' + JSON.stringify(result));
      if (result) {
        this.pointGammaList = result
        this.settingList[1].setValue(GAMMA_CALI_POINT_LIST[this.point])
        this.settingList[2].setValue(this.pointGammaList[this.point].colorR.toString())
        this.settingList[3].setValue(this.pointGammaList[this.point].colorG.toString())
        this.settingList[4].setValue(this.pointGammaList[this.point].colorB.toString())
      } else {
        promptAction.showToast({ message: '获取失败' })
      }
    } catch (error) {
      LogUtil.error(TAG + 'get10PointGamma error => ' + JSON.stringify(error));
      promptAction.showToast({ message: '系统异常' })
    }
  }

  // 重置十点伽马校准
  async restore10PointGamma() {
    try {
      const result: boolean = await displaySetting.restore10PointGamma()
      LogUtil.log(TAG + 'restore10PointGamma success => ' + JSON.stringify(result));
      if (result) {
        this.pointGammaList.forEach((param: displaySetting.GammaCaliParam) => {
          param.colorR = 0
          param.colorG = 0
          param.colorB = 0
        })
        this.point = 0
        this.settingList[1].setValue(GAMMA_CALI_POINT_LIST[this.point])
        this.settingList[2].setValue(this.pointGammaList[this.point].colorR.toString())
        this.settingList[3].setValue(this.pointGammaList[this.point].colorG.toString())
        this.settingList[4].setValue(this.pointGammaList[this.point].colorB.toString())
      } else {
        promptAction.showToast({ message: '重置失败' })
      }
    } catch (error) {
      LogUtil.error(TAG + 'restore10PointGamma error => ' + JSON.stringify(error));
      promptAction.showToast({ message: '系统异常' })
    }
  }

  // 更新色块
  updateColorCube() {
    const colorCubeList = [26, 51, 77, 102, 128, 153, 179, 204, 230, 255]
    const cubeColor = colorCubeList[this.point]
    const colorCubeText = `R:${cubeColor} G:${cubeColor} B:${cubeColor}`
    this.cubeColor = colorCubeList[this.point]
    this.des = colorCubeText
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      SettingListTvComponent({
        settingList: this.settingList,
        title: '屏幕校准',
        subTitle: '系统·' + AppStorage.get('displayModeType'),
        onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
          if (event.type === KeyType.Up && event.keyCode === KeyCode.KEY_ENTER) {
            if (item.name === '恢复默认值') {
              this.dialogController.open();
            }
          }

          if (event.type === KeyType.Down &&
            (event.keyCode == KeyCode.KEY_DPAD_LEFT || event.keyCode === KeyCode.KEY_DPAD_RIGHT)) {

            if (item.name === '调节点') {
              const length = Object.keys(GAMMA_CALI_POINT_LIST).length
              // 设置调节点
              if (event.keyCode == KeyCode.KEY_DPAD_LEFT) { // left
                this.point = (this.point - 1 + length) % length;
              }
              if (event.keyCode === KeyCode.KEY_DPAD_RIGHT) { // right
                this.point = (this.point + 1) % length
              }
              console.log('this.point ==> ', this.point)
              this.settingList[1].setValue(GAMMA_CALI_POINT_LIST[this.point])
              this.settingList[2].setValue(this.pointGammaList[this.point].colorR.toString())
              this.settingList[3].setValue(this.pointGammaList[this.point].colorG.toString())
              this.settingList[4].setValue(this.pointGammaList[this.point].colorB.toString())
              this.updateColorCube()
            }
            if (item.name === '红' || item.name === '绿' || item.name === '蓝') {
              // 设置红、绿、蓝
              let colorKey = ''
              let settingIndex = 0
              if (item.name === '红') {
                colorKey = 'colorR'
                settingIndex = 2
              } else if (item.name === '绿') {
                colorKey = 'colorG'
                settingIndex = 3
              } else if (item.name === '蓝') {
                colorKey = 'colorB'
                settingIndex = 4
              }
              const curVal = Number(this.pointGammaList[this.point][colorKey])
              if (event.keyCode == KeyCode.KEY_DPAD_LEFT) { // left
                if (curVal > -20) {
                  const setPoint = Number(this.pointGammaList[this.point][colorKey]) - 1;
                  this.pointGammaList[this.point][colorKey] = ((setPoint + 41) + 20) % 41 - 20;
                } else {
                  return;
                }
              }
              if (event.keyCode === KeyCode.KEY_DPAD_RIGHT) { // right
                if (curVal < 20) {
                  const setPoint = Number(this.pointGammaList[this.point][colorKey]) + 1;
                  this.pointGammaList[this.point][colorKey] = ((setPoint + 41) + 20) % 41 - 20;
                } else {
                  return;
                }
              }
              this.settingList[settingIndex].setValue(this.pointGammaList[this.point][colorKey].toString())
              this.set10PointGamma(this.point)
              this.updateColorCube()
            }
          }
        },
        onFocusHandle: (item: SettingItemTvModel) => {
          this.focusIndex = item.focusIndex
          if (this.focusIndex === 0) {
            this.des = item.description
          } else if (this.focusIndex === 1) {
            this.updateColorCube()
          }
        }
      })
        .width(ConfigData.WH_48_100)
        .height(ConfigData.WH_100_100)
        .margin({ left: lpx(84) })
        .position({ x: 0, y: 0 })


      Column() {
        if (this.focusIndex === 0) {
          Image($r(this.imageUrl))
            .width(this.imageUrl == 'app.media.icon_light' || this.imageUrl == 'app.media.icon_display' ? '330lpx' :
            ConfigData.WH_40_100)// .height(ConfigData.WH_50_100)
            .objectFit(this.imageUrl == 'app.media.icon_light' || this.imageUrl == 'app.media.icon_display' ?
            ImageFit.Cover : ImageFit.Contain)
            .aspectRatio(1)
        } else {
          Row()
            .backgroundColor(`rgba(${this.cubeColor}, ${this.cubeColor}, ${this.cubeColor}, 1)`)
            .border({
              color: '#66ffffff',
              width: lpx(2)
            })
            .width(lpx(308))
            .aspectRatio(1)
        }

        Text(this.des)
          .fontColor('rgba(255, 255, 255, 0.2)')
          .fontSize(lpx(36))
          .margin({
            top: lpx(24)
          })
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width(ConfigData.WH_48_100)
      .height(ConfigData.WH_100_100)
      .position({ x: '52.5%', y: 0 })

    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
