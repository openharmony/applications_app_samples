/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { CreateToggle } from './CreateToggle';
import { CustomStyle } from './ToggleCustomStyle';
import { Route } from '../../common/Route';
import { ToggleSample } from './ToggleCaseExample';
import resource from '../../common/resource';

export const TOGGLE_ROUTE_PREFIX: string = 'toggle';

const routes: Route[] = [
  {
    name: `${TOGGLE_ROUTE_PREFIX}/CreateToggle`,
    title: resource.resourceToString($r('app.string.CreateToggle_title')),
    description: $r('app.string.CreateToggle_description')
  },
  {
    name: `${TOGGLE_ROUTE_PREFIX}/ToggleCustomStyle`,
    title: resource.resourceToString($r('app.string.ToggleCustomStyle_title')),
    description: $r('app.string.ToggleCustomStyle_description')
  },
  {
    name: `${TOGGLE_ROUTE_PREFIX}/ToggleCaseExample`,
    title: resource.resourceToString($r('app.string.changeToggle_example')),
    description: $r('app.string.ToggleCaseExample_description')
  }
]

@Builder
export function toggleDestination(name: string) {
  if (name === TOGGLE_ROUTE_PREFIX) {
    ToggleExample();
  } else if (name === routes[0].name) {
    CreateToggle();
  } else if (name === routes[1].name) {
    CustomStyle();
  } else if (name === routes[2].name) {
    ToggleSample();
  }
}

@Entry
@Component
struct ToggleExample {
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
    .title('Toggle', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}

