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

import { AgeFriendlyTabs } from './AgeFriendlyTabs';
import { BottomTabBar } from './BottomTabBar';
import { CompletedRoutableCard } from '../../common/Card';
import { ContentWillChange } from './ContentWillChange';
import { CustomTabBar } from './CustomTabBar';
import { FixedTabBar } from './FixedTabBar';
import { Route } from '../../common/Route';
import { ScrollableTabBar } from './ScrollableTabBar';
import { SideTabBar } from './SideTabBar';
import { SwipeLockedTabBar } from './SwipeLockedTabBar';
import { TabsLayout } from './TabsLayout';
import { TopTabBar } from './TopTabBar';
import resource from '../../common/resource';

export const TABS_ROUTE_PREFIX: string = 'tabs';

const routes: Route[] = [
  {
    name: `${TABS_ROUTE_PREFIX}/TabsLayout`,
    title: resource.resourceToString($r('app.string.TabsLayout_title')),
    description: $r('app.string.TabsLayout_description')
  },
  {
    name: `${TABS_ROUTE_PREFIX}/BottomTabBar`,
    title: resource.resourceToString($r('app.string.BottomTabBar_title')),
    description: $r('app.string.BottomTabBar_description')
  },
  {
    name: `${TABS_ROUTE_PREFIX}/TopTabBar`,
    title: resource.resourceToString($r('app.string.TopTabBar_title')),
    description: $r('app.string.TopTabBar_description')
  },
  {
    name: `${TABS_ROUTE_PREFIX}/SideTabBar`,
    title: resource.resourceToString($r('app.string.SideTabBar_title')),
    description: $r('app.string.SideTabBar_description')
  },
  {
    name: `${TABS_ROUTE_PREFIX}/SwipeLockedTabBar`,
    title: resource.resourceToString($r('app.string.SwipeLockedTabBar_title')),
    description: $r('app.string.SwipeLockedTabBar_description')
  },
  {
    name: `${TABS_ROUTE_PREFIX}/FixedTabBar`,
    title: resource.resourceToString($r('app.string.FixedTabBar_title')),
    description: $r('app.string.FixedTabBar_description')
  },
  {
    name: `${TABS_ROUTE_PREFIX}/ScrollableTabBar`,
    title: resource.resourceToString($r('app.string.ScrollableTabBar_title')),
    description: $r('app.string.ScrollableTabBar_description')
  },
  {
    name: `${TABS_ROUTE_PREFIX}/CustomTabBar`,
    title: resource.resourceToString($r('app.string.CustomTabBar_title')),
    description: $r('app.string.CustomTabBar_description')
  },
  {
    name: `${TABS_ROUTE_PREFIX}/ContentWillChange`,
    title: resource.resourceToString($r('app.string.ContentWillChange_title')),
    description: $r('app.string.ContentWillChange_description')
  },
  {
    name: `${TABS_ROUTE_PREFIX}/AgeFriendlyTabs`,
    title: resource.resourceToString($r('app.string.AgeFriendlyTabs_title')),
    description: $r('app.string.AgeFriendlyTabs_description')
  }
];

@Builder
export function tabsDestination(name: string) {
  if (name === TABS_ROUTE_PREFIX) {
    TabsExample();
  } else if (name === routes[0].name) {
    TabsLayout();
  } else if (name === routes[1].name) {
    BottomTabBar();
  } else if (name === routes[2].name) {
    TopTabBar();
  } else if (name === routes[3].name) {
    SideTabBar();
  } else if (name === routes[4].name) {
    SwipeLockedTabBar();
  } else if (name === routes[5].name) {
    FixedTabBar();
  } else if (name === routes[6].name) {
    ScrollableTabBar();
  } else if (name === routes[7].name) {
    CustomTabBar();
  } else if (name === routes[8].name) {
    ContentWillChange();
  } else if (name === routes[9].name) {
    AgeFriendlyTabs();
  }
}

@Entry
@Component
struct TabsExample {
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
      .contentStartOffset(56)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor('#f1f3f5')
    .title('Tabs', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}
