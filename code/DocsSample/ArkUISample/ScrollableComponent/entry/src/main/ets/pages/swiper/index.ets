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
import { SwiperAutoPlay } from './SwiperAutoPlay';
import { SwiperCustomAnimation } from './SwiperCustomAnimation';
import { SwiperDirection } from './SwiperDirection';
import { SwiperIndicatorStyle } from './SwiperIndicatorStyle';
import { SwiperLoop } from './SwiperLoop';
import { SwiperMultiPage } from './SwiperMultiPage';
import { SwiperPageSwitchMethod } from './SwiperPageSwitchMethod';
import { SwiperAndTabsLinkage } from './SwiperAndTabsLinkage';
import resource from '../../common/resource';

export const SWIPER_ROUTE_PREFIX: string = 'swiper';

const routes: Route[] = [
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperLoop`,
    title: resource.resourceToString($r('app.string.SwiperLoop_title')),
    description: $r('app.string.SwiperLoop_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperAutoPlay`,
    title: resource.resourceToString($r('app.string.SwiperAutoPlay_title')),
    description: $r('app.string.SwiperAutoPlay_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperIndicatorStyle`,
    title: resource.resourceToString($r('app.string.SwiperIndicatorStyle_title')),
    description: $r('app.string.SwiperIndicatorStyle_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperPageSwitchMethod`,
    title: resource.resourceToString($r('app.string.SwiperPageSwitchMethod_title')),
    description: $r('app.string.SwiperPageSwitchMethod_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperDirection`,
    title: resource.resourceToString($r('app.string.SwiperDirection_title')),
    description: $r('app.string.SwiperDirection_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperMultiPage`,
    title: resource.resourceToString($r('app.string.SwiperMultiPage_title')),
    description: $r('app.string.SwiperMultiPage_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperCustomAnimation`,
    title: resource.resourceToString($r('app.string.SwiperCustomAnimation_title')),
    description: $r('app.string.SwiperCustomAnimation_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperAndTabsLinkage`,
    title: resource.resourceToString($r('app.string.SwiperAndTabsLinkage_title')),
    description: $r('app.string.SwiperAndTabsLinkage_description')
  }
];

@Builder
export function swiperDestination(name: string) {
  if (name === SWIPER_ROUTE_PREFIX) {
    SwiperExample();
  } else if (name === routes[0].name) {
    SwiperLoop();
  } else if (name === routes[1].name) {
    SwiperAutoPlay();
  } else if (name === routes[2].name) {
    SwiperIndicatorStyle();
  } else if (name === routes[3].name) {
    SwiperPageSwitchMethod();
  } else if (name === routes[4].name) {
    SwiperDirection();
  } else if (name === routes[5].name) {
    SwiperMultiPage();
  } else if (name === routes[6].name) {
    SwiperCustomAnimation();
  } else if (name === routes[7].name) {
    SwiperAndTabsLinkage();
  }
}

@Entry
@Component
struct SwiperExample {
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
    .title('Swiper', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}