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
import { DatePickerCustomDialogExample } from './DatePickerCustomDialog';
import { TextPickerDialogExample } from './TextPickerDialog';
import {TextPickerCNDialogExample} from './TextPickerCNDialog'
import { TimePickerDialogExample } from './TimePickerDialog';
import { showAlertDialogExample } from './AlertDialog';
import { ShowActionMenuExample } from './ShowActionMenu';
import { ShowDialogExample } from './ShowDialog';
import resource from '../../common/resource';


export const Fixed_ROUTE_PREFIX: string = 'Fixed_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${Fixed_ROUTE_PREFIX}/CalendarPickerDialog`,
    // 请将$r('app.string.CalendarPickerDialog_title')替换为实际资源文件，在本示例中该资源文件的value值为"日历选择器弹窗"
    title: resource.resourceToString($r('app.string.CalendarPickerDialog_title')),
    // 请将$r('app.string.CalendarPickerDialog_des')替换为实际资源文件，在本示例中该资源文件的value值为"日历选择器弹窗提供日历视图，包含年、月和星期信息，通过CalendarPickerDialog接口实现。开发者可调用show函数，定义并弹出日历选择器弹窗。"
    description: $r('app.string.CalendarPickerDialog_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/DatePickerDialogExample`,
    // 请将$r('app.string.DatePicker_title')替换为实际资源文件，在本示例中该资源文件的value值为"日期滑动选择器弹窗"
    title: resource.resourceToString($r('app.string.DatePicker_title')),
    // 请将$r('app.string.DatePicker_des')替换为实际资源文件，在本示例中该资源文件的value值为"开发者可以利用指定的日期范围，创建日期滑动选择器弹窗，将日期信息清晰地展示在弹出的窗口上。"
    description: $r('app.string.DatePicker_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/DatePickerCustomDialogExample`,
    // 请将$r('app.string.DatePickerCustom_title')替换为实际资源文件，在本示例中该资源文件的value值为"日期滑动选择器自定义弹窗"
    title: resource.resourceToString($r('app.string.DatePickerCustom_title')),
    // 请将$r('app.string.DatePickerCustom_des')替换为实际资源文件，在本示例中该资源文件的value值为"开发者可以利用指定的日期范围，创建日期滑动选择器自定义弹窗，将日期信息清晰地展示在弹出的窗口上。"
    description: $r('app.string.DatePickerCustom_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/TimePickerDialog`,
    // 请将$r('app.string.TimePicker_title')替换为实际资源文件，在本示例中该资源文件的value值为"时间滑动选择器弹窗"
    title: resource.resourceToString($r('app.string.TimePicker_title')),
    // 请将$r('app.string.TimePicker_des')替换为实际资源文件，在本示例中该资源文件的value值为"开发者可根据24小时的时间区间，创建时间滑动选择器弹窗，将时间信息清晰地展示在弹出的窗口上。"
    description: $r('app.string.TimePicker_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/TextPickerDialog`,
    // 请将$r('app.string.TextPicker_title')替换为实际资源文件，在本示例中该资源文件的value值为"文本滑动选择器弹窗"
    title: resource.resourceToString($r('app.string.TextPicker_title')),
    // 请将$r('app.string.TextPicker_des')替换为实际资源文件，在本示例中该资源文件的value值为"开发者可根据指定的选择范围，创建文本滑动选择器弹窗，将文本信息清晰地展示在弹出的窗口上。"
    description: $r('app.string.TextPicker_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/TextPickerCNDialog`,
    // 请将$r('app.string.TextPicker_cn_title')替换为实际资源文件，在本示例中该资源文件的value值为"文本滑动选择器中文弹窗"
    title: resource.resourceToString($r('app.string.TextPicker_cn_title')),
    // 请将$r('app.string.TextPicker_cn_des')替换为实际资源文件，在本示例中该资源文件的value值为"开发者可根据指定的选择范围，创建文本滑动选择器弹窗，将文本信息清晰地展示在弹出的窗口上。"
    description: $r('app.string.TextPicker_cn_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/ActionSheet`,
    // 请将$r('app.string.ActionSheet_title')替换为实际资源文件，在本示例中该资源文件的value值为"列表选择弹窗"
    title: resource.resourceToString($r('app.string.ActionSheet_title')),
    // 请将$r('app.string.ActionSheet_des')替换为实际资源文件，在本示例中该资源文件的value值为"列表选择器弹窗适用于呈现多个操作选项，尤其当界面中仅需展示操作列表而无其他内容时。"
    description:  $r('app.string.ActionSheet_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/AlertDialog`,
    // 请将$r('app.string.AlertDialog_title')替换为实际资源文件，在本示例中该资源文件的value值为"警告弹窗"
    title: resource.resourceToString($r('app.string.AlertDialog_title')),
    // 请将$r('app.string.AlertDialog_des')替换为实际资源文件，在本示例中该资源文件的value值为"需要向用户提问或得到用户的许可时，可使用警告弹窗。"
    description:  $r('app.string.AlertDialog_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/ShowActionMenu`,
    // 请将$r('app.string.ShowActionMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"操作菜单"
    title: resource.resourceToString($r('app.string.ShowActionMenu_title')),
    // 请将$r('app.string.ShowActionMenu_des')替换为实际资源文件，在本示例中该资源文件的value值为"操作菜单通过UIContext中的getPromptAction方法获取到PromptAction对象，再通过该对象调用showActionMenu接口实现，支持在回调或开发者自定义类中使用。"
    description: $r('app.string.ShowActionMenu_des'),
  },
  {
    name: `${Fixed_ROUTE_PREFIX}/ShowDialog`,
    // 请将$r('app.string.ShowDialog_title')替换为实际资源文件，在本示例中该资源文件的value值为"对话框"
    title: resource.resourceToString($r('app.string.ShowDialog_title')),
    // 请将$r('app.string.ShowDialog_des')替换为实际资源文件，在本示例中该资源文件的value值为"对话框通过UIContext中的getPromptAction方法获取到PromptAction对象，再通过该对象调用showDialog接口实现，支持在回调或开发者自定义类中使用。"
    description: $r('app.string.ShowDialog_des'),
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
    DatePickerCustomDialogExample();
  } else if (name === routes[3].name) {
    TimePickerDialogExample();
  } else if (name === routes[4].name) {
    TextPickerDialogExample();
  } else if (name === routes[5].name) {
    TextPickerCNDialogExample();
  } else if (name === routes[6].name) {
    showActionSheetExample();
  } else if (name === routes[7].name) {
    showAlertDialogExample();
  } else if (name === routes[8].name) {
    ShowActionMenuExample();
  } else if (name === routes[9].name) {
    ShowDialogExample();
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
    // 请将$r('app.string.fixed_dialog')替换为实际资源文件，在本示例中该资源文件的value值为"固定样式弹出框"
    .title($r('app.string.fixed_dialog'))
  }
}