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

// [Start Decorative_Date]
@Entry
@ComponentV2
export struct DecorativeDate {
  @Provider() SelectedDate: Date = new Date('2021-08-08');

  build() {
    Column() {
      Text(`parent: ${this.SelectedDate}`)
      Button('update the new date')
        .onClick(() => {
          this.SelectedDate = new Date('2023-07-07');
        })
      Button('increase the year by 1')
        .onClick(() => {
          this.SelectedDate.setFullYear(this.SelectedDate.getFullYear() + 1);
        })
      Button('increase the month by 1')
        .onClick(() => {
          this.SelectedDate.setMonth(this.SelectedDate.getMonth() + 1);
        })
      Button('increase the day by 1')
        .onClick(() => {
          this.SelectedDate.setDate(this.SelectedDate.getDate() + 1);
        })
      Child()
    }
  }
}
@ComponentV2
struct Child {
  @Consumer() SelectedDate: Date = new Date('2022-07-07');

  build() {
    Column() {
      Text(`child: ${this.SelectedDate}`)
      Button('update the new date')
        .onClick(() => {
          this.SelectedDate = new Date('2025-01-01');
        })
      Button('increase the year by 1')
        .onClick(() => {
          this.SelectedDate.setFullYear(this.SelectedDate.getFullYear() + 1);
        })
      Button('increase the month by 1')
        .onClick(() => {
          this.SelectedDate.setMonth(this.SelectedDate.getMonth() + 1);
        })
      Button('increase the day by 1')
        .onClick(() => {
          this.SelectedDate.setDate(this.SelectedDate.getDate() + 1);
        })
    }
  }
}
// [End Decorative_Date]