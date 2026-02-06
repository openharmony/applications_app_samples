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
import resource from '../../common/Resource';
import { SyncUsageExample } from './SyncUsageExample';
import { SyncUsageExampleV2 } from './SyncUsageExampleV2'

export const SYNC_STATE_MANAGER_$$: string = 'sync_state_manager_$$';

const routes: Route[] = [
  {
    name: `${SYNC_STATE_MANAGER_$$}/SyncUsageExample`,
    title: resource.resourceToString($r('app.string.sync_usage_example')),
  },
  {
    name: `${SYNC_STATE_MANAGER_$$}/SyncUsageExampleV2`,
    title: resource.resourceToString($r('app.string.sync_usage_example_v2')),
  }
];

@Builder
export function syncStateManagerDestination(name: string) {
  if (name === SYNC_STATE_MANAGER_$$) {
    SyncStateManagerExample();
  } else if (name === `${SYNC_STATE_MANAGER_$$}/SyncUsageExample`) {
    SyncUsageExample()
  } else if (name === `${SYNC_STATE_MANAGER_$$}/SyncUsageExampleV2`) {
    SyncUsageExampleV2()
  }
}

@Entry
@Component
struct SyncStateManagerExample {
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
    .title($r('app.string.sync_state_manager'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}