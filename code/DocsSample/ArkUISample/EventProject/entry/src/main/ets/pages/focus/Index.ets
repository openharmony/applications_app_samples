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
import { DefaultFocus } from './DefaultFocus';
import { FocusableExample } from './Focusable';
import { FocusAndClick } from './FocusAndClick';
import { FocusControl } from './FocusController';
import { FocusPrioritySample } from './FocusPriority';
import { FocusScopePriority } from './FocusScopePriority';
import { FocusStyle } from './FocusStyle';
import { OnFocusBlur } from './onFocusBlur';
import resource from '../../common/resource';
import { FocusActiveExample } from './FocusActive';
import { FocusOnclickExample } from './FocusOnClick';
import { FocusScopeIdExample } from './FocusScopeId';
import { FocusScopePriorityPrevious } from './FocusScopePriorityPrevious';
import { FocusTransferExample } from './FocusTransfer';
import { FocusLinerExample } from './FocusTraversalGuidelines';
import { ProjectAreaFocusFlexExample } from './FrojectAreaFocusFlex';
import { NextFocusExample } from './NextFocus';
import { FocusAndBlurExample } from './OnFocusOnBlurEvents';
import { ProjectAreaFocusExample } from './ProjectionBasedFocus';
import { RequestFocusExample } from './RequestFocus';
import { ScopeFocusExample } from './ScopeFocus';
import { TabIndexExample } from './TabIndex';
import { TabIndexFocusExample } from './TabIndexFocus';
import { TabStopExample } from './TabStop';

export const Focus_ROUTE_PREFIX: string = 'Focus_ROUTE_PREFIX';

// [Start route_push]
// $r('app.string.xxx')需要替换为开发者所需的资源文件
const routes: Route[] = [
  {
    name: `${Focus_ROUTE_PREFIX}/onFocusBlur`,
    title: resource.resourceToString($r('app.string.Focus_Index_onFocusBlur_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_onFocusBlur_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusableExample`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_title1')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_description1')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusableExample`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_title2')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_description2')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusableExample`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_title3')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusableExample_description3')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusStyle`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusStyle_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusStyle_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusControl`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusControl_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusControl_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusScopePriority`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusScopePriority_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusScopePriority_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusAndClick`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusAndClick_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusAndClick_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusActive`,
    title: resource.resourceToString($r('app.string.Pages_Index_Focus_Active_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_Focus_Active_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusOnClick`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusOnClick_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusOnClick_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/FocusScopeId`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusScopeId_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusScopeId_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ FocusScopePriorityPrevious`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusScopePriorityPrevious_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusScopePriorityPrevious_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ FocusTransfer`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusTransfer_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusTransfer_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ FocusTraversalGuidelines`,
    title: resource.resourceToString($r('app.string.Focus_Index_FocusTraversalGuidelines_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FocusTransfer_desFocus_Index_FocusTraver_descriptioncription')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ FrojectAreaFocusFlex`,
    title: resource.resourceToString($r('app.string.Focus_Index_FrojectAreaFocusFlex_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_FrojectAreaFocusFlex_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ NextFocus`,
    title: resource.resourceToString($r('app.string.Focus_Index_NextFocus_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_NextFocus_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ OnFocusOnBlurEvents`,
    title: resource.resourceToString($r('app.string.Focus_Index_OnFocusOnBlurEvents_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_OnFocusOnBlurEvents_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ ProjectionBasedFocus`,
    title: resource.resourceToString($r('app.string.Focus_Index_ProjectionBasedFocus_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_ProjectionBasedFocus_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ RequestFocus`,
    title: resource.resourceToString($r('app.string.Focus_Index_RequestFocus_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_RequestFocus_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ ScopeFocus`,
    title: resource.resourceToString($r('app.string.Focus_Index_ScopeFocus_title')),
    description: resource.resourceToString($r('app.string.Focus_Index_ScopeFocus_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ TabIndex`,
    title: resource.resourceToString($r('app.string.Tab_Index_TabIndex_title')),
    description: resource.resourceToString($r('app.string.Tab_Index_TabIndex_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ TabIndexFocus`,
    title: resource.resourceToString($r('app.string.Tab_Index_TabIndexFocus_title')),
    description: resource.resourceToString($r('app.string.Tab_Index_TabIndexFocus_description')),
  },
  {
    name: `${Focus_ROUTE_PREFIX}/ TabStop`,
    title: resource.resourceToString($r('app.string.Tab_Index_TabStop_title')),
    description: resource.resourceToString($r('app.string.Tab_Index_TabStop_description')),
  }
];
// [End route_push]
@Builder
export function FocusDestination(name: string) {
  if (name === Focus_ROUTE_PREFIX) {
    FocusExample();
  } else if (name === routes[0].name) {
    OnFocusBlur();
  } else if (name === routes[1].name) {
    FocusableExample();
  } else if (name === routes[2].name) {
    DefaultFocus();
  } else if (name === routes[3].name) {
    FocusPrioritySample();
  } else if (name === routes[4].name) {
    FocusStyle();
  } else if (name === routes[5].name) {
    FocusControl();
  } else if (name === routes[6].name) {
    FocusScopePriority();
  } else if (name === routes[7].name) {
    FocusAndClick();
  } else if (name === routes[8].name) {
    FocusActiveExample();
  } else if (name === routes[9].name) {
    FocusOnclickExample();
  } else if (name === routes[10].name) {
    FocusScopeIdExample();
  } else if (name === routes[11].name) {
    FocusScopePriorityPrevious();
  } else if (name === routes[12].name) {
    FocusTransferExample();
  } else if (name === routes[13].name) {
    FocusLinerExample();
  } else if (name === routes[14].name) {
    ProjectAreaFocusFlexExample();
  } else if (name === routes[15].name) {
    NextFocusExample();
  } else if (name === routes[16].name) {
    FocusAndBlurExample();
  } else if (name === routes[17].name) {
    ProjectAreaFocusExample();
  } else if (name === routes[18].name) {
    RequestFocusExample();
  } else if (name === routes[19].name) {
    ScopeFocusExample();
  } else if (name === routes[20].name) {
    TabIndexExample();
  } else if (name === routes[21].name) {
    TabIndexFocusExample();
  } else if (name === routes[22].name) {
    TabStopExample();
  }
}

@Entry
@Component
struct FocusExample {
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
        .contentStartOffset(20)
        .padding({ left: 16, right: 16 })
      }
    }
    .backgroundColor('#f1f3f5')
    .title('', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    // $r('app.string.Focus_Index_title')资源文件中的value值为'焦点事件'
    .title($r('app.string.Focus_Index_title'))
  }
}