/*
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

import { ButtonCustomStyle } from './ButtonCustomStyle';
import { CompletedRoutableCard } from '../../common/Card';
import { CreateButton } from './CreateButton'
import { FloatingButton } from './FloatingButton';
import { Route } from '../../common/Route';
import { SetButtonType } from './SetButtonType';
import { SubmitForm } from './SubmitForm';
import  resource  from  '../../common/resource'
import { ButtonCaseTouch } from './ButtonCaseTouch';
import { ButtonCaseLogin } from './ButtonCaseLogin';
import { HoverButtonExample } from './HoverButtonExample';

export const BUTTON_ROUTE_PREFIX: string = 'button';

const routes: Route[] = [
  {
    name: `${BUTTON_ROUTE_PREFIX}/CreateButton`,
    title: resource.resourceToString($r('app.string.CreateButton_title')),
    description: $r('app.string.CreateButton_description')
  },
  {
    name: `${BUTTON_ROUTE_PREFIX}/SetButtonType`,
    title: resource.resourceToString($r('app.string.SetButtonType_title')),
    description: $r('app.string.SetButtonType_description')
  },
  {
    name: `${BUTTON_ROUTE_PREFIX}/ButtonCustomStyle`,
    title: resource.resourceToString($r('app.string.ButtonCustomStyle_title')),
    description: $r('app.string.ButtonCustomStyle_description')
  },
  {
    name: `${BUTTON_ROUTE_PREFIX}/SubmitForm`,
    title: resource.resourceToString($r('app.string.SubmitForm_title')),
    description: $r('app.string.SubmitForm_description')
  },
  {
    name: `${BUTTON_ROUTE_PREFIX}/FloatingButton`,
    title: resource.resourceToString($r('app.string.FloatingButton_title')),
    description: $r('app.string.FloatingButton_description')
  },
  {
    name: `${BUTTON_ROUTE_PREFIX}/ButtonCaseTouch`,
    title: resource.resourceToString($r('app.string.ButtonCaseTouch_title')),
    description: $r('app.string.ButtonCaseTouch_desc')
  },
  {
    name: `${BUTTON_ROUTE_PREFIX}/ButtonCaseLogin`,
    title: resource.resourceToString($r('app.string.ButtonCaseLogin_title')),
    description: $r('app.string.ButtonCaseLogin_desc')
  },
  {
    name: `${BUTTON_ROUTE_PREFIX}/HoverButtonExample`,
    title: resource.resourceToString($r('app.string.HoverButtonExample_title')),
    description: $r('app.string.HoverButtonExample_desc')
  }]

@Builder
export function buttonDestination(name: string) {
  if (name === BUTTON_ROUTE_PREFIX) {
    ButtonExample();
  } else if (name === routes[0].name) {
    CreateButton();
  } else if (name === routes[1].name) {
    SetButtonType();
  } else if (name === routes[2].name) {
    ButtonCustomStyle();
  } else if (name === routes[3].name) {
    SubmitForm();
  } else if (name === routes[4].name) {
    FloatingButton();
  } else if (name === routes[5].name) {
    ButtonCaseTouch();
  } else if (name === routes[6].name) {
    ButtonCaseLogin();
  } else if (name === routes[7].name) {
    HoverButtonExample();
  }
}

@Entry
@Component
struct ButtonExample {
  @Consume pathStack: NavPathStack;

  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }
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
    .title('Button', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .title('Button')
  }
}