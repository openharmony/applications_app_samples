/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import Logger from '../model/Logger';
import SettingList from '../common/SettingList';

const TAG: string = "SettingPublicLayout";

@Component
export struct SettingPublicLayout {
  private icon: Resource | string = '';
  private modeMessage: string = '';
  private getModeBol: (bol: boolean) => void = (bol: boolean) => {};
  private setModeBol: boolean = false;
  private isModeBol: boolean = false;
  private borderBol: boolean = false;
  private borderBole: boolean = false;
  private iconModeBol: boolean = false;
  private backNum: number = 1;
  @State backClBol: boolean = false;
  @Link @Watch('leftSliderChange') leftSliderIndex: number;
  private settingRightLayoutController: CustomDialogController = new CustomDialogController({
    builder: SettingList({
      leftSliderIndex: $leftSliderIndex
    }),
    autoCancel: false,
    customStyle: true
  });

  leftSliderChange(): void {
    if (this.backNum === this.leftSliderIndex) {
      this.backClBol = true;
    } else {
      this.backClBol = false;
    }
  }

  aboutToAppear(): void {
    this.leftSliderChange();
  }

  /**
   * 两种形式，1、无圆角，2、全圆角，3、下左下右圆角，4、上左上右圆角
   * 默认不传 无圆角
   * isModeBol = true borderBol= false 全圆角
   * isModeBol = true  borderBol= true  borderBole = false 下左下右圆角
   * isModeBol = true  borderBol= true  borderBole = true 上左上右圆角
   */
  isBorderFn(): BorderRadiuses {
    if (this.isModeBol) {
      if (this.borderBol) {
        if (this.borderBole) {
          return { topLeft: 16, topRight: 16 };
        } else {
          return { bottomLeft: 16, bottomRight: 16 };
        }
      } else {
        return { topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 16 };
      }
    } else {
      return {};
    }
  }

  build() {
    Row() {
      Row() {
        Row() {
          Image(this.icon)
            .width(20)
            .height(20)
            .margin({ left: '30px' })
          Text(this.modeMessage)
            .fontSize(16)
            .margin({ left: '35px' })
            .fontWeight(500)
        }

        if (this.iconModeBol) {
          Toggle({ type: ToggleType.Switch, isOn: this.setModeBol })
            .selectedColor($r('app.color.theme_color'))
            .switchPointColor('#FFFFFF')
            .onChange((isOn: boolean) => {
              this.getModeBol(isOn);
              Logger.info(TAG, `Toggleon Change Component status: ${isOn}`);
            })
        } else {
          Image($r('app.media.ic_camera_set_arrow'))
            .width(20)
            .height(20)
            .margin({ right: 10 })
        }
      }
      .onClick(() => {
        this.leftSliderIndex = this.backNum;
        this.settingRightLayoutController.open();
        Logger.info(TAG, `onClick leftSliderIndex status: ${this.leftSliderIndex}, backNum: ${this.backNum}`);
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .borderRadius(12)
      .height('40vp')
      .backgroundColor(this.backClBol ? 'rgba(255,0,52,0.10)' : '')
    }
    .padding(2)
    .size({width: '100%', height: '40vp'})
    .borderRadius(this.isBorderFn())
    .backgroundColor(Color.White)
  }
}