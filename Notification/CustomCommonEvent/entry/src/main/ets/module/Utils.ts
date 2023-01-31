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

export default class utils {
  static getLocaleTime(n: number): string {
    return new Date(n).toLocaleString().replace(/:\d{1,2}$/, ' ')
  }

  static convertTimeToFormatString(n: number): string {
    let totalTimeInSec = Math.floor(n / 1000)
    let hour: number = Math.floor(totalTimeInSec / 3600)
    let min: number = Math.floor((totalTimeInSec % 3600) / 60)
    let sec: number = (totalTimeInSec % 3600) % 60
    let hourString: string = hour < 10 ? '0' + hour.toString() : hour.toString()
    let minString: string = min < 10 ? '0' + min.toString() : min.toString()
    let secString: string = sec < 10 ? '0' + sec.toString() : sec.toString()
    return hourString + ":" + minString + ":" + secString
  }
}