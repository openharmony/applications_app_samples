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
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import lpx from '../../common/Lpx';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { JSON } from '@kit.ArkTS';
import { KeyCode } from '@kit.InputKit';
import json from '@ohos.util.json';
import { screen, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';
import displaySetting from '@ohos.tvservice.displaySetting';

@Entry
@Component
struct ScreenRotation {
  @State settingList: SettingItemTvModel[] = []
  @State chooseList: SettingItemTvModel[] = []
  @State isShow: boolean = false
  focusController = this.getUIContext().getFocusController();

  orientation:number=0                //当前屏幕方向

  aboutToDisappear(): void {
  }

  async aboutToAppear(): Promise<void> {
    setTimeout(async () => {
      this.focusController.activate(true, false);
      this.focusController.requestFocus('title')
      try {
        console.log('xz_获取屏幕方向')
        let displayClass:number = await displaySetting.GetScreenRotation()
        this.orientation=displayClass
        console.log('xz_进入屏幕度数:', displayClass)
        this.isShow=displayClass!=0
        console.log('xz_进入屏幕方向:', this.isShow)
        this.settingList[0].isOn = this.isShow
        this.initInsert()
      } catch (exception) {
        console.error(`xz_ 进入Failed to get default display. Code: ${exception.code}, message: ${exception.message}`);
      }
    },500)
    let item0 = new SettingItemTvModel();
    item0.name = '屏幕旋转';
    item0.style = SettingItemStyle.switch;
    item0.value = '屏幕旋转';
    item0.isOn = this.isShow;
    this.settingList.push(item0)
  }

  initInsert() {
    let items: string[] = ['90°', '180°', '270°'];
    items.forEach((name) => {
      let model: SettingItemTvModel = new SettingItemTvModel();
      model.name = name;
      if (this.orientation == 3 && name == '90°') {
        model.setIsSelect(true);
      }
      if (this.orientation == 2 && name == '180°') {
        model.setIsSelect(true);
      }
      if (this.orientation == 1 && name == '270°') {
        model.setIsSelect(true);
      }
      model.style = SettingItemStyle.singleChoose;
      model.isEnable = true
      model.isDisableFocus = false;
      this.chooseList.push(model)
    })
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)
      Row() {
        Column() {
          SettingListTvComponent({
            settingList: this.settingList,
            title: '屏幕旋转',
            onToggleChangedHandle: (item: SettingItemTvModel) => {
              try {
                console.log('xz_2===')
                this.isShow = !this.isShow
                if (item.isOn==true) {
                  this.chooseList.forEach(model => model.setIsSelect(false));
                  displaySetting.SetScreenRotation(0)
                }else {
                }
              }catch (e) {
                console.log('Screen开关错误', json.stringify(e))
              }

            },
            onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
              console.log('xz_', json.stringify(item))

            }
          })
            .height(lpx(350))

          if (this.isShow) {
            Column(){
              SettingListTvComponent({
                settingList: this.chooseList,
                title: '',
                onMouseClickHandle: (item: SettingItemTvModel,) => {
                  console.log('xz_===',item.name)
                  if (item.name=='90°') {
                    displaySetting.SetScreenRotation(3)

                  }
                  if (item.name=='180°') {
                    displaySetting.SetScreenRotation(2)


                  }
                  if (item.name=='270°') {
                    displaySetting.SetScreenRotation(1)

                  }
                },
                onKeyEventHandle:(item:SettingItemTvModel,event: KeyEvent)=>{
                  console.log('xz_',item.name,event.keyCode)
                }
              })
            }.height(lpx(680))
          }
        }
        .width(ConfigData.WH_52_100)
        .height(ConfigData.WH_100_100)
        .padding({ left: lpx(84) })

        SettingItemDesLayout({ imageUrl: 'app.media.icon_screen_rotation', des: '屏幕旋转' })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
      .id('title')

    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
