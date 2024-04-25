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

const IP_RIGHT_SHIFT_0 = 0;
const IP_RIGHT_SHIFT_8 = 8;
const IP_RIGHT_SHIFT_16 = 16;
const IP_RIGHT_SHIFT_24 = 24;

export class IpUtils {
  getIpAddress(number: number): string {
    if (number <= 0) {
      return "";
    }
    let ip3 = (number << IP_RIGHT_SHIFT_0) >>> IP_RIGHT_SHIFT_24;
    let ip2 = (number << IP_RIGHT_SHIFT_8) >>> IP_RIGHT_SHIFT_24;
    let ip1 = (number << IP_RIGHT_SHIFT_16) >>> IP_RIGHT_SHIFT_24;
    let ip0 = (number << IP_RIGHT_SHIFT_24) >>> IP_RIGHT_SHIFT_24;
    let result: string = ip3 + '.' + ip2 + '.' + ip1 + '.' + ip0;
    return result;
  }
}

let mUtil = new IpUtils();

export default mUtil as IpUtils;
