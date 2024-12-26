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

@Entry
@Component
struct Index {
  @State message: string = 'Business Expansion Scenario';

  build() {
    Column() {
      Text(this.message)
        .fontSize(20)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      Button('动态加载业务扩展场景')
        .width('50%')
        .onClick(() => {
          import('harlibrary').then((ns: ESObject) => {
            ns.Calc.staticAdd(8, 9); // 调用静态成员函数staticAdd()
            let calc: ESObject = new ns.Calc(); // 实例化类Calc
            calc.instanceAdd(10, 11); // 调用成员函数instanceAdd()
            ns.addHarlibrary(6, 7); // 调用全局方法addHarlibrary()

            // 使用类、成员函数和方法的字符串名字进行反射调用
            let className = 'Calc';
            let methodName = 'instanceAdd';
            let staticMethod = 'staticAdd';
            let functionName = 'addHarlibrary';
            ns[className][staticMethod](12, 13); // 调用静态成员函数staticAdd()
            let calc1: ESObject = new ns[className](); // 实例化类Calc
            calc1[methodName](14, 15); // 调用成员函数instanceAdd()
            ns[functionName](16, 17); // 调用全局方法addHarlibrary()
          });
        })
    }
    .height('100%')
    .width('100%')
  }
}