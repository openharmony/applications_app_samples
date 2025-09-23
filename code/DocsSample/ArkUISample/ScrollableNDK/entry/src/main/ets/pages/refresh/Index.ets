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
import { RefreshList } from './RefreshList';
import { Route } from '../../common/Route';
import resource from '../../common/Resource';

export const REFRESH_ROUTE_PREFIX: string = 'refresh';

const routes: Route[] = [
  {
    name: `${REFRESH_ROUTE_PREFIX}/RefreshList`,
    title: resource.resourceToString($r('app.string.RefreshList_title')),
    description: $r('app.string.RefreshList_description')
  },
];

@Builder
export function refreshDestination(name: string) {
  if (name === REFRESH_ROUTE_PREFIX) {
    RefreshExample();
  } else if (name === `${REFRESH_ROUTE_PREFIX}/RefreshList`) {
    RefreshList();
  }
}

@Entry
@Component
struct RefreshExample {
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
      .height('100%')
      .width('100%')
    }
    .backgroundColor($r('sys.color.comp_background_focus'))
    .title('Refresh', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}