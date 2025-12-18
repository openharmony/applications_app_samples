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
import resource from '../../common/resource';
import { Route } from '../../common/Route';
import { openCustomDialog } from './openCustomDialog';
import { CustomDialogComponentWithTransition } from './customDialogComponentWithTransition';
import { CustomDialogWithKeyboardAvoidDistance } from './customDialogWithKeyboardAvoidDistance';
import { OpenDialogAndUpdate } from './OpenDialogAndUpdate';

export const CustomDialog_ROUTE_PREFIX: string = 'CustomDialog_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${CustomDialog_ROUTE_PREFIX}/Customdialog`,
    // 请将$r('app.string.Customdialog_title')替换为实际资源文件，在本示例中该资源文件的value值为"不依赖UI组件的全局自定义弹出框"
    title: resource.resourceToString($r('app.string.Customdialog_title')),
    // 请将$r('app.string.Customdialog_des')替换为实际资源文件，在本示例中该资源文件的value值为"由于CustomDialogController在使用上存在诸多限制，不支持动态创建也不支持动态刷新，在相对较复杂的应用场景中推荐使用UIContext中获取到的PromptAction对象提供的openCustomDialog接口来实现自定义弹出框。"
    description: $r('app.string.Customdialog_des'),
  },
  {
    name: `${CustomDialog_ROUTE_PREFIX}/CustomDialogComponentWithTransition`,
    // 请将$r('app.string.CustomDialogComponentWithTransition_title')替换为实际资源文件，在本示例中该资源文件的value值为"为弹出框内容和蒙层设置不同的动画效果"
    title: resource.resourceToString($r('app.string.CustomDialogComponentWithTransition_title')),
    // 请将$r('app.string.CustomDialogComponentWithTransition_desc')替换为实际资源文件，在本示例中该资源文件的value值为"当弹出框出现时，内容与蒙层显示动效一致。若开发者希望为弹出框内容及蒙层设定不同动画效果，从API version 19开始，可通过BaseDialogOptions中dialogTransition和maskTransition属性单独配置弹窗内容与蒙层的动画。具体的动画效果请参考组件内转场 (transition)。"
    description: $r('app.string.CustomDialogComponentWithTransition_desc'),
  },
  {
    name: `${CustomDialog_ROUTE_PREFIX}/CustomDialogWithKeyboardAvoidDistance`,
    // 请将$r('app.string.CustomDialogWithKeyboardAvoidDistance_title')替换为实际资源文件，在本示例中该资源文件的value值为"设置弹出框避让软键盘的距离"
    title: resource.resourceToString($r('app.string.CustomDialogWithKeyboardAvoidDistance_title')),
    // 请将$r('app.string.CustomDialogWithKeyboardAvoidDistance_desc')替换为实际资源文件，在本示例中该资源文件的value值为"为显示弹出框的独立性，弹出框弹出时会与周边进行避让，包括状态栏、导航条以及键盘等留有间距。故当软键盘弹出时，默认情况下，弹出框会自动避开软键盘，并与之保持16vp的距离。从API version 15开始，开发者可以利用BaseDialogOptions中的keyboardAvoidMode和keyboardAvoidDistance这两个配置项，来设置弹出框在软键盘弹出时的行为，包括是否需要避开软键盘以及与软键盘之间的距离。"
    description: $r('app.string.CustomDialogWithKeyboardAvoidDistance_desc'),
  },
  {
    name: `${CustomDialog_ROUTE_PREFIX}/OpenDialogAndUpdate`,
    // 请将$r('app.string.OpenDialogAndUpdate_title')替换为实际资源文件，在本示例中该资源文件的value值为"完整示例"
    title: resource.resourceToString($r('app.string.OpenDialogAndUpdate_title')),
    // 请将$r('app.string.OpenDialogAndUpdate_desc')替换为实际资源文件，在本示例中该资源文件的value值为"完整示例。"
    description: $r('app.string.OpenDialogAndUpdate_desc'),
  }
]

@Builder
export function CustomDialogDestination(name: string) {
  if (name === CustomDialog_ROUTE_PREFIX) {
    CustomDialogExample();
  } else if (name === routes[0].name) {
    openCustomDialog();
  } else if (name === routes[1].name) {
    CustomDialogComponentWithTransition();
  } else if (name === routes[2].name) {
    CustomDialogWithKeyboardAvoidDistance();
  } else if (name === routes[3].name) {
    OpenDialogAndUpdate();
  }
}

@Entry
@Component
struct CustomDialogExample {
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
            this.pathStack.pushPath({ name: route.name })
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
    .title('CustomDialog')
  }
}