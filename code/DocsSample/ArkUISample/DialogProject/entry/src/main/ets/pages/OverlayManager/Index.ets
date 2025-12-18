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
import { OverlayManagerComponent } from './OverlayManagerComponent';
import { OverlayManagerAlertDialog } from './OverlayManagerAlertDialog';
import { OverlayManagerWithOrder } from './OverlayManagerWithOrder';

export const OverlayManager_ROUTE_PREFIX: string = 'OverlayManager_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${OverlayManager_ROUTE_PREFIX}/OverlayManagerComponent`,
    // 请将$r('app.string.OverlayManager_component_title')替换为实际资源文件，在本示例中该资源文件的value值为"设置浮层"
    title: resource.resourceToString($r('app.string.OverlayManager_component_title')),
    // 请将$r('app.string.OverlayManager_component_des')替换为实际资源文件，在本示例中该资源文件的value值为"在OverlayManager上新增指定节点（addComponentContent）、删除指定节点（removeComponentContent）、显示所有节点（showAllComponentContents）和隐藏所有节点（hideAllComponentContents）"
    description: $r('app.string.OverlayManager_component_des'),
  },
  {
    name: `${OverlayManager_ROUTE_PREFIX}/OverlayManagerAlertDialog`,
    // 请将$r('app.string.OverlayManager_alert_title')替换为实际资源文件，在本示例中该资源文件的value值为"弹出alertDialog弹窗"
    title: resource.resourceToString($r('app.string.OverlayManager_alert_title')),
    // 请将$r('app.string.OverlayManager_alert_des')替换为实际资源文件，在本示例中该资源文件的value值为"显示一个始终在屏幕左侧的悬浮球，点击可以弹出alertDialog弹窗。"
    description: $r('app.string.OverlayManager_alert_des'),
  },
  {
    name: `${OverlayManager_ROUTE_PREFIX}/OverlayManagerWithOrder`,
    // 请将$r('app.string.OverlayManager_withOrder_title')替换为实际资源文件，在本示例中该资源文件的value值为"新增指定节点addComponentContentWithOrder"
    title: resource.resourceToString($r('app.string.OverlayManager_withOrder_title')),
    // 请将$r('app.string.OverlayManager_withOrder_des')替换为实际资源文件，在本示例中该资源文件的value值为"从API version 18开始，可以通过调用UIContext中getOverlayManager方法获取OverlayManager对象，并利用该对象在指定层级上新增指定节点（addComponentContentWithOrder），层次高的浮层会覆盖在层级低的浮层之上。"
    description: $r('app.string.OverlayManager_withOrder_des'),
  }

]

@Builder
export function OverlayManagerDestination(name: string) {
  if (name === OverlayManager_ROUTE_PREFIX) {
    OverlayManagerList();
  } else if (name === routes[0].name) {
    OverlayManagerComponent();
  } else if (name === routes[1].name) {
    OverlayManagerAlertDialog();
  } else if (name === routes[2].name) {
    OverlayManagerWithOrder();
  }
}

@Entry
@Component
struct OverlayManagerList {
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      List({ space: 12 }) {
        ForEach(routes, (route: Route) => {
          ListItem() {
            CompletedRoutableCard({ title: route.title, description: route.description });
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
    // 请将$r('app.string.OverlayManager_component_title')替换为实际资源文件，在本示例中该资源文件的value值为"设置浮层"
    .title($r('app.string.OverlayManager_component_title'))
  }
}