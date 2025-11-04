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
import { LengthMetrics, router, Router } from '@kit.ArkUI'
import { RoutableCard } from '../common/Card';
import resource from '../common/Resource';
import { Route } from '../common/Route';
import { BuilderNodeDemo } from '../homePage/BuilderNode';
import { DecorativeArray } from '../homePage/DecorativeArray';
import { DecorativeComplex } from '../homePage/DecorativeComplex';
import { DecorativeDate } from '../homePage/DecorativeDate';
import { DecorativeInitialized } from '../homePage/DecorativeInitialized';
import { DecorativeMap } from '../homePage/DecorativeMap';
import { DecorativeSet } from '../homePage/DecorativeSet';
import { DragDrop } from '../homePage/DragDrop';
import { NoTwowayBinding } from '../homePage/NoTwowayBinding';
import { ProviderSame } from '../homePage/ProviderSame';
import { TwowayBinding } from '../homePage/TwowayBinding';


const routes: Route[] = [
  {
    title: resource.resourceToString($r('app.string.Twoway_Binding')),
    name: 'TwowayBinding'
  },
  {
    title: resource.resourceToString($r('app.string.No_Twoway_Binding')),
    name: 'NoTwowayBinding'
  },
  {
    title: resource.resourceToString($r('app.string.Decorative_Array')),
    name: 'DecorativeArray'
  },
  {
    title: resource.resourceToString($r('app.string.Decorative_Date')),
    name: 'DecorativeDate'
  },
  {
    title: resource.resourceToString($r('app.string.Decorative_Map')),
    name: 'DecorativeMap'
  },
  {
    title: resource.resourceToString($r('app.string.Decorative_Set')),
    name: 'DecorativeSet'
  },
  {
    title: resource.resourceToString($r('app.string.Drag_Drop')),
    name: 'DragDrop'
  },
  {
    title: resource.resourceToString($r('app.string.Decorative_Complex')),
    name: 'DecorativeComplex'
  },
  {
    title: resource.resourceToString($r('app.string.Provider_Same')),
    name: 'ProviderSame'
  },
  {
    title: resource.resourceToString($r('app.string.Decorative_Initialized')),
    name: 'DecorativeInitialized'
  },
  {
    title: resource.resourceToString($r('app.string.Builder_Node')),
    name: 'BuilderNode'
  }
];

@Builder
function destination(name: string) {
  if (name === 'TwowayBinding') {
    TwowayBinding();
  } else if (name === 'NoTwowayBinding'){
    NoTwowayBinding()
  } else if (name === 'DecorativeArray') {
    DecorativeArray();
  } else if (name === 'DecorativeDate') {
    DecorativeDate();
  } else if (name === 'DecorativeMap') {
    DecorativeMap();
  } else if (name === 'DecorativeSet') {
    DecorativeSet();
  } else if (name === 'DragDrop') {
    DragDrop();
  } else if (name === 'DecorativeComplex') {
    DecorativeComplex();
  } else if (name === 'ProviderSame') {
    ProviderSame();
  } else if (name === 'DecorativeInitialized') {
    DecorativeInitialized();
  } else if (name === 'BuilderNode') {
    BuilderNodeDemo();
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
    Column() {
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
}