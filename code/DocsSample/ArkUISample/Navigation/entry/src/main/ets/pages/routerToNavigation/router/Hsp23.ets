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

// [Start router_hsp23]
// 1.导入跨包的路由页面
import { PageInHSP } from 'library/src/main/ets/pages/PageInHSP'

@Entry
@Component
struct mainPage {
  pageStack: NavPathStack = new NavPathStack();

  @Builder pageMap(name: string) {
    if (name === 'PageInHSP') {
      // 2.定义路由映射表
      PageInHSP();
    }
  }

  build() {
    Navigation(this.pageStack) {
      Button('Push HSP Page')
        .onClick(() => {
          // 3.跳转到Hsp中的页面
          this.pageStack.pushPath({ name: 'PageInHSP' });
        })
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.pageMap)
  }
}
// [End router_hsp23]