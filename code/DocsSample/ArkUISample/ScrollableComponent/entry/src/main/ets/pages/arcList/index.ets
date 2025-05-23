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
import { ArcListAcrScrollBar } from './ArcListAcrScrollBar';
import { ArcListArcIndexerBar } from './ArcListArcIndexerBar';
import { arcListBuiltInScrollerBar } from './arcListBuiltInScrollerBar';
import { ArcListContents } from './ArcListContents';
import { ArcListCrown } from './ArcListCrown';
import { ArcListShow } from './ArcListShow';
import { ArcListSideSlip } from './ArcListSideSlip';
import { ArcListStyles } from './ArcListStyles';
import { ArcLongList } from './ArcLongList';

import resource from '../../common/resource';

export const ARCLIST_ROUTE_PREFIX: string = 'arcList';

const routes: Route[] = [
  {
    name: `${ARCLIST_ROUTE_PREFIX}/ArcListShow`,
    title: resource.resourceToString($r('app.string.ArcListShow_title')),
    description: $r('app.string.ArcListShow_description')
  },
  {
    name: `${ARCLIST_ROUTE_PREFIX}/ArcListContents`,
    title: resource.resourceToString($r('app.string.ArcListContents_title')),
    description: $r('app.string.ArcListContents_description')
  },
  {
    name: `${ARCLIST_ROUTE_PREFIX}/ArcListStyles`,
    title: resource.resourceToString($r('app.string.ArcListStyles_title')),
    description: $r('app.string.ArcListStyles_description')
  },
  {
    name: `${ARCLIST_ROUTE_PREFIX}/arcListBuiltInScrollerBar`,
    title: resource.resourceToString($r('app.string.arcListBuiltInScrollerBar_title')),
    description: $r('app.string.arcListBuiltInScrollerBar_description')
  },
  {
    name: `${ARCLIST_ROUTE_PREFIX}/ArcListAcrScrollBar`,
    title: resource.resourceToString($r('app.string.ArcListAcrScrollBar_title')),
    description: $r('app.string.ArcListAcrScrollBar_description')
  },
  {
    name: `${ARCLIST_ROUTE_PREFIX}/ArcListArcIndexerBar`,
    title: resource.resourceToString($r('app.string.ArcListArcIndexerBar_title')),
    description: $r('app.string.ArcListArcIndexerBar_description')
  },
  {
    name: `${ARCLIST_ROUTE_PREFIX}/ArcListSideSlip`,
    title: resource.resourceToString($r('app.string.ArcListSideSlip_title')),
    description: $r('app.string.ArcListSideSlip_description')
  },
  {
    name: `${ARCLIST_ROUTE_PREFIX}/ArcLongList`,
    title: resource.resourceToString($r('app.string.ArcLongList_title')),
    description: $r('app.string.ArcLongList_description')
  },
  {
    name: `${ARCLIST_ROUTE_PREFIX}/ArcListCrown`,
    title: resource.resourceToString($r('app.string.ArcListCrown_title')),
    description: $r('app.string.ArcListCrown_description')
  }
];

@Builder
export function arcListDestination(name: string) {
  if (name === ARCLIST_ROUTE_PREFIX) {
    ArcListExample();
  } else if (name === routes[0].name) {
    ArcListShow();
  } else if (name === routes[1].name) {
    ArcListContents();
  } else if (name === routes[2].name) {
    ArcListStyles();
  } else if (name === routes[3].name) {
    arcListBuiltInScrollerBar();
  } else if (name === routes[4].name) {
    ArcListAcrScrollBar();
  } else if (name === routes[5].name) {
    ArcListArcIndexerBar();
  } else if (name === routes[6].name) {
    ArcListSideSlip();
  } else if (name === routes[7].name) {
    ArcLongList();
  } else if (name === routes[8].name) {
    ArcListCrown();
  }
}

@Entry
@Component
struct ArcListExample {
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
    .title('ArcList', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}