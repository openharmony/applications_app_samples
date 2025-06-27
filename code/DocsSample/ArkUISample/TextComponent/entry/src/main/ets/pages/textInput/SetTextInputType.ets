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
              TextInput()
                .id('Normal')
                .type(InputType.Normal)
            }
          }.width('33%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_2') }) {
              // [Start set_password_input_type]
              TextInput()
                .id('Password')
                .type(InputType.Password)
              // [End set_password_input_type]
            }
          }.width('33%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_3') }) {
              // [Start set_email_input_type]
              TextInput()
                .id('Email')
                .type(InputType.Email)
              // [End set_email_input_type]
            }
          }.width('33%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_4') }) {
              // [Start set_number_input_type]
              TextInput()
                .id('Number')
                .type(InputType.Number)
              // [End set_number_input_type]
            }
          }.width('33%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_5') }) {
              // [Start set_phonenumber_input_type]
              TextInput()
                .id('PhoneNumber')
                .type(InputType.PhoneNumber)
              // [End set_phonenumber_input_type]
            }
          }.width('33%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_6') }) {
              // [Start set_number_decimal_input_type]
              TextInput()
                .id('NUMBER_DECIMAL')
                .type(InputType.NUMBER_DECIMAL)
              // [End set_number_decimal_input_type]
            }
          }.width('33%')
          GridItem() {
            ComponentCard({ title: $r('app.string.SetTextInputType_title_7') }) {
              // [Start set_url_input_type]
              TextInput()
                .id('URL')
                .type(InputType.URL)
              // [End set_url_input_type]
            }
          }.width('33%')
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