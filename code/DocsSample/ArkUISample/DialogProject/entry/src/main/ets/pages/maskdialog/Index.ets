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
import { CustomDialogAnimation } from './CustomDialogAnimation';
import { CustomDialogControl } from './CustomDialogControl';

export const Mask_ROUTE_PREFIX: string = 'Mask_Mask_ROUTE_PREFIX';

// $r('app.string.xxx')需要替换为开发者所需的资源文件
const routes: Route[] = [
  {
    name: `${Mask_ROUTE_PREFIX}/CustomDialogAnimation`,
    title: resource.resourceToString($r('app.string.CustomDialogAnimation_title')),
    description: $r('app.string.CustomDialogAnimation_desc'),
  },
  {
    name: `${Mask_ROUTE_PREFIX}/CustomDialogControl`,
    title: resource.resourceToString($r('app.string.CustomDialogControl_title')),
    description: $r('app.string.CustomDialogControl_desc'),
  }
]

@Builder
export function MaskDestination(name: string) {
  if (name === Mask_ROUTE_PREFIX) {
    MaskCustomExample();
  } else if (name === routes[0].name) {
    CustomDialogAnimation();
  } else if (name === routes[1].name) {
    CustomDialogControl();
  }
}

@Entry
@Component
struct MaskCustomExample {
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
      .contentStartOffset(20)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor('#f1f3f5')
    .title('', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    // 请将$r('app.string.Mask_CustomDialog_dialog')替换为实际资源文件，在本示例中该资源文件的value值为"弹出框蒙层控制"
    .title($r('app.string.Mask_CustomDialog_dialog'))
  }
}