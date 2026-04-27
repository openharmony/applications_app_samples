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
import { Ratio } from '../../common/Ratio';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import lpx from '../../common/Lpx';
import displaySetting from '@ohos.tvservice.displaySetting';
import promptAction from '@ohos.promptAction';
import { Duration } from '../../common/constants/Duration';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';

const TAG = 'photoSettingIndex'

@Entry
@Component
struct photoSetting {
  @State imageUrl: string = Ratio.resName('icon_graphic')
  @State des: string = '图像模式';
  @State settingList: SettingItemTvModel[] = [];
  @State focusIndex: number = -1;
  @StorageLink('displayMode') displayMode: string = '';
  outPutPictureMap: Map<string, number> = new Map();

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  aboutToAppear() {
    let displayArr: string[] = ['自动', '鲜艳', '标准', '电影', '体育', '电脑', '照片', '游戏', '大师模式'];
    displayArr.forEach(item => {
      let model = new SettingItemTvModel();
      model.name = item;
      if (item === this.displayMode) {
        model.setIsSelect(true);
      }
      model.style = SettingItemStyle.singleChoose;
      this.settingList.push(model);
    })
    this.initOutputOpiton()
  }

  initOutputOpiton() {
    this.outPutPictureMap.set('自动', 8);
    this.outPutPictureMap.set('鲜艳', 1);
    this.outPutPictureMap.set('标准', 0);
    this.outPutPictureMap.set('电影', 2);
    this.outPutPictureMap.set('体育', 3);
    this.outPutPictureMap.set('电脑', 6);
    this.outPutPictureMap.set('照片', 4);
    this.outPutPictureMap.set('游戏', 5);
    this.outPutPictureMap.set('大师模式', 7);
  }

  async setOutputPictureMode(value: number) {
    try {
      LogUtil.log(TAG + 'setPictureModeSuccess=' + JSON.stringify(value));
      let setPictureMode: boolean = await displaySetting.setPictureMode(value); // 调用厂商api
      LogUtil.log(TAG + 'setPictureModeSuccess= SuccessBoolean==:' + JSON.stringify(setPictureMode));
      if (!setPictureMode) {
        promptAction.showToast({ message: '设置图像模式失败' })
      }
    } catch (error) {
      LogUtil.log(TAG + 'setPictureMode=' + JSON.stringify(error));
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
          title: '图像模式',
          onClickHandle: (item: SettingItemTvModel) => {
          },
          onMouseClickHandle: (item: SettingItemTvModel) => {
            this.displayMode = item.name;
            this.setOutputPictureMode(this.outPutPictureMap.get(item.name) as number)
            AppStorage.setOrCreate('displayMode', this.displayMode);
          },
          onValueChangeLeftHandle: (item: SettingItemTvModel) => {
          },
          onValueChangeRightHandle: (item: SettingItemTvModel) => {
          },
          onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
            if (event.keyCode === KeyCode.KEY_ENTER && event.type === KeyType.Up) {
              this.displayMode = item.name;
              this.setOutputPictureMode(this.outPutPictureMap.get(item.name) as number)
              AppStorage.setOrCreate('displayMode', this.displayMode);
            }
          }
        })
          .width(ConfigData.WH_52_100)
          .height('100%')
          .padding({ left: lpx(84) })
          .linearGradient({
            direction: GradientDirection.Right,
            repeating: true,
            colors: [['rgb(0,0,0)', 0.0], ['rgba(62,62,62,0.62)', 1]]
          })

        SettingItemDesLayout({ imageUrl: '', des: '' })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
  }
}
