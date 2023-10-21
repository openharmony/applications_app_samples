/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import brightness from '@ohos.brightness';
import settings from '@ohos.settings';
import { GlobalContext } from '../../../../../../entry/src/main/ets/pages/GlobalContext';

@Preview
@Component
export struct BrightnessManager {
  @State value: number = 0;

  async aboutToAppear() {
    let ctx: Context = GlobalContext.getContext().getValue('abilityContext') as Context;
    let brightness = await settings.getValue(ctx, settings.display.SCREEN_BRIGHTNESS_STATUS);
    this.value = Number(brightness);
  }

  build() {
    Column() {
      Text($r("app.string.brightness_manager"))
        .fontSize(18)
        .fontColor($r("app.color.list_content"))
        .fontWeight(FontWeight.Medium)
        .margin({
          left: 16,
          top: 48
        })
      Row() {
        Image($r("app.media.ic_brightness_l"))
          .objectFit(ImageFit.Contain)
          .width(30)
          .height(30)
          .margin({
            left: 16,
            right: 16
          })
        Slider({
          value: this.value,
          min: 0,
          max: 255,
          style: SliderStyle.InSet
        })
          .layoutWeight(1)
          .showTips(true)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.value = value;
            brightness.setValue(Math.round(value));
          })
        Image($r("app.media.ic_brightness_h"))
          .objectFit(ImageFit.Contain)
          .width(30)
          .height(30)
          .margin({
            left: 16,
            right: 16
          })
      }
      .margin({
        top: 12,
        left: 4,
        right: 4
      })
      .backgroundColor($r("app.color.white"))
      .borderRadius(20)
      .height(120)
    }
    .alignItems(HorizontalAlign.Start)
  }
}