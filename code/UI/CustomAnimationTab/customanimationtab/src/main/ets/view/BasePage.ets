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
import { SkeletonLayout } from './SkeletonLayout';
import LazyDataSource from './LazyDataSource';

@Builder
export function baseBuilder() {
  BasePage();
}

@Component
struct BasePage {
  @State data: LazyDataSource<string> = new LazyDataSource<string>();

  aboutToAppear(): void {
    for (let i = 0; i < 100; i++) {
      this.data.pushData(`${i}`);
    }
  }

  build() {
    Column() {
      List() {
        LazyForEach(this.data, (data: string) => {
          ListItem() {
            SkeletonLayout({isMine: false})
          }
        })
      }
      .cachedCount(1)
      .width($r('app.string.custom_animation_tab_one_hundred_percent'))
      .height($r('app.string.custom_animation_tab_one_hundred_percent'))
    }
    .width($r('app.string.custom_animation_tab_one_hundred_percent'))
    .height($r('app.string.custom_animation_tab_one_hundred_percent'))
  }
}