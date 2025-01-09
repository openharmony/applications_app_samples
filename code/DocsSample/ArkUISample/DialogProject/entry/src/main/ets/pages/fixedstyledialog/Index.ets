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

import { CompletedRoutableCard } from '../../common/Card';
import { Route } from '../../common/Route';
import { showActionSheetExample } from './ActionSheet';
import { CalendarDialog } from './CalendarPickerDialog';
import { DatePickerDialogExample } from './DatePickerDialog';
import { TextPickerDialogExample } from './TextPickerDialog';
import { TimePickerDialogExample } from './TimePickerDialog';
import { showAlertDialogExample } from './AlertDialog';
import resource from '../../common/resource';


export const Fixed_ROUTE_PREFIX: string = 'Fixed_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${Fixed_ROUTE_PREFIX}/CalendarPickerDialog`,
    title: resource.resourceToString($r('app.string.CalendarPickerDialog_title')),
    description: $r('app.string.CalendarPickerDialog_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/DatePickerDialogExample`,
    title: resource.resourceToString($r('app.string.DatePicker_title')),
    description: $r('app.string.DatePicker_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/TimePickerDialog`,
    title: resource.resourceToString($r('app.string.TimePicker_title')),
    description: $r('app.string.TimePicker_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/TextPickerDialog`,
    title: resource.resourceToString($r('app.string.TextPicker_title')),
    description: $r('app.string.TextPicker_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/ActionSheet`,
    title: resource.resourceToString($r('app.string.ActionSheet_title')),
    description:  $r('app.string.ActionSheet_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/AlertDialog`,
    title: resource.resourceToString($r('app.string.AlertDialog_title')),
    description:  $r('app.string.AlertDialog_des'),
  }
]

@Builder
export function FixedDialogDestination(name: string) {
  if (name === Fixed_ROUTE_PREFIX) {
    FixedDialogExample();
  } else if (name === routes[0].name) {
    CalendarDialog();
  } else if (name === routes[1].name) {
    DatePickerDialogExample();
  } else if (name === routes[2].name) {
    TimePickerDialogExample();
  } else if (name === routes[3].name) {
    TextPickerDialogExample();
  } else if (name === routes[4].name) {
    showActionSheetExample();
  } else if (name === routes[5].name) {
    showAlertDialogExample();
  }
}

@Entry
@Component
struct FixedDialogExample {
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      List({ space: 12 }) {
        ForEach(routes, (route: Route) => {
          ListItem() {
            CompletedRoutableCard({ title: route.title, description: route.description })
          }
          .width('100%')
          .onClick(() => {
            this.pathStack.pushPath({ name: route.name });
          })
        })
      }
      .contentStartOffset(20)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor('#f1f3f5')
    .title('', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .title($r('app.string.fixed_dialog'))
  }
}