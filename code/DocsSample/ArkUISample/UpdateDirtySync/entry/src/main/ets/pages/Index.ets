/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { LengthMetrics } from '@kit.ArkUI';
import { RoutableCard } from '../common/Card';
import { Route } from '../common/Route';
import resource from '../common/Resource';
import { applySyncUse } from './ApplySyncUse';
import { flushUpdatesUse } from './FlushUpdatesUse';
import { flushUIUpdatesUse } from './FlushUIUpdatesUse';
import { applySyncNestApplySync } from './ApplySyncNestApplySync';
import { applySyncNestOthers } from './ApplySyncNestOthers';
import { callInComputed } from './CallInComputed';
import { callInMonitor } from './CallInMonitor';
import { animateToUse } from './AnimateToUse';
import { pageUse } from './PageUse';

const routes: Route[] = [
  {
    name: 'applySyncUse',
    title: resource.resourceToString($r('app.string.applySync_use_title')),
    description: ''
  },
  {
    name: 'flushUpdatesUse',
    title: resource.resourceToString($r('app.string.flushUpdates_use_title')),
    description: ''
  },
  {
    name: 'flushUIUpdatesUse',
    title: resource.resourceToString($r('app.string.flushUIUpdates_use_title')),
    description: ''
  },
  {
    name: 'applySyncNestApplySync',
    title: resource.resourceToString($r('app.string.applySync_nested_applySync')),
    description: ''
  },
  {
    name: 'applySyncNestOthers',
    title: resource.resourceToString($r('app.string.applySync_nested_others')),
    description: ''
  },
  {
    name: 'callInComputed',
    title: resource.resourceToString($r('app.string.called_in_computed')),
    description: ''
  },
  {
    name: 'callInMonitor',
    title: resource.resourceToString($r('app.string.called_in_monitor')),
    description: ''
  },
  {
    name: 'animateToUse',
    title: resource.resourceToString($r('app.string.use_with_animateTo')),
    description: ''
  },
  {
    name: 'pageUse',
    title: resource.resourceToString($r('app.string.use_with_pageTransition')),
    description: ''
  }

];

@Builder
function computedDestination(name: string) {
  if (name.startsWith('applySyncUse')) {
    applySyncUse();
  } else if (name.startsWith('flushUpdatesUse')) {
    flushUpdatesUse();
  } else if (name.startsWith('flushUIUpdatesUse')) {
    flushUIUpdatesUse();
  } else if (name.startsWith('applySyncNestApplySync')) {
    applySyncNestApplySync();
  } else if (name.startsWith('applySyncNestOthers')) {
    applySyncNestOthers();
  } else if (name.startsWith('callInComputed')) {
    callInComputed();
  } else if (name.startsWith('callInMonitor')) {
    callInMonitor();
  } else if (name.startsWith('animateToUse')) {
    animateToUse();
  } else if (name.startsWith('pageUse')) {
    pageUse();
  }
}

@Entry
@Component
struct Index {
  @State condition: string = '';
  @Provide pathStack: NavPathStack = new NavPathStack();

  getFilteredRoutes(): Route[] {
    if (!this.condition) {
      return routes;
    }
    return routes.filter((route: Route) => {
      return route.title.includes(this.condition);
    })
  }


  build() {
    Navigation(this.pathStack) {
      List({ space: 12 }) {
        ForEach(this.getFilteredRoutes(), (route: Route) => {
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
      .contentStartOffset(56)
      .height('100%')
      .width('100%')
    }
    .backgroundColor('#f1f3f5')
    .navDestination(computedDestination)
  }
}
