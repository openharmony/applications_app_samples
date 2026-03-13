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
import resource from '../../common/Resource';
import { StateSceneSimpleType } from './StateSceneSimpleType';
import { StateChangeObservationObject } from './StateChangeObservationObject';
import { StateChangeObservationArray } from './StateChangeObservationArray';
import { StateSceneTypeClass } from './StateSceneTypeClass';
import { StateSceneTypeMap } from './StateSceneTypeMap';
import { StateSceneTypeArray } from './StateSceneTypeArray';
import { StateSceneTypeSet } from './StateSceneTypeSet';
import { StateSceneTypeDate } from './StateSceneTypeDate';
import { StateSceneJointTypeInstance } from './StateSceneJointTypeInstance';
import { PlayDetailPageOpposite } from './playDetailPageOpposite/PlayDetailPage';
import { PlayDetailPagePositive } from './playDetailPagePositive/PlayDetailPage';
import { StateProblemThisUnableObserveOpposite } from './StateProblemThisUnableObserveOpposite';
import { StateProblemThisUnableObservePositive } from './StateProblemThisUnableObservePositive';
import { StateProblemStateUiRefreshExample01 } from './StateProblemStateUiRefreshExample01';
import { StateProblemStateUiRefreshExample02 } from './StateProblemStateUiRefreshExample02';
import { StateProblemStateUiRefreshExample03 } from './StateProblemStateUiRefreshExample03';
import { StateProblemComplexConstantRepeatRefresh } from './StateProblemComplexConstantRepeatRefresh';
import { StateProblemComplexSolution01 } from './StateProblemComplexSolution01';
import { StateProblemComplexSolution02 } from './StateProblemComplexSolution02';
import { StateProblemNotUpdateInBuildError01 } from './StateProblemNotUpdateInBuildError01';
import { StateProblemABCallUiRefreshOpposite } from './StateProblemABCallUiRefreshOpposite';
import { StateProblemABCallUiRefreshPositive } from './StateProblemABCallUiRefreshPositive';
import { StateProblemUnregisterStateCallback } from './StateProblemUnregisterStateCallback';
import { StateInputUndefined } from './StateInputUndefined';

export const STATE: string = 'state_text';

const routes: Route[] = [
  {
    name: `${STATE}/StateSceneSimpleType`,
    title: resource.resourceToString($r('app.string.state_scene_simple_type')),
  },
  {
    name: `${STATE}/StateChangeObservationObject`,
    title: resource.resourceToString($r('app.string.state_change_observation_object')),
  },
  {
    name: `${STATE}/StateChangeObservationArray`,
    title: resource.resourceToString($r('app.string.state_change_observation_array')),
  },
  {
    name: `${STATE}/StateInputUndefined`,
    title: resource.resourceToString($r('app.string.state_input_undefined')),
  },
  {
    name: `${STATE}/StateSceneTypeClass`,
    title: resource.resourceToString($r('app.string.state_scene_type_class')),
  },
  {
    name: `${STATE}/StateSceneTypeArray`,
    title: resource.resourceToString($r('app.string.state_scene_type_array')),
  },
  {
    name: `${STATE}/StateSceneTypeMap`,
    title: resource.resourceToString($r('app.string.state_scene_type_map')),
  },
  {
    name: `${STATE}/StateSceneTypeSet`,
    title: resource.resourceToString($r('app.string.state_scene_type_set')),
  },
  {
    name: `${STATE}/StateSceneTypeDate`,
    title: resource.resourceToString($r('app.string.state_scene_type_date')),
  },
  {
    name: `${STATE}/StateSceneJointTypeInstance`,
    title: resource.resourceToString($r('app.string.state_scene_joint_type_instance')),
  },
  {
    name: `${STATE}/PlayDetailPageOpposite`,
    title: resource.resourceToString($r('app.string.state_problem_arrow_function_opposite')),
  },
  {
    name: `${STATE}/PlayDetailPagePositive`,
    title: resource.resourceToString($r('app.string.state_problem_arrow_function_positive')),
  },
  {
    name: `${STATE}/StateProblemThisUnableObserveOpposite`,
    title: resource.resourceToString($r('app.string.state_problem_this_unable_observe_opposite')),
  },
  {
    name: `${STATE}/StateProblemThisUnableObservePositive`,
    title: resource.resourceToString($r('app.string.state_problem_this_unable_observe_positive')),
  },
  {
    name: `${STATE}/StateProblemStateUiRefreshExample01`,
    title: resource.resourceToString($r('app.string.state_problem_state_ui_refresh_example_01')),
  },
  {
    name: `${STATE}/StateProblemStateUiRefreshExample02`,
    title: resource.resourceToString($r('app.string.state_problem_state_ui_refresh_example_02')),
  },
  {
    name: `${STATE}/StateProblemStateUiRefreshExample03`,
    title: resource.resourceToString($r('app.string.state_problem_state_ui_refresh_example_03')),
  },
  {
    name: `${STATE}/StateProblemComplexConstantRepeatRefresh`,
    title: resource.resourceToString($r('app.string.state_problem_complex_constant_repeat_refresh')),
  },
  {
    name: `${STATE}/StateProblemComplexSolution01`,
    title: resource.resourceToString($r('app.string.state_problem_complex_solution_01')),
  },
  {
    name: `${STATE}/StateProblemComplexSolution02`,
    title: resource.resourceToString($r('app.string.state_problem_complex_solution_02')),
  },
  {
    name: `${STATE}/StateProblemNotUpdateInBuildError01`,
    title: resource.resourceToString($r('app.string.state_problem_not_update_in_build_error_01')),
  },
  {
    name: `${STATE}/StateProblemABCallUiRefreshOpposite`,
    title: resource.resourceToString($r('app.string.state_problem_a_b_call_ui_refresh_opposite')),
  },
  {
    name: `${STATE}/StateProblemABCallUiRefreshPositive`,
    title: resource.resourceToString($r('app.string.state_problem_a_b_call_ui_refresh_positive')),
  },
  {
    name: `${STATE}/StateProblemUnregisterStateCallback`,
    title: resource.resourceToString($r('app.string.state_problem_unregister_state_callback')),
  },
];

@Builder
export function stateDestination(name: string) {
  if (name === STATE) {
    StateExample();
  } else if (name === `${STATE}/StateSceneSimpleType`) {
    StateSceneSimpleType()
  } else if (name === `${STATE}/StateChangeObservationObject`) {
    StateChangeObservationObject()
  } else if (name === `${STATE}/StateChangeObservationArray`) {
    StateChangeObservationArray()
  } else if (name === `${STATE}/StateSceneTypeClass`) {
    StateSceneTypeClass()
  } else if (name === `${STATE}/StateSceneTypeArray`) {
    StateSceneTypeArray()
  } else if (name === `${STATE}/StateSceneTypeMap`) {
    StateSceneTypeMap()
  } else if (name === `${STATE}/StateSceneTypeSet`) {
    StateSceneTypeSet()
  } else if (name === `${STATE}/StateSceneTypeDate`) {
    StateSceneTypeDate()
  } else if (name === `${STATE}/StateSceneJointTypeInstance`) {
    StateSceneJointTypeInstance()
  } else if (name === `${STATE}/PlayDetailPageOpposite`) {
    PlayDetailPageOpposite()
  } else if (name === `${STATE}/PlayDetailPagePositive`) {
    PlayDetailPagePositive()
  } else if (name === `${STATE}/StateProblemThisUnableObserveOpposite`) {
    StateProblemThisUnableObserveOpposite()
  } else if (name === `${STATE}/StateProblemThisUnableObservePositive`) {
    StateProblemThisUnableObservePositive()
  } else if (name === `${STATE}/StateProblemStateUiRefreshExample01`) {
    StateProblemStateUiRefreshExample01()
  } else if (name === `${STATE}/StateProblemStateUiRefreshExample02`) {
    StateProblemStateUiRefreshExample02()
  } else if (name === `${STATE}/StateProblemStateUiRefreshExample03`) {
    StateProblemStateUiRefreshExample03()
  } else if (name === `${STATE}/StateProblemComplexConstantRepeatRefresh`) {
    StateProblemComplexConstantRepeatRefresh()
  } else if (name === `${STATE}/StateProblemComplexSolution01`) {
    StateProblemComplexSolution01()
  } else if (name === `${STATE}/StateProblemComplexSolution02`) {
    StateProblemComplexSolution02()
  } else if (name === `${STATE}/StateProblemNotUpdateInBuildError01`) {
    StateProblemNotUpdateInBuildError01()
  } else if (name === `${STATE}/StateProblemABCallUiRefreshOpposite`) {
    StateProblemABCallUiRefreshOpposite()
  } else if (name === `${STATE}/StateProblemABCallUiRefreshPositive`) {
    StateProblemABCallUiRefreshPositive()
  } else if (name === `${STATE}/StateProblemUnregisterStateCallback`) {
    StateProblemUnregisterStateCallback()
  } else if (name === `${STATE}/StateInputUndefined`) {
    StateInputUndefined()
  }
}

@Entry
@Component
struct StateExample {
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
    .title($r('app.string.state'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}