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
import { OverlayManagerDemo1 } from './OverlayManagerDemo1';
import { OverlayManagerDemo2 } from './OverlayManagerDemo2';
import { OverlayManagerDemo3 } from './OverlayManagerDemo3';

export const OverlayManager_ROUTE_PREFIX: string = 'OverlayManager_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${OverlayManager_ROUTE_PREFIX}/OverlayManagerDemo1`,
    title: resource.resourceToString($r('app.string.OverlayManager_demo1_title')),
    description: $r('app.string.OverlayManager_demo1_des'),
  },
  {
    name: `${OverlayManager_ROUTE_PREFIX}/OverlayManagerDemo2`,
    title: resource.resourceToString($r('app.string.OverlayManager_demo2_title')),
    description: $r('app.string.OverlayManager_demo2_des'),
  },
  {
    name: `${OverlayManager_ROUTE_PREFIX}/OverlayManagerDemo3`,
    title: resource.resourceToString($r('app.string.OverlayManager_demo3_title')),
    description: $r('app.string.OverlayManager_demo3_des'),
  }

]

@Builder
export function OverlayManagerDestination(name: string) {
  if (name === OverlayManager_ROUTE_PREFIX) {
    OverlayManagerList();
  } else if (name === routes[0].name) {
    OverlayManagerDemo1();
  } else if (name === routes[1].name) {
    OverlayManagerDemo2();
  } else if (name === routes[2].name) {
    OverlayManagerDemo3();
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
    .title($r('app.string.OverlayManager_demo1_title'))
  }
}