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

import { Route } from '../common/Route';
import { RoutableCard } from '../common/Card';
import resource from '../common/resource';
import { LengthMetrics } from '@kit.ArkUI';
import { OperationNodeTree } from './OperationNodeTree';
import { RenderingProperties } from './RenderingProperties';
import { CustomDraw } from './CustomDraw';
import { CustomDrawCanvas } from './CustomDrawCanvas';
import { CustomDrawCanvasNative } from './CustomDrawCanvasNative';
import { SetLabel } from './SetLabel';
import { CheckRanderNodeDisposed } from './CheckRanderNodeDisposed';

const routes: Route[] = [
  {
    title: resource.resourceToString($r('app.string.OperationNodeTree')),
    name: 'OperationNodeTree'
  },
  {
    title: resource.resourceToString($r('app.string.RenderingProperties')),
    name: 'RenderingProperties'
  },
  {
    title: resource.resourceToString($r('app.string.CustomDraw')),
    name: 'CustomDraw'
  },
  {
    title: resource.resourceToString($r('app.string.CustomDrawCanvas')),
    name: 'CustomDrawCanvas'
  },
  {
    title: resource.resourceToString($r('app.string.CustomDrawCanvasNative')),
    name: 'CustomDrawCanvasNative'
  },
  {
    title: resource.resourceToString($r('app.string.SetLabel')),
    name: 'SetLabel'
  },
  {
    title: resource.resourceToString($r('app.string.CheckRanderNodeDisposed')),
    name: 'CheckRanderNodeDisposed'
  }
];

@Builder
function destination(name: string) {
  if (name === routes[0].name) {
    OperationNodeTree();
  } else if (name === routes[1].name) {
    RenderingProperties();
  } else if (name === routes[2].name) {
    CustomDraw();
  } else if (name === routes[3].name) {
    CustomDrawCanvas();
  } else if (name === routes[4].name) {
    CustomDrawCanvasNative();
  } else if (name === routes[5].name) {
    SetLabel();
  } else if (name === routes[6].name) {
    CheckRanderNodeDisposed();
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
        .margin({ start: LengthMetrics.vp(16), end: LengthMetrics.vp(16) });
    }
    .justifyContent(FlexAlign.Center)
    .height('100%');
  }

  build() {
    Navigation(this.pathStack) {
      List({ space: 12 }) {
        ForEach(this.getFilteredRoutes(), (route: Route) => {
          ListItem() {
            RoutableCard({ title: route.title });
          }
          .width('100%')
          .onClick(() => {
            this.pathStack.pushPath({ name: route.name });
          });
        });
      }
      .padding({ start: LengthMetrics.vp(16), end: LengthMetrics.vp(16) })
      .contentStartOffset(56)
      .height('100%')
      .width('100%');
    }
    .backgroundColor('#f1f3f5')
    .title({ builder: this.Title, height: 56 }, {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .navDestination(destination);
  }
}