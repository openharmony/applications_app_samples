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
import { TextImageComponent } from './TextImageComponent';
import { TextImageAttribute } from './TextImageAttribute';

export const TEXT_IMAGE_MIXED_LAYOUT: string = 'TextImageMixedLayout';

const routes: Route[] = [
    {
      name: `${TEXT_IMAGE_MIXED_LAYOUT}/TextImageComponent`,
      title: resource.resourceToString($r('app.string.TextImage_MixedLayout_Text_1')),
      description: $r('app.string.TextImage_MixedLayout_Component_desc')
    },
    {
      name: `${TEXT_IMAGE_MIXED_LAYOUT}/TextImageAttribute`,
      title: resource.resourceToString($r('app.string.TextImage_MixedLayout_Text_2')),
      description: $r('app.string.TextImage_MixedLayout_Attribute_desc')
    }
];

@Builder
export function TextImageMixedLayoutDestination(name: string) {
  if (name === TEXT_IMAGE_MIXED_LAYOUT) {
    PropertyStringExample();
  } else if (name === routes[0].name) {
    TextImageComponent();
  } else if (name === routes[1].name) {
    TextImageAttribute();
  }
}

@Entry
@Component
struct PropertyStringExample {
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
    .title('TextImageMixedLayout', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}