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
import { menuExample } from './CreateMenu';
import { OpenPopup } from './globalmenusindependentofuicomponents//GlobalOpenMenu';
import { PopVibrateMenuExample } from './PopVibrateMenu';
import { SupportAvoidCentralAxisMenuExample } from './SupportAvoidCentralAxisMenu';
import { EventTransSubWindowMenuExample } from './EventTransSubWindowMenu';
import { BindComponentMenuExample } from './BindComponentMenu'
import { CreateDefaultMenuExample } from './CreateDefaultMenu';
import { BuilderCustomMenuExample } from './BuilderCustomMenu';

export const Menu_ROUTE_PREFIX: string = 'Menu_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${Menu_ROUTE_PREFIX}/CreateMenu`,
    // 请将$r('app.string.CreateMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"创建自定义样式的菜单"
    title: resource.resourceToString($r('app.string.CreateMenu_title')),
    // 请将$r('app.string.CreateMenu_des')替换为实际资源文件，在本示例中该资源文件的value值为"菜单需要调用bindMenu接口来实现。bindMenu响应绑定组件的点击事件，绑定组件后手势点击对应组件后即可弹出。"
    description: $r('app.string.CreateMenu_des'),
  },
  {
    name: `${Menu_ROUTE_PREFIX}/OpenMenu`,
    // 请将$r('app.string.OpenMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"不依赖UI组件的全局气泡提示"
    title: resource.resourceToString($r('app.string.OpenMenu_title')),
    // 请将$r('app.string.OpenMenu_des')替换为实际资源文件，在本示例中该资源文件的value值为"通过使用全局接口openMenu的方式，在无UI组件的场景下直接或封装使用。"
    description: $r('app.string.OpenMenu_des'),
  },
  {
    name: `${Menu_ROUTE_PREFIX}/PopVibrateMenu`,
    // 请将$r('app.string.PopVibrateMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"菜单弹出时振动效果"
    title: resource.resourceToString($r('app.string.PopVibrateMenu_title')),
    // 请将$r('app.string.PopVibrateMenu_des')替换为实际资源文件，在本示例中该资源文件的value值为"菜单弹出时，默认不振动。若希望菜单弹出时有振动效果，可以通过ContextMenuOptions的hapticFeedbackMode属性，设置菜单弹出时的振动模式。"
    description: $r('app.string.PopVibrateMenu_des'),
  },
  {
    name: `${Menu_ROUTE_PREFIX}/SupportAvoidCentralAxisMenu`,
    // 请将$r('app.string.SupportAvoidCentralAxisMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"菜单支持避让中轴"
    title: resource.resourceToString($r('app.string.SupportAvoidCentralAxisMenu_title')),
    // 请将$r('app.string.SupportAvoidCentralAxisMenu_des')替换为实际资源文件，在本示例中该资源文件的value值为"从API version 18起，菜单支持中轴避让功能。从API version 20开始，在2in1设备上默认启用（仅在窗口处于瀑布模式时产生避让）。开发者可通过ContextMenuOptions中的enableHoverMode属性，控制菜单是否启用中轴避让。"
    description: $r('app.string.SupportAvoidCentralAxisMenu_des'),
  },
  {
    name: `${Menu_ROUTE_PREFIX}/EventTransSubWindowMenu`,
    // 请将$r('app.string.EventTransSubWindowMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"控制子窗菜单的事件透传"
    title: resource.resourceToString($r('app.string.EventTransSubWindowMenu_title')),
    // 请将$r('app.string.EventTransSubWindowMenu_des')替换为实际资源文件，在本示例中该资源文件的value值为"当菜单在子窗口中弹出时，默认情况下，菜单周围的事件会传递至所在窗口。从API version 20开始，开发者可通过ContextMenuOptions的modalMode属性设置子菜单弹出时的模态模式，以控制菜单周围事件是否传递。将modalMode设置为ModalMode.TARGET_WINDOW时，菜单周围的事件将不再传递，菜单下方的控件也不会响应事件。"
    description: $r('app.string.EventTransSubWindowMenu_des'),
  },
  {
    name: `${Menu_ROUTE_PREFIX}/BindComponentMenu`,
    // 请将$r('app.string.BindComponentMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"基于绑定组件指定位置弹出菜单"
    title: resource.resourceToString($r('app.string.BindComponentMenu_title')),
    // 请将$r('app.string.BindComponentMenu_des')替换为实际资源文件，在本示例中该资源文件的value值为"菜单从API version 20开始支持基于绑定组件在指定位置弹出。通过设置水平与垂直偏移量，控制菜单相对于绑定组件左上角的弹出位置。与单独使用offset接口不同，此方法可使菜单覆盖显示在绑定组件上。需要指定弹出位置时，可使用ContextMenuOptions的anchorPosition属性进行设置。"
    description: $r('app.string.BindComponentMenu_des'),
  },
  {
    name: `${Menu_ROUTE_PREFIX}/CreateDefaultMenuExample`,
    // 请将$r('app.string.CreateDefaultMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"创建默认样式的菜单"
    title: resource.resourceToString($r('app.string.CreateDefaultMenu_title')),
    // 请将$r('app.string.CreateDefaultMenu_des')替换为实际资源文件，在本示例中该资源文件的value值为"      "value": "菜单需要调用bindMenu接口来实现。bindMenu响应绑定组件的点击事件，绑定组件后手势点击对应组件后即可弹出。""
    description: $r('app.string.CreateDefaultMenu_des'),
  },
  {
    name: `${Menu_ROUTE_PREFIX}/BuilderCustomMenuExample`,
    // 请将$r('app.string.BuilderCustomMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"使用@Builder自定义菜单内容"
    title: resource.resourceToString($r('app.string.BuilderCustomMenu_title')),
  }
]

@Builder
export function MenuDestination(name: string) {
  if (name === Menu_ROUTE_PREFIX) {
    MenuExample();
  } else if (name === routes[0].name) {
    menuExample();
  } else if (name === routes[1].name) {
    OpenPopup();
  } else if (name === routes[2].name) {
    PopVibrateMenuExample();
  } else if (name === routes[3].name) {
    SupportAvoidCentralAxisMenuExample();
  } else if (name === routes[4].name) {
    EventTransSubWindowMenuExample();
  } else if (name === routes[5].name) {
    BindComponentMenuExample();
  } else if (name === routes[6].name) {
    CreateDefaultMenuExample();
  } else if (name === routes[7].name) {
    BuilderCustomMenuExample();
  }
}

@Entry
@Component
struct MenuExample {
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
    // 请将$r('app.string.menu')替换为实际资源文件，在本示例中该资源文件的value值为"菜单"
    .title($r('app.string.menu'))
  }
}