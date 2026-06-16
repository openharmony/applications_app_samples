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

import { CompletedRoutableCard } from '../../common/Card';
import { Route } from '../../common/Route';
import resource from '../../common/resource';
import { CustomLazyColumnLayoutSample } from './CustomLazyColumnLayoutSample';
import { CustomLazyGridLayoutSample } from './CustomLazyGridLayoutSample';
import { CustomLazyWaterFlowLayoutSample } from './CustomLazyWaterFlowLayoutSample';

export const LAZY_CUSTOM_LAYOUT_ROUTE_PREFIX: string = 'lazyCustomLayout';

const routes: Route[] = [
  {
    name: `${LAZY_CUSTOM_LAYOUT_ROUTE_PREFIX}/CustomLazyColumnLayoutSample`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.customLazyColumnLayout_title'))},
    description: $r('app.string.customLazyColumnLayout_description')
  },
  {
    name: `${LAZY_CUSTOM_LAYOUT_ROUTE_PREFIX}/CustomLazyGridLayoutSample`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.customLazyGridLayout_title'))},
    description: $r('app.string.customLazyGridLayout_description')
  },
  {
    name: `${LAZY_CUSTOM_LAYOUT_ROUTE_PREFIX}/CustomLazyWaterFlowLayoutSample`,
    title: (context: Context) => { return resource.resourceToString(context, $r('app.string.customLazyWaterFlowLayout_title'))},
    description: $r('app.string.customLazyWaterFlowLayout_description')
  }
];

@Builder
export function lazyCustomLayoutDestination(name: string) {
  if (name === LAZY_CUSTOM_LAYOUT_ROUTE_PREFIX) {
    LazyCustomLayoutExample();
  } else if (name === routes[0].name) {
    CustomLazyColumnLayoutSample();
  } else if (name === routes[1].name) {
    CustomLazyGridLayoutSample();
  } else if (name === routes[2].name) {
    CustomLazyWaterFlowLayoutSample();
  }
}

@Entry
@Component
struct LazyCustomLayoutExample {
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
    }
    .backgroundColor('#f1f3f5')
    .title($r('app.string.lazyCustomLayout_Title'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}