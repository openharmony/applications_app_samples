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

import { logger } from '../utils/Logger';

// 从下载链接获取文件名。这里以简单包含文件名的下载链接为例。
export function  getFileNameFromUrl(url: string): string {
  // 将URL字符串按照'/'字符进行分割,返回一个数组。
  const segments = url.split('/');
  // 使用pop方法从数组的末尾返回最后一个元素。
  return segments.pop() || '未知文件名';
}

/**
 * 格式化日期时间字符串
 *
 * @param value 待格式化的日期值，支持数字、字符串和Date类型，默认为当前时间戳
 * @param fmt 格式化字符串，默认为'YYYY-MM-DD HH:mm:ss'
 * @returns 返回格式化后的日期时间字符串
 */
export  function formatTime (value: number | string | Date = Date.now(), fmt: string = 'YYYY-MM-DD HH:mm:ss'): string {
  try {
    let data: Date;

    if(typeof value === 'number' || typeof value === 'string') {
      data = new Date(value);
      if(isNaN(data.getTime())) {
        throw new Error('Invalid date');
      }
    } else {
      data = value;
    }

    // 左侧补零函数
    const padZero = (value: number, len: number = 2): string => {
      return String(value).padStart(len, '0');
    }

    const replacement = (match: string) => {
      switch (match) {
        case 'YYYY':
          return padZero(data.getFullYear());

        case 'YY':
          return padZero(data.getFullYear()).slice(2, 4);

        case 'MM':
          return padZero(data.getMonth() + 1);

        case 'M':
          return String(data.getMonth() + 1);

        case 'DD':
          return padZero(data.getDate());

        case 'D':
          return String(data.getDate());

        case 'HH':
          return padZero(data.getHours());

        case 'H':
          return String(data.getHours());

        case 'mm':
          return padZero(data.getMinutes());

        case 'm':
          return String(data.getMinutes());

        case 'ss':
          return padZero(data.getSeconds());

        case 's':
          return String(data.getSeconds());

        default:
          return match;
      }
    }

    return fmt.replace(/(YYYY|YY|M{1,2}|D{1,2}|H{1,2}|m{1,2}|s{1,2})/g, replacement);

  } catch (error) {
    logger.error('Error formatting date:', error);
    return '';
  }
}
