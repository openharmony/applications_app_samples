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
import { CreateText } from './CreateText';
import { CustomTextStyle } from './CustomTextStyle';
import { Route } from '../../common/Route';
import { TextAddEvent } from './TextAddEvent';
import { TextHotSearch } from './TextHotSearch';
import { TextSpan } from './TextSpan';
import resource from '../../common/resource';
import { SelectMenu } from './SelectMenu';
import { AIMenu } from './AIMenu';

export const TEXT_ROUTE_PREFIX: string = 'text';

const routes: Route[] = [
  {
    name: `${TEXT_ROUTE_PREFIX}/CreatText`,
    title: resource.resourceToString($r('app.string.CreatText_title')),
    description: $r('app.string.CreatText_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/TextSpan`,
    title: resource.resourceToString($r('app.string.TextSpan_title')),
    description: $r('app.string.TextSpan_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/CustomTextStyle`,
    title: resource.resourceToString($r('app.string.CustomTextStyle_title')),
    description: $r('app.string.CustomTextStyle_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/TextAddEvent`,
    title: resource.resourceToString($r('app.string.TextAddEvent_title')),
    description: $r('app.string.TextAddEvent_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/SelectMenu`,
    title: resource.resourceToString($r('app.string.SetSelectionMenu_title')),
    description: $r('app.string.SetSelectionMenu_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/AIMenu`,
    title: resource.resourceToString($r('app.string.SetUpAIMenu_title')),
    description: $r('app.string.SetUpAIMenu_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/TextHotSearch`,
    title: resource.resourceToString($r('app.string.TextHotSearch_title')),
    description: $r('app.string.TextHotSearch_description')
  }
];

@Builder
export function TextDestination(name: string) {
  if (name === TEXT_ROUTE_PREFIX) {
    TextExample();
  } else if (name === routes[0].name) {
    CreateText();
  } else if (name === routes[1].name) {
    TextSpan();
  } else if (name === routes[2].name) {
    CustomTextStyle();
  } else if (name === routes[3].name) {
    TextAddEvent();
  } else if (name === routes[4].name) {
    SelectMenu();
  } else if (name === routes[5].name) {
    AIMenu();
  } else if (name === routes[6].name) {
    TextHotSearch();
  }
}

@Entry
@Component
struct TextExample {
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
    .title('Text/Span', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}