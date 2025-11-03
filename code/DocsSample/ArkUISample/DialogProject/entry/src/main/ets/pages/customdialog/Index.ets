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
import { CreateDialog } from './CreateCustomDialog';
import { DialogAnimation } from './DialogAnimation';
import { DialogInteraction } from './DialogInteraction';
import { DialogInteraction1 } from './DialogInteraction1';
import { DialogStyle } from './DialogStyle';
import { NestDialog } from './NestDialog';
import { CreateCustomDialog1 } from './CreateCustomDialog1';
import { DialogInteraction2 } from './DialogInteraction2';
import { DialogInteraction3 } from './DialogInteraction3';
import { DialogAnimation1 } from './DialogAnimation1';
import { DialogStyle1 } from './DialogStyle1';
import { NestDialog1 } from './NestDialog1';
import { DialogWithPhysicalBack } from './DialogWithPhysicalBack';
import { DialogAvoidSoftKeyboard } from './DialogAvoidSoftKeyboard';
import { GetDialogStatus } from './GetDialogStatus';
import { Index as DialogFocusStrategy } from './dialogboxfocuspolicy/DialogFocusStrategy';
import { DialogController } from './dialogcontroller/DialogController';
import { PageLevelDialogBox } from './pageleveldialogbox/PageLevelDialogBox';
import { DialogBoxLayer } from './dialogboxlayermanagement/DialogBoxLayer';

export const Custom_ROUTE_PREFIX: string = 'Custom_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${Custom_ROUTE_PREFIX}/dialog`,
    title: resource.resourceToString($r('app.string.CustomDialog_create_title')),
    description: $r('app.string.CustomDialog_create_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/dialoginteraction`,
    title: resource.resourceToString($r('app.string.CustomDialog_interaction_title')),
    description: $r('app.string.CustomDialog_interaction_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/dialoginteraction1`,
    title: resource.resourceToString($r('app.string.CustomDialog_interaction1_title')),
    description: $r('app.string.CustomDialog_interaction1_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogAnimation`,
    title: resource.resourceToString($r('app.string.CustomDialog_animation_title')),
    description: $r('app.string.CustomDialog_animation_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogStyle`,
    title: resource.resourceToString($r('app.string.CustomDialog_Style_title')),
    description: $r('app.string.CustomDialog_Style_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/NestDialog`,
    title: resource.resourceToString($r('app.string.CustomDialog_nest')),
    description: $r('app.string.CustomDialog_nest_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/CreateCustomDialog1`,
    title: resource.resourceToString($r('app.string.CreateCustomDialog1_title')),
    description: $r('app.string.CreateCustomDialog1_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogInteraction2`,
    title: resource.resourceToString($r('app.string.DialogInteraction2_title')),
    description: $r('app.string.DialogInteraction2_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogInteraction3`,
    title: resource.resourceToString($r('app.string.DialogInteraction3_title')),
    description: $r('app.string.DialogInteraction3_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogAnimation1`,
    title: resource.resourceToString($r('app.string.DialogAnimation1_title')),
    description: $r('app.string.DialogAnimation1_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogStyle1`,
    title: resource.resourceToString($r('app.string.DialogStyle1_title')),
    description: $r('app.string.DialogStyle1_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/NestDialog1`,
    title: resource.resourceToString($r('app.string.NestDialog1_title')),
    description: $r('app.string.NestDialog1_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogWithPhysicalBack`,
    title: resource.resourceToString($r('app.string.DialogWithPhysicalBack_title')),
    description: $r('app.string.DialogWithPhysicalBack_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogAvoidSoftKeyboard`,
    title: resource.resourceToString($r('app.string.DialogAvoidSoftKeyboard_title')),
    description: $r('app.string.DialogAvoidSoftKeyboard_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/GetDialogStatus`,
    title: resource.resourceToString($r('app.string.GetDialogStatus_title')),
    description: $r('app.string.GetDialogStatus_desc'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogFocusStrategy`,
    title: resource.resourceToString($r('app.string.CustomDialog_focus')),
    description: $r('app.string.CustomDialog_focus_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogController`,
    title: resource.resourceToString($r('app.string.CustomDialog_controller')),
    description: $r('app.string.CustomDialog_controller_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/PageLevelDialog`,
    title: resource.resourceToString($r('app.string.CustomDialog_page_level')),
    description: $r('app.string.CustomDialog_controller_des'),
  },
  {
    name: `${Custom_ROUTE_PREFIX}/DialogBoxLayer`,
    title: resource.resourceToString($r('app.string.CustomDialog_box_layer')),
    description: $r('app.string.CustomDialog_layer_des'),
  },
]

@Builder
export function CustomDestination(name: string) {
  if (name === Custom_ROUTE_PREFIX) {
    CustomExample();
  } else if (name === routes[0].name) {
    CreateDialog();
  } else if (name === routes[1].name) {
    DialogInteraction();
  } else if (name === routes[2].name) {
    DialogInteraction1();
  } else if (name === routes[3].name) {
    DialogAnimation();
  } else if (name === routes[4].name) {
    DialogStyle();
  } else if (name === routes[5].name) {
    NestDialog();
  } else if (name === routes[6].name) {
    CreateCustomDialog1();
  } else if (name === routes[7].name) {
    DialogInteraction2();
  } else if (name === routes[8].name) {
    DialogInteraction3();
  } else if (name === routes[9].name) {
    DialogAnimation1();
  } else if (name === routes[10].name) {
    DialogStyle1();
  } else if (name === routes[11].name) {
    NestDialog1();
  } else if (name === routes[12].name) {
    DialogWithPhysicalBack();
  } else if (name === routes[13].name) {
    DialogAvoidSoftKeyboard();
  } else if (name === routes[14].name) {
    GetDialogStatus(); 
  } else if (name === routes[15].name) { 
    DialogFocusStrategy();
  } else if (name === routes[16].name) {
    DialogController();
  } else if (name === routes[17].name) {
    PageLevelDialogBox();
  } else if (name === routes[18].name) {
    DialogBoxLayer();
  }
}

@Entry
@Component
struct CustomExample {
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
    .title($r('app.string.CustomDialog_dialog'))
  }
}