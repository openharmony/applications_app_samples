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
import { CompletedRoutableCard } from "../../../common/Card";
import resource from "../../../common/resource";
import { Route } from "../../../common/Route";
import { DisableMenuItems } from "./DisableMenuItems";
import { DisableSystemServiceMenuItems } from "./DisableSystemServiceMenuItems";

export const INPUT_ROUTE_PREFIX: string = 'ProhibitSelectMenu';

const routes: Route[] = [
  {
    name: `${INPUT_ROUTE_PREFIX}/DisableSystemServiceMenuItems`,
    title: resource.resourceToString($r('app.string.ProhibitSelectMenu_title_1')),
    description: $r('app.string.ProhibitSelectMenu_description_1')
  },
  {
    name: `${INPUT_ROUTE_PREFIX}/DisableMenuItems`,
    title: resource.resourceToString($r('app.string.ProhibitSelectMenu_title_2')),
    description: $r('app.string.ProhibitSelectMenu_description_2')
  }
];

@Builder
export function ProhibitSelectDestination(name: string) {
    if (name === routes[0].name) {
    DisableSystemServiceMenuItems();
  } else if (name === routes[1].name) {
    DisableMenuItems();
  }
}

@Entry
@Component
export struct ProhibitSelectionMenu {
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


