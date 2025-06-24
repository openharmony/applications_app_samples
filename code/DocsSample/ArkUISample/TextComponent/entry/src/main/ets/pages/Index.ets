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

import { LengthMetrics } from '@kit.ArkUI';
import { RoutableCard } from '../common/Card';
import { Route } from '../common/Route';
import { TextDestination, TEXT_ROUTE_PREFIX } from './text';
import { TextInputDestination, INPUT_ROUTE_PREFIX } from './textInput';
import { RichEditorDestination, RICH_EDITOR_ROUTE_PREFIX } from './richEditor';
import { SymbolGlyphSpanDestination, SYMBOL_GLYPH_SPAN } from './symbol';
import { PropertyStringDestination, PROPERTY_STRING_ROUTE_PREFIX } from './propertyString';
import { NDKDestination, NDK_ROUTE_PREFIX } from './ndk';
import resource from '../common/resource';

const routes: Route[] = [
  {
    title: resource.resourceToString($r('app.string.pageIndex_Text')),
    name: TEXT_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.pageIndex_TextInput')),
    name: INPUT_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.pageIndex_RichEditor')),
    name: RICH_EDITOR_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.pageIndex_symbolGlyphSpan')),
    name: SYMBOL_GLYPH_SPAN
  },
  {
    title: resource.resourceToString($r('app.string.pageIndex_PropertyString')),
    name: PROPERTY_STRING_ROUTE_PREFIX
  },
  {
    title: resource.resourceToString($r('app.string.pageIndex_TextNDKUI')),
    name: NDK_ROUTE_PREFIX
  }
];

@Builder
function Destination(name: string) {
  if (name.startsWith(TEXT_ROUTE_PREFIX)) {
    TextDestination(name);
  } else if (name.startsWith(INPUT_ROUTE_PREFIX)) {
    TextInputDestination(name);
  } else if (name.startsWith(RICH_EDITOR_ROUTE_PREFIX)) {
    RichEditorDestination(name);
  } else if (name.startsWith(SYMBOL_GLYPH_SPAN)) {
    SymbolGlyphSpanDestination(name);
  } else if (name.startsWith(PROPERTY_STRING_ROUTE_PREFIX)) {
    PropertyStringDestination(name);
  }else if (name.startsWith(NDK_ROUTE_PREFIX)) {
    NDKDestination(name);
  }
}

@Entry
@Component
struct Index {
  @State condition: string = '';
  @Provide pathStack: NavPathStack = new NavPathStack();

  getFilteredRoutes(): Route[] {
    if (!this.condition) {
      return routes;
    }
    return routes.filter((route: Route) => {
      return route.title.includes(this.condition);
    })
  }

  @LocalBuilder
  Title() {
    Column() {
      Search({ value: this.condition })
        .onChange(value => {
          this.condition = value;
        })
        .margin({ start: LengthMetrics.vp(16), end: LengthMetrics.vp(16) })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
  }

  build() {
    Navigation(this.pathStack) {
      List({ space: 12 }) {
        ForEach(this.getFilteredRoutes(), (route: Route) => {
          ListItem() {
            RoutableCard({ title: route.title })
          }
          .width('100%')
          .onClick(() => {
            this.pathStack.pushPath({ name: route.name });
          })
        })
      }
      .padding({ start: LengthMetrics.vp(16), end: LengthMetrics.vp(16) })
      .contentStartOffset(56)
      .height('100%')
      .width('100%')
    }
    .backgroundColor('#f1f3f5')
    .title({ builder: this.Title, height: 56 }, {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .navDestination(Destination)
  }
}