/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

@Entry
@Component
struct Index {
  pageInfos: NavPathStack = new NavPathStack();
  isUseInterception: boolean = false;

  build() {
    Navigation(this.pageInfos) {
      Tabs() {
        TabContent() {
          Column() {
            Button('点击此处进入', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .margin(20)
              .onClick(() => {
                this.pageInfos.pushPath({ name: 'pageOne'});
              })
            Text('  使用NDK接口创建XComponent，并使用NativeXComponent相关接口')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Start)
        }
        .tabBar('NDK接口')
        TabContent() {
          Column() {
            Button('点击此处进入', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .margin(20)
              .onClick(() => {
                this.pageInfos.pushPath({ name: 'pageTwo'});
              })
            Text('  使用ArkTS声明式方法创建XComponent，并使用NativeXComponent相关接口')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Start)
        }
        .tabBar('ArkTS声明式')
        TabContent() {
          Column() {
            Button('点击此处进入', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .margin(20)
              .onClick(() => {
                this.pageInfos.pushPath({ name: 'pageThree'});
              })
            Text('  使用自定义节点创建XComponent，并使用SurfaceHolder相关接口')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Start)
        }
        .tabBar('自定义节点')
      }
    }.title('XComponent')
  }
}