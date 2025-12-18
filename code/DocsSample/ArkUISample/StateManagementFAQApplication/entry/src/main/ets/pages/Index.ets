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

import { LengthMetrics } from '@kit.ArkUI';
import { RoutableCard } from '../common/Card';
import { Route } from '../common/Route';
import resource from '../common/Resource';
import { lazyImportNeg } from './LazyImportNeg';
import { lazyImportPos } from './LazyImportPos';
import { decUseIsolationNeg } from './DecUseIsolationNeg';
import { decUseIsolationPos } from './DecUseIsolationPos';

const routes: Route[] = [
  {
    name: 'LazyImportNeg',
    title: resource.resourceToString($r('app.string.lazy_import_negative')),
    description: ''
  },
  {
    name: 'LazyImportPos',
    title: resource.resourceToString($r('app.string.lazy_import_positive')),
    description: ''
  },
  {
    name: 'DecUseIsolationNeg',
    title: resource.resourceToString($r('app.string.decorator_use_isolation_negative')),
    description: ''
  },
  {
    name: 'DecUseIsolationPos',
    title: resource.resourceToString($r('app.string.decorator_use_isolation_positive')),
    description: ''
  },
];

@Builder
function faqDestination(name: string) {
  if (name.startsWith('LazyImportNeg')) {
    lazyImportNeg();
  } else if (name.startsWith('LazyImportPos')) {
    lazyImportPos();
  } else if (name.startsWith('DecUseIsolationNeg')) {
    decUseIsolationNeg();
  } else if (name.startsWith('DecUseIsolationPos')) {
    decUseIsolationPos();
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
    .navDestination(faqDestination)
  }
}
