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
import resource from '../../common/Resource';
import { Route } from '../../common/Route';
import { LocalBuilderLabelDiff } from './BuilderLabelDiff';
import { LocalBuilderThisDiff } from './BuilderThisDiff';
import { LocalBuilderCustomBuilderInComponent } from './CustomBuilderInComponent';
import { LocalBuilderParentRefSync } from './ParentRefSync';
import { LocalBuilderReferencePassing } from './ReferencePassing';
import { LocalBuilderV2LocalBuilderUpdate } from './V2LocalBuilderUpdate';
import { LocalBuilderValuePassing } from './ValuePassing';

export const LOCAL_BUILDER: string = 'local_builder';

const routes: Route[] = [
  {
    name: `${LOCAL_BUILDER}/CustomBuilderInComponent`,
    title: resource.resourceToString($r('app.string.custom_builder_in_component')),
  },
  {
    name: `${LOCAL_BUILDER}/ReferencePassing`,
    title: resource.resourceToString($r('app.string.reference_passing')),
  },
  {
    name: `${LOCAL_BUILDER}/ParentRefSync`,
    title: resource.resourceToString($r('app.string.parent_ref_sync')),
  },
  {
    name: `${LOCAL_BUILDER}/BuilderThisDiff`,
    title: resource.resourceToString($r('app.string.builder_this_diff')),
  },
  {
    name: `${LOCAL_BUILDER}/ValuePassing`,
    title: resource.resourceToString($r('app.string.value_passing')),
  },
  {
    name: `${LOCAL_BUILDER}/BuilderLabelDiff`,
    title: resource.resourceToString($r('app.string.builder_label_diff')),
  },
  {
    name: `${LOCAL_BUILDER}/V2LocalBuilderUpdate`,
    title: resource.resourceToString($r('app.string.v2_local_builder_update')),
  }
];

@Builder
export function localBuilderDestination(name: string) {
  if (name === LOCAL_BUILDER) {
    LocalBuilderExample();
  } else if (name === `${LOCAL_BUILDER}/CustomBuilderInComponent`) {
    LocalBuilderCustomBuilderInComponent();
  } else if (name === `${LOCAL_BUILDER}/ReferencePassing`) {
    LocalBuilderReferencePassing();
  } else if (name === `${LOCAL_BUILDER}/ParentRefSync`) {
    LocalBuilderParentRefSync();
  } else if (name === `${LOCAL_BUILDER}/BuilderThisDiff`) {
    LocalBuilderThisDiff();
  } else if (name === `${LOCAL_BUILDER}/ValuePassing`) {
    LocalBuilderValuePassing();
  } else if (name === `${LOCAL_BUILDER}/BuilderLabelDiff`) {
    LocalBuilderLabelDiff();
  } else if (name === `${LOCAL_BUILDER}/V2LocalBuilderUpdate`) {
    LocalBuilderV2LocalBuilderUpdate();
  }
}

@Entry
@Component
struct LocalBuilderExample {
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
      .width('100%')
      .height('100%')
      .contentStartOffset(56)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor($r('sys.color.comp_background_focus'))
    .title($r('app.string.local_builder'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}