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

import { CompletedRoutableCard } from '../../common/Card'
import { Route } from '../../common/Route'
import { Isolated } from './Isolated'
import resource from '../../common/resource'

export const ISOLATED_ROUTE_PREFIX: string = 'IsolatedComponent';

const routes: Route[] = [
  {
    name: `${ISOLATED_ROUTE_PREFIX}/Isolated`,
    title: resource.resourceToString($r('app.string.Isolated_Component_title')),
    description: resource.resourceToString($r('app.string.Isolated_Component_description')),
  }
];

@Builder
export function IsolatedDestination(name: string) {
  if (name == ISOLATED_ROUTE_PREFIX) {
    IsolatedExample();
  } else if (name == routes[0].name) {
    Isolated();
  }
}

@Entry
@Component
struct IsolatedExample {
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
    .title(resource.resourceToString($r('app.string.pageIndex_IsolatedComponent')), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}