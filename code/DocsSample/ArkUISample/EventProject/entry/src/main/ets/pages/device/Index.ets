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
import { HoverEffectSample } from './HoverEffect';
import { Hover } from './OnHover';
import { OnKey } from './OnKey';
import { PreIme } from './OnKeyPreIme';
import { Mouse } from './OnMouse';
import resource from '../../common/resource';


export const Device_ROUTE_PREFIX: string = 'Device_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${Device_ROUTE_PREFIX}/OnHover`,
    title: resource.resourceToString($r('app.string.Hover_Event')),
    description: resource.resourceToString($r('app.string.Hover_Description')),
  },
  {
    name: `${Device_ROUTE_PREFIX}/OnMouse`,
    title: resource.resourceToString($r('app.string.Mouse_Event')),
    description: resource.resourceToString($r('app.string.Mouse_Description'))
  },
  {
    name: `${Device_ROUTE_PREFIX}/HoverEffect`,
    title: resource.resourceToString($r('app.string.Hover_Effect')),
    description: resource.resourceToString($r('app.string.Hover_Effect_Description')),
  },
  {
    name: `${Device_ROUTE_PREFIX}/onKeyEvent `,
    title: resource.resourceToString($r('app.string.Key_Event')),
    description: resource.resourceToString($r('app.string.Key_Description')),
  },
  {
    name: `${Device_ROUTE_PREFIX}/OnKeyPreIme `,
    title: resource.resourceToString($r('app.string.Key_PreIme')),
    description: resource.resourceToString($r('app.string.Key_PreIme_Description')),
  }


]

@Builder
export function DeviceDestination(name: string) {
  if (name === Device_ROUTE_PREFIX) {
    DeviceExample();
  } else if (name === routes[0].name) {
    Hover();
  } else if (name === routes[1].name) {
    Mouse();
  } else if (name === routes[2].name) {
    HoverEffectSample();
  } else if (name === routes[3].name) {
    OnKey();
  } else if (name === routes[4].name) {
    PreIme();
  }
}

@Entry
@Component
struct DeviceExample {
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
    .title($r('app.string.Device_index_title'))
  }
}