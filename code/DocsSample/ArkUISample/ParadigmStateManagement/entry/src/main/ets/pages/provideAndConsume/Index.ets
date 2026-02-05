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
import { ProvideConsumeBidirectionalSyncDecorator } from './ProvideConsumeBidirectionalSync';
import { ProvideConsumeDateSyncDecorator } from './ProvideConsumeDateSync';
import { ProvideConsumeDecoratedVariable } from './ProvideConsumeDecoratedVariable';
import { ProvideConsumeFederation } from './ProvideConsumeFederation';
import { ProvideConsumeMapSyncDecorator } from './ProvideConsumeMapSync';
import { ProvideConsumeProperDemoDecorator } from './ProvideConsumeProperDemo';
import { ProvideConsumeProperDemoTwo } from './ProvideConsumeProperDemoTwo';
import { ProvideConsumeProvideAllowOverride } from './ProvideConsumeProvideAllowOverride';
import { ProvideConsumeProvideError } from './ProvideConsumeProvideError';
import { ProvideConsumeSetSyncDecorator } from './ProvideConsumeSetSync';
import { ProvideConsumeThisObject } from './ProvideConsumeThisObject';
import { ProvideConsumeTwoWay } from './ProvideConsumeTwoWay';
import { ProvideConsumeArraySyncDecorator } from './ProvideConsumeArraySync';
import { ProvideConsumeUndefined } from './ProvideConsumeUndefined';


export const PROVIDE_AND_CONSUME: string = 'provide_and_consume';

const routes: Route[] = [
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeProperDemo`,
    title: resource.resourceToString($r('app.string.provide_consume_proper_demo')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeProperDemoTwo`,
    title: resource.resourceToString($r('app.string.provide_consume_proper_demo_two')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeBidirectionalSync`,
    title: resource.resourceToString($r('app.string.provide_consume_bidirectional_sync')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeArraySync`,
    title: resource.resourceToString($r('app.string.provide_consume_array_sync')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeMapSync`,
    title: resource.resourceToString($r('app.string.provide_consume_map_sync')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeSetSync`,
    title: resource.resourceToString($r('app.string.provide_consume_set_sync')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeDateSync`,
    title: resource.resourceToString($r('app.string.provide_consume_date_sync')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeFederation`,
    title: resource.resourceToString($r('app.string.provide_consume_federation')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeProvideAllowOverride`,
    title: resource.resourceToString($r('app.string.provide_consume_provide_allow_override')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeDecoratedVariable`,
    title: resource.resourceToString($r('app.string.provide_consume_decorated_variable')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeTwoWay`,
    title: resource.resourceToString($r('app.string.provide_consume_two_way')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeProvideError`,
    title: resource.resourceToString($r('app.string.provide_consume_provide_error')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeThisObject`,
    title: resource.resourceToString($r('app.string.provide_consume_this_object')),
  },
  {
    name: `${PROVIDE_AND_CONSUME}/ProvideConsumeUndefined`,
    title: resource.resourceToString($r('app.string.provide_consume_undefined')),
  }
];

@Builder
export function provideAndConsumeDestination(name: string) {
  if (name === PROVIDE_AND_CONSUME) {
    ProvideAndConsumeExample();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeProperDemo`) {
    ProvideConsumeProperDemoDecorator();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeProperDemoTwo`) {
    ProvideConsumeProperDemoTwo();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeBidirectionalSync`) {
    ProvideConsumeBidirectionalSyncDecorator();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeMapSync`) {
    ProvideConsumeMapSyncDecorator();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeSetSync`) {
    ProvideConsumeSetSyncDecorator();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeDateSync`) {
    ProvideConsumeDateSyncDecorator();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeFederation`) {
    ProvideConsumeFederation();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeProvideAllowOverride`) {
    ProvideConsumeProvideAllowOverride();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeDecoratedVariable`) {
    ProvideConsumeDecoratedVariable();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeTwoWay`) {
    ProvideConsumeTwoWay();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeProvideError`) {
    ProvideConsumeProvideError();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeThisObject`) {
    ProvideConsumeThisObject();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeArraySync`) {
    ProvideConsumeArraySyncDecorator();
  } else if (name === `${PROVIDE_AND_CONSUME}/ProvideConsumeUndefined`) {
    ProvideConsumeUndefined();
  }
}

@Entry
@Component
struct ProvideAndConsumeExample {
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
    .title($r('app.string.provide_and_consume'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}