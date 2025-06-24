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
import { CreatSymbolGlyph } from './CreatSymbolGlyph';
import { SymbolGlyphSpanAddToText } from './SymbolAddToText';
import { SymbolGlyphSpanCustomIconAnimation } from './SymbolCustomIconAnimation';
import { SymbolGlyphSpanAddEvent } from './SymbolAddEvent';
import { SymbolGlyphSpanSceneExample } from './SymbolSceneExample';

import { Route } from '../../common/Route';
import resource from '../../common/resource';

export const SYMBOL_GLYPH_SPAN: string = 'symbol';

const routes: Route[] = [
  {
    name: `${SYMBOL_GLYPH_SPAN}/CreatSymbolGlyph`,
    title: resource.resourceToString($r('app.string.CreatSymbolGlyph_title')),
    description: $r('app.string.CreatSymbolGlyph_description')
  },
  {
    name: `${SYMBOL_GLYPH_SPAN}/SymbolGlyphSpanAddToText`,
    title: resource.resourceToString($r('app.string.SymbolGlyphSpanAddToText_title')),
    description: $r('app.string.SymbolGlyphSpanAddToText_description')
  },
  {
    name: `${SYMBOL_GLYPH_SPAN}/SymbolGlyphSpanCustomIconAnimation`,
    title: resource.resourceToString($r('app.string.SymbolGlyphSpanCustomIconAnimation_title')),
    description: $r('app.string.SymbolGlyphSpanCustomIconAnimation_description')
  },
  {
    name: `${SYMBOL_GLYPH_SPAN}/SymbolGlyphSpanAddEvent`,
    title: resource.resourceToString($r('app.string.SymbolGlyphSpanAddEvent_title')),
    description: $r('app.string.SymbolGlyphSpanAddEvent_description')
  },
  {
    name: `${SYMBOL_GLYPH_SPAN}/SymbolGlyphSpanSceneExample`,
    title: resource.resourceToString($r('app.string.SymbolGlyphSpanSceneExample_title')),
    description: $r('app.string.SymbolGlyphSpanSceneExample_description')
  }
];

@Builder
export function SymbolGlyphSpanDestination(name: string) {
  if (name === SYMBOL_GLYPH_SPAN) {
    SymbolGlyphSpanExample();
  } else if (name === routes[0].name) {
    CreatSymbolGlyph();
  } else if (name === routes[1].name) {
    SymbolGlyphSpanAddToText();
  } else if (name === routes[2].name) {
    SymbolGlyphSpanCustomIconAnimation();
  } else if (name === routes[3].name) {
    SymbolGlyphSpanAddEvent();
  } else if (name === routes[4].name) {
    SymbolGlyphSpanSceneExample();
  }
}

@Entry
@Component
struct SymbolGlyphSpanExample {
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
    .title('symbol', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}