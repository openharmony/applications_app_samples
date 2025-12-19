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
import { GestureJudge } from './GestureJudge';
import resource from '../../common/resource';


export const GestureJudge_ROUTE_PREFIX: string = 'GestureJudge_ROUTE_PREFIX';

const routes: Route[] = [
  {
    name: `${GestureJudge_ROUTE_PREFIX}/GestureJudge`,
    // 请将$r('app.string.gesture_Index_GestureJudge_title')替换为实际资源文件，在本示例中该资源文件的value值为"手势拦截"
    title: resource.resourceToString($r('app.string.gesture_Index_GestureJudge_title')),
    // 请将$r('app.string.gesture_Index_GestureJudge_description')替换为实际资源文件，在本示例中该资源文件的value值为"手势拦截主要用于确保手势按需执行，有效解决手势冲突问题。典型应用场景包括：嵌套滚动、通过过滤组件响应手势的范围来优化交互体验。手势拦截主要采用手势触发控制和手势响应控制两种方式实现。"
    description: resource.resourceToString($r('app.string.gesture_Index_GestureJudge_description')),
  }
];

@Builder
export function GestureJudgeDestination(name: string) {
  if (name === GestureJudge_ROUTE_PREFIX) {
    GestureJudgeExample();
  } else if (name === routes[0].name) {
    GestureJudge();
  }
}

@Entry
@Component
struct GestureJudgeExample {
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
      .contentStartOffset(20)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor('#f1f3f5')
    .title('', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    // 请将$r('app.string.gesture_Index_title')替换为实际资源文件，在本示例中该资源文件的value值为"手势拦截"
    .title($r('app.string.gesture_Index_title'))
  }
}