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

import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import inputMethod from '@ohos.inputMethod';
import { JSON } from '@kit.ArkTS';
import { Duration } from '../../common/constants/Duration';

@Entry
@Component
struct Ime {
  @State imageUrl: string = Ratio.resName('icon_general')
  @State des: string = '输入法选项'
  @State settingList: SettingItemTvModel[] = []
  @State imList: inputMethod.InputMethodProperty[] = [];
  currentIME: string = '';
  currentIMEName: string = '';

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  aboutToAppear() {
    this.getAllMethod()

    if (inputMethod.getCurrentInputMethod()) {
      let nowIMEInfo = inputMethod.getCurrentInputMethod();
      this.currentIME = nowIMEInfo.label!
      this.currentIMEName = nowIMEInfo.name;
    } else {
      this.currentIME = this.imList[0].label!
      this.currentIMEName = this.imList[0].name;
      inputMethod.switchInputMethod(this.imList[0]);
      this.settingList[0].setIsSelect(true);
    }

    this.settingList.forEach(item => {
      if (item.nameId === this.currentIMEName) {
        item.setIsSelect(true)
      }
    })

  }

  getAllMethod() {
    try {
      if (inputMethod.getSetting().getAllInputMethodsSync()) {
        this.imList = inputMethod.getSetting().getAllInputMethodsSync()
        this.imList.forEach((item: inputMethod.InputMethodProperty) => {
          let model: SettingItemTvModel = new SettingItemTvModel();
          model.name = item.label!
          model.style = this.imList.length == 1 ? SettingItemStyle.info : SettingItemStyle.singleChoose;
          model.nameId = item.name
          this.settingList.push(model)
        })
      }
    } catch (err) {
      console.error(`Failed to getAllInputMethodsSync: ${JSON.stringify(err)}`);
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
          title: '输入法切换',
          onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
            if (event.keyCode == KeyCode.KEY_ENTER && event.type === KeyType.Up) {
              for (let index = 0; index < this.settingList.length; index++) {
                if (this.settingList[index].name == item.name) {
                  item.setIsSelect(true)
                  this.imList.forEach((im: inputMethod.InputMethodProperty) => {
                    if (item.name === im.label ?? im.name) {
                      inputMethod.switchInputMethod(im)
                    }
                  })
                } else {
                  this.settingList[index].setIsSelect(false)
                }
              }
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
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
