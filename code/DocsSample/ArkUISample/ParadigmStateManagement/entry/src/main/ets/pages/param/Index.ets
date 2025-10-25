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
import { ParamDecoratorLimitations } from './ParamDecoratorLimitations';
import { ParamObserveChangeArray } from './ParamObserveChangeArray';
import { ParamObserveChangeClass } from './ParamObserveChangeClass';
import { ParamObserveChangeNestedClass } from './ParamObserveChangeNestedClass';
import { ParamObserveChangeVariable } from './ParamObserveChangeVariable';
import { ParamRestrictModifyObject } from './ParamRestrictModifyObject';
import { ParamUseSceneArray } from './ParamUseSceneArray';
import { ParamUseSceneDate } from './ParamUseSceneDate';
import { ParamUseSceneMap } from './ParamUseSceneMap';
import { ParamUseSceneParentToChild } from './ParamUseSceneParentToChild';
import { ParamUseSceneSet } from './ParamUseSceneSet';
import { ParamUseSceneUnite } from './ParamUseSceneUnite';


export const PARMA: string = 'param_text';

const routes: Route[] = [
  {
    name: `${PARMA}/ParamDecoratorLimitations`,
    title: resource.resourceToString($r('app.string.param_decorator_limitations')),
  },
  {
    name: `${PARMA}/ParamObserveChangeVariable`,
    title: resource.resourceToString($r('app.string.param_observe_change_variable')),
  },
  {
    name: `${PARMA}/ParamObserveChangeClass`,
    title: resource.resourceToString($r('app.string.param_observe_change_class')),
  },
  {
    name: `${PARMA}/ParamObserveChangeArray`,
    title: resource.resourceToString($r('app.string.param_observe_change_array')),
  },
  {
    name: `${PARMA}/ParamObserveChangeNestedClass`,
    title: resource.resourceToString($r('app.string.param_observe_change_nested_class')),
  },
  {
    name: `${PARMA}/ParamUseSceneParentToChild`,
    title: resource.resourceToString($r('app.string.param_use_scene_parent_to_child')),
  },
  {
    name: `${PARMA}/ParamUseSceneArray`,
    title: resource.resourceToString($r('app.string.param_use_scene_array')),
  },
  {
    name: `${PARMA}/ParamUseSceneDate`,
    title: resource.resourceToString($r('app.string.param_use_scene_date')),
  },
  {
    name: `${PARMA}/ParamUseSceneMap`,
    title: resource.resourceToString($r('app.string.param_use_scene_map')),
  },
  {
    name: `${PARMA}/ParamUseSceneSet`,
    title: resource.resourceToString($r('app.string.param_use_scene_set')),
  },
  {
    name: `${PARMA}/ParamUseSceneUnite`,
    title: resource.resourceToString($r('app.string.param_use_scene_unite')),
  },
  {
    name: `${PARMA}/ParamRestrictModifyObject`,
    title: resource.resourceToString($r('app.string.param_restrict_modify_object')),
  },
];

@Builder
export function paramDestination(name: string) {
  if (name === PARMA) {
    ParamExample();
  } else if (name === `${PARMA}/ParamDecoratorLimitations`) {
    ParamDecoratorLimitations()
  } else if (name === `${PARMA}/ParamObserveChangeVariable`) {
    ParamObserveChangeVariable()
  } else if (name === `${PARMA}/ParamObserveChangeClass`) {
    ParamObserveChangeClass()
  } else if (name === `${PARMA}/ParamObserveChangeArray`) {
    ParamObserveChangeArray()
  } else if (name === `${PARMA}/ParamObserveChangeNestedClass`) {
    ParamObserveChangeNestedClass()
  } else if (name === `${PARMA}/ParamUseSceneParentToChild`) {
    ParamUseSceneParentToChild()
  } else if (name === `${PARMA}/ParamUseSceneArray`) {
    ParamUseSceneArray()
  } else if (name === `${PARMA}/ParamUseSceneMap`) {
    ParamUseSceneMap()
  } else if (name === `${PARMA}/ParamUseSceneDate`) {
    ParamUseSceneDate()
  } else if (name === `${PARMA}/ParamUseSceneSet`) {
    ParamUseSceneSet()
  } else if (name === `${PARMA}/ParamUseSceneUnite`) {
    ParamUseSceneUnite()
  } else if (name === `${PARMA}/ParamRestrictModifyObject`) {
    ParamRestrictModifyObject()
  }
}

@Entry
@Component
struct ParamExample {
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
    .title('@Param', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}