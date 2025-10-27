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
import { StateMixedSceneJsV1V2Recommend } from './StateMixedSceneJsV1V2Recommend';
import { StateMixedSceneJsV1V2NotRecommend } from './StateMixedSceneJsV1V2NotRecommend';
import { StateMixedSceneJsV2V1Recommend } from './StateMixedSceneJsV2V1Recommend';
import { StateMixedSceneJsV2V1NotRecommend } from './StateMixedSceneJsV2V1NotRecommend';
import { StateMixedSceneObservedClassV1V2 } from './StateMixedSceneObservedClassV1V2';
import { StateMixedSceneObservedClassV2V1 } from './StateMixedSceneObservedClassV2V1';
import { StateMixedSceneBuiltTypeV1V2Recommend } from './StateMixedSceneBuiltTypeV1V2Recommend';
import { StateMixedSceneBuiltTypeV1V2NotRecommend } from './StateMixedSceneBuiltTypeV1V2NotRecommend';
import { StateMixedSceneBuiltTypeV2V1Recommend } from './StateMixedSceneBuiltTypeV2V1Recommend';
import { StateMixedSceneBuiltTypeV2V1NotRecommend } from './StateMixedSceneBuiltTypeV2V1NotRecommend';
import { StateMixedSceneTwoBitArrayV1V2 } from './StateMixedSceneTwoBitArrayV1V2';
import { StateMixedSceneTwoBitArrayV2V1 } from './StateMixedSceneTwoBitArrayV2V1';
import { StateMixedSceneNestedTypeV1V2 } from './StateMixedSceneNestedTypeV1V2';
import { StateMixedSceneNestedTypeV2V1 } from './StateMixedSceneNestedTypeV2V1';

export const MIXED_STATE_MANAGE_V1_V2: string = 'mixed_state_manage_v1_v2';

const routes: Route[] = [
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneJsV1V2Recommend`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_js_v1_v2_recommend')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneJsV1V2NotRecommend`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_js_v1_v2_not_recommend')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneJsV2V1Recommend`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_js_v2_v1_recommend')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneJsV2V1NotRecommend`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_js_v2_v1_not_recommend')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneObservedClassV1V2`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_observed_class_v1_v2')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneObservedClassV2V1`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_observed_class_v2_v1')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneBuiltTypeV1V2Recommend`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_built_type_v1_v2_recommend')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneBuiltTypeV1V2NotRecommend`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_built_type_v1_v2_not_recommend')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneBuiltTypeV2V1Recommend`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_built_type_v2_v1_recommend')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneBuiltTypeV2V1NotRecommend`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_built_type_v2_v1_not_recommend')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneTwoBitArrayV1V2`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_two_bit_array_v1_v2')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneTwoBitArrayV2V1`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_two_bit_array_v2_v1')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneNestedTypeV1V2`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_nested_type_v1_v2')),
  },
  {
    name: `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneNestedTypeV2V1`,
    title: resource.resourceToString($r('app.string.state_mixed_scene_nested_type_v2_v1')),
  },
];

@Builder
export function mixedStateManageV1V2Destination(name: string) {
  if (name === MIXED_STATE_MANAGE_V1_V2) {
    BuilderParamExample();
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneJsV1V2Recommend`) {
    StateMixedSceneJsV1V2Recommend()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneJsV1V2NotRecommend`) {
    StateMixedSceneJsV1V2NotRecommend()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneJsV2V1Recommend`) {
    StateMixedSceneJsV2V1Recommend()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneJsV2V1NotRecommend`) {
    StateMixedSceneJsV2V1NotRecommend()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneObservedClassV1V2`) {
    StateMixedSceneObservedClassV1V2()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneObservedClassV2V1`) {
    StateMixedSceneObservedClassV2V1()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneBuiltTypeV1V2Recommend`) {
    StateMixedSceneBuiltTypeV1V2Recommend()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneBuiltTypeV1V2NotRecommend`) {
    StateMixedSceneBuiltTypeV1V2NotRecommend()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneBuiltTypeV2V1Recommend`) {
    StateMixedSceneBuiltTypeV2V1Recommend()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneBuiltTypeV2V1NotRecommend`) {
    StateMixedSceneBuiltTypeV2V1NotRecommend()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneTwoBitArrayV1V2`) {
    StateMixedSceneTwoBitArrayV1V2()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneTwoBitArrayV2V1`) {
    StateMixedSceneTwoBitArrayV2V1()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneNestedTypeV1V2`) {
    StateMixedSceneNestedTypeV1V2()
  } else if (name === `${MIXED_STATE_MANAGE_V1_V2}/StateMixedSceneNestedTypeV2V1`) {
    StateMixedSceneNestedTypeV2V1()
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
    .title($r('app.string.mixed_state_manage_v1_v2'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}