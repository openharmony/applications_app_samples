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
import { MonitorDecoratorArraySupport } from './MonitorDecoratorArraySupport';
import { MonitorDecoratorInheritanceSupportObservedV2 } from './MonitorDecoratorInheritanceSupportObservedV2';
import { MonitorLimitationLastListenerWins } from './MonitorLimitationLastListenerWins';
import { MonitorDecoratorLastWrite } from './MonitorDecoratorLastWrite';
import { MonitorDecoratorMultiWatchCompV2 } from './MonitorDecoratorMultiWatchCompV2';
import { MonitorDecoratorMultiWatchObservedV2 } from './MonitorDecoratorMultiWatchObservedV2';
import { MonitorDecoratorObjectSupport } from './MonitorDecoratorObjectSupport';
import { MonitorDecoratorObjectTraceCompV2 } from './MonitorDecoratorObjectTraceCompV2';
import { MonitorDecoratorObjectTraceObservedV2 } from './MonitorDecoratorObjectTraceObservedV2';
import { MonitorWatchDecoratorLimitationsV1 } from './WatchDecoratorLimitationsV1';
import { MonitorLimitationMultiplePathParams } from './MonitorLimitationMultiplePathParams';
import { MonitorLimitationParameterStringConstraint } from './MonitorLimitationParameterStringConstraint';
import { MonitorSceneDeepAttributeChanges } from './MonitorSceneDeepAttributeChanges';
import { MonitorProblemEffectTimeCompV2 } from './MonitorProblemEffectTimeCompV2';
import { MonitorProblemEffectTimeClass } from './MonitorProblemEffectTimeClass';
import { MonitorProblemClassDelayed } from './MonitorProblemClassDelayed';
import { MonitorProblemClassFailureTimeSetComp } from './MonitorProblemClassFailureTimeSetComp';
import { MonitorProblemClassFailureTimeEmptyObject } from './MonitorProblemClassFailureTimeEmptyObject';
import { MonitorProblemParamCounterExample1 } from './MonitorProblemParamCounterExample1';
import { MonitorProblemParamPositiveExample1 } from './MonitorProblemParamPositiveExample1';
import { MonitorProblemParamCounterExample2 } from './MonitorProblemParamCounterExample2';
import { MonitorProblemParamPositiveExample2 } from './MonitorProblemParamPositiveExample2';
import { MonitorProblemParamStateVariables } from './MonitorProblemParamStateVariables';
import { MonitorProblemStateChangeUseAddMonitor } from './MonitorProblemStateChangeUseAddMonitor';

export const MONITOR: string = 'monitor_text';

const routes: Route[] = [
  {
    name: `${MONITOR}/WatchDecoratorLimitationsV1`,
    title: resource.resourceToString($r('app.string.monitor_watch_decorator_limitations_v1')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorDecoratorMultiWatchCompV2`,
    title: resource.resourceToString($r('app.string.monitor_decorator_multi_watch_comp_v2')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorDecoratorObjectTraceCompV2`,
    title: resource.resourceToString($r('app.string.monitor_decorator_object_trace_comp_v2')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorDecoratorMultiWatchObservedV2`,
    title: resource.resourceToString($r('app.string.monitor_decorator_multi_watch_observed_v2')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorDecoratorObjectTraceObservedV2`,
    title: resource.resourceToString($r('app.string.monitor_decorator_object_trace_observed_v2')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorDecoratorInheritanceSupportObservedV2`,
    title: resource.resourceToString($r('app.string.monitor_decorator_inheritance_support_observed_v2')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorDecoratorArraySupport`,
    title: resource.resourceToString($r('app.string.monitor_decorator_array_support')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorDecoratorObjectSupport`,
    title: resource.resourceToString($r('app.string.monitor_decorator_object_support')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorDecoratorLastWrite`,
    title: resource.resourceToString($r('app.string.monitor_decorator_last_write')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorLimitationLastListenerWins`,
    title: resource.resourceToString($r('app.string.monitor_limitation_last_listener_wins')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorLimitationMultiplePathParams`,
    title: resource.resourceToString($r('app.string.monitor_limitation_multiple_path_params')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorSceneDeepAttributeChanges`,
    title: resource.resourceToString($r('app.string.monitor_scene_deep_attribute_changes')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemEffectTimeCompV2`,
    title: resource.resourceToString($r('app.string.monitor_problem_effect_time_comp_v2')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemEffectTimeClass`,
    title: resource.resourceToString($r('app.string.monitor_problem_effect_time_class')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemClassDelayed`,
    title: resource.resourceToString($r('app.string.monitor_problem_class_delayed')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemClassFailureTimeSetComp`,
    title: resource.resourceToString($r('app.string.monitor_problem_class_failure_time_set_comp')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemClassFailureTimeEmptyObject`,
    title: resource.resourceToString($r('app.string.monitor_problem_class_failure_time_empty_object')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemParamCounterExample1`,
    title: resource.resourceToString($r('app.string.monitor_problem_param_counter_example_1')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemParamPositiveExample1`,
    title: resource.resourceToString($r('app.string.monitor_problem_param_positive_example_1')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemParamCounterExample2`,
    title: resource.resourceToString($r('app.string.monitor_problem_param_counter_example_2')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemParamPositiveExample2`,
    title: resource.resourceToString($r('app.string.monitor_problem_param_positive_example_2')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemParamStateVariables`,
    title: resource.resourceToString($r('app.string.monitor_problem_param_state_variables')),
    description: ''
  },
  {
    name: `${MONITOR}/MonitorProblemStateChangeUseAddMonitor`,
    title: resource.resourceToString($r('app.string.monitor_problem_state_change_use_addMonitor')),
    description: ''
  }

];

@Builder
export function monitorDestination(name: string) {
  if (name === MONITOR) {
    SyncStateManagerExample();
  } else if (name === `${MONITOR}/WatchDecoratorLimitationsV1`) {
    MonitorWatchDecoratorLimitationsV1()
  } else if (name === `${MONITOR}/MonitorDecoratorMultiWatchCompV2`) {
    MonitorDecoratorMultiWatchCompV2()
  } else if (name === `${MONITOR}/MonitorDecoratorObjectTraceCompV2`) {
    MonitorDecoratorObjectTraceCompV2()
  } else if (name === `${MONITOR}/MonitorDecoratorMultiWatchObservedV2`) {
    MonitorDecoratorMultiWatchObservedV2()
  } else if (name === `${MONITOR}/MonitorDecoratorObjectTraceObservedV2`) {
    MonitorDecoratorObjectTraceObservedV2()
  } else if (name === `${MONITOR}/MonitorDecoratorInheritanceSupportObservedV2`) {
    MonitorDecoratorInheritanceSupportObservedV2()
  } else if (name === `${MONITOR}/MonitorDecoratorArraySupport`) {
    MonitorDecoratorArraySupport()
  } else if (name === `${MONITOR}/MonitorDecoratorObjectSupport`) {
    MonitorDecoratorObjectSupport()
  } else if (name === `${MONITOR}/MonitorDecoratorLastWrite`) {
    MonitorDecoratorLastWrite()
  } else if (name === `${MONITOR}/MonitorLimitationLastListenerWins`) {
    MonitorLimitationLastListenerWins()
  } else if (name === `${MONITOR}/MonitorLimitationMultiplePathParams`) {
    MonitorLimitationMultiplePathParams()
  } else if (name === `${MONITOR}/MonitorLimitationParameterStringConstraint`) {
    MonitorLimitationParameterStringConstraint()
  } else if (name === `${MONITOR}/MonitorSceneDeepAttributeChanges`) {
    MonitorSceneDeepAttributeChanges()
  } else if (name === `${MONITOR}/MonitorProblemEffectTimeCompV2`) {
    MonitorProblemEffectTimeCompV2()
  } else if (name === `${MONITOR}/MonitorProblemEffectTimeClass`) {
    MonitorProblemEffectTimeClass()
  } else if (name === `${MONITOR}/MonitorProblemClassDelayed`) {
    MonitorProblemClassDelayed()
  } else if (name === `${MONITOR}/MonitorProblemClassFailureTimeSetComp`) {
    MonitorProblemClassFailureTimeSetComp()
  } else if (name === `${MONITOR}/MonitorProblemClassFailureTimeEmptyObject`) {
    MonitorProblemClassFailureTimeEmptyObject()
  } else if (name === `${MONITOR}/MonitorProblemParamCounterExample1`) {
    MonitorProblemParamCounterExample1()
  } else if (name === `${MONITOR}/MonitorProblemParamPositiveExample1`) {
    MonitorProblemParamPositiveExample1()
  } else if (name === `${MONITOR}/MonitorProblemParamCounterExample2`) {
    MonitorProblemParamCounterExample2()
  } else if (name === `${MONITOR}/MonitorProblemParamPositiveExample2`) {
    MonitorProblemParamPositiveExample2()
  } else if (name === `${MONITOR}/MonitorProblemParamStateVariables`) {
    MonitorProblemParamStateVariables()
  } else if (name === `${MONITOR}/MonitorProblemStateChangeUseAddMonitor`) {
    MonitorProblemStateChangeUseAddMonitor()
  }
}

@Entry
@Component
struct SyncStateManagerExample {
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
    .title($r('app.string.monitor'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}