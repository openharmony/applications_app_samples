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
import { CreateDialog } from './CreateCustomDialog';
import { DialogAnimation } from './DialogAnimation';
import { DialogInteraction } from './DialogInteraction';
import { DialogInteraction1 } from './DialogInteraction1';
import { DialogStyle } from './DialogStyle';
import { NestDialog } from './NestDialog';
import { CreateCustomDialogNew } from './CreateCustomDialogNew';
import { DialogInteractionUseConstructor } from './DialogInteractionUseConstructor';
import { DialogInteractionUseButton } from './DialogInteractionUseButton';
import { DialogAnimationNew } from './DialogAnimationNew';
import { DialogStyleNew } from './DialogStyleNew';
import { NestDialogNew } from './NestDialogNew';
import { DialogWithPhysicalBack } from './DialogWithPhysicalBack';
import { DialogAvoidSoftKeyboard } from './DialogAvoidSoftKeyboard';
import { GetDialogStatus } from './GetDialogStatus';
import { Index as DialogFocusStrategy } from './dialogboxfocuspolicy/DialogFocusStrategy';
import { DialogController } from './dialogcontroller/DialogController';
import { PageLevelDialogBox } from './pageleveldialogbox/PageLevelDialogBox';
import { DialogBoxLayer } from './dialogboxlayermanagement/DialogBoxLayer';

export const Custom_ROUTE_PREFIX: string = 'Custom_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${Custom_ROUTE_PREFIX}/dialog`,
    // 请将$r('app.string.CustomDialog_create_title')替换为实际资源文件，在本示例中该资源文件的value值为"创建自定义弹出框"
    title: resource.resourceToString($r('app.string.CustomDialog_create_title')),
    // 请将$r('app.string.CustomDialog_create_des')替换为实际资源文件，在本示例中该资源文件的value值为"使用@CustomDialog装饰器装饰自定义弹出框，可在此装饰器内自定义弹出框内容。CustomDialogController需在@Component内定义。"
    description: $r('app.string.CustomDialog_create_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/dialoginteraction`,
    // 请将$r('app.string.CustomDialog_interaction_title')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框的交互"
    title: resource.resourceToString($r('app.string.CustomDialog_interaction_title')),
    // 请将$r('app.string.CustomDialog_interaction_des')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框可用于数据交互，完成用户一系列响应操作。"
    description: $r('app.string.CustomDialog_interaction_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/dialoginteraction1`,
    // 请将$r('app.string.CustomDialog_interaction1_title')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框的交互页面跳转"
    title: resource.resourceToString($r('app.string.CustomDialog_interaction1_title')),
    // 请将$r('app.string.CustomDialog_interaction1_des')替换为实际资源文件，在本示例中该资源文件的value值为"可通过弹出框中的按钮实现路由跳转，同时获取跳转页面向当前页传入的参数。"
    description: $r('app.string.CustomDialog_interaction1_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogAnimation`,
    // 请将$r('app.string.CustomDialog_animation_title')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框的动画"
    title: resource.resourceToString($r('app.string.CustomDialog_animation_title')),
    // 请将$r('app.string.CustomDialog_animation_des')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框通过定义openAnimation控制弹出框出现动画的持续时间，速度等参数。"
    description: $r('app.string.CustomDialog_animation_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogStyle`,
    // 请将$r('app.string.CustomDialog_Style_title')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框的样式"
    title: resource.resourceToString($r('app.string.CustomDialog_Style_title')),
    // 请将$r('app.string.CustomDialog_Style_des')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框通过定义宽度、高度、背景色、阴影等参数来控制样式。"
    description: $r('app.string.CustomDialog_Style_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/NestDialog`,
    // 请将$r('app.string.CustomDialog_nest')替换为实际资源文件，在本示例中该资源文件的value值为"嵌套自定义弹出框"
    title: resource.resourceToString($r('app.string.CustomDialog_nest')),
    // 请将$r('app.string.CustomDialog_create_title')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框通过定义宽度、高度、背景色、阴影等参数来控制样式。"
    description: $r('app.string.CustomDialog_nest_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/CreateCustomDialogNew`,
    // 请将$r('app.string.CreateCustomDialogNew_title')替换为实际资源文件，在本示例中该资源文件的value值为"创建自定义弹出框新页面"
    title: resource.resourceToString($r('app.string.CreateCustomDialogNew_title')),
    // 请将$r('app.string.CreateCustomDialogNew_desc')替换为实际资源文件，在本示例中该资源文件的value值为"使用@CustomDialog装饰器装饰自定义弹出框，可在此装饰器内自定义弹出框内容。CustomDialogController需在@Component内定义。"
    description: $r('app.string.CreateCustomDialogNew_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogInteractionUseConstructor`,
    // 请将$r('app.string.DialogInteractionUseConstructor_title')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框的交互使用构造器"
    title: resource.resourceToString($r('app.string.DialogInteractionUseConstructor_title')),
    // 请将$r('app.string.DialogInteractionUseConstructor_desc')替换为实际资源文件，在本示例中该资源文件的value值为"页面内需要在构造器内进行接收，同时创建相应的函数操作。"
    description: $r('app.string.DialogInteractionUseConstructor_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogInteractionUseButton`,
    // 请将$r('app.string.DialogInteractionUseButton_title')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框的交互使用button"
    title: resource.resourceToString($r('app.string.DialogInteractionUseButton_title')),
    // 请将$r('app.string.DialogInteractionUseButton_desc')替换为实际资源文件，在本示例中该资源文件的value值为"可通过弹出框中的按钮实现路由跳转，同时获取跳转页面向当前页传入的参数。"
    description: $r('app.string.DialogInteractionUseButton_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogAnimationNew`,
    // 请将$r('app.string.DialogAnimationNew_title')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框的动画新页面"
    title: resource.resourceToString($r('app.string.DialogAnimationNew_title')),
    // 请将$r('app.string.DialogAnimationNew_desc')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框通过定义openAnimation控制弹出框出现动画的持续时间，速度等参数。"
    description: $r('app.string.DialogAnimationNew_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogStyleNew`,
    // 请将$r('app.string.DialogStyleNew_title')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框的样式新页面"
    title: resource.resourceToString($r('app.string.DialogStyleNew_title')),
    // 请将$r('app.string.DialogStyleNew_desc')替换为实际资源文件，在本示例中该资源文件的value值为"通过定义弹出框的宽度、高度、背景色、阴影等参数，控制其样式。"
    description: $r('app.string.DialogStyleNew_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/NestDialogNew`,
    // 请将$r('app.string.NestDialogNew_title')替换为实际资源文件，在本示例中该资源文件的value值为"嵌套自定义弹出框新页面"
    title: resource.resourceToString($r('app.string.NestDialogNew_title')),
    // 请将$r('app.string.NestDialogNew_desc')替换为实际资源文件，在本示例中该资源文件的value值为"通过第一个弹出框打开第二个弹出框时，最好将第二个弹出框定义在第一个弹出框的父组件处，通过父组件传给第一个弹出框的回调来打开第二个弹出框。"
    description: $r('app.string.NestDialogNew_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogWithPhysicalBack`,
    // 请将$r('app.string.DialogWithPhysicalBack_title')替换为实际资源文件，在本示例中该资源文件的value值为"实现弹出框的物理返回拦截"
    title: resource.resourceToString($r('app.string.DialogWithPhysicalBack_title')),
    // 请将$r('app.string.DialogWithPhysicalBack_desc')替换为实际资源文件，在本示例中该资源文件的value值为"执行点击遮障层关闭、侧滑（左滑或右滑）、三键Back、键盘ESC关闭等交互操作时，如果注册了CustomDialogControllerOptions中的onWillDismiss回调函数，弹出框不会立即关闭。在回调函数中，通过DismissDialogAction中的reason属性获取阻拦关闭弹出框的操作类型，根据原因决定是否关闭弹出框。"
    description: $r('app.string.DialogWithPhysicalBack_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogAvoidSoftKeyboard`,
    // 请将$r('app.string.DialogAvoidSoftKeyboard_title')替换为实际资源文件，在本示例中该资源文件的value值为"设置弹出框避让软键盘的距离"
    title: resource.resourceToString($r('app.string.DialogAvoidSoftKeyboard_title')),
    // 请将$r('app.string.DialogAvoidSoftKeyboard_desc')替换为实际资源文件，在本示例中该资源文件的value值为"为显示弹出框的独立性，弹出框弹出时会与周边进行避让，包括状态栏、导航条以及键盘等留有间距。故当软键盘弹出时，默认情况下，弹出框会自动避开软键盘，并与之保持16vp的距离。从API version 15开始，开发者可以利用CustomDialogControllerOptions中的keyboardAvoidMode和keyboardAvoidDistance这两个配置项，来设置弹出框在软键盘弹出时的行为，包括是否需要避开软键盘以及与软键盘之间的距离。"
    description: $r('app.string.DialogAvoidSoftKeyboard_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/GetDialogStatus`,
    // 请将$r('app.string.GetDialogStatus_title')替换为实际资源文件，在本示例中该资源文件的value值为"获取弹出框的状态"
    title: resource.resourceToString($r('app.string.GetDialogStatus_title')),
    // 请将$r('app.string.GetDialogStatus_desc')替换为实际资源文件，在本示例中该资源文件的value值为"在业务模块中，页面上可能会同时出现多个弹出框。为避免重复打开相同的弹出框，建议在显示弹出框前，先通过控制器检查其当前状态。如果弹出框已处于显示状态，则不应再次打开。"
    description: $r('app.string.GetDialogStatus_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogFocusStrategy`,
    // 请将$r('app.string.CustomDialog_focus')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框焦点策略"
    title: resource.resourceToString($r('app.string.CustomDialog_focus')),
    // 请将$r('app.string.CustomDialog_focus_des')替换为实际资源文件，在本示例中该资源文件的value值为"通过设置focusable参数来管理弹出框是否获取焦点。"
    description: $r('app.string.CustomDialog_focus_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogController`,
    // 请将$r('app.string.CustomDialog_controller')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框控制器"
    title: resource.resourceToString($r('app.string.CustomDialog_controller')),
    // 请将$r('app.string.CustomDialog_controller_des')替换为实际资源文件，在本示例中该资源文件的value值为"可以将控制器传入弹出框内容区域后进行操作。"
    description: $r('app.string.CustomDialog_controller_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/PageLevelDialog`,
    // 请将$r('app.string.CustomDialog_page_level')替换为实际资源文件，在本示例中该资源文件的value值为"页面级弹出框"
    title: resource.resourceToString($r('app.string.CustomDialog_page_level')),
    // 请将$r('app.string.CustomDialog_controller_des')替换为实际资源文件，在本示例中该资源文件的value值为"在路由跳转后，弹出框能够随前一个路由页面的切换而消失，并在路由返回后弹出框能够继续正常显示。"
    description: $r('app.string.CustomDialog_controller_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogBoxLayer`,
    // 请将$r('app.string.CustomDialog_box_layer')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框层级管理"
    title: resource.resourceToString($r('app.string.CustomDialog_box_layer')),
    // 请将$r('app.string.CustomDialog_layer_des')替换为实际资源文件，在本示例中该资源文件的value值为"创建不同层级的弹出框。"
    description: $r('app.string.CustomDialog_layer_des'),
  },
]

@Builder
export function CustomDestination(name: string) {
  if (name === Custom_ROUTE_PREFIX) {
    CustomExample();
  } else if (name === routes[0].name) {
    CreateDialog();
  } else if (name === routes[1].name) {
    DialogInteraction();
  } else if (name === routes[2].name) {
    DialogInteraction1();
  } else if (name === routes[3].name) {
    DialogAnimation();
  } else if (name === routes[4].name) {
    DialogStyle();
  } else if (name === routes[5].name) {
    NestDialog();
  } else if (name === routes[6].name) {
    CreateCustomDialogNew();
  } else if (name === routes[7].name) {
    DialogInteractionUseConstructor();
  } else if (name === routes[8].name) {
    DialogInteractionUseButton();
  } else if (name === routes[9].name) {
    DialogAnimationNew();
  } else if (name === routes[10].name) {
    DialogStyleNew();
  } else if (name === routes[11].name) {
    NestDialogNew();
  } else if (name === routes[12].name) {
    DialogWithPhysicalBack();
  } else if (name === routes[13].name) {
    DialogAvoidSoftKeyboard();
  } else if (name === routes[14].name) {
    GetDialogStatus(); 
  } else if (name === routes[15].name) { 
    DialogFocusStrategy();
  } else if (name === routes[16].name) {
    DialogController();
  } else if (name === routes[17].name) {
    PageLevelDialogBox();
  } else if (name === routes[18].name) {
    DialogBoxLayer();
  }
}

@Entry
@Component
struct CustomExample {
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
    // 请将$r('app.string.CustomDialog_dialog')替换为实际资源文件，在本示例中该资源文件的value值为"自定义弹窗"
    .title($r('app.string.CustomDialog_dialog'))
  }
}