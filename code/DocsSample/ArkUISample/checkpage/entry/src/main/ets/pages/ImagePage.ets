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
// [Start uiContextInspector_start]
import { inspector } from '@kit.ArkUI'

@Entry
@Component
struct ImageExample {
  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
        Row({ space: 5 }) {
          // 可以替换成本地存在的图片
          Image($r('app.media.startIcon'))
            .width(110)
            .height(110)
            .border({ width: 1 })
            .id('IMAGE_ID')
        }
      }
    }.height(320).width(360).padding({ right: 10, top: 10 })
  }

  listener: inspector.ComponentObserver = this.getUIContext().getUIInspector().createComponentObserver('IMAGE_ID')

  aboutToAppear() {
    let onLayoutComplete: () => void = (): void => {
      // 补充待实现的功能
    }
    let onDrawComplete: () => void = (): void => {
      // 补充待实现的功能
    }
    let onDrawChildrenComplete: () => void = (): void => {
      // 补充待实现的功能
    }
    let funcLayout = onLayoutComplete // 绑定当前js对象
    let funcDraw = onDrawComplete // 绑定当前js对象
    let funcDrawChildren = onDrawChildrenComplete // 绑定当前js对象
    let offFuncLayout = onLayoutComplete // 绑定当前js对象
    let offFuncDraw = onDrawComplete // 绑定当前js对象
    let offFuncDrawChildren = onDrawChildrenComplete // 绑定当前js对象

    this.listener.on('layout', funcLayout)
    this.listener.on('draw', funcDraw)
    this.listener.on('drawChildren', funcDrawChildren)

    // 通过句柄向对应的查询条件取消注册回调，由开发者自行决定在何时调用。
    // this.listener.off('layout', OffFuncLayout)
    // this.listener.off('draw', OffFuncDraw)
    // this.listener.off('drawChildren', OffFuncDrawChildren)
  }
}
// [End uiContextInspector_start]