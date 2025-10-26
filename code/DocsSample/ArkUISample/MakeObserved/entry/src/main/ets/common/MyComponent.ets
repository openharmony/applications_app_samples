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
//[Start UIUtils_makeObserved]
import { UIUtils } from '@kit.ArkUI';
// let res1 = UIUtils.makeObserved(2); // 非法类型入参，错误用法，编译报错
let res2 = UIUtils.makeObserved(undefined); // 非法类型入参，错误用法，返回自身，res2 === undefined
let res3 = UIUtils.makeObserved(null); // 非法类型入参，错误用法，返回自身，res3 === null

class Info4 {
 public id: number = 0;
}
let rawInfo: Info4 = UIUtils.makeObserved(new Info4()); // 正确用法
//[End UIUtils_makeObserved]

//[Start UIUtils_makeObserved1]
@ObservedV2
class Info3 {
  @Trace public id: number = 0;
}
// 错误用法：makeObserved发现传入的实例是@ObservedV2装饰的类的实例，则返回传入对象自身
let observedInfo: Info3 = UIUtils.makeObserved(new Info3());

class Info2 {
 public id: number = 0;
}
// 正确用法：传入对象既不是@ObservedV2/@Observed装饰的类的实例，也不是makeObserved封装过的代理数据
// 返回可观察数据
let observedInfo1: Info2 = UIUtils.makeObserved(new Info2());
// 错误用法：传入对象为makeObserved封装过的代理数据，此次makeObserved不做处理
let observedInfo2: Info2 = UIUtils.makeObserved(observedInfo1);
//[End UIUtils_makeObserved1]



// 定义一个简单的 Info 类
@ObservedV2
class Info {
  @Trace public id: number = 0;

  constructor(id?: number) {
    if (id !== undefined) {
      this.id = id;
    }
  }
}

@ComponentV2
export struct MyComponent {
  // 正确用法：@State 变量可以直接使用 @Observed 类实例作为初始值
  @Local message: Info = new Info(20);

  // 这样也不会抛出异常，因为 @State 已经处理了观测功能
  @Local message2: Info = UIUtils.makeObserved(new Info(30));

  // [Start State_throw]
  // 错误写法，运行时异常
  // @State message: Info = UIUtils.makeObserved(new Info(20));
  // [End State_throw]
  build() {
    Column() {
      Text(`Message ID: ${this.message.id}`)
        .fontSize(16)

      Text(`Message2 ID: ${this.message2.id}`)
        .fontSize(16)

      Button('Update Message').onClick(()=>{
        this.message.id += 1;
      })

      Button('Update Message2').onClick(()=>{
        this.message2.id += 1;
      })
    }
  }
}
