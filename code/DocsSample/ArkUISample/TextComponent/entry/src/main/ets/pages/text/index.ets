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
import { CreateText } from './CreateText';
import { CustomTextStyle } from './CustomTextStyle';
import { Route } from '../../common/Route';
import { TextAddEvent } from './TextAddEvent';
import { TextHotSearch } from './TextHotSearch';
import { TextSpan } from './TextSpan';
import resource from '../../common/resource';
import { SelectMenu } from './SelectMenu';
import { AIMenu } from './AIMenu';
import { TextSpanOnHover } from './TextSpanOnHover';
import { ContentTransition } from './ContentTransition';
import { TextLayout } from './TextLayout';
import { LineSpacing } from './LineSpacing';
import { EnableAutoSpacing } from './EnableAutoSpacing';
import { ShaderStyle } from './ShaderStyle';
import { GeneralEvents } from './GeneralEvents';
import { BindSelectionMenu } from './BindSelectionMenu';
import { SelectionChange } from './SelectionChange';
import { ServiceMenuItems } from './ServiceMenuItems';
import { DisableMenuItems } from './DisableMenuItems';
import { PrepareMenu } from './PrepareMenu';
import { WordBreakd } from './WordBreakd';
import { HeightAdaptivePolicy } from './HeightAdaptivePolicy';
import { LengthMetric } from './LengthMetric';

export const TEXT_ROUTE_PREFIX: string = 'text';

const routes: Route[] = [
  {
    name: `${TEXT_ROUTE_PREFIX}/CreatText`,
    title: resource.resourceToString($r('app.string.CreatText_title')),
    description: $r('app.string.CreatText_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/TextSpan`,
    title: resource.resourceToString($r('app.string.TextSpan_title')),
    description: $r('app.string.TextSpan_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/CustomTextStyle`,
    title: resource.resourceToString($r('app.string.CustomTextStyle_title')),
    description: $r('app.string.CustomTextStyle_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/TextAddEvent`,
    title: resource.resourceToString($r('app.string.TextAddEvent_title')),
    description: $r('app.string.TextAddEvent_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/SelectMenu`,
    title: resource.resourceToString($r('app.string.SetSelectionMenu_title')),
    description: $r('app.string.SetSelectionMenu_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/AIMenu`,
    title: resource.resourceToString($r('app.string.SetUpAIMenu_title')),
    description: $r('app.string.SetUpAIMenu_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/TextHotSearch`,
    title: resource.resourceToString($r('app.string.TextHotSearch_title')),
    description: $r('app.string.TextHotSearch_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/TextSpanOnHover`,
    title: resource.resourceToString($r('app.string.OnClick_onHover')),
    description: $r('app.string.OnClickOnHover_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/ContentTransition`,
    title: resource.resourceToString($r('app.string.Set_digital_flip_effect')),
    description: $r('app.string.Set_digital_flip_effect_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/TextLayout`,
    title: resource.resourceToString($r('app.string.text_layout')),
    description: $r('app.string.text_layout_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/LineSpacing`,
    title: resource.resourceToString($r('app.string.Set_text_line_spacing')),
    description: $r('app.string.Set_text_line_spacing_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/EnableAutoSpacing`,
    title: resource.resourceToString($r('app.string.Automatic_spacing')),
    description: $r('app.string.Automatic_spacing_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/ShaderStyle`,
    title: resource.resourceToString($r('app.string.Shader_Style')),
    description: $r('app.string.Shader_Style_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/GeneralEvents`,
    title: resource.resourceToString($r('app.string.General_Events')),
    description: $r('app.string.General_Events_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/BindSelectionMenu`,
    title: resource.resourceToString($r('app.string.Bind_SelectionMenu')),
    description: $r('app.string.Bind_SelectionMenu_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/SelectionChange`,
    title: resource.resourceToString($r('app.string.Selection_Change')),
    description: $r('app.string.Selection_Change_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/ServiceMenuItems`,
    title: resource.resourceToString($r('app.string.Service_MenuItems')),
    description: $r('app.string.Service_MenuItems_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/DisableMenuItems`,
    title: resource.resourceToString($r('app.string.Disable_MenuItems')),
    description: $r('app.string.Disable_MenuItems_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/PrepareMenu`,
    title: resource.resourceToString($r('app.string.Prepare_Menu')),
    description: $r('app.string.Prepare_Menu_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/WordBreakd`,
    title: resource.resourceToString($r('app.string.Word_Break')),
    description: $r('app.string.Word_Break_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/HeightAdaptivePolicy`,
    title: resource.resourceToString($r('app.string.Height_AdaptivePolicy')),
    description: $r('app.string.Height_AdaptivePolicy_description')
  },
  {
    name: `${TEXT_ROUTE_PREFIX}/LengthMetric`,
    title: resource.resourceToString($r('app.string.Length_Metric')),
    description: $r('app.string.Length_Metric_description')
  }
];

@Builder
export function TextDestination(name: string) {
  if (name === TEXT_ROUTE_PREFIX) {
    TextExample();
  } else if (name === routes[0].name) {
    CreateText();
  } else if (name === routes[1].name) {
    TextSpan();
  } else if (name === routes[2].name) {
    CustomTextStyle();
  } else if (name === routes[3].name) {
    TextAddEvent();
  } else if (name === routes[4].name) {
    SelectMenu();
  } else if (name === routes[5].name) {
    AIMenu();
  } else if (name === routes[6].name) {
    TextHotSearch();
  } else if (name === routes[7].name) {
    TextSpanOnHover();
  } else if (name === routes[8].name) {
    ContentTransition();
  } else if (name === routes[9].name) {
    TextLayout();
  } else if (name === routes[10].name) {
    LineSpacing();
  } else if (name === routes[11].name) {
    EnableAutoSpacing();
  } else if (name === routes[12].name) {
    ShaderStyle();
  } else if (name === routes[13].name) {
    GeneralEvents();
  } else if (name === routes[14].name) {
    BindSelectionMenu();
  } else if (name === routes[15].name) {
    SelectionChange();
  } else if (name === routes[16].name) {
    ServiceMenuItems();
  } else if (name === routes[17].name) {
    DisableMenuItems();
  } else if (name === routes[18].name) {
    PrepareMenu();
  } else if (name === routes[19].name) {
    WordBreakd();
  } else if (name === routes[20].name) {
    HeightAdaptivePolicy();
  } else if (name === routes[21].name) {
    LengthMetric();
  }
}

@Entry
@Component
struct TextExample {
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
      .contentStartOffset(56)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor('#f1f3f5')
    .title('Text/Span', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}