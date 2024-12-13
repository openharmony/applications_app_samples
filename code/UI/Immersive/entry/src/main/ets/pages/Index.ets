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
import { NavImmersive } from 'immersive';
@Entry
@Component
struct Index {
  build() {
    Column() {
      /**
       * 功能描述：开发应用沉浸式效果主要指通过调整状态栏、应用界面和导航条的显示效果来减少状态栏导航条等系统界面的突兀感，从而使用户获得最佳的UI
       * 体验。本案例分别针对Navigation、列表滑动、Web页、底部弹框等场景实现了沉浸式适配。
       * 参数介绍：无
       * README：https://gitee.com/harmonyos-cases/cases/blob/master/CommonAppDevelopment/feature/immersive/README.md
       */
      NavImmersive()

    }
    .height('100%')
    .width('100%')
  }
}