'use static';
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

/**
 * 功能介绍：在一些主页的场景中，为了实现更好的视觉体验，会给TabBar加上透明的背景模糊效果。
 *
 * 推荐场景：为了体验需要实现模糊效果的场景，例如购物商场的主页下方的TabBar效果。
 *
 * 核心组件:CustomTabsComponent.ets
 *
 * 实现步骤:
 * 1.使用backgroundBrightness和backgroundBlurStyleTabBar属性实现TabBar背景模糊效果：
 * 在自定义的TabBar实现中，添加backgroundBrightness和backgroundBlurStyleTabBar属性，实现透明模糊效果。其中backgroundBrightness
 * 属性可以控制背景的亮度等效果，backgroundBlurStyleTabBar属性控制背景的透明度等效果。
 * 2.实现底部TabBar页签的沉浸式效果：
 * 为了实现底部TabBar页签的沉浸式效果，需要在**所有**TabBar的嵌套路径中，添加expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
 */

import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement';
import { CustomTabsComponent } from './CustomTabsComponent';
import { Component, Entry, Column } from '@ohos.arkui.component';

@Entry
@Component
export struct TabsSample {
  build() {
    Column(){
      CustomTabsComponent()
    }
  }
}