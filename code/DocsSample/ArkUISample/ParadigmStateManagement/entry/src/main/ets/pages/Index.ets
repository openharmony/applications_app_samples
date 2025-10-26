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
import { Route } from '../common/Route';
import { RoutableCard } from '../common/Card';
import resource from '../common/Resource';
import { localBuilderDestination, LOCAL_BUILDER } from './localBuilder/Index';
import { extendDestination, EXTEND } from './extend/Index';
import { syncStateManagerDestination, SYNC_STATE_MANAGER_$$ } from './syncStateManager/Index';
import { MigrationDestination, MIGRATION_DATA } from './migrationDataObjectVariables/Index';
import { localDestination, LOCAL } from './local/Index';
import { paramDestination, PARMA } from './param/Index';
import { persistenceV2Destination, PERSISTENCE_V2 } from './persistenceV2/Index';
import { MONITOR, monitorDestination } from './monitor/Index';
import { provideAndConsumeDestination, PROVIDE_AND_CONSUME } from './provideAndConsume/Index';
import { STATE, stateDestination } from './state/Index';
import { internalTraceDestination, INTERNAL_MIGRATE } from './internalmigrate/Index';

const routes: Route[] = [
  {
    title: resource.resourceToString($r('app.string.local_builder')),
    name: LOCAL_BUILDER
  },
  {
    title: resource.resourceToString($r('app.string.extend')),
    name: EXTEND
  },
  {
    title: resource.resourceToString($r('app.string.sync_state_manager')),
    name: SYNC_STATE_MANAGER_$$
  },
  {
    title: resource.resourceToString($r('app.string.local')),
    name: LOCAL
  },
  {
    title: resource.resourceToString($r('app.string.migration_data_object_variables')),
    name: MIGRATION_DATA
  },
  {
    title: resource.resourceToString($r('app.string.persistenceV2')),
    name: PERSISTENCE_V2
  },
  {
    title: resource.resourceToString($r('app.string.param')),
    name: PARMA
  },
  {
    title: resource.resourceToString($r('app.string.provide_and_consume')),
    name: PROVIDE_AND_CONSUME
  },
  {
    title: resource.resourceToString($r('app.string.monitor')),
    name: MONITOR
  },
  {
    title: resource.resourceToString($r('app.string.state')),
    name: STATE
  },
  {
    title: resource.resourceToString($r('app.string.internal_trace')),
    name: INTERNAL_MIGRATE
  }
];

@Builder
function destination(name: string) {
  if (name.startsWith(LOCAL_BUILDER)) {
    localBuilderDestination(name);
  } else if (name.startsWith(EXTEND)) {
    extendDestination(name)
  } else if (name.startsWith(MIGRATION_DATA)) {
    MigrationDestination(name)
  } else if (name.startsWith(SYNC_STATE_MANAGER_$$)) {
    syncStateManagerDestination(name)
  } else if (name.startsWith(LOCAL)) {
    localDestination(name)
  } else if (name.startsWith(PARMA)) {
    paramDestination(name)
  } else if (name.startsWith(PERSISTENCE_V2)) {
    persistenceV2Destination(name)
  } else if (name.startsWith(PROVIDE_AND_CONSUME)) {
    provideAndConsumeDestination(name)
  } else if (name.startsWith(MONITOR)) {
    monitorDestination(name)
  } else if (name.startsWith(STATE)) {
    stateDestination(name)
  } else if (name.startsWith(INTERNAL_MIGRATE)) {
    internalTraceDestination(name)
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

  @LocalBuilder
  Title() {
    Column() {
      Search({ value: this.condition })
        .onChange(value => {
          this.condition = value;
        })
        .margin({ start: LengthMetrics.vp(16), end: LengthMetrics.vp(16) })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
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
    .backgroundColor($r('sys.color.comp_background_focus'))
    .title({ builder: this.Title, height: 56 }, {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .navDestination(destination)
  }
}