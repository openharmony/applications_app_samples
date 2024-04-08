/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import { window } from '@kit.ArkUI';
import logger from '../../utils/Logger';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct SetTouchableAreas {
  private onButtonClick: Callback<string> = (msg: string) => {
    promptAction.showToast({
      message: `click ${msg}`,
      duration: 2000,
      bottom: 100
    })
  };

  onPageShow() {
    this.setTouchableAreas();
  }

  onPageHide(): void {
    this.clearTouchableAreas();
  }

  build() {
    Column() {
      Text($r("app.string.area1"))
        .width('100%')
        .height('25%')
        .backgroundColor($r("app.color.light_gray"))
        .textAlign(TextAlign.Center)
        .id('area1')
        .onClick(async () => this.onButtonClick(await getContext(this)
          .resourceManager
          .getStringValue($r("app.string.area1"))))
      Text($r("app.string.area2"))
        .width('100%')
        .height('25%')
        .backgroundColor($r("app.color.blue"))
        .textAlign(TextAlign.Center)
        .id('area2')
        .onClick(async () => this.onButtonClick(await getContext(this)
          .resourceManager
          .getStringValue($r("app.string.area2"))))
      Text($r("app.string.area3"))
        .width('100%')
        .height('25%')
        .backgroundColor($r("app.color.red"))
        .textAlign(TextAlign.Center)
        .id('area3')
        .onClick(async () => this.onButtonClick(await getContext(this)
          .resourceManager
          .getStringValue($r("app.string.area3"))))
      Text($r("app.string.area4"))
        .width('100%')
        .height('25%')
        .backgroundColor($r("app.color.green"))
        .textAlign(TextAlign.Center)
        .id('area4')
        .onClick(async () => this.onButtonClick(await getContext(this)
          .resourceManager
          .getStringValue($r("app.string.area4"))))
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.light_gray'))
  }

  async clearTouchableAreas() {
    const parentWindow: window.Window = await window.getLastWindow(getContext(this));
    parentWindow.setTouchableAreas([]);
  }

  async setTouchableAreas() {
    const parentWindow: window.Window = await window.getLastWindow(getContext(this));
    const windowWidth = parentWindow.getWindowProperties();
    const rect = windowWidth.windowRect;
    const top = rect.top;
    const left = rect.left;
    const width = rect.width;
    const height = rect.height;
    try {
      parentWindow.setTouchableAreas([
        { top: top, left: left, width: width, height: height / 4 },
        { top: top + height * 3 / 4, left: left, width: width, height: height / 4 },
      ]);
    } catch (e) {
      logger.error(`setTouchableAreas error,Caused: ${JSON.stringify(e)}`);
    }
  }
}
