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
import resource from '../../common/resource';
import { CreateRichEditor } from './CreateRichEditor';
import { SetAttributes } from './SetAttributes';
import { AddEvent } from './AddEvent';
import { SetUserPresetTextStyles } from './SetUserPresetTextStyles';
import { BackplaneHighlighting } from './BackplaneHighlighting';
import { AddTextContent } from './AddTextContent';
import { AddImageContent } from './AddImageContent';
import { AddBuilderDecoratorContent } from './AddBuilderDecoratorContent';
import { AddSymbolSpanContent } from './AddSymbolSpanContent';
import { GetGraphicInfoInComponent } from './GetGraphicInfoInComponent';

export const RICH_EDITOR_ROUTE_PREFIX: string = 'RichEditor';

const routes: Route[] = [
  {
    name: `${RICH_EDITOR_ROUTE_PREFIX}/CreateRichEditor`,
    title: resource.resourceToString($r('app.string.Create_RichEditor_Component_title')),
    description: $r('app.string.Create_RichEditor_Component_description')
  },
  {
    name: `${RICH_EDITOR_ROUTE_PREFIX}/SetAttributes`,
    title: resource.resourceToString($r('app.string.Set_Attributes_title')),
  },
  {
    name: `${RICH_EDITOR_ROUTE_PREFIX}/AddEvent`,
    title: resource.resourceToString($r('app.string.Add_Event_title')),
  },
  {
    name: `${RICH_EDITOR_ROUTE_PREFIX}/SetUserPresetTextStyles`,
    title: resource.resourceToString($r('app.string.Set_User_PresetText_Styles_title')),
    description: $r('app.string.Set_User_PresetText_Styles_desc')
  },
  {
    name: `${RICH_EDITOR_ROUTE_PREFIX}/BackplaneHighlighting`,
    title: resource.resourceToString($r('app.string.Backplane_Highlighting_title')),
    description: $r('app.string.Backplane_Highlighting_desc')
  },
  {
    name: `${RICH_EDITOR_ROUTE_PREFIX}/AddTextContent`,
    title: resource.resourceToString($r('app.string.Add_TextContent_title')),
    description: $r('app.string.Add_TextContent_desc')
  },
  {
    name: `${RICH_EDITOR_ROUTE_PREFIX}/AddImageContent`,
    title: resource.resourceToString($r('app.string.Add_ImageContent_title')),
    description: $r('app.string.Add_ImageContent_desc')
  },
  {
    name: `${RICH_EDITOR_ROUTE_PREFIX}/AddBuilderDecoratorContent`,
    title: resource.resourceToString($r('app.string.Add_Builder_DecoratorContent_title')),
    description: $r('app.string.Add_Builder_DecoratorContent_desc')
  },
  {
    name: `${RICH_EDITOR_ROUTE_PREFIX}/AddSymbolSpanContent`,
    title: resource.resourceToString($r('app.string.Add_SymbolSpanContent_title')),
    description: $r('app.string.Add_SymbolSpanContent_desc')
  },
  {
    name: `${RICH_EDITOR_ROUTE_PREFIX}/GetGraphicInfoInComponent`,
    title: resource.resourceToString($r('app.string.Get_GraphicInfo_In_Component_title')),
    description: $r('app.string.Get_GraphicInfo_In_Component_desc')
  }
];

@Builder
export function RichEditorDestination(name: string) {
  if (name === RICH_EDITOR_ROUTE_PREFIX) {
    RichEditorExample();
  } else if (name === routes[0].name) {
    CreateRichEditor();
  } else if (name === routes[1].name) {
    SetAttributes();
  } else if (name === routes[2].name) {
    AddEvent();
  } else if (name === routes[3].name) {
    SetUserPresetTextStyles();
  } else if (name === routes[4].name) {
    BackplaneHighlighting();
  } else if (name === routes[5].name) {
    AddTextContent();
  } else if (name === routes[6].name) {
    AddImageContent();
  } else if (name === routes[7].name) {
    AddBuilderDecoratorContent();
  } else if (name === routes[8].name) {
    AddSymbolSpanContent();
  } else if (name === routes[9].name) {
    GetGraphicInfoInComponent();
  }
}

@Entry
@Component
struct RichEditorExample {
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
    .title('RichEditor', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}