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
import { Exclusive } from './Exclusive';
import { Parallel } from './Parallel';
import { Sequence } from './Sequence';
import resource from '../../common/resource';

export const GroupGesture_ROUTE_PREFIX: string = 'GroupGestureExample';

const routes: Route[] = [
  {
    name: `${GroupGesture_ROUTE_PREFIX}/Sequence`,
    title: resource.resourceToString($r('app.string.groupgesture_Index_Sequence_title')),
    description: resource.resourceToString($r('app.string.groupgesture_Index_Sequence_description')),
  },
  {
    name: `${GroupGesture_ROUTE_PREFIX}/Parallel`,
    title: resource.resourceToString($r('app.string.groupgesture_Index_Parallel_title')),
    description: resource.resourceToString($r('app.string.groupgesture_Index_Parallel_description')),
  },
  {
    name: `${GroupGesture_ROUTE_PREFIX}/Exclusive`,
    title: resource.resourceToString($r('app.string.groupgesture_Index_Exclusive_title')),
    description: resource.resourceToString($r('app.string.groupgesture_Index_Exclusive_description')),
  }
]

@Builder
export function GroupGestureDestination(name: string) {
  if (name === GroupGesture_ROUTE_PREFIX) {
    GroupGestureExample();
  } else if (name === routes[0].name) {
    Sequence();
  } else if (name === routes[1].name) {
    Parallel();
  } else if (name === routes[2].name) {
    Exclusive();
  }
}

@Entry
@Component
struct GroupGestureExample {
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
    .title($r('app.string.groupgesture_Index_title'))
  }
}