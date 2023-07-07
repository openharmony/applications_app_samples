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

const MAX_LENGTH: number = 2;

export default class DateUtils {
  /**
   * 格式化日期
   * @param date 日期
   * @param format 格式字符串，例如：'yyyy-MM-dd HH:mm:ss'
   * @returns 格式化后的字符串
   */
  public static format(date: Date, format: string = 'yyyy-MM-dd HH:mm:ss'): string {
    let year = date.getFullYear().toString();
    let month = (date.getMonth() + 1).toString().padStart(MAX_LENGTH, '0');
    let day = date.getDate().toString().padStart(MAX_LENGTH, '0');
    let hour = date.getHours().toString().padStart(MAX_LENGTH, '0');
    let minute = date.getMinutes().toString().padStart(MAX_LENGTH, '0');
    let second = date.getSeconds().toString().padStart(MAX_LENGTH, '0');
    let result = format.replace('yyyy', year);
    result = result.replace('MM', month);
    result = result.replace('dd', day);
    result = result.replace('HH', hour);
    result = result.replace('mm', minute);
    result = result.replace('ss', second);
    return result;
  }

  /**
   * 解析日期字符串
   * @param str 日期字符串
   * @returns 解析后的日期对象，如果解析失败则返回 null
   */
  public static parse(str: string): Date | null {
    let match = str.match(/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})$/);
    if (!match) {
      return null;
    }
    let [, year, month, day, hour, minute, second] = match;
    return new Date(+year, +month - 1, +day, +hour, +minute, +second);
  }
}