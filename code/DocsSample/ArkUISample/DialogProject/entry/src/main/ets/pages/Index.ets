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
import { RoutableCard } from '../common/Card';
import resource from '../common/resource';
import { Route } from '../common/Route';
import { CustomDestination, Custom_ROUTE_PREFIX } from './customdialog/Index';
import { FixedDialogDestination, Fixed_ROUTE_PREFIX } from './fixedstyledialog/Index';
import { MenuDestination, Menu_ROUTE_PREFIX } from './Menu/Index';
import { CustomDialogDestination, CustomDialog_ROUTE_PREFIX } from './opencustomdialog/Index';
import { PopupDestination, Popup_ROUTE_PREFIX } from './popup/Index';
import { ToastDestination, Toast_ROUTE_PREFIX } from './Toast/Index';

const routes: Route[] = [
  {
    title: resource.resourceToString($r('app.string.openCustomDialog')),
    name: CustomDialog_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.CustomDialog1')),
    name: Custom_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.FixedStyleDialog1')),
    name: Fixed_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.Menu1')),
    name: Menu_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.Toast1')),
    name: Toast_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.Popup1')),
    name: Popup_ROUTE_PREFIX
  }
];

@Builder
function Destination(name: string) {
  if (name.startsWith(CustomDialog_ROUTE_PREFIX)) {
    CustomDialogDestination(name);
  } else if (name.startsWith(Custom_ROUTE_PREFIX)) {
    CustomDestination(name);
  } else if (name.startsWith(Fixed_ROUTE_PREFIX)) {
    FixedDialogDestination(name);
  } else if (name.startsWith(Menu_ROUTE_PREFIX)) {
    MenuDestination(name);
  } else if (name.startsWith(Toast_ROUTE_PREFIX)) {
    ToastDestination(name);
  } else if (name.startsWith(Popup_ROUTE_PREFIX)) {
    PopupDestination(name);
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
    .navDestination(Destination)
  }
}