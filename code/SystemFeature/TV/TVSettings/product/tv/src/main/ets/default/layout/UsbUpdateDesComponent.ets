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

import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { KeyCode } from '../../common/constants/KeyCode';
import lpx from '../../common/Lpx';
import { EventUtil } from '../../common/EventUtil';
import { SourcetoolConstants } from '../../common/constants/StyleConstants';

const TAG = 'UsbUpdateDesComponent';

@Component
export struct UsbUpdateDesComponent {
  @Prop des: string | Resource;
  @Prop isUsbDeviceMounted: boolean = false;
  @State focusIndex: number = -1
  private onClickHandle: Function = () => {
  };

  aboutToAppear() {
    LogUtil.info(TAG + ' aboutToAppear')
  }

  build() {
    Column() {
      Image($r('app.media.usb_device'))
        .width(ConfigData.WH_40_100)
        .objectFit(ImageFit.Contain)
        .aspectRatio(1)

      Text(this.des)
        .fontColor('rgba(105, 105, 105, 1)')
        .fontSize(lpx(36))
        .margin({
          top: this.isUsbDeviceMounted ? lpx(17) : lpx(41)
        })

      Button($r('app.string.usb_check_update'))
        .id('usb_check_update')
        .backgroundColor(this.focusIndex == 0 ? 'rgba(222, 222, 222, 1)' : 'rgba(86, 86, 86, 1)')
        .fontColor(this.focusIndex == 0 ? 'rgba(7, 7, 7, 1)' : 'rgba(255, 255, 255, 1)')
        .height(lpx(82))
        .fontSize(lpx(36))
        .focusable(true)
        .padding({
          left: lpx(38),
          right: lpx(38),
          top: lpx(23),
          bottom: lpx(23)
        })
        .onFocus(() => {
          this.focusIndex = 0
        })
        .onBlur(() => {
          this.focusIndex = -1
        })
        .margin({ top: lpx(29) })
        .onClick(() => {
            console.log(TAG, 'onKeyEvent check update button.');
            this.onClickHandle();
        })
        .onTouch((event?: TouchEvent) => {
          if (!event) {
            return;
          }
          if (!EventUtil.isTouchEvent(event)) {
            return;
          }
          if (!EventUtil.isPenOrMouseClick(event, SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK)) {
            return;
          }
        })
        .stateStyles({
          focused: {
            .border({
              color: Color.Transparent
            })
          }
        })
        .visibility(this.isUsbDeviceMounted ? Visibility.Visible : Visibility.None)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}
