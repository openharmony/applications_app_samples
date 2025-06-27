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
export struct AutoFill {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ description: $r('app.string.Auto_Fill_description') }) {
          // [Start auto_fill]
          TextInput({ placeholder: $r('app.string.Auto_Fill_PlaceHolder') })
            .width('95%')
            .height(40)
            .margin(20)
            .contentType(ContentType.EMAIL_ADDRESS)
          // [End auto_fill]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Auto_Fill'))
  }
}