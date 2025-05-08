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

import { CompletedRoutableCard } from '../../common/Card'
import { Route } from '../../common/Route'
import { AccessibilityText } from './AccessibilityText'
import { AccessibilityGroup } from './AccessibilityGroup'
import resource from '../../common/resource'

export const ACCESSIBILITY_ROUTE_PREFIX: string = 'UniversalAttributesAccessibility';

const routes: Route[] = [
  {
    name: `${ACCESSIBILITY_ROUTE_PREFIX}/AccessibilityText`,
    title: resource.resourceToString($r('app.string.UniversalAttributesAccessibility_title1')),
    description: resource.resourceToString($r('app.string.UniversalAttributesAccessibility_description1')),
  },
  {
    name: `${ACCESSIBILITY_ROUTE_PREFIX}/AccessibilityGroup`,
    title: resource.resourceToString($r('app.string.UniversalAttributesAccessibility_title2')),
    description: resource.resourceToString($r('app.string.UniversalAttributesAccessibility_description2')),
  }
];

@Builder
export function AccessibilityDestination(name: string) {
  if (name == ACCESSIBILITY_ROUTE_PREFIX) {
    AccessibilityExample();
  } else if (name == routes[0].name) {
    AccessibilityText();
  } else if (name == routes[1].name) {
    AccessibilityGroup();
  }
}

@Entry
@Component
struct AccessibilityExample {
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
    .title(resource.resourceToString($r('app.string.pageIndex_UniversalAttributesAccessibility')), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}