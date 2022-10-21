/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

// 预测 气象列表
class Forecast {
  constructor(public degree: string, public date: string, public desc: string, public icon: Resource | string, public win: string, public winSpeed: string) {
    this.degree = degree
    this.date = date
    this.desc = desc
    this.icon = icon
    this.win = win
    this.winSpeed = winSpeed
  }
}

// 一周天气
class WeekWeather {
  constructor(public date: string, public week: string, public icon: Resource | string, public weather: string, public airLevel: string, public max: string, public min: string) {
    this.date = date
    this.week = week
    this.icon = icon
    this.weather = weather
    this.airLevel = airLevel
    this.max = max
    this.min = min
  }
}


export { Forecast, WeekWeather }