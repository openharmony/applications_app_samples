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
import resource from '../../common/resource';
import { Route } from '../../common/Route';
import { ButtonPopupExample } from './ButtonPopup';
import { CustomPopupExample } from './CustomPopup';
import { AnimationPopupExample } from './PopupAnimation';
import { StatePopupExample } from './PopupStateChange';
import { StylePopupExample } from './PopupStyle';
import { TextPopupExample } from './TextPrompts';


export const Popup_ROUTE_PREFIX: string = 'Popup_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${Popup_ROUTE_PREFIX}/TextPopupExample`,
    title: resource.resourceToString($r('app.string.TextPopup_title')),
    description: $r('app.string.TextPopup_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/onStateChange`,
    title: resource.resourceToString($r('app.string.onStateChange_title')),
    description: $r('app.string.onStateChange_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/ButtonPopupExample`,
    title: resource.resourceToString($r('app.string.ButtonPopup_title')),
    description: $r('app.string.ButtonPopup_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/AnimationPopupExample`,
    title: resource.resourceToString($r('app.string.AnimationPopup_title')),
    description: $r('app.string.AnimationPopup_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/CustomPopupExample`,
    title: resource.resourceToString($r('app.string.CustomPopup_title')),
    description: $r('app.string.CustomPopup_des'),
  },
  {
    name: `${Popup_ROUTE_PREFIX}/StylePopupExample`,
    title: resource.resourceToString($r('app.string.StylePopup_title')),
    description: $r('app.string.StylePopup_des'),
  }
]

@Builder
export function PopupDestination(name: string) {
  if (name === Popup_ROUTE_PREFIX) {
    PopupExample();
  } else if (name === routes[0].name) {
    TextPopupExample();
  } else if (name === routes[1].name) {
    StatePopupExample();
  } else if (name === routes[2].name) {
    ButtonPopupExample();
  } else if (name === routes[3].name) {
    AnimationPopupExample();
  } else if (name === routes[4].name) {
    CustomPopupExample();
  } else if (name === routes[5].name) {
    StylePopupExample();
  }
}

@Entry
@Component
struct PopupExample {
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
    .title($r('app.string.popup'))
  }
}