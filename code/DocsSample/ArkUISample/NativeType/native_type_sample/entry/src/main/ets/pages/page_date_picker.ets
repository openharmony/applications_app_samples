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
import dateNapi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

enum DatePickerMode {
  ARKUI_DATEPICKER_MODE_DATE = 0,
  ARKUI_DATEPICKER_YEAR_AND_MONTH = 1,
  ARKUI_DATEPICKER_MONTH_AND_DAY = 2,
}
@Entry
@Component
struct datePicker {
  @State datepickerMode : number = DatePickerMode.ARKUI_DATEPICKER_MODE_DATE;
  private nodeContent: Content = new NodeContent();
  @Builder
  SubMenuModeType() {
    Menu() {
      MenuItem({ content: 'ARKUI_DATEPICKER_MODE_DATE' })
        .width('50%')
        .onChange(()=> {
          this.datepickerMode = DatePickerMode.ARKUI_DATEPICKER_MODE_DATE;
          dateNapi.createDatePicker(this.datepickerMode);
        })
      MenuItem({ content: 'ARKUI_DATEPICKER_YEAR_AND_MONTH'})
        .width('50%')
        .onChange(()=> {
          this.datepickerMode = DatePickerMode.ARKUI_DATEPICKER_YEAR_AND_MONTH;
          dateNapi.createDatePicker(this.datepickerMode);
        })
      MenuItem({ content: 'ARKUI_DATEPICKER_MONTH_AND_DAY'})
        .width('50%')
        .onChange(()=> {
          this.datepickerMode = DatePickerMode.ARKUI_DATEPICKER_MONTH_AND_DAY;
          dateNapi.createDatePicker(this.datepickerMode);
        })
      }
  }
  build() {
    Row() {
      Column() {
        Button($r('app.string.Select_datepicker_mode'))
          .height(50)
          .width('50%')
          .bindMenu(this.SubMenuModeType)
        Column() {
          ContentSlot(this.nodeContent)
        }
        .width('100%')
      }
    }
    .height('100%')
  }
  async aboutToAppear() {
    dateNapi.setContentHandle(this.nodeContent);
  }
  async aboutToDisappear() {
    dateNapi.clearNodes();
  }
}
