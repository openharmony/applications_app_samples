/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { CustomCalendarSamplePage } from 'calendarswitch';

@Entry
@Component
struct Index {
  build() {
    Column() {
      /**
       * 功能描述：本示例主要介绍如何使用自定义日历组件CustomCalendar实现日历年视图，月视图，周视图以及视图切换功能。还有使用Calendar Kit日历服务实现日程提醒的功能。
       * 参数介绍：无
       */
      CustomCalendarSamplePage()
    }
    .height('100%')
    .width('100%')
  }
}