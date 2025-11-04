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

// [Start app_context_cache_start]
import { common } from '@kit.AbilityKit';


@Entry
@Component
struct ApplicationContextCache {
  @State message: string = 'Hello World';
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Row() {
      Column() {
        Text(this.message)
          // [StartExclude app_context_cache_start]
          .width('50vp')
          // [EndExclude app_context_cache_start]
        Button() {
          Text('create file')
          // [StartExclude app_context_cache_start]
            .width('50vp')
          // [EndExclude app_context_cache_start]
            .onClick(() => {
              let applicationContext = this.context.getApplicationContext();
              // 获取应用缓存路径
              let cacheDir = applicationContext.cacheDir;
            })
        }
        // [StartExclude app_context_cache_start]
        .width('50vp')
        // [EndExclude app_context_cache_start]
      }
      // [StartExclude app_context_cache_start]
      .width('50vp')
      // [EndExclude app_context_cache_start]
    }
    // [StartExclude app_context_cache_start]
    .width('50vp')
    // [EndExclude app_context_cache_start]
  }
}
// [End app_context_cache_start]