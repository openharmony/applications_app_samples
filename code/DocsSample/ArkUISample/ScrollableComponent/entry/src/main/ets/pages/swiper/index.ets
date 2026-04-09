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
import { SwiperIgnoreComponentSize } from './SwiperIgnoreComponentSize';
import { SwiperDigitIndicatorIgnoreComponentSize } from './SwiperDigitIndicatorIgnoreComponentSize';
import { SwiperVisibleContentPosition } from './SwiperVisibleContentPosition';
import resource from '../../common/resource';

export const SWIPER_ROUTE_PREFIX: string = 'swiper';

const routes: Route[] = [
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperLoop`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperLoop_title'))},
    description: $r('app.string.SwiperLoop_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperAutoPlay`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperAutoPlay_title'))},
    description: $r('app.string.SwiperAutoPlay_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperIndicatorStyle`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperIndicatorStyle_title'))},
    description: $r('app.string.SwiperIndicatorStyle_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperPageSwitchMethod`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperPageSwitchMethod_title'))},
    description: $r('app.string.SwiperPageSwitchMethod_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperDirection`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperDirection_title'))},
    description: $r('app.string.SwiperDirection_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperMultiPage`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperMultiPage_title'))},
    description: $r('app.string.SwiperMultiPage_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperCustomAnimation`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperCustomAnimation_title'))},
    description: $r('app.string.SwiperCustomAnimation_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperAndTabsLinkage`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperAndTabsLinkage_title'))},
    description: $r('app.string.SwiperAndTabsLinkage_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperIgnoreComponentSize`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperIgnoreComponentSize_title'))},
    description: $r('app.string.SwiperIgnoreComponentSize_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperDigitIndicatorIgnoreComponentSize`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperDigitIndicatorIgnoreComponentSize_title'))},
    description: $r('app.string.SwiperDigitIndicatorIgnoreComponentSize_description')
  },
  {
    name: `${SWIPER_ROUTE_PREFIX}/SwiperVisibleContentPosition`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.SwiperVisibleContentPosition_title'))},
    description: $r('app.string.SwiperVisibleContentPosition_description')
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
  } else if (name === routes[8].name) {
    SwiperIgnoreComponentSize();
  } else if (name === routes[9].name) {
    SwiperDigitIndicatorIgnoreComponentSize();
  } else if (name === routes[10].name) {
    SwiperVisibleContentPosition();
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
            CompletedRoutableCard({ title: route.title(this.getUIContext().getHostContext()!),
            description: route.description })
          }
          .width('100%')
          .onClick(() => {
            this.pathStack.pushPath({ name: route.name });
          })
        })
      }
      .contentStartOffset(56)
      .padding({ left: 16, right: 16 })
      .id('list_')
    }
    .backgroundColor('#f1f3f5')
    .title('Swiper', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}