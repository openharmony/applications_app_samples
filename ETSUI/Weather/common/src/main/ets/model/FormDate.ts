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

// 时间格式 调整
export default class FormDate {
  // 月+日
  formMonthDay(goal?: string) {
    let date = goal ? new Date(goal) : new Date()
    return `${this.fill(date.getMonth() + 1)}/${date.getDate()}`
  }

  // 换算当前星期几
  formDay() {
    let day = new Date().getDay()
    if (day === 1) {
      return '星期一'
    } else if (day === 2) {
      return '星期二'
    } else if (day === 3) {
      return '星期三'
    } else if (day === 4) {
      return '星期四'
    } else if (day === 5) {
      return '星期五'
    } else if (day === 6) {
      return '星期六'
    } else if (day === 7) {
      return '星期日'
    }
  }

  // 格式化 当前分钟
  fill(num?: number) {
    return num > 9 ? '' : '0' + num
  }

  // 当前时间节点称谓
  formTimeSlot(hour?: number) {
    let now = hour ? hour : new Date().getHours()
    if (now >= 0 && now <= 8) {
      return '早上'
    } else if (now >= 9 && now < 11) {
      return '上午'
    } else if (now >= 11 && now <= 13) {
      return '中午'
    } else if (now >= 14 && now <= 16) {
      return '下午'
    } else if (now >= 17 && now <= 19) {
      return '傍晚'
    } else if (now >= 19 && now <= 23) {
      return '晚上'
    }
  }
}