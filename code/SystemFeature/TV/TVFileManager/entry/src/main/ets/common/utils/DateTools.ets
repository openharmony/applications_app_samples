/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 * 时间工具类
 */
interface DateFormatDict {
  yyyy: number;
  M: number;
  d: number;
  H: number;
  m: number;
  s: number;
  MM: string;
  dd: string;
  HH: string;
  mm: string;
  ss: string;
}

export class DateTools {

  /**
   * 格式化时间
   * 调用formatDate(strDate, 'yyyy-MM-dd');
   * @param strDate（中国标准时间、时间戳等）
   * @param strFormat（返回格式）
   */
  private static getDictValue(dict: DateFormatDict, key: string): number | string {
    switch (key) {
      case 'yyyy':
        return dict.yyyy;
      case 'M':
        return dict.M;
      case 'd':
        return dict.d;
      case 'H':
        return dict.H;
      case 'm':
        return dict.m;
      case 's':
        return dict.s;
      case 'MM':
        return dict.MM;
      case 'dd':
        return dict.dd;
      case 'HH':
        return dict.HH;
      case 'mm':
        return dict.mm;
      case 'ss':
        return dict.ss;
      default:
        return '';
    }
  }

  public static formatDate(strDate: Date | string | number, strFormat?: string): string {
    if (!strDate) {
      return '';
    }
    if (!strFormat) {
      strFormat = 'yyyy-MM-dd';
    }
    switch (typeof strDate) {
      case 'string':
        strDate = new Date(strDate.replace(/-/, '/'));
        break;
      case 'number':
        if (strDate < 9999999999) {
          strDate *= 1000;
        }
        strDate = new Date(strDate);
        break;
    }
    // 北京时间 东八区 8*60*60*1000
    strDate = new Date(strDate.getTime() + 28800000);
    if (strDate instanceof Date) {
      const dict: DateFormatDict = {
        yyyy: strDate.getFullYear(),
        M: strDate.getMonth() + 1,
        d: strDate.getDate(),
        H: strDate.getHours(),
        m: strDate.getMinutes(),
        s: strDate.getSeconds(),
        MM: ('' + (strDate.getMonth() + 101)).substr(1),
        dd: ('' + (strDate.getDate() + 100)).substr(1),
        HH: ('' + (strDate.getHours() + 100)).substr(1),
        mm: ('' + (strDate.getMinutes() + 100)).substr(1),
        ss: ('' + (strDate.getSeconds() + 100)).substr(1),
      };
      return strFormat.replace(/(yyyy|MM?|dd?|HH?|mm?|ss?)/g, (match: string): string => {
        return String(DateTools.getDictValue(dict, match));
      });
    }
    return '';
  }
}
