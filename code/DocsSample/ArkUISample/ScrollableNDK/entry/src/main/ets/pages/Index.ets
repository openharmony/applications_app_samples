/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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
import { Route } from '../common/Route';
import { RoutableCard } from '../common/Card';
import { WATER_FLOW_ROUTE_PREFIX, waterFlowDestination } from './waterflow/Index';
import { GRID_ROUTE_PREFIX, gridDestination } from './grid/Index';
import { List_ROUTE_PREFIX as LIST_ROUTE_PREFIX, listDestination } from './list/Index';
import { REFRESH_ROUTE_PREFIX, refreshDestination } from './refresh/Index';
import { SCROLL_ROUTE_PREFIX, scrollDestination } from './scroll/Index';

const routes: Route[] = [
  { title: $r('app.string.pageIndex_WaterFlow'), name: WATER_FLOW_ROUTE_PREFIX },
  { title: $r('app.string.pageIndex_Grid'),      name: GRID_ROUTE_PREFIX },
  { title: $r('app.string.pageIndex_List'),      name: LIST_ROUTE_PREFIX },
  { title: $r('app.string.pageIndex_Refresh'),   name: REFRESH_ROUTE_PREFIX },
  { title: $r('app.string.pageIndex_Scroll'),    name: SCROLL_ROUTE_PREFIX },
];

@Builder
function destination(name: string) {
  if (name.startsWith(WATER_FLOW_ROUTE_PREFIX)) {
    waterFlowDestination(name);
  } else if (name.startsWith(GRID_ROUTE_PREFIX)) {
    gridDestination(name);
  } else if (name.startsWith(LIST_ROUTE_PREFIX)) {
    listDestination(name);
  } else if (name.startsWith(REFRESH_ROUTE_PREFIX)) {
    refreshDestination(name);
  } else if (name.startsWith(SCROLL_ROUTE_PREFIX)) {
    scrollDestination(name);
  }
}

@Entry
@Component
struct Index {
  @Provide pathStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pathStack) {
      List({ space: 12 }) {
        ForEach(routes, (route: Route) => {
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
      .height('100%')
      .width('100%')
    }
    .backgroundColor($r('sys.color.comp_background_focus'))
    .title($r('app.string.app_name'))
    .navDestination(destination)
  }
}