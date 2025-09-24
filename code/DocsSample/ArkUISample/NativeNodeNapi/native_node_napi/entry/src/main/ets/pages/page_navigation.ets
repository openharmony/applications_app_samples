/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import Napi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack();

  @Builder
  PagesMap(name: string) {
    if (name === 'PageOne') {
      PageOne();
    } else if (name === 'PageTwo') {
      PageTwo();
    }
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Button('pushPath').onClick(() => {
          this.pageStack.pushPath({ name: 'PageOne' });
        }).margin('sys.float.menu_item_content_align')
        Button('pushPath with param').onClick(() => {
          this.pageStack.pushPath({ name: 'PageOne', param: 'param' });
        }).margin('sys.float.menu_item_content_align')
        Button('pushPath Two').onClick(() => {
          this.pageStack.pushPath({ name: 'PageTwo', param: 'param' });
        }).margin('sys.float.menu_item_content_align')
        Button('pop').onClick(() => {
          this.pageStack.pop();
        }).margin('sys.float.menu_item_content_align')
      }
    }
    .title('NavIndex')
    .id('This is Navigation ID')
    .mode(NavigationMode.Split)
    .navDestination(this.PagesMap)
    .navBarWidth('50%')
    .backgroundColor('#2aa1a6b1')
  }
}

@Component
export struct PageOne {
  @Consume('pageStack') pageStack: NavPathStack;
  private nodeContent = new NodeContent();

  build() {
    NavDestination(){
      Column(){
        Text('This is PageOne')
          .fontSize(20)
        ContentSlot(this.nodeContent)
      }.width('100%').height('100%')
    }.title('NavDestination')
    .onWillShow(()=>{
      Napi.createNativeNaviNode(this.nodeContent);
    })
    .id('This is NavDestination ID1')
    .backgroundColor('#2aa1a6b1')
  }
}

@Component
export struct PageTwo {
  @Consume('pageStack') pageStack: NavPathStack;
  private nodeContent = new NodeContent();

  build() {
    NavDestination(){
      Column(){
        Text('This is PageTwo')
          .fontSize(20)
        ContentSlot(this.nodeContent)
      }.width('100%').height('100%')
    }.title('NavDestination')
    .onWillShow(()=>{
      Napi.createNativeNaviNode(this.nodeContent);
    })
    .id('This is NavDestination ID2')
    .backgroundColor('#2aa1a6b1')
  }
}