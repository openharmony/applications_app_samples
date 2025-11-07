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
import resource from '../../common/Resource';
import { Route } from '../../common/Route';
import { PersistenceV2Page1Decorator } from './page/Page1';
import { Page2Builder } from './page/Page2';
import { PersistenceV2ConnectMigration1Decorator } from './PersistenceV2ConnectMigration1';
import { PersistenceV2ConnectMigration2Decorator } from './PersistenceV2ConnectMigration2';
import { PersistenceV2GlobalConnectDecorator } from './PersistenceV2GlobalConnect';
import { PersistenceV2ModuleConnectStorage1Decorator } from './PersistenceV2ModuleConnectStorage1';
import { PersistenceV2ModuleConnectStorage2Decorator } from './PersistenceV2ModuleConnectStorage2';


export const PERSISTENCE_V2: string = 'persistence_v2';

const routes: Route[] = [
  {
    name: `${PERSISTENCE_V2}/PersistenceV2_Page1`,
    title: resource.resourceToString($r('app.string.persistence_v2_page1')),
  },
  {
    name: `${PERSISTENCE_V2}/PersistenceV2_Page2`,
    title: resource.resourceToString($r('app.string.persistence_v2_page2')),
  },
  {
    name: `${PERSISTENCE_V2}/PersistenceV2_GlobalConnect`,
    title: resource.resourceToString($r('app.string.persistence_v2_global_connect')),
  },
  {
    name: `${PERSISTENCE_V2}/PersistenceV2_ModuleConnectStorage1`,
    title: resource.resourceToString($r('app.string.persistence_v2_module_connect_storage1')),
  },
  {
    name: `${PERSISTENCE_V2}/PersistenceV2_ModuleConnectStorage2`,
    title: resource.resourceToString($r('app.string.persistence_v2_module_connect_storage2')),
  },
  {
    name: `${PERSISTENCE_V2}/PersistenceV2_ConnectMigration1`,
    title: resource.resourceToString($r('app.string.persistence_v2_connect_migration1')),
  },
  {
    name: `${PERSISTENCE_V2}/PersistenceV2_ConnectMigration2`,
    title: resource.resourceToString($r('app.string.persistence_v2_connect_migration2')),
  },
];

@Builder
export function persistenceV2Destination(name: string) {
  if (name === PERSISTENCE_V2) {
    PersistenceV2Example();
  } else if (name === `${PERSISTENCE_V2}/PersistenceV2_Page1`) {
    PersistenceV2Page1Decorator()
  } else if (name === `${PERSISTENCE_V2}/PersistenceV2_Page2`) {
    Page2Builder()
  } else if (name === `${PERSISTENCE_V2}/PersistenceV2_GlobalConnect`) {
    PersistenceV2GlobalConnectDecorator()
  } else if (name === `${PERSISTENCE_V2}/PersistenceV2_ModuleConnectStorage1`) {
    PersistenceV2ModuleConnectStorage1Decorator()
  } else if (name === `${PERSISTENCE_V2}/PersistenceV2_ModuleConnectStorage2`) {
    PersistenceV2ModuleConnectStorage2Decorator()
  } else if (name === `${PERSISTENCE_V2}/PersistenceV2_ConnectMigration1`) {
    PersistenceV2ConnectMigration1Decorator()
  } else if (name === `${PERSISTENCE_V2}/PersistenceV2_ConnectMigration2`) {
    PersistenceV2ConnectMigration2Decorator()
  }
}

@Entry
@Component
struct PersistenceV2Example {
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
      .width('100%')
      .height('100%')
      .contentStartOffset(56)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor($r('sys.color.comp_background_focus'))
    .title('persistence_v2', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}