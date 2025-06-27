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
import { CreatTextInput } from './CreatTextInput';
import { CustomTextInputStyle } from './CustomTextInputStyle';
import { KeyboardAvoidance } from './KeyboardAvoidance';
import { LoginRegisterPage } from './LoginRegisterPage';
import { SetTextInputType } from './SetTextInputType';
import { TextInputAddEvent } from './TextInputAddEvent';
import resource from '../../common/resource';
import { SelectMenu } from './SelectMenu';
import { AutoFill } from './AutoFill';
import { SetOmissionProperty } from './SetOmissionProperty';
import { CursorAvoidance } from './CursorAvoidance';

export const INPUT_ROUTE_PREFIX: string = 'TextInput';

const routes: Route[] = [
  {
    name: `${INPUT_ROUTE_PREFIX}/CreatTextInput`,
    title: resource.resourceToString($r('app.string.CreatTextInput_title')),
    description: $r('app.string.CreatTextInput_description')
  },
  {
    name: `${INPUT_ROUTE_PREFIX}/SetTextInputType`,
    title: resource.resourceToString($r('app.string.SetTextInputType_title')),
    description: $r('app.string.SetTextInputType_description')
  },
  {
    name: `${INPUT_ROUTE_PREFIX}/CustomTextInputStyle`,
    title: resource.resourceToString($r('app.string.CustomTextInputStyle_title')),
    description: $r('app.string.CustomTextInputStyle_description')
  },
  {
    name: `${INPUT_ROUTE_PREFIX}/TextInputAddEvent`,
    title: resource.resourceToString($r('app.string.TextInputAddEvent_title')),
    description: $r('app.string.TextInputAddEvent_description')
  },
  {
    name: `${INPUT_ROUTE_PREFIX}/SelectMenu`,
    title: resource.resourceToString($r('app.string.SelectionMenu_title')),
    description: $r('app.string.SelectionMenu_description')
  },
  {
    name: `${INPUT_ROUTE_PREFIX}/AutoFill`,
    title: resource.resourceToString($r('app.string.Auto_Fill')),
    description: $r('app.string.Auto_Fill_description')
  },
  {
    name: `${INPUT_ROUTE_PREFIX}/SetOmissionProperty`,
    title: resource.resourceToString($r('app.string.Set_Omission_Property')),
    description: $r('app.string.Set_Omission_Property_description')
  },
  {
    name: `${INPUT_ROUTE_PREFIX}/KeyboardAvoidance`,
    title: resource.resourceToString($r('app.string.KeyboardAvoidance_title')),
    description: $r('app.string.KeyboardAvoidance_description')
  },
  {
    name: `${INPUT_ROUTE_PREFIX}/CursorAvoidance`,
    title: resource.resourceToString($r('app.string.CursorAvoidance_title')),
    description: $r('app.string.CursorAvoidance_description')
  },
  {
    name: `${INPUT_ROUTE_PREFIX}/LoginRegisterPage`,
    title: resource.resourceToString($r('app.string.LoginRegisterPage_title')),
    description: $r('app.string.LoginRegisterPage_description')
  }
];

@Builder
export function TextInputDestination(name: string) {
  if (name === INPUT_ROUTE_PREFIX) {
    TextInputExample();
  } else if (name === routes[0].name) {
    CreatTextInput();
  } else if (name === routes[1].name) {
    SetTextInputType();
  } else if (name === routes[2].name) {
    CustomTextInputStyle();
  } else if (name === routes[3].name) {
    TextInputAddEvent();
  } else if (name === routes[4].name) {
    SelectMenu();
  } else if (name === routes[5].name) {
    AutoFill();
  } else if (name === routes[6].name) {
    SetOmissionProperty();
  } else if (name === routes[7].name) {
    KeyboardAvoidance();
  } else if (name === routes[8].name) {
    CursorAvoidance();
  } else if (name === routes[9].name) {
    LoginRegisterPage();
  }
}

@Entry
@Component
struct TextInputExample {
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Scroll() {
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
      }.id('scroll_')
    }
    .backgroundColor('#f1f3f5')
    .title('TextInput/TextArea', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}