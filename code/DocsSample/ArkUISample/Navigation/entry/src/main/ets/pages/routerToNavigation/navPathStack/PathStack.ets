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
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  pathStack: NavPathStack = new NavPathStack();
  aboutToAppear(): void {
    this.Navigation();
  }
  build() {
    // 设置NavPathStack并传入Navigation
    Navigation(this.pathStack) {
      // ...

    }.width('100%').height('100%')
    .title('Navigation， this.pathStack')
    .mode(NavigationMode.Stack)
  }

  Navigation(){
    // [Start nav_stack_two]
    this.pathStack.pop();
    // push page
    this.pathStack.pushPath({ name: 'pageOne' });

    // pop page
    this.pathStack.pop();
    this.pathStack.popToIndex(1);
    this.pathStack.popToName('pageOne');

    // replace page
    this.pathStack.replacePath({ name: 'pageOne' });

    // clear all page
    this.pathStack.clear();

    // 获取路由栈大小
    let size: number = this.pathStack.size();

    // 删除栈中name为PageOne的所有页面
    this.pathStack.removeByName('pageOne');

    // 删除指定索引的页面
    this.pathStack.removeByIndexes([1, 3, 5]);

    // 获取栈中所有页面name集合
    this.pathStack.getAllPathName();

    // 获取索引为1的页面参数
    this.pathStack.getParamByIndex(1);

    // 获取PageOne页面的参数
    this.pathStack.getParamByName('pageOne');

    // 获取PageOne页面的索引集合
    this.pathStack.getIndexByName('pageOne');
    // ...
    // [End nav_stack_two]
  }
}