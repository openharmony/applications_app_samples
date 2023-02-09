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

import Logger from './Logger'

const TAG: string = 'TimeConversion'
const HOUR_SECONDS: number = 3600
const DAY_SECONDS: number = 86400
const MINUTES_SECONDS: number = 60
const YEAR_SECONDS: number = 31536000
const MONTH_SECONDS: number = 2592000

class TimeConversion {
  // Converts the time units obtained in the time selection component to milliseconds
  timeToMillisecond(hour: number, minute: number) {
    let nowTime: Date = new Date
    let nowAllTime: number = nowTime.getHours() * HOUR_SECONDS + nowTime.getMinutes() *
    MINUTES_SECONDS + nowTime.getSeconds()
    let selectAllTime: number = (hour * HOUR_SECONDS + minute * MINUTES_SECONDS)
    let delayTime: number = selectAllTime - nowAllTime >= 0 ? selectAllTime - nowAllTime :
      DAY_SECONDS - (nowAllTime - selectAllTime)
    Logger.info(TAG, `this vibratorTime is ${delayTime}`)
    return (delayTime - 2)
  }

  // Converts the time units obtained in the date selection component to milliseconds
  dateToMillisecond(year: number, month: number, day: number, hour: number, minute: number) {
    let nowTime: Date = new Date
    let nowAllTime: number = nowTime.getFullYear() * YEAR_SECONDS + nowTime.getMonth() * MONTH_SECONDS +
    nowTime.getDay() * DAY_SECONDS + nowTime.getHours() * HOUR_SECONDS + nowTime.getMinutes() * MINUTES_SECONDS +
    nowTime.getSeconds()
    let selectAllTime: number = year * YEAR_SECONDS + month * MONTH_SECONDS + day * DAY_SECONDS + hour * HOUR_SECONDS +
    minute * MINUTES_SECONDS
    let delayTime: number = selectAllTime - nowAllTime
    Logger.info(TAG, `this vibratorTime is ${delayTime}`)
    return delayTime
  }
}

export default new TimeConversion()