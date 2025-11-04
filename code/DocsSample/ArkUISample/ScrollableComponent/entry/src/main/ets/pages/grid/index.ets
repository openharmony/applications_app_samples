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
import { GridCalculator } from './GridCalculator';
import resource from '../../common/resource';

export const GRID_ROUTE_PREFIX: string = 'grid';

const routes: Route[] = [
  {
    name: `${GRID_ROUTE_PREFIX}/GridLayout`,
    // app.string.GridLayout_title资源文件中的value值为‘网格开发布局’
    title: resource.resourceToString($r('app.string.GridLayout_title')),
    // app.string.DataInGrid_title资源文件中的value值为‘示例设置了网格中子组件行列数量占比、行列间距和主轴方向。’
    description: $r('app.string.GridLayout_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/DataInGrid`,
    // app.string.DataInGrid_title资源文件中的value值为‘网格显示数据’
    title: resource.resourceToString($r('app.string.DataInGrid_title')),
    // app.string.DataInGrid_description资源文件中的value值为‘示例采用二维布局的方式组织其内部元素，显示通用办公服务网格。’
    description: $r('app.string.DataInGrid_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/ScrollableGrid`,
    // app.string.ScrollableGrid_title资源文件中的value值为‘可滚动的网格布局’
    title: resource.resourceToString($r('app.string.ScrollableGrid_title')),
    // app.string.ScrollableGrid_description资源文件中的value值为‘示例通过仅设置行、列数量与占比中的一个实现横向可滚动网格布局。’
    description: $r('app.string.ScrollableGrid_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/ScrollPosition`,
    // app.string.ScrollPosition_title资源文件中的value值为‘控制滚动位置的网格布局’
    title: resource.resourceToString($r('app.string.ScrollPosition_title')),
    // app.string.ScrollPosition_description资源文件中的value值为‘示例通过添加Scroller对象的scrollPage方法，实现滚动网格布局翻页滚动的功能。’
    description: $r('app.string.ScrollPosition_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/GridSideToSide`,
    // app.string.GridSideToSide_title资源文件中的value值为‘控制滚动位置’
    title: resource.resourceToString($r('app.string.GridSideToSide_title')),
    // app.string.GridSideToSide_description资源文件中的value值为‘与新闻列表的返回顶部场景类似，控制滚动位置功能在网格布局中也很常用，例如下图所示日历的翻页功能。’
    description: $r('app.string.GridSideToSide_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/GridScrollbar`,
    // app.string.GridScrollbar_title资源文件中的value值为‘添加外置滚动条’
    title: resource.resourceToString($r('app.string.GridScrollbar_title')),
    // app.string.GridScrollbar_description资源文件中的value值为‘网格组件Grid可与ScrollBar组件配合使用，为网格添加外置滚动条。’
    description: $r('app.string.GridScrollbar_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/LongGrid`,
    // app.string.LongGrid_title资源文件中的value值为‘性能优化’
    title: resource.resourceToString($r('app.string.LongGrid_title')),
    // app.string.LongGrid_description资源文件中的value值为‘与长列表的处理类似，循环渲染适用于数据量较小的布局场景，当构建具有大量网格项的可滚动网格布局时，推荐使用数据懒加载方式实现按需迭代加载数据，从而提升列表性能。’
    description: $r('app.string.LongGrid_description')
  },
  {
    name: `${GRID_ROUTE_PREFIX}/GridCalculator`,
    // app.string.GridCalculator_title资源文件中的value值为‘计算器的按键布局’
    title: resource.resourceToString($r('app.string.GridCalculator_title')),
    // app.string.GridCalculator_description资源文件中的value值为‘实现不同大小的网格组成不均匀分布的网格布局场景’
    description: $r('app.string.GridCalculator_description')
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
  } else if (name === routes[7].name) {
    GridCalculator();
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