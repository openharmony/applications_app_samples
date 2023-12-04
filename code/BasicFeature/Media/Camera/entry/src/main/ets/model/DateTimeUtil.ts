/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @file Date tool
 */
export default class DateTimeUtil {
  /**
   * Hour, minute, second
   */
  getTime() {
    const DATETIME = new Date();
    return this.concatTime(DATETIME.getHours(), DATETIME.getMinutes(), DATETIME.getSeconds());
  }

  /**
   * Year, Month, Day
   */
  getDate() {
    const DATETIME = new Date();
    return this.concatDate(DATETIME.getFullYear(), DATETIME.getMonth() + 1, DATETIME.getDate());
  }

  /**
   * Add 0 if the date is less than two digits
   * @param value-data value
   */
  fill(value: number) {
    return (value > 9 ? '' : '0') + value;
  }

  /**
   * Recording time timer
   * @param millisecond-data value
   */
  getVideoTime(millisecond: number): string {
    let minute = Math.floor(millisecond / 60000);
    let second = Math.floor((millisecond - minute * 60000) / 1000);
    return `${this.fill(minute)} : ${this.fill(second)}`;
  }

  /**
   * Format modification of year, month, day
   * @param year
   * @param month
   * @param date
   */
  concatDate(year: number, month: number, date: number) {
    return `${year}${this.fill(month)}${this.fill(date)}`;
  }

  /**
   * Time minute second format modification
   * @param hours
   * @param minutes
   * @param seconds
   */
  concatTime(hours: number, minutes: number, seconds: number) {
    return `${this.fill(hours)}${this.fill(minutes)}${this.fill(seconds)}`;
  }
}