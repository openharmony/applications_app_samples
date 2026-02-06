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
import { LocalObserveChangesArray } from './LocalObserveChangesArray';
import { LocalObserveChangesDecorator } from './LocalObserveChangesDecorator';
import { LocalObserveChangesDeepObject } from './LocalObserveChangesDeepObject';
import { LocalObserveChangesType } from './LocalObserveChangesType';
import { LocalQuestionExpectedEffect } from './LocalQuestionExpectedEffect';
import { LocalQuestionSparkUpdate } from './LocalQuestionSparkUpdate';
import { LocalQuestionUIUtils } from './LocalQuestionUIUtils';
import { LocalQuestionV2animateTo } from './LocalQuestionV2animateTo';
import { LocalQuestionV1animateTo } from './LocalQuestionV1animateTo';
import { LocalQuestionAnimateToImmediately } from './LocalQuestionAnimateToImmediately';
import { LocalUseCaseArray } from './LocalUseCaseArray';
import { LocalUseCaseDate } from './LocalUseCaseDate';
import { LocalUseCaseJoin } from './LocalUseCaseJoin';
import { LocalUseCaseMap } from './LocalUseCaseMap';
import { LocalUseCaseObject } from './LocalUseCaseObject';
import { LocalUseCaseSet } from './LocalUseCaseSet';
import { LocalV1StateDecorator } from './LocalV1StateDecorator';

export const LOCAL: string = 'local_text';

const routes: Route[] = [
  {
    name: `${LOCAL}/LocalV1StateDecorator`,
    title: resource.resourceToString($r('app.string.local_v1_state_decorator')),
  },
  {
    name: `${LOCAL}/LocalObserveChangesType`,
    title: resource.resourceToString($r('app.string.local_observe_changes_type')),
  },
  {
    name: `${LOCAL}/LocalObserveChangesDecorator`,
    title: resource.resourceToString($r('app.string.local_observe_changes_decorator')),
  },
  {
    name: `${LOCAL}/LocalObserveChangesArray`,
    title: resource.resourceToString($r('app.string.local_observe_changes_array')),
  },
  {
    name: `${LOCAL}/LocalObserveChangesDeepObject`,
    title: resource.resourceToString($r('app.string.local_observe_changes_deep_object')),
  },
  {
    name: `${LOCAL}/LocalUseCaseObject`,
    title: resource.resourceToString($r('app.string.local_use_case_object')),
  },
  {
    name: `${LOCAL}/LocalUseCaseArray`,
    title: resource.resourceToString($r('app.string.local_use_case_array')),
  },
  {
    name: `${LOCAL}/LocalUseCaseDate`,
    title: resource.resourceToString($r('app.string.local_use_case_date')),
  },
  {
    name: `${LOCAL}/LocalUseCaseMap`,
    title: resource.resourceToString($r('app.string.local_use_case_map')),
  },
  {
    name: `${LOCAL}/LocalUseCaseSet`,
    title: resource.resourceToString($r('app.string.local_use_case_set')),
  },
  {
    name: `${LOCAL}/LocalUseCaseJoin`,
    title: resource.resourceToString($r('app.string.local_use_case_join')),
  },
  {
    name: `${LOCAL}/LocalQuestionSparkUpdate`,
    title: resource.resourceToString($r('app.string.local_question_spark_update')),
  },
  {
    name: `${LOCAL}/LocalQuestionUIUtils`,
    title: resource.resourceToString($r('app.string.local_question_ui_utils')),
  },
  {
    name: `${LOCAL}/LocalQuestionV1animateTo`,
    title: resource.resourceToString($r('app.string.local_question_v1_animate_to')),
  },
  {
    name: `${LOCAL}/LocalQuestionV2animateTo`,
    title: resource.resourceToString($r('app.string.local_question_v2_animate_to')),
  },
  {
    name: `${LOCAL}/LocalQuestionAnimateToImmediately`,
    title: resource.resourceToString($r('app.string.local_question_animateToImmediately')),
  },
  {
    name: `${LOCAL}/LocalQuestionExpectedEffect`,
    title: resource.resourceToString($r('app.string.local_question_expected_effect')),
  },

];

@Builder
export function localDestination(name: string) {
  if (name === LOCAL) {
    LocalExample();
  } else if (name === `${LOCAL}/LocalV1StateDecorator`) {
    LocalV1StateDecorator()
  } else if (name === `${LOCAL}/LocalObserveChangesType`) {
    LocalObserveChangesType()
  } else if (name === `${LOCAL}/LocalObserveChangesDecorator`) {
    LocalObserveChangesDecorator()
  } else if (name === `${LOCAL}/LocalObserveChangesArray`) {
    LocalObserveChangesArray()
  } else if (name === `${LOCAL}/LocalObserveChangesDeepObject`) {
    LocalObserveChangesDeepObject()
  } else if (name === `${LOCAL}/LocalUseCaseObject`) {
    LocalUseCaseObject()
  } else if (name === `${LOCAL}/LocalUseCaseArray`) {
    LocalUseCaseArray()
  } else if (name === `${LOCAL}/LocalUseCaseDate`) {
    LocalUseCaseDate()
  } else if (name === `${LOCAL}/LocalUseCaseMap`) {
    LocalUseCaseMap()
  } else if (name === `${LOCAL}/LocalUseCaseSet`) {
    LocalUseCaseSet()
  } else if (name === `${LOCAL}/LocalUseCaseJoin`) {
    LocalUseCaseJoin()
  } else if (name === `${LOCAL}/LocalQuestionSparkUpdate`) {
    LocalQuestionSparkUpdate()
  } else if (name === `${LOCAL}/LocalQuestionUIUtils`) {
    LocalQuestionUIUtils()
  } else if (name === `${LOCAL}/LocalQuestionV2animateTo`) {
    LocalQuestionV2animateTo()
  } else if (name === `${LOCAL}/LocalQuestionV1animateTo`) {
    LocalQuestionV1animateTo()
  } else if (name === `${LOCAL}/LocalQuestionAnimateToImmediately`) {
    LocalQuestionAnimateToImmediately();
  } else if (name === `${LOCAL}/LocalQuestionExpectedEffect`) {
    LocalQuestionExpectedEffect()
  }
}

@Entry
@Component
struct LocalExample {
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
    .title($r('app.string.local'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}