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
import { LocalExtendFunctionHandle } from './ExtendFunctionHandle';
import { LocalExtendParameterUsage } from './ExtendParameterUsage';
import { LocalExtendExtendPositiveExample } from './ExtendPositiveExample';
import { LocalExtendUIStateVariable } from './ExtendUIStateVariable';
import { LocalExtendUsageScenario } from './ExtendUsageScenario';
import { LocalExtendUsageScenario2 } from './ExtendUsageScenariotwo';
import { LocalGlobalFunctionExtension } from './GlobalFunctionExtension';

export const EXTEND: string = 'extend';

const routes: Route[] = [
  {
    name: `${EXTEND}/GlobalFunctionExtension`,
    title: resource.resourceToString($r('app.string.global_function_extension')),
  },
  {
    name: `${EXTEND}/ExtendParameterUsage`,
    title: resource.resourceToString($r('app.string.extend_parameter_usage')),
  },
  {
    name: `${EXTEND}/ExtendFunctionHandle`,
    title: resource.resourceToString($r('app.string.extend_extend_function_handle')),
  },
  {
    name: `${EXTEND}/ExtendUIStateVariable`,
    title: resource.resourceToString($r('app.string.extend_ui_state_variable')),
  },
  {
    name: `${EXTEND}/ExtendPositiveExample`,
    title: resource.resourceToString($r('app.string.extend_positive_example')),
  },
  {
    name: `${EXTEND}/ExtendUsageScenario`,
    title: resource.resourceToString($r('app.string.extend_usage_scenario')),
  },
  {
    name: `${EXTEND}/ExtendUsageScenariotwo`,
    title: resource.resourceToString($r('app.string.extend_usage_scenario_two')),
  }
];

@Builder
export function extendDestination(name: string) {
  if (name === EXTEND) {
    ExtendExample();
  } else if (name === `${EXTEND}/GlobalFunctionExtension`) {
    LocalGlobalFunctionExtension()
  } else if (name === `${EXTEND}/ExtendParameterUsage`) {
    LocalExtendParameterUsage()
  } else if (name === `${EXTEND}/ExtendFunctionHandle`) {
    LocalExtendFunctionHandle();
  } else if (name === `${EXTEND}/ExtendUIStateVariable`) {
    LocalExtendUIStateVariable();
  } else if (name === `${EXTEND}/ExtendPositiveExample`) {
    LocalExtendExtendPositiveExample();
  } else if (name === `${EXTEND}/ExtendUsageScenario`) {
    LocalExtendUsageScenario();
  } else if (name === `${EXTEND}/ExtendUsageScenariotwo`) {
    LocalExtendUsageScenario2();
  }
}

@Entry
@Component
struct ExtendExample {
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
    .title($r('app.string.extend'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}