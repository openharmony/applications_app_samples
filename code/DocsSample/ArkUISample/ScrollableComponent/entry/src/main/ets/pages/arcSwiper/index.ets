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
import { ArcSwiperAction } from './ArcSwiperAction';
import { ArcSwiperHorizontal } from './ArcSwiperHorizontal';
import { ArcSwiperSideSlip } from './ArcSwiperSideSlip';
import { ArcSwiperStyles } from './ArcSwiperStyles';
import { ArcSwiperToggle } from './ArcSwiperToggle';
import { ArcSwiperVertical } from './ArcSwiperVertical';
import resource from '../../common/resource';

export const ARCSWIPER_ROUTE_PREFIX: string = 'arcSwiper';

const routes: Route[] = [
  {
    name: `${ARCSWIPER_ROUTE_PREFIX}/ArcSwiperStyles`,
    title: resource.resourceToString($r('app.string.ArcSwiperStyles_title')),
    description: $r('app.string.ArcSwiperStyles_description')
  },
  {
    name: `${ARCSWIPER_ROUTE_PREFIX}/ArcSwiperToggle`,
    title: resource.resourceToString($r('app.string.ArcSwiperToggle_title')),
    description: $r('app.string.ArcSwiperToggle_description')
  },
  {
    name: `${ARCSWIPER_ROUTE_PREFIX}/ArcSwiperHorizontal`,
    title: resource.resourceToString($r('app.string.ArcSwiperHorizontal_title')),
    description: $r('app.string.ArcSwiperHorizontal_description')
  },
  {
    name: `${ARCSWIPER_ROUTE_PREFIX}/ArcSwiperVertical`,
    title: resource.resourceToString($r('app.string.ArcSwiperVertical_title')),
    description: $r('app.string.ArcSwiperVertical_description')
  },
  {
    name: `${ARCSWIPER_ROUTE_PREFIX}/ArcSwiperAction`,
    title: resource.resourceToString($r('app.string.ArcSwiperAction_title')),
    description: $r('app.string.ArcSwiperAction_description')
  },
  {
    name: `${ARCSWIPER_ROUTE_PREFIX}/ArcSwiperSideSlip`,
    title: resource.resourceToString($r('app.string.ArcSwiperSideSlip_title')),
    description: $r('app.string.ArcSwiperSideSlip_description')
  }
];

@Builder
export function arcSwiperDestination(name: string) {
  if (name === ARCSWIPER_ROUTE_PREFIX) {
    ArcSwiperExample();
  } else if (name === routes[0].name) {
    ArcSwiperStyles();
  } else if (name === routes[1].name) {
    ArcSwiperToggle();
  } else if (name === routes[2].name) {
    ArcSwiperHorizontal();
  } else if (name === routes[3].name) {
    ArcSwiperVertical();
  } else if (name === routes[4].name) {
    ArcSwiperAction();
  } else if (name === routes[5].name) {
    ArcSwiperSideSlip();
  }
}

@Entry
@Component
struct ArcSwiperExample {
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
    .title('ArcSwiper', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}