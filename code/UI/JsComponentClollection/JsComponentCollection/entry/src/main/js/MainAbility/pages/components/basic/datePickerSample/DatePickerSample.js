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

export default {
  data() {
    return {
      datePickerTitle: '',
      dateValue: '2022-10-22',
      dateSelected: '2022-10-22'
    }
  },

  onInit() {
    this.datePickerTitle = this.$t('strings.date_picker_title')
  },

  changeDate(dateObj) {
    if (dateObj) {
      var month = `${Number(dateObj.month + 1)}`
      var day = `${Number(dateObj.day)}`
      if (Number(dateObj.month) < 9) {
        month = `0${Number(dateObj.month) + 1}`
      }
      if (Number(dateObj.day) < 10) {
        day = `0${Number(dateObj.day)}`
      }
      if (dateObj.month)
      this.dateValue = dateObj.year + "-" + month + "-" + day
    }
  },
}