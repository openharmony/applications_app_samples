/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const NUMBER_10 = 10; // 数字10

export class TimeUtil {

  /**
   *
   * @param val 毫秒值
   */
  getTimeStr(val: number): string {
    if (!val || val <= 0) {
      return '--';
    }
    let date = new Date(val);
    if (date.getUTCHours() > 0) {
      return this.fixZeroStart(date.getUTCHours()) + ':' + this.fixZeroStart(date.getMinutes()) + ':' + this.fixZeroStart(date.getSeconds());
    } else {
      return this.fixZeroStart(date.getMinutes()) + ':' + this.fixZeroStart(date.getSeconds());
    }
  }

  fixZeroStart(str: number): string {
    if (str < NUMBER_10) {
      return '0' + str;
    }
    return '' + str;
  }
}

let mTimeUtil = new TimeUtil();

export default mTimeUtil as TimeUtil;
