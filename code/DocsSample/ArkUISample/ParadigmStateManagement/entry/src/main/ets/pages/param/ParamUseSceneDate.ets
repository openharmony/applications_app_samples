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

@Component
export struct ParamUseSceneDate {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.param_use_scene_date'))
  }
}

// [Start Param_Use_Scene_Date]
@ComponentV2
struct DateComponent {
  @Param selectedDate: Date = new Date('2024-01-01');

  build() {
    Column() {
      DatePicker({
        start: new Date('1970-1-1'),
        end: new Date('2100-1-1'),
        selected: this.selectedDate
      })
    }
  }
}

@Entry
@ComponentV2
struct Index {
  @Local parentSelectedDate: Date = new Date('2021-08-08');

  build() {
    Column() {
      Button('parent update the new date')
        .margin(10)
        .onClick(() => {
          this.parentSelectedDate = new Date('2023-07-07');
        })
      Button('increase the year by 1')
        .margin(10)
        .onClick(() => {
          this.parentSelectedDate.setFullYear(this.parentSelectedDate.getFullYear() + 1);
        })
      Button('increase the month by 1')
        .margin(10)
        .onClick(() => {
          this.parentSelectedDate.setMonth(this.parentSelectedDate.getMonth() + 1);
        })
      Button('parent increase the day by 1')
        .margin(10)
        .onClick(() => {
          this.parentSelectedDate.setDate(this.parentSelectedDate.getDate() + 1);
        })
      DateComponent({ selectedDate: this.parentSelectedDate })
    }
  }
}
// [End Param_Use_Scene_Date]