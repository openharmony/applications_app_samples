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
import { ButtonPopupExample } from './ButtonPopup';
import { CustomPopupExample } from './CustomPopup';
import { AnimationPopupExample } from './PopupAnimation';
import { StatePopupExample } from './PopupStateChange';
import { StylePopupExample } from './PopupStyle';
import { TextPopupExample } from './TextPrompts';
import { AvoidSoftKeyboardPopupExample } from './PopupAvoidSoftKeyboard';
import { PolymorphicEffectPopupExample } from './PopupPolymorphicEffect';
import { SupportedAvoidAxisPopupExample } from './PopupSupportedAvoidAxis';
import { OpenPopup } from './globalpopupsindependentofuicomponents/OpenPopup';

export const Popup_ROUTE_PREFIX: string = 'Popup_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${Popup_ROUTE_PREFIX}/TextPopupExample`,
    // 请将$r('app.string.TextPopup_title')替换为实际资源文件，在本示例中该资源文件的value值为"文本提示气泡"
    title: resource.resourceToString($r('app.string.TextPopup_title')),
    // 请将$r('app.string.TextPopup_des')替换为实际资源文件，在本示例中该资源文件的value值为"文本提示气泡常用于只展示带有文本的信息提示，不带有任何交互的场景。Popup属性需绑定组件，当bindPopup属性中参数show为true时会弹出气泡提示。"
    description: $r('app.string.TextPopup_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/onStateChange`,
    // 请将$r('app.string.onStateChange_title')替换为实际资源文件，在本示例中该资源文件的value值为"添加气泡状态变化的事件"
    title: resource.resourceToString($r('app.string.onStateChange_title')),
    // 请将$r('app.string.onStateChange_des')替换为实际资源文件，在本示例中该资源文件的value值为"通过onStateChange参数为气泡添加状态变化的事件回调，可以判断当前气泡的显示状态。"
    description: $r('app.string.onStateChange_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/ButtonPopupExample`,
    // 请将$r('app.string.ButtonPopup_title')替换为实际资源文件，在本示例中该资源文件的value值为"带按钮的提示气泡"
    title: resource.resourceToString($r('app.string.ButtonPopup_title')),
    // 请将$r('app.string.ButtonPopup_des')替换为实际资源文件，在本示例中该资源文件的value值为"通过primaryButton、secondaryButton属性为气泡最多设置两个Button按钮，通过此按钮进行简单的交互，开发者可以通过配置action参数来设置想要触发的操作。"
    description: $r('app.string.ButtonPopup_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/AnimationPopupExample`,
    // 请将$r('app.string.AnimationPopup_title')替换为实际资源文件，在本示例中该资源文件的value值为"气泡的动画"
    title: resource.resourceToString($r('app.string.AnimationPopup_title')),
    // 请将$r('app.string.AnimationPopup_des')替换为实际资源文件，在本示例中该资源文件的value值为"气泡通过定义transition控制气泡的进场和出场动画效果。"
    description: $r('app.string.AnimationPopup_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/CustomPopupExample`,
    // 请将$r('app.string.CustomPopup_title')替换为实际资源文件，在本示例中该资源文件的value值为"自定义气泡"
    title: resource.resourceToString($r('app.string.CustomPopup_title')),
    // 请将$r('app.string.CustomPopup_des')替换为实际资源文件，在本示例中该资源文件的value值为"开发者可以使用CustomPopupOptions的builder创建自定义气泡，@Builder中可以放自定义的内容。除此之外，还可以通过popupColor等参数控制气泡样式。"
    description: $r('app.string.CustomPopup_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/StylePopupExample`,
    // 请将$r('app.string.StylePopup_title')替换为实际资源文件，在本示例中该资源文件的value值为"气泡样式"
    title: resource.resourceToString($r('app.string.StylePopup_title')),
    // 请将$r('app.string.StylePopup_des')替换为实际资源文件，在本示例中该资源文件的value值为"气泡除了可以通过builder实现自定义气泡，还可以通过接口设置气泡的样式和显示效果。"
    description: $r('app.string.StylePopup_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/AvoidSoftKeyboardPopupExample`,
    // 请将$r('app.string.AvoidSoftKeyboardPopupExample_title')替换为实际资源文件，在本示例中该资源文件的value值为"气泡避让软键盘"
    title: resource.resourceToString($r('app.string.AvoidSoftKeyboardPopupExample_title')),
    // 请将$r('app.string.AvoidSoftKeyboardPopupExample_des')替换为实际资源文件，在本示例中该资源文件的value值为"当软键盘弹出时，气泡默认不会对其避让，可能导致气泡被软键盘覆盖，这时需要设置keyboardAvoidMode为KeyboardAvoidMode.DEFAULT，来使气泡避让键盘。这时如果当前没有位置放下气泡时，气泡会从预设位置平移覆盖宿主组件。"
    description: $r('app.string.AvoidSoftKeyboardPopupExample_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/PolymorphicEffectPopupExample`,
    // 请将$r('app.string.PolymorphicEffectPopupExample_title')替换为实际资源文件，在本示例中该资源文件的value值为"设置气泡内的多态效果"
    title: resource.resourceToString($r('app.string.PolymorphicEffectPopupExample_title')),
    // 请将$r('app.string.PolymorphicEffectPopupExample_des')替换为实际资源文件，在本示例中该资源文件的value值为"目前使用@Builder自定义气泡内容时，默认不支持多态样式，可以使用@Component新建一个组件实现按下气泡中的内容时背景变色。"
    description: $r('app.string.PolymorphicEffectPopupExample_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/SupportedAvoidAxisPopupExample`,
    // 请将$r('app.string.SupportedAvoidAxisPopupExample_title')替换为实际资源文件，在本示例中该资源文件的value值为"气泡支持避让中轴"
    title: resource.resourceToString($r('app.string.SupportedAvoidAxisPopupExample_title')),
    // 请将$r('app.string.SupportedAvoidAxisPopupExample_des')替换为实际资源文件，在本示例中该资源文件的value值为"从API version 18起，气泡支持中轴避让功能。从API version 20开始，在2in1设备上默认启用（仅在窗口处于瀑布模式时产生避让）。开发者可通过PopupOptions中的enableHoverMode属性，控制气泡是否启用中轴避让。"
    description: $r('app.string.SupportedAvoidAxisPopupExample_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/OpenPopupExample`,
    // 请将$r('app.string.StylePopup_global')替换为实际资源文件，在本示例中该资源文件的value值为"全局气泡提示"
    title: resource.resourceToString($r('app.string.StylePopup_global')),
    // 请将$r('app.string.StylePopup_global_des')替换为实际资源文件，在本示例中该资源文件的value值为"通过使用全局接口openPopup的方式，在无UI组件的场景下直接或封装使用。"
    description: $r('app.string.StylePopup_global_des'),
  }
]

@Builder
export function PopupDestination(name: string) {
  if (name === Popup_ROUTE_PREFIX) {
    PopupExample();
  } else if (name === routes[0].name) {
    TextPopupExample();
  } else if (name === routes[1].name) {
    StatePopupExample();
  } else if (name === routes[2].name) {
    ButtonPopupExample();
  } else if (name === routes[3].name) {
    AnimationPopupExample();
  } else if (name === routes[4].name) {
    CustomPopupExample();
  } else if (name === routes[5].name) {
    StylePopupExample();
  } else if (name === routes[6].name) {
    AvoidSoftKeyboardPopupExample();
  } else if (name === routes[7].name) {
    PolymorphicEffectPopupExample();
  } else if (name === routes[8].name) {
    SupportedAvoidAxisPopupExample();
  } else if (name === routes[9].name) {
    OpenPopup();
  }
}

@Entry
@Component
struct PopupExample {
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
    // 请将$r('app.string.popup')替换为实际资源文件，在本示例中该资源文件的value值为"气泡提示"
    .title($r('app.string.popup'))
  }
}