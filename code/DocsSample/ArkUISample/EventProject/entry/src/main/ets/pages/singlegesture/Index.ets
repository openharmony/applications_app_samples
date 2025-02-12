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
import { LongPress } from './LongPressGesture';
import { Pan } from './PanGesture';
import { Pinch } from './PinchGesture';
import { Rotation } from './RotationGesture';
import { Swipe } from './SwipeGesture';
import { Tap } from './TapGesture';
import resource from '../../common/resource';

export const Gesture_ROUTE_PREFIX: string = 'gesture';

const routes: Route[] = [
  {
    name: `${Gesture_ROUTE_PREFIX}/TapGesture`,
    title: resource.resourceToString($r('app.string.singlegesture_Index_TapGesture_title')),
    description: resource.resourceToString($r('app.string.singlegesture_Index_TapGesture_description')),
  },
  {
    name: `${Gesture_ROUTE_PREFIX}/LongPress`,
    title: resource.resourceToString($r('app.string.singlegesture_Index_LongPress_title')),
    description: resource.resourceToString($r('app.string.singlegesture_Index_LongPress_description')),
  },
  {
    name: `${Gesture_ROUTE_PREFIX}/Pan`,
    title: resource.resourceToString($r('app.string.singlegesture_Index_Pan_title')),
    description: resource.resourceToString($r('app.string.singlegesture_Index_Pan_description')),
  },
  {
    name: `${Gesture_ROUTE_PREFIX}/Pinch`,
    title: resource.resourceToString($r('app.string.singlegesture_Index_Pinch_title')),
    description: resource.resourceToString($r('app.string.singlegesture_Index_Pinch_description')),
  },
  {
    name: `${Gesture_ROUTE_PREFIX}/Rotation`,
    title: resource.resourceToString($r('app.string.singlegesture_Index_Rotation_title')),
    description: resource.resourceToString($r('app.string.singlegesture_Index_Rotation_description')),
  },
  {
    name: `${Gesture_ROUTE_PREFIX}/Swipe`,
    title: resource.resourceToString($r('app.string.singlegesture_Index_Swipe_title')),
    description: resource.resourceToString($r('app.string.singlegesture_Index_Swipe_description')),
  }
]

@Builder
export function GestureDestination(name: string) {
  if (name === Gesture_ROUTE_PREFIX) {
    GestureExample();
  } else if (name === routes[0].name) {
    Tap();
  } else if (name === routes[1].name) {
    LongPress();
  } else if (name === routes[2].name) {
    Pan();
  } else if (name === routes[3].name) {
    Pinch();
  } else if (name === routes[4].name) {
    Rotation();
  } else if (name === routes[5].name) {
    Swipe();
  }
}

@Entry
@Component
struct GestureExample {
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
    .title($r('app.string.singlegesture_Index_title'))
  }
}