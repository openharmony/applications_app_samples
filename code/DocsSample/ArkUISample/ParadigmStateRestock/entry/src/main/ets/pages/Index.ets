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

import { LengthMetrics } from '@kit.ArkUI';
import { Route } from '../common/Route';
import { RoutableCard } from '../common/Card';
import resource from '../common/Resource';
import { builderParamDestination, BUILDER_PARAM } from './builderParam/Index';
import { mixedStateManageV1V2Destination, MIXED_STATE_MANAGE_V1_V2 } from './mixedStateManageV1V2/Index';


const routes: Route[] = [
  {
    title: resource.resourceToString($r('app.string.builder_param')),
    name: BUILDER_PARAM
  },
  {
    title: resource.resourceToString($r('app.string.mixed_state_manage_v1_v2')),
    name: MIXED_STATE_MANAGE_V1_V2
  },
];

@Builder
function destination(name: string) {
  if (name.startsWith(BUILDER_PARAM)) {
    builderParamDestination(name)
  } else if (name.startsWith(MIXED_STATE_MANAGE_V1_V2)) {
    mixedStateManageV1V2Destination(name)
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
    .backgroundColor($r('sys.color.comp_background_focus'))
    .title({ builder: this.Title, height: 56 }, {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .navDestination(destination)
  }
}