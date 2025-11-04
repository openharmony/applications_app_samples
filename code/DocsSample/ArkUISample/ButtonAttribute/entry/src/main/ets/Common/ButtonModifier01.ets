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
// [Start Common_AttributeModifier]
declare interface AttributeModifier<T> {

  applyNormalAttribute?(instance: T): void;

  applyPressedAttribute?(instance: T): void;

  applyFocusedAttribute?(instance: T): void;

  applyDisabledAttribute?(instance: T): void;

  applySelectedAttribute?(instance: T): void;

}
// [End Common_AttributeModifier]

// [Start Common_CommonMethod]
declare class CommonMethod<T> {
  attributeModifier(modifier: AttributeModifier<T>): T;
}
// [End Common_CommonMethod]

// [Start Common_MyButtonModifier]
export class MyButtonModifier implements AttributeModifier<ButtonAttribute> {
  // 可以实现一个Modifier，定义私有的成员变量，外部可动态修改
  public isDark: boolean = false

  // 通过构造函数，创建时传参
  constructor(dark?: boolean) {
    this.isDark = dark ?? false
  }

  applyNormalAttribute(instance: ButtonAttribute): void {
    // instance为Button的属性对象，可以通过instance对象对属性进行修改
    if (this.isDark) { // 支持业务逻辑的编写
      // 属性变化触发apply函数时，变化前已设置并且变化后未设置的属性会恢复为默认值
      instance.backgroundColor('#707070')
    } else {
      // 支持属性的链式调用
      instance.backgroundColor('#17A98D')
        .borderColor('#707070')
        .borderWidth(2)
    }
  }
}
// [End Common_MyButtonModifier]
