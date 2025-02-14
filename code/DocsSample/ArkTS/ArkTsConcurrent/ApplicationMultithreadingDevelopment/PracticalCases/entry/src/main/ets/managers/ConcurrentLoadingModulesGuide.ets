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

import { Calculator } from '../sdk/Calculator';
import { TimerSdk } from '../sdk/TimerSdk';
import { taskpool } from '@kit.ArkTS';

@Concurrent
function initCalculator(): Calculator {
  return Calculator.init();
}

@Concurrent
function initTimerSdk(): TimerSdk {
  return TimerSdk.init();
}

@Entry
@Component
struct Index {
  @State calculateAdd: string = 'calculate add';
  @State showHistory: string = 'show history';
  @State countdown: string = 'countdown';
  calc?: Calculator;
  timer?: TimerSdk;

  aboutToAppear(): void {
    taskpool.execute(initCalculator).then((ret) => {
      this.calc = ret as Calculator;
    })
    taskpool.execute(initTimerSdk).then((ret) => {
      this.timer = ret as TimerSdk;
    })
  }

  build() {
    Row() {
      Column() {
        Text(this.calculateAdd)
          .id('add')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(async () => {
            let result = this.calc?.add(1, 2)
            console.info(`Result is ${result}`)
            this.calculateAdd = 'success';
          })
        Text(this.showHistory)
          .id('show')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(async () => {
            this.calc?.showHistory();
            this.showHistory = 'success';
          })
        Text(this.countdown)
          .id('get')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(async () => {
            console.info(`Timer start`);
            await this.timer?.Countdown(1000);
            console.info(`Timer end`);
            this.countdown = 'success';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}