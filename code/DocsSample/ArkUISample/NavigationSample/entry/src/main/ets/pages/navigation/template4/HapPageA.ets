/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start CrossPackagePageA]
// 仅作为示例写法，其余页面、模块需自行创建
import { ControlPanel } from './Common';

@Component
export struct HapPageA {
  build() {
    NavDestination() {
      Stack({alignContent: Alignment.Center}) {
        ControlPanel()
      }.width('100%').height('100%')
    }.title('HapPageA')
    .onReady((ctx: NavDestinationContext) => {
      let config = ctx.getConfigInRouteMap();
      console.log(`testTag HapPageA config.data: ${JSON.stringify(config?.data)}`);
    })
  }
}

// 页面的buildFunction，用于构造页面
@Builder
export function HapPageABuilder(): void {
  HapPageA();
}
// [End CrossPackagePageA]
