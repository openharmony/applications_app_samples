/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start CloseMaterial]
import { uiMaterial } from '@kit.ArkUI';

@Entry
@Component
struct CloseMaterialPage {
  build() {
    Column() {
      Text('关闭组件沉浸式系统材质')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 30 })

      Text('默认开启沉浸式系统材质的Select：')
        .fontSize(16)
        .margin({ bottom: 10 })

      // Select组件默认开启沉浸式系统材质
      Select([{ value: '选项1' }, { value: '选项2' }])
        .value('选择')
        .margin({ bottom: 30 })

      Text('单独关闭沉浸式系统材质的Select：')
        .fontSize(16)
        .margin({ bottom: 10 })

      // 单独关闭Select组件的沉浸式系统材质
      Select([{ value: '选项' }])
        .value('选择')
        .systemMaterial(uiMaterial.Material.empty)
        // .menuSystemMaterial(uiMaterial.Material.empty)
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .justifyContent(FlexAlign.Center)
  }
}
// [End CloseMaterial]
