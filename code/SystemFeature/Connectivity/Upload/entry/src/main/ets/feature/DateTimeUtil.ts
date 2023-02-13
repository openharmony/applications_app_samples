/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

export default class DateTimeUtil {
  /**
   * 获取时间
   */
  getTime(): string {
    const DATE_TIME = new Date()
    return this.concatTime(DATE_TIME.getHours(), DATE_TIME.getMinutes(), DATE_TIME.getSeconds())
  }

  /**
   * 获取日期
   */
  getDate(): string {
    const DATE_TIME = new Date()
    return this.concatDate(DATE_TIME.getFullYear(), DATE_TIME.getMonth() + 1, DATE_TIME.getDate())
  }

  /**
   * 日期不足两位补充0
   */
  fill(value: number): string {
    return (value > 9 ? '' : '0') + value
  }

  /**
   * 年月日格式
   */
  concatDate(year: number, month: number, date: number): string {
    return `${year}${this.fill(month)}${this.fill(date)}`
  }

  /**
   * 时分秒格式
   */
  concatTime(hours: number, minutes: number, seconds: number): string {
    return `${this.fill(hours)}${this.fill(minutes)}${this.fill(seconds)}`
  }
}