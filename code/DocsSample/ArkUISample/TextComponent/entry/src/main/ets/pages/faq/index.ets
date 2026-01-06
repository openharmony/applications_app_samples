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
import { CursorPersistsWhenTextInputIsCoveredExample } from './CursorPersistsWhenTextInputIsCovered';
import { HowToDrawMultipleDecorationLinesExample } from './HowToDrawMultipleDecorationLines';
import { HowToFixIncorrectCharacterDisplayDemoAdaptExample } from './HowToFixIncorrectCharacterDisplayDemoAdapt';
import { HowToFixIncorrectCharacterDisplayDemoLeftExample } from './HowToFixIncorrectCharacterDisplayDemoLeft';
import { HowToFixIncorrectCharacterDisplayShowEffectExample } from './HowToFixIncorrectCharacterDisplayShowEffect';


export const TEXT_FAQ: string = 'faq';


const routes: Route[] = [
  {
    name: `${TEXT_FAQ}/TextInputCaretShowOutOfExpect`,
    title: resource.resourceToString($r('app.string.Cursor_Persists_When_TextInput_Is_Covered')),
    description: $r('app.string.Cursor_Persists_When_TextInput_Is_Covered_description')
  },
  {
    name: `${TEXT_FAQ}/HowToFixIncorrectCharacterDisplayShowEffect`,
    title: resource.resourceToString($r('app.string.How_To_Fix_Incorrect_Character_Display_Show_Effect')),
    description: $r('app.string.How_To_Fix_Incorrect_Character_Display_Show_Effect_description')
  },
  {
    name: `${TEXT_FAQ}/HowToFixIncorrectCharacterDisplayDemoLeft`,
    title: resource.resourceToString($r('app.string.How_To_Fix_Incorrect_Character_Display_Demo_Left')),
    description: $r('app.string.How_To_Fix_Incorrect_Character_Display_Demo_Left_description')
  },
  {
    name: `${TEXT_FAQ}/HowToFixIncorrectCharacterDisplayDemoAdapt`,
    title: resource.resourceToString($r('app.string.How_To_Fix_Incorrect_Character_Display_Demo_Adapt')),
    description: $r('app.string.How_To_Fix_Incorrect_Character_Display_Demo_Adapt_description')
  },
  {
    name: `${TEXT_FAQ}/How_To_Draw_Multiple_Decoration_Lines`,
    title: resource.resourceToString($r('app.string.How_To_Draw_Multiple_Decoration_Lines')),
    description: $r('app.string.How_To_How_To_Draw_Multiple_Decoration_Lines_description')
  },
  {
    name: `${TEXT_FAQ}/CursorPersistsWhenTextInputIsCovered`,
    title: resource.resourceToString($r('app.string.How_To_Draw_Multiple_Decoration_Lines')),
    description: $r('app.string.Special_Characters_Display_Incorrectly_description')
  },
];


@Builder
export function TextFAQDestination(name: string) {
  if (name === TEXT_FAQ) {
    TextFAQExample();
  } else if (name === routes[0].name) {
    CursorPersistsWhenTextInputIsCoveredExample();
  } else if (name === routes[1].name) {
    HowToFixIncorrectCharacterDisplayShowEffectExample();
  } else if (name === routes[2].name) {
    HowToFixIncorrectCharacterDisplayDemoLeftExample();
  } else if (name === routes[3].name) {
    HowToFixIncorrectCharacterDisplayDemoAdaptExample();
  } else if (name === routes[4].name) {
    HowToDrawMultipleDecorationLinesExample();
  } else if (name === routes[5].name) {
    CursorPersistsWhenTextInputIsCoveredExample();
  }
}


@Entry
@Component
struct TextFAQExample {
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
    .title('TextFAQ', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}