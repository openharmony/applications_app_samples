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
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { KeyCode } from '../../common/constants/KeyCode';
import { Ratio } from '../../common/Ratio';
import { CustomDialogContentStyle, SettingItemStyle } from '../../common/constants/StyleConstants';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import { Duration } from '../../common/constants/Duration';
import { promptAction } from '@kit.ArkUI';
import displaySetting from '@ohos.tvservice.displaySetting';

const TAG = 'higthSettingIndex'

/**
 * 显示设置
 */

@Entry
@Component
struct Display {
  @State imageUrl: string = Ratio.resName('icon_light')
  @State des: string | Resource = $r('app.string.display_control')
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  private content: DialogContent =
    new DialogContent('确认恢复默认设置?', '此操作会将高级图像设置参数恢复至默认值', '', '', 692, 332);
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: () => {
        this.dialogController.close();
      },
      confirm: async () => {
        try {
          let restoreCurrentPictureMode: boolean = await displaySetting.restoreCurrentPictureMode()
          LogUtil.log(TAG + 'restoreCurrentPictureMode SuccessBoolean==:' + JSON.stringify(restoreCurrentPictureMode));
          if (!restoreCurrentPictureMode) {
            promptAction.showToast({ message: '高级图像默认设置失败' })
          }
        } catch (error) {
          LogUtil.log(TAG + 'restoreCurrentPictureMode=' + JSON.stringify(error));
          promptAction.showToast({ message: $r('app.string.tips_in_development') })
        }
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
    item1.name = '亮度设置';
    item1.pageUrl = 'pages/display/BrightnessSetting'
    item1.description = $r('app.string.display_control')
    item1.imageUrl = Ratio.resName('icon_light')

    let item2 = new SettingItemTvModel();
    item2.name = '色彩设置'
    item2.pageUrl = 'pages/display/ColorSetting'
    item2.description = '色彩设置'
    item2.imageUrl = Ratio.resName('icon_display')

    let item3 = new SettingItemTvModel();
    item3.name = '清晰度与流畅度'
    item3.pageUrl = 'pages/display/ClaritySetting'
    item3.description = '锐利度、随机降噪、MPEG设置'
    item3.imageUrl = Ratio.resName('icon_claritySetting')

    let item4 = new SettingItemTvModel();
    item4.name = '恢复默认值'
    item4.description = '恢复默认值'
    item4.imageUrl = Ratio.resName('icon_display')

    let item5 = new SettingItemTvModel();
    item5.name = '片源识别'
    item5.pageUrl = 'pages/display/SourceIdentification'
    item5.description = '片源识别'
    item5.imageUrl = Ratio.resName('icon_source_identification')


    let item6 = new SettingItemTvModel();
    item6.name = '屏幕校准'
    item6.pageUrl = 'pages/display/ScreenCalibration'
    item6.description = '屏幕校准'
    item6.imageUrl = Ratio.resName('icon_display')


    if (AppStorage.get('displayModeType') != '大师模式') {
      this.settingList.push(item1, item2, item3, item4);
    } else {
      this.settingList.push(item1, item2, item5, item6, item3, item4);
    }
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      SettingListTvComponent({
        settingList: this.settingList,
        title: '高级图像设置',
        subTitle: '系统·' + AppStorage.get('displayModeType'),
        onClickHandle: async (item: SettingItemTvModel) => {
        },
        onMouseClickHandle: async (item: SettingItemTvModel) => {
          if (item.name === '恢复默认值') {
            this.dialogController.open();
          } else {
            router.pushUrl({ url: item.pageUrl }, router.RouterMode.Single)
            this.pageTranState = true;
          }
        },
        onValueChangeLeftHandle: async (item: SettingItemTvModel) => {
        },
        onValueChangeRightHandle: async (item: SettingItemTvModel) => {
        },
        onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
          if (event.type === KeyType.Up && event.keyCode === KeyCode.KEY_ENTER) {
            if (item.name === '恢复默认值') {
              this.dialogController.open();
            } else {
              router.pushUrl({ url: item.pageUrl }, router.RouterMode.Single)
              this.pageTranState = true;
            }
          }
        },
        onFocusHandle: (item: SettingItemTvModel) => {
          this.des = item.description
          this.imageUrl = item.imageUrl
        }
      })
        .width(ConfigData.WH_48_100)
        .height(ConfigData.WH_100_100)
        .margin({ left: lpx(84) })
        .position({ x: 0, y: 0 })

      SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
        .width(ConfigData.WH_48_100)
        .height(ConfigData.WH_100_100)
        .position({ x: '52.5%', y: 0 })
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
