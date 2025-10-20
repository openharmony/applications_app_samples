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
// [ Start build function ]
@Entry
@Component
struct MyComponent {
  build() {
      // 根节点唯一且必要，必须为容器组件
      Row() {
        ChildComponentBuildFunction()
      }
  }
}

@Component
struct ChildComponentBuildFunction {
  build() {
    // 根节点唯一且必要，可为非容器组件
    // 图片资源文件需要开发者自行添加
    Image($r('app.media.startIcon'))
  }
}
// [ End build function ]
