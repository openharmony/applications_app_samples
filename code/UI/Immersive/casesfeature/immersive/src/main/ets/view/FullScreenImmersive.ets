/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { window } from '@kit.ArkUI';
import { Constants } from '../common/Constants';

/**
 * 窗口全屏布局方案示例
 * 1、设置窗口强制全屏布局
 * 2、获取状态栏和导航条的高度手动进行避让
 */
@Component
export struct FullScreenImmersive {
  @State topHeight: number = 0;
  @State bottomHeight: number = 0;
  windowClass?: window.Window;

  aboutToAppear(): void {
    window.getLastWindow(getContext(), (err, windowClass) => {
      this.windowClass = windowClass;
      // 设置窗口强制全屏布局
      windowClass.setWindowLayoutFullScreen(true);
      // 获取导航条高度
      this.bottomHeight =
        windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height;
      // 获取状态栏高度
      this.topHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height;
    })
  }

  aboutToDisappear() {
    // 销毁前把布局设回去，防止影响其他页面
    if (this.windowClass) {
       this.windowClass.setWindowLayoutFullScreen(false);
    }
  }

  build() {
    Column() {
      Text($r('app.string.full_screen_immersive_adaption'))
        .textAlign(TextAlign.Center)
        .width('100%')
        .fontSize($r('app.integer.integer_40'))
        .fontColor(Color.Black)
        .height('10%')
      Column() {
        Text('row1')
          .width('100%')
          .height($r('app.integer.integer_100'))
          .fontSize(Constants.NUMBER_16)
          .textAlign(TextAlign.Center)
          .borderRadius(Constants.NUMBER_10)
          .backgroundColor(Color.White)

        Divider()
          .strokeWidth(Constants.NUMBER_2)
          .color(Color.White)
          .width('100%')
          .padding({ left: Constants.NUMBER_20, right: Constants.NUMBER_20 })
          .margin({ top: Constants.NUMBER_20, bottom: Constants.NUMBER_20 })

        Text('row2')
          .width('100%')
          .height($r('app.integer.integer_100'))
          .fontSize(Constants.NUMBER_16)
          .textAlign(TextAlign.Center)
          .borderRadius(Constants.NUMBER_10)
          .backgroundColor(Color.White)
        Divider()
          .strokeWidth(Constants.NUMBER_2)
          .color(Color.White)
          .width('100%')
          .padding({ left: Constants.NUMBER_20, right: Constants.NUMBER_20 })
          .margin({ top: Constants.NUMBER_20, bottom: Constants.NUMBER_20 })

        Text('row3')
          .width('100%')
          .height($r('app.integer.integer_100'))
          .fontSize(Constants.NUMBER_16)
          .textAlign(TextAlign.Center)
          .borderRadius(Constants.NUMBER_10)
          .backgroundColor(Color.White)

        Divider()
          .strokeWidth(Constants.NUMBER_2)
          .color(Color.White)
          .width('100%')
          .padding({ left: Constants.NUMBER_20, right: Constants.NUMBER_20 })
          .margin({ top: Constants.NUMBER_20, bottom: Constants.NUMBER_20 })

        Text('row4')
          .width('100%')
          .height($r('app.integer.integer_100'))
          .fontSize(Constants.NUMBER_16)
          .textAlign(TextAlign.Center)
          .borderRadius(Constants.NUMBER_10)
          .backgroundColor(Color.White)

        Divider()
          .strokeWidth(Constants.NUMBER_2)
          .color(Color.White)
          .width('100%')
          .padding({ left: Constants.NUMBER_20, right: Constants.NUMBER_20 })
          .margin({ top: Constants.NUMBER_20, bottom: Constants.NUMBER_20 })
        Text('row5')
          .width('100%')
          .height($r('app.integer.integer_100'))
          .fontSize(Constants.NUMBER_16)
          .textAlign(TextAlign.Center)
          .borderRadius(Constants.NUMBER_10)
          .backgroundColor(Color.White)
      }
      .width('90%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.immersive_background_color'))
    // 设置padding避让状态栏及导航条
    .padding({ top: px2vp(this.topHeight), bottom: px2vp(this.bottomHeight) })
  }
}