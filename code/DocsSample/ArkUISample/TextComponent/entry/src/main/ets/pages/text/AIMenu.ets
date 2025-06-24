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

@Entry
@Component
export struct AIMenu {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SetUpAIMenu_title') }) {
          // [Start set_ai_menu]
          Text($r('app.string.AIMenu_Text_1'))
            .fontSize(16)
            .copyOption(CopyOptions.LocalDevice)
            .enableDataDetector(true)// 使能实体识别
            .dataDetectorConfig({
              // 配置识别样式
              // types可支持PHONE_NUMBER电话号码、URL链接、EMAIL邮箱、ADDRESS地址、DATE_TIME时间
              // types设置为null或者[]时，识别所有类型的实体
              types: [], onDetectResultUpdate: (result: string) => {
              }
            })
          // [End set_ai_menu]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SetUpAIMenu_title'))
  }
}