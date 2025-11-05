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
export struct SetTextInputType {
  build() {
    NavDestination() {
      Scroll() {
        Grid() {
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_1') }) {
              // [Start set_password_input_type_1]
              TextInput()
                .type(InputType.Normal)
                // [End set_password_input_type_1]
                .id('Normal')
            }
          }.width('100%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_2') }) {
              // [Start set_password_input_type_2]
              TextInput()
                .type(InputType.Password)
                // [End set_password_input_type_2]
                .id('Password')
            }
          }.width('100%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_3') }) {
              // [Start set_email_input_type_3]
              TextInput()
                .type(InputType.Email)
                // [End set_email_input_type_3]
                .id('Email')
            }
          }.width('100%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_4') }) {
              // [Start set_number_input_type_4]
              TextInput()
                .type(InputType.Number)
                // [End set_number_input_type_4]
                .id('Number')
            }
          }.width('100%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_5') }) {
              // [Start set_phonenumber_input_type_5]
              TextInput({ text: '+86 123-0123-0456' })
                .type(InputType.PhoneNumber)
                // [End set_phonenumber_input_type_5]
                .id('PhoneNumber')
            }
          }.width('100%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_6') }) {
              // [Start set_number_decimal_input_type_6]
              TextInput()
                .type(InputType.NUMBER_DECIMAL)
                // [End set_number_decimal_input_type_6]
                .id('NUMBER_DECIMAL')
            }
          }.width('100%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_7') }) {
              // [Start set_url_input_type_7]
              TextInput()
                .type(InputType.URL)
                // [End set_url_input_type_7]
                .id('URL')
            }
          }.width('100%')
        }
        .width('100%')
        .height('100%')
        .padding({ left: 12, right: 12 })
      }.id('scroll_')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SetTextInputType_title'))
  }
}