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

import { LengthMetrics } from '@kit.ArkUI';
import { RoutableCard } from '../common/Card';
import { Route } from '../common/Route';
import resource from '../common/Resource';
import { CustomComponentUseFunc as CustomComponentUse } from './CustomComponentUse';
import { ObservedV2ClassUserFunc as ObservedV2ClassUser } from './ObservedV2ClassUser';
import { ComputingPropertyResolution } from './ComputingPropertyResolution';
import { ComputedInitParam } from './ComputedInitParam';
import { ComputedProperty } from './ComputedProperty';

const routes: Route[] = [
  {
    name: 'CustomComponentUse',
    // 请将$r('app.string.computed_desc_1')替换为实际资源文件，在本示例中该资源文件的value值为"在自定义组件中使用计算属性。"
    title: resource.resourceToString($r('app.string.computed_desc_1')),
    description: ''
  },
  {
    name: 'ObservedV2ClassUser',
    // 请将$r('app.string.computed_desc_2')替换为实际资源文件，在本示例中该资源文件的value值为"在@ObservedV2装饰的类中使用计算属性。。"
    title: resource.resourceToString($r('app.string.computed_desc_2')),
    description: ''
  },
  {
    name: 'ComputingPropertyResolution',
    // 请将$r('app.string.computed_title_2')替换为实际资源文件，在本示例中该资源文件的value值为"@Computed装饰的属性可以被@Monitor监听变化"
    title: resource.resourceToString($r('app.string.computed_title_2')),
    // 请将$r('app.string.computed_desc_3')替换为实际资源文件，在本示例中该资源文件的value值为"如何使用计算属性求解fahrenheit和kelvin。"
    description: $r('app.string.computed_desc_3')
  },
  {
    name: 'ComputedInitParam',
    // 请将$r('app.string.computed_title_3')替换为实际资源文件，在本示例中该资源文件的value值为"@Computed装饰的属性可以初始化@Param"
    title: resource.resourceToString($r('app.string.computed_title_3')),
    // 请将$r('app.string.computed_desc_4')替换为实际资源文件，在本示例中该资源文件的value值为"下面的例子使用@Computed初始化@Param。"
    description: $r('app.string.computed_desc_4')
  },
  {
    name: 'ComputedProperty',
    // 请将$r('app.string.computed_property_title')替换为实际资源文件，在本示例中该资源文件的value值为"使用@Computed计算属性"
    title: resource.resourceToString($r('app.string.computed_property_title')),
    description: ''
  },

];

@Builder
function computedDestination(name: string) {
  if (name.startsWith('CustomComponentUse')) {
    CustomComponentUse();
  } else if (name.startsWith('ObservedV2ClassUser')) {
    ObservedV2ClassUser();
  } else if (name.startsWith('ComputingPropertyResolution')) {
    ComputingPropertyResolution();
  } else if (name.startsWith('ComputedInitParam')) {
    ComputedInitParam();
  } else if (name.startsWith('ComputedProperty')) {
    ComputedProperty();
  }
}


@Entry
@Component
struct Index {
  @State condition: string = '';
  @Provide pathStack: NavPathStack = new NavPathStack();

  getFilteredRoutes(): Route[] {
    if (!this.condition) {
      return routes;
    }
    return routes.filter((route: Route) => {
      return route.title.includes(this.condition);
    })
  }


  build() {
    Navigation(this.pathStack) {
      List({ space: 12 }) {
        ForEach(this.getFilteredRoutes(), (route: Route) => {
          ListItem() {
            RoutableCard({ title: route.title })
          }
          .width('100%')
          .onClick(() => {
            this.pathStack.pushPath({ name: route.name });
          })
        })
      }
      .padding({ start: LengthMetrics.vp(16), end: LengthMetrics.vp(16) })
      .contentStartOffset(56)
      .height('100%')
      .width('100%')
    }
    .backgroundColor('#f1f3f5')
    .navDestination(computedDestination)
  }
}
