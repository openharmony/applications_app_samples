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

/**
 * 时间处理工具类
 */
export class TimeUtils {
  // 毫秒转换为“HH:mm:ss”字符串格式
  static msToHHMMSS(timeMs: number): string {
    const MS_ONE_SECOND: number = 1000;
    const SECONDS_ONE_HOUR: number = 3600;
    const SECONDS_ONE_MIN: number = 60;
    const FLAG_NUMBER: number = 10; // 显示两位数判断

    let hours = Math.floor(timeMs / (SECONDS_ONE_HOUR * MS_ONE_SECOND));
    let hourStr = hours + ':';
    if (hours < FLAG_NUMBER) { // 10 显示两位数
      hourStr = '0' + hourStr;
    }
    let minSecTime = timeMs % (SECONDS_ONE_HOUR * MS_ONE_SECOND);
    let minutes = Math.floor(minSecTime / (SECONDS_ONE_MIN * MS_ONE_SECOND));
    let minStr = minutes + ':';
    if (minutes < FLAG_NUMBER) { // 10 显示两位数
      minStr = '0' + minStr;
    }
    let seconds = timeMs % (SECONDS_ONE_MIN * MS_ONE_SECOND);
    seconds = Math.round(seconds); // 乘以1000 然后round
    seconds = Math.floor(seconds / MS_ONE_SECOND); // 最后除以1000 再次floor 精确度到小数点后3位
    let secStr = seconds + '';
    if (seconds < FLAG_NUMBER) {
      secStr = '0' + secStr;
    }
    return hourStr + minStr + secStr;
  }

  /**
   * 格式化日期
   * @param date 日期
   * @param format 格式字符串，例如：'yyyy-MM-dd HH:mm:ss'
   * @returns 格式化后的字符串
   */
  static format(date: Date, format: string = 'yyyy_MM_dd_HHmmss'): string {
    const MAX_LENGTH: number = 2;
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

  static fillNum(num: number): string {
    if (num < 10) {
      return `0${num}`;
    }
    return num.toString();
  }

  // 视频时长转换
  static getTimeString(time: number): string {
    if (time === -1 || time === undefined) {
      time = 0;
    }
    const TIMESTAMP: number = 1000;
    const TIME_UNIT: number = 60;
    const MAX_HOURS: number = 24;
    let hour = Math.floor(time % (TIMESTAMP * TIME_UNIT * TIME_UNIT * MAX_HOURS) / (TIMESTAMP * TIME_UNIT * TIME_UNIT));
    let minute = Math.floor(time % (TIMESTAMP * TIME_UNIT * TIME_UNIT) / (TIMESTAMP * TIME_UNIT));
    let second = Math.floor(time % (TIMESTAMP * TIME_UNIT) / TIMESTAMP);
    if (hour > 0) {
      return `${TimeUtils.fillNum(hour)}:${TimeUtils.fillNum(minute)}:${TimeUtils.fillNum(second)}`;
    }
    return `${TimeUtils.fillNum(minute)}:${TimeUtils.fillNum(second)}`;
  }

  // 获取当前时间
  static getCurrentTime(): string {
    const now = new Date();
    const currentYear: number = now.getFullYear();
    let currentMonth: number = now.getMonth() + 1;
    let currentDay: number = now.getDate();
    return `${currentYear}-${currentMonth}-${currentDay}`;
  }
}
