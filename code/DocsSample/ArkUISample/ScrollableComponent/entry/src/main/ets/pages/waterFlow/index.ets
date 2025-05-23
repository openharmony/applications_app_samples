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
import { Route } from '../../common/Route';
import { WaterFlowInfiniteScrolling } from './WaterFlowInfiniteScrolling';
import { WaterFlowInfiniteScrollingEarly } from './WaterFlowInfiniteScrollingEarly';
import { WaterFlowGroupingMixing } from './WaterFlowGroupingMixing';
import { WaterFlowDynamicSwitchover } from './WaterFlowDynamicSwitchover';
import resource from '../../common/resource';

export const WATERFLOW_ROUTE_PREFIX: string = 'waterFlow';

const routes: Route[] = [
  {
    name: `${WATERFLOW_ROUTE_PREFIX}/WaterFlowInfiniteScrolling`,
    title: resource.resourceToString($r('app.string.WaterFlowInfiniteScrolling_title')),
    description: $r('app.string.WaterFlowInfiniteScrolling_description')
  },
  {
    name: `${WATERFLOW_ROUTE_PREFIX}/WaterFlowInfiniteScrollingEarly`,
    title: resource.resourceToString($r('app.string.WaterFlowInfiniteScrollingEarly_title')),
    description: $r('app.string.WaterFlowInfiniteScrollingEarly_description')
  },
  {
    name: `${WATERFLOW_ROUTE_PREFIX}/WaterFlowGroupingMixing`,
    title: resource.resourceToString($r('app.string.WaterFlowGroupingMixing_title')),
    description: $r('app.string.WaterFlowGroupingMixing_description')
  },
  {
    name: `${WATERFLOW_ROUTE_PREFIX}/WaterFlowDynamicSwitchover`,
    title: resource.resourceToString($r('app.string.WaterFlowDynamicSwitchover_title')),
    description: $r('app.string.WaterFlowDynamicSwitchover_description')
  }

];

@Builder
export function waterFlowDestination(name: string) {
  if (name === WATERFLOW_ROUTE_PREFIX) {
    WaterFlowExample();
  } else if (name === routes[0].name) {
    WaterFlowInfiniteScrolling();
  } else if (name === routes[1].name) {
    WaterFlowInfiniteScrollingEarly();
  } else if (name === routes[2].name) {
    WaterFlowGroupingMixing();
  } else if (name === routes[3].name) {
    WaterFlowDynamicSwitchover();
  }
}

@Entry
@Component
struct WaterFlowExample {
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
    .title('WaterFlow', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}