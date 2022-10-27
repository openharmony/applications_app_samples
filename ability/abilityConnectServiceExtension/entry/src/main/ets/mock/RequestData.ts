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

import { weather } from '../mock/WeatherData'
import { Forecast, WeekWeather } from '../model/Main'
import FormDate from '../model/FormDate'

// 动态切换天气
function getUpdateTemperature() {
  let temperature: number[] = [25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]
  return (temperature[Math.floor(Math.random() * temperature.length)])
}

// 获取天气类型对应的icon
function getTypeIcon(data: string) {
  switch (data) {
    case '晴':
      return $r('app.media.ic_weather_sunny')
      break;
    case '多云':
      return $r('app.media.ic_weather_cloudy')
      break;
    case '阴':
      return $r('app.media.ic_weather_yin')
      break;
    case '小雨':
      return $r('app.media.ic_weather_lightrain')
      break;
    case '雷阵雨':
      return $r('app.media.ic_weather_lightrain')
      break;
    case '日落':
      return $r('app.media.ic_weather_sunset')
      break;
    case '中雨':
      return $r('app.media.ic_weather_rain')
      break;
    case '大雨':
      return $r('app.media.ic_weather_rain')
      break;
    default:
      return $r('app.media.ic_weather_cloudy')
      break;
  }
}

// 获取逐小时天气情况
function getHoursData(cityIndex: number) {
  let hoursData = new Array<Forecast>()
  weather[cityIndex].data[1].hours.forEach(item => {
    let time = item.hours.substring(0, item.hours.length - 1)
    hoursData.push(new Forecast(`${item.tem}°`, `${time}:00`, new FormDate().formTimeSlot(parseInt(time)), getTypeIcon(item.wea), item.win, item.win_speed))
    if (item.hours.indexOf('17') !== -1) {
      hoursData.push(new Forecast('日落', '17:32', new FormDate().formTimeSlot(parseInt(time)), getTypeIcon('日落'), item.win, item.win_speed))
    }
  })
  return hoursData
}

// 获取一周天气情况 根据获取到的数据格式化成需要的样式
function getWeekWeatherData(cityIndex: number) {
  let weekData = new Array<WeekWeather>()
  weather[cityIndex].data.forEach(item => {
    weekData.push(new WeekWeather(new FormDate().formMonthDay(item.date), item.week, getTypeIcon(item.wea), item.wea, item.air_level, item.tem1, item.tem2))
  })
  return weekData
}

export { getUpdateTemperature, getHoursData, getWeekWeatherData }