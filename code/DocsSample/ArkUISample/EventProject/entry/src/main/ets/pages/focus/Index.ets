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
import { DefaultFocus } from './DefaultFocus';
import { FocusableExample } from './Focusable';
import { FocusAndClick } from './FocusAndClick';
import { FocusControl } from './FocusController';
import { FocusPrioritySample } from './FocusPriority';
import { FocusScopePriority } from './FocusScopePriority';
import { FocusStyle } from './FocusStyle';
import { OnFocusBlur } from './onFocusBlur';
import resource from '../../common/resource';


export const Focus_ROUTE_PREFIX: string = 'Focus_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${Focus_ROUTE_PREFIX}/onFocusBlur`,
    title: resource.resourceToString($r('app.string.Focus_Index_onFocusBlur_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_onFocusBlur_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusableExample`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_title1')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_description1')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusableExample`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_title2')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_description2')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusableExample`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_title3')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_description3')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusStyle`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusStyle_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusStyle_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusControl`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusControl_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusControl_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusScopePriority`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusScopePriority_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusScopePriority_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusAndClick`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusAndClick_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusAndClick_description')),
  }
]

@Builder
export function FocusDestination(name: string) {
  if (name === Focus_ROUTE_PREFIX) {
    FocusExample();
  } else if (name === routes[0].name) {
    OnFocusBlur();
  } else if (name === routes[1].name) {
    FocusableExample();
  } else if (name === routes[2].name) {
    DefaultFocus();
  } else if (name === routes[3].name) {
    FocusPrioritySample();
  } else if (name === routes[4].name) {
    FocusStyle();
  } else if (name === routes[5].name) {
    FocusControl();
  } else if (name === routes[6].name) {
    FocusScopePriority();
  } else if (name === routes[7].name) {
    FocusAndClick();
  }
}

@Entry
@Component
struct FocusExample {
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
    .title($r('app.string.Focus_Index_title'))
  }
}