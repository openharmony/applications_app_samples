/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Textcomponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'Textcomponent_';

// [Start Computing_Property_Resolution]
@Entry
@ComponentV2
export struct ComputingPropertyResolution {
  @Local celsius: number = 20;

  @Computed
  get fahrenheit(): number {
    return this.celsius * 9 / 5 + 32; // C -> F
  }

  @Computed
  get kelvin(): number {
    return (this.fahrenheit - 32) * 5 / 9 + 273.15; // F -> K
  }

  @Monitor('kelvin')
  onKelvinMonitor(mon: IMonitor) {
    hilog.info(DOMAIN, TAG, BUNDLE + 'kelvin changed from' + mon.value()?.before + ' to ' + mon.value()?.now);
  }

  build() {
    // [StartExclude Computing_Property_Resolution]
    NavDestination() {
      // [EndExclude  Computing_Property_Resolution]
      Column({ space: 20 }) {
        Row({ space: 20 }) {
          Button('-')
            .onClick(() => {
              this.celsius--;
            })

          Text(`Celsius ${this.celsius.toFixed(1)}`)
            .fontSize(40)

          Button('+')
            .onClick(() => {
              this.celsius++;
            })
        }

        Text(`Fahrenheit ${this.fahrenheit.toFixed(2)}`)
          .fontSize(40)
        Text(`Kelvin ${this.kelvin.toFixed(2)}`)
          .fontSize(40)
      }
      .width('100%')
        // [StartExclude Computing_Property_Resolution]
      }
      .backgroundColor('#f1f2f3')
      .title($r('app.string.computed_title_3'))
      // [EndExclude  Computing_Property_Resolution]
  }
}
// [End Computing_Property_Resolution]