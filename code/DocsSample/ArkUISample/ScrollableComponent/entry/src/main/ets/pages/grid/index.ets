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
import { DataInGrid } from './DataInGrid';
import { GridLayout } from './GridLayout';
import { Route } from '../../common/Route';
import { ScrollableGrid } from './ScrollableGrid';
import { ScrollPosition } from './ScrollPositionGrid';
import { GridSideToSide } from './GridSideToSide';
import { GridScrollbar } from './GridScrollbar';
import { LongGrid } from './LongGrid';
import resource from '../../common/resource';

export const GRID_ROUTE_PREFIX: string = 'grid';

const routes: Route[] = [
  {
    name: `${GRID_ROUTE_PREFIX}/GridLayout`,
    title: resource.resourceToString($r('app.string.GridLayout_title')),
    description: $r('app.string.GridLayout_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/DataInGrid`,
    title: resource.resourceToString($r('app.string.DataInGrid_title')),
    description: $r('app.string.DataInGrid_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/ScrollableGrid`,
    title: resource.resourceToString($r('app.string.ScrollableGrid_title')),
    description: $r('app.string.ScrollableGrid_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/ScrollPosition`,
    title: resource.resourceToString($r('app.string.ScrollPosition_title')),
    description: $r('app.string.ScrollPosition_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/GridSideToSide`,
    title: resource.resourceToString($r('app.string.GridSideToSide_title')),
    description: $r('app.string.GridSideToSide_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/GridScrollbar`,
    title: resource.resourceToString($r('app.string.GridScrollbar_title')),
    description: $r('app.string.GridScrollbar_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/LongGrid`,
    title: resource.resourceToString($r('app.string.LongGrid_title')),
    description: $r('app.string.LongGrid_description')
  }
];

@Builder
export function gridDestination(name: string) {
  if (name === GRID_ROUTE_PREFIX) {
    GridExample();
  } else if (name === routes[0].name) {
    GridLayout();
  } else if (name === routes[1].name) {
    DataInGrid();
  } else if (name === routes[2].name) {
    ScrollableGrid();
  } else if (name === routes[3].name) {
    ScrollPosition();
  } else if (name === routes[4].name) {
    GridSideToSide();
  } else if (name === routes[5].name) {
    GridScrollbar();
  } else if (name === routes[6].name) {
    LongGrid();
  }
}

@Entry
@Component
struct GridExample {
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
    .title('Grid', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}