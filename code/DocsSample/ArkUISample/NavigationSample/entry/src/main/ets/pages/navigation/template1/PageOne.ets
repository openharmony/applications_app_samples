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
// [Start SystemRoutingTable]
@Entry
@Component
struct SystemRoutingTable {
  pageStack : NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageStack){
    }.onAppear(() => {
      this.pageStack.pushPathByName('PageOne', null, false);
    })
    .hideNavBar(true)
  }
}
// [End SystemRoutingTable]
// [Start SystemRoutingTableOne]
// 跳转页面入口函数
@Builder
export function PageOneBuilder() {
  PageOne();
}

@Component
struct PageOne {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
    }
    .title('PageOne')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}
// [End SystemRoutingTableOne]