/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { TabType } from '../common/DataSource'

export const tabArray: Array<TabType> = [
  {
    icon: $r('app.media.worldclock'),
    icon_after: $r('app.media.worldclock_blue'),
    text: $r('app.string.tab0'),
    num: 0
  },
  {
    icon: $r('app.media.clock'),
    icon_after: $r('app.media.clock_blue'),
    text: $r('app.string.tab1'),
    num: 1
  },
  {
    icon: $r('app.media.timer'),
    icon_after: $r('app.media.timer_blue'),
    text: $r('app.string.tab2'),
    num: 2
  },
  {
    icon: $r('app.media.settings'),
    icon_after: $r('app.media.settings_blue'),
    text: $r('app.string.tab3'),
    num: 3
  }
]