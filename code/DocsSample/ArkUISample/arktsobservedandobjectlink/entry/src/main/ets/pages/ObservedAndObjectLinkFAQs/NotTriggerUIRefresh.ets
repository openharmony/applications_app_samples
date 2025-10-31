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
// [Start Not_Trigger_UI_Refresh_Proxy]
@Observed
class Weather {
  public temperature: number;

  constructor(temperature: number) {
    this.temperature = temperature;
  }

  static increaseTemperature(weather: Weather) {
    weather.temperature++;
  }
}

class Day {
  public weather: Weather;
  public week: string;

  constructor(weather: Weather, week: string) {
    this.weather = weather;
    this.week = week;
  }
}

@Entry
@Component
struct NotTriggerUIRefreshParent {
  @State day1: Day = new Day(new Weather(15), 'Monday');

  build() {
    Column({ space: 10 }) {
      Child({ weather: this.day1.weather })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct Child {
  @ObjectLink weather: Weather;

  reduceTemperature(weather: Weather) {
    weather.temperature--;
  }

  build() {
    Column({ space: 10 }) {
      Text(`The temperature of day1 is ${this.weather.temperature} degrees.`)
        .fontSize(20)
      Button('increaseTemperature')
        .onClick(() => {
          // 通过赋值添加 Proxy 代理
          let weather1 = this.weather;
          Weather.increaseTemperature(weather1);
        })
      Button('reduceTemperature')
        .onClick(() => {
          // 通过赋值添加 Proxy 代理
          let weather2 = this.weather;
          this.reduceTemperature(weather2);
        })
    }
    .height('100%')
    .width('100%')
  }
}

// [End Not_Trigger_UI_Refresh_Proxy]