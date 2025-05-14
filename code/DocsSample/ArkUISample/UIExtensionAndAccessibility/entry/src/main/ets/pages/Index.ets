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

import { LengthMetrics } from '@kit.ArkUI';
import { RoutableCard } from '../common/Card';
import { Route } from '../common/Route';
import resource from '../common/resource';
import { UI_EXTENSION_ROUTE_PREFIX, UIExtensionDestination } from './UIExtensionComponent/Index'
import { EMBEDDED_ROUTE_PREFIX, EmbeddedDestination } from './EmbeddedComponent/Index'
import { SCREEN_ROUTE_PREFIX, FullScreenDestination } from './FullScreenLaunchComponent/Index'
import { ISOLATED_ROUTE_PREFIX, IsolatedDestination } from './IsolatedComponent/Index'
import { ACCESSIBILITY_ROUTE_PREFIX, AccessibilityDestination } from './UniversalAttributesAccessibility/Index'

const routes: Route[] = [
  {
    title: resource.resourceToString($r('app.string.pageIndex_UIExtensionComponent')),
    name: UI_EXTENSION_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.pageIndex_EmbeddedComponent')),
    name: EMBEDDED_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.pageIndex_FullScreenLaunchComponent')),
    name: SCREEN_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.pageIndex_IsolatedComponent')),
    name: ISOLATED_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.pageIndex_UniversalAttributesAccessibility')),
    name: ACCESSIBILITY_ROUTE_PREFIX
  }
]

@Builder
function Destination(name: string) {
  if (name.startsWith(UI_EXTENSION_ROUTE_PREFIX)) {
    UIExtensionDestination(name);
  } else if (name.startsWith(EMBEDDED_ROUTE_PREFIX)) {
    EmbeddedDestination(name);
  } else if (name.startsWith(SCREEN_ROUTE_PREFIX)) {
    FullScreenDestination(name);
  } else if (name.startsWith(ISOLATED_ROUTE_PREFIX)) {
    IsolatedDestination(name);
  } else if (name.startsWith(ACCESSIBILITY_ROUTE_PREFIX)) {
    AccessibilityDestination(name);
  }
}

@Entry
@Component
struct Index {
  @State condition: string = '';
  @Provide pathStack: NavPathStack = new NavPathStack();

  getFilteredRoutes(): Route[] {
    if (!this.condition) {
      return routes;
    }
    return routes.filter((route: Route) => {
      return route.title.includes(this.condition);
    })
  }

  @LocalBuilder
  Title() {
    Column() {
      Search({ value: this.condition })
        .onChange(value => {
          this.condition = value;
        })
        .margin({ start: LengthMetrics.vp(16), end: LengthMetrics.vp(16) })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
  }

  build() {
    Navigation(this.pathStack) {
      List({ space: 12 }) {
        ForEach(this.getFilteredRoutes(), (route: Route) => {
          ListItem() {
            RoutableCard({ title: route.title })
          }
          .width('100%')
          .onClick(() => {
            this.pathStack.pushPath({ name: route.name });
          })
        })
      }
      .padding({ start: LengthMetrics.vp(16), end: LengthMetrics.vp(16) })
      .contentStartOffset(56)
      .height('100%')
      .width('100%')
    }
    .backgroundColor('#f1f3f5')
    .title({ builder: this.Title, height: 56 }, {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .navDestination(Destination)
  }
}
