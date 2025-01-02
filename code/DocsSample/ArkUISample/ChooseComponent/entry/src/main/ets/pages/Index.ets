/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { BUTTON_ROUTE_PREFIX, buttonDestination } from './button/Index';
import { LengthMetrics } from '@kit.ArkUI';
import { radioDestination, RADIO_ROUTE_PREFIX } from './radio/Index';
import { RoutableCard } from '../common/Card';
import { Route } from '../common/Route';
import { toggleDestination, TOGGLE_ROUTE_PREFIX } from './toggle/Index';
import resource from '../common/resource';

const routes: Route[] = [
  {
    title: resource.resourceToString($r('app.string.button')),
    name: BUTTON_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.radio')),
    name: RADIO_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.toggle')),
    name: TOGGLE_ROUTE_PREFIX
  }
];

@Builder
function destination(name: string) {
  if (name.startsWith(BUTTON_ROUTE_PREFIX)) {
    buttonDestination(name);
  } else if (name.startsWith(RADIO_ROUTE_PREFIX)) {
    radioDestination(name);
  } else if (name.startsWith(TOGGLE_ROUTE_PREFIX)) {
    toggleDestination(name);
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
    .backgroundColor('#f1f3f5')
    .title({ builder: this.Title, height: 56 }, {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .navDestination(destination)
  }
}