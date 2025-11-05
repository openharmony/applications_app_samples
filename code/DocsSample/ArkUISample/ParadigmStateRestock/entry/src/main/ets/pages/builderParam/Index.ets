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
import { BuilderParamInitMethodDemo01 } from './BuilderParamInitMethodDemo01';
import { BuilderParamInitMethodDemo02 } from './BuilderParamInitMethodDemo02';
import { BuilderParamSceneInitComponent } from './BuilderParamSceneInitComponent';
import { BuilderParamSceneTrailingClosure01 } from './BuilderParamSceneTrailingClosure01';
import { BuilderParamSceneTrailingClosure02 } from './BuilderParamSceneTrailingClosure02';
import { BuilderParamSceneJumpLogic } from '../BuilderParamSceneJumpLogic';
import { BuilderParamSceneGlobalLocalInit } from './BuilderParamSceneGlobalLocalInit';
import { BuilderParamSceneInComponentV2 } from './BuilderParamSceneInComponentV2';
import { BuilderParamProblemNotRefreshOpposite } from './BuilderParamProblemNotRefreshOpposite';
import { BuilderParamProblemNotRefreshPositive } from './BuilderParamProblemNotRefreshPositive';
import { BuilderParamProblemCombinedPositive } from './BuilderParamProblemCombinedPositive';
import { BuilderParamProblemMustBuilderPositive } from './BuilderParamProblemMustBuilderPositive';

export const BUILDER_PARAM: string = 'builder_param';

const routes: Route[] = [
  {
    name: `${BUILDER_PARAM}/BuilderParamInitMethodDemo01`,
    title: resource.resourceToString($r('app.string.builder_param_init_method_demo01')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamInitMethodDemo02`,
    title: resource.resourceToString($r('app.string.builder_param_init_method_demo02')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamSceneInitComponent`,
    title: resource.resourceToString($r('app.string.builder_param_scene_init_component')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamSceneTrailingClosure01`,
    title: resource.resourceToString($r('app.string.builder_param_scene_trailing_closure_01')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamSceneTrailingClosure02`,
    title: resource.resourceToString($r('app.string.builder_param_scene_trailing_closure_02')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamSceneJumpLogic`,
    title: resource.resourceToString($r('app.string.builder_param_scene_jump_logic')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamSceneGlobalLocalInit`,
    title: resource.resourceToString($r('app.string.builder_param_scene_global_local_init')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamSceneInComponentV2`,
    title: resource.resourceToString($r('app.string.builder_param_scene_in_component_v2')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamProblemNotRefreshOpposite`,
    title: resource.resourceToString($r('app.string.builder_param_problem_not_refresh_opposite')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamProblemNotRefreshPositive`,
    title: resource.resourceToString($r('app.string.builder_param_problem_not_refresh_positive')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamProblemCombinedPositive`,
    title: resource.resourceToString($r('app.string.builder_param_problem_combined_positive')),
  },
  {
    name: `${BUILDER_PARAM}/BuilderParamProblemMustBuilderPositive`,
    title: resource.resourceToString($r('app.string.builder_param_problem_must_builder_positive')),
  }
];

@Builder
export function builderParamDestination(name: string) {
  if (name === BUILDER_PARAM) {
    BuilderParamExample();
  } else if (name === `${BUILDER_PARAM}/BuilderParamInitMethodDemo01`) {
    BuilderParamInitMethodDemo01()
  } else if (name === `${BUILDER_PARAM}/BuilderParamInitMethodDemo02`) {
    BuilderParamInitMethodDemo02()
  } else if (name === `${BUILDER_PARAM}/BuilderParamSceneInitComponent`) {
    BuilderParamSceneInitComponent()
  } else if (name === `${BUILDER_PARAM}/BuilderParamSceneTrailingClosure01`) {
    BuilderParamSceneTrailingClosure01()
  } else if (name === `${BUILDER_PARAM}/BuilderParamSceneTrailingClosure02`) {
    BuilderParamSceneTrailingClosure02()
  } else if (name === `${BUILDER_PARAM}/BuilderParamSceneJumpLogic`) {
    BuilderParamSceneJumpLogic()
  } else if (name === `${BUILDER_PARAM}/BuilderParamSceneGlobalLocalInit`) {
    BuilderParamSceneGlobalLocalInit()
  } else if (name === `${BUILDER_PARAM}/BuilderParamSceneInComponentV2`) {
    BuilderParamSceneInComponentV2()
  } else if (name === `${BUILDER_PARAM}/BuilderParamProblemNotRefreshOpposite`) {
    BuilderParamProblemNotRefreshOpposite()
  } else if (name === `${BUILDER_PARAM}/BuilderParamProblemNotRefreshPositive`) {
    BuilderParamProblemNotRefreshPositive()
  } else if (name === `${BUILDER_PARAM}/BuilderParamProblemCombinedPositive`) {
    BuilderParamProblemCombinedPositive()
  } else if (name === `${BUILDER_PARAM}/BuilderParamProblemMustBuilderPositive`) {
    BuilderParamProblemMustBuilderPositive()
  }
}

@Entry
@Component
struct BuilderParamExample {
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
    .title($r('app.string.builder_param'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}