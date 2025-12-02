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
 
// [Start NavigationAnimation]
// [Start AppStorageSetStack]
@Entry
@Component
struct NavigationPage {
  navStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    AppStorage.setOrCreate<NavPathStack>('basicNavigationStack', this.navStack);
    // [StartExclude AppStorageSetStack]
    this.navStack.pushPath({ name: 'animation-BasicNavDestination' }, false); // 关闭本次push动画即可
    // [EndExclude AppStorageSetStack]
  }

  build() {
    Navigation(this.navStack) {
      // [StartExclude NavigationAnimation]
      // [StartExclude AppStorageSetStack]
      Column({ space: 20 }) {
        Text('This is NavBar');

        Button('push BasicNavDestination')
          .onClick(() => {
            this.navStack.pushPath({ name: 'animation-BasicNavDestination' });
          })
      }
      // [EndExclude AppStorageSetStack]
      // [EndExclude NavigationAnimation]
    }
  }
}
// [End AppStorageSetStack]
// [End NavigationAnimation]