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
import resource from '../../common/resource';
import { Route } from '../../common/Route';
import { openCustomDialog } from './openCustomDialog';

export const CustomDialog_ROUTE_PREFIX: string = 'CustomDialog_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${CustomDialog_ROUTE_PREFIX}/Customdialog`,
    title: resource.resourceToString($r('app.string.Customdialog_title')),
    description: $r('app.string.Customdialog_des'),
  }
]

@Builder
export function CustomDialogDestination(name: string) {
  if (name === CustomDialog_ROUTE_PREFIX) {
    CustomDialogExample();
  } else if (name === routes[0].name) {
    openCustomDialog();
  }
}

@Entry
@Component
struct CustomDialogExample {
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
            this.pathStack.pushPath({ name: route.name })
          })
        })
      }
      .contentStartOffset(20)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor('#f1f3f5')
    .title('', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .title('CustomDialog')
  }
}