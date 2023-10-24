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

import settings from '@ohos.settings';
import { ColumnOperation } from '../components/ColumnOperation';
import { GlobalContext } from '../../../../../../entry/src/main/ets/pages/GlobalContext';

@Preview
@Component
export struct SettingsManager {
  @State result: string = '';

  build() {
    Scroll() {
      Column() {
        Row() {
          Text(this.result)
            .fontWeight(FontWeight.Medium)
            .fontSize(20)
        }
        .alignItems(VerticalAlign.Top)
        .width('100%')
        .backgroundColor($r("app.color.white"))
        .height(160)
        .padding(16)
        .borderRadius(20)
        .margin({ top: 16 })
        ColumnOperation({ operationRes: $r('app.strarray.settings_operations'), doOperation: this.doOperation })
      }
      .width('100%')
      .padding(4)
    }
    .scrollBar(BarState.Off)
  }

  doOperation = async (index: number) => {
    switch (index) {
      case 0:
        try {
          let ctx: Context = GlobalContext.getContext().getValue('abilityContext') as Context;
          let status = await settings.setValue(ctx, settings.display.SCREEN_BRIGHTNESS_STATUS, '100');
          let val = await settings.getValue(ctx, settings.display.SCREEN_BRIGHTNESS_STATUS);
          this.result = `set SCREEN_BRIGHTNESS_STATUS 100 ${status}, current value:${val}`;
        } catch (err) {
          this.result = `set SCREEN_BRIGHTNESS_STATUS 100 fail: ${err}`;
        }
        break
      default:
        break
    }
  }
}