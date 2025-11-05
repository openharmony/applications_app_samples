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
import { ComponentCard } from '../../common/Card';
// [Start number_of_caches_tabBar]
@Entry
@Component
export struct NumberOfCachesTabBar {
  build() {
    // [StartExclude number_of_caches_tabBar]
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.Cache_count') }) {
          // [EndExclude number_of_caches_tabBar]
          Tabs({ barPosition: BarPosition.Start }) {
            TabContent() {
              MyComponent({ color: '#00CB87' })
            }.tabBar(SubTabBarStyle.of('green'))

            TabContent() {
              MyComponent({ color: '#007DFF' })
            }.tabBar(SubTabBarStyle.of('blue'))

            TabContent() {
              MyComponent({ color: '#FFBF00' })
            }.tabBar(SubTabBarStyle.of('yellow'))

            TabContent() {
              MyComponent({ color: '#E67C92' })
            }.tabBar(SubTabBarStyle.of('pink'))

            TabContent() {
              MyComponent({ color: '#FF0000' })
            }.tabBar(SubTabBarStyle.of('red'))
          }
          .width(360)
          .height(296)
          .backgroundColor('#F1F3F5')
          .cachedMaxCount(1, TabsCacheMode.CACHE_BOTH_SIDE)
        }
      }
      // [StartExclude number_of_caches_tabBar]
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Cache_count'))
    // [EndExclude number_of_caches_tabBar]
  }
}

@Component
struct MyComponent {
  private color: string = '';

  aboutToAppear(): void {
    console.info('aboutToAppear backgroundColor:' + this.color);
  }

  aboutToDisappear(): void {
    console.info('aboutToDisappear backgroundColor:' + this.color);
  }

  build() {
    Column()
      .width('100%')
      .height('100%')
      .backgroundColor(this.color)
  }
}
// [End number_of_caches_tabBar]