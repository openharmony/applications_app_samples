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

declare interface AttributeModifier<T> {

  applyNormalAttribute?(instance: T): void;

  applyPressedAttribute?(instance: T): void;

  applyFocusedAttribute?(instance: T): void;

  applyDisabledAttribute?(instance: T): void;

  applySelectedAttribute?(instance: T): void;

}

declare class CommonMethod<T> {
  attributeModifier(modifier: AttributeModifier<T>): T;
}
// [Start Common_MyButtonModifier4]
export class MyButtonModifier4 implements AttributeModifier<ButtonAttribute> {
  applyNormalAttribute(instance: ButtonAttribute): void {
    instance.backgroundColor('#17A98D')
      .borderColor('#707070')
      .borderWidth(2)
  }

  applyPressedAttribute(instance: ButtonAttribute): void {
    instance.backgroundColor('#2787D9')
      .borderColor('#FFC000')
      .borderWidth(5)
  }
}
// [End Common_MyButtonModifier4]