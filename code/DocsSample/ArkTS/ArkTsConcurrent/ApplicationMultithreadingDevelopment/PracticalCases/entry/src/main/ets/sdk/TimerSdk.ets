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

// [Start define_timer_module]
@Sendable
export class TimerSdk {
  static init(): TimerSdk {
    let timer = new TimerSdk();
    return timer;
  }

  async Countdown(time: number) {
    return new Promise((resolve: (value: boolean) => void) => {
      setTimeout(() => {
        resolve(true);
      }, time);
    });
  }
}
// [End define_timer_module]