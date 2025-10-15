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
import CalendarNapi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

enum ArkUICalendarAlignment {
  ARKUI_CALENDAR_ALIGNMENT_START = 0,
  ARKUI_CALENDAR_ALIGNMENT_CENTER = 1,
  ARKUI_CALENDAR_ALIGNMENT_END = 2,
}
@Entry
@Component
struct calendarPicker {
  @State calendarAlignment : number = ArkUICalendarAlignment.ARKUI_CALENDAR_ALIGNMENT_CENTER;
  private nodeContent: Content = new NodeContent();

  @Builder
  SubMenuCalendarType() {
    Menu() {
      MenuItem({ content: 'ARKUI_CALENDAR_ALIGNMENT_START' })
        .width('50%')
        .onChange(()=> {
          this.calendarAlignment = ArkUICalendarAlignment.ARKUI_CALENDAR_ALIGNMENT_START;
          CalendarNapi.createCalendarPicker(this.calendarAlignment);
        });
      MenuItem({ content: 'ARKUI_CALENDAR_ALIGNMENT_CENTER'})
        .width('50%')
        .onChange(()=> {
          this.calendarAlignment = ArkUICalendarAlignment.ARKUI_CALENDAR_ALIGNMENT_CENTER;
          CalendarNapi.createCalendarPicker(this.calendarAlignment);
        });
      MenuItem({ content: 'ARKUI_CALENDAR_ALIGNMENT_END'})
        .width('50%')
        .onChange(()=> {
          this.calendarAlignment = ArkUICalendarAlignment.ARKUI_CALENDAR_ALIGNMENT_END;
          CalendarNapi.createCalendarPicker(this.calendarAlignment);
        })
    }
  }

  build() {
    Row() {
      Column() {
        Row() {
          Button($r('app.string.Set_alignment_mode'))
            .height(50)
            .width('50%')
            .bindMenu(this.SubMenuCalendarType)
        }
        .padding({bottom: 10})
        Column() {
          ContentSlot(this.nodeContent)
        }
        .width('100%')
      }
    }
    .height('100%')
  }
  async aboutToAppear() {
    CalendarNapi.setContentHandle(this.nodeContent);
    CalendarNapi.createCalendarPicker(this.calendarAlignment);
  }
  async aboutToDisappear() {
    CalendarNapi.clearNodes();
  }
}
