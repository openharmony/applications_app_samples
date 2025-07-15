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

// 并发函数中使用自定义类或函数
// 并发函数中使用自定义类或函数时需定义在不同文件，否则会被认为是闭包，如下例所示。
// [Start concurrent_taskpool_custom_class_function]
import { taskpool } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { testAdd, MyTestA, MyTestB } from './Test';

function add(arg: number) {
  return ++arg;
}

class TestA {
  constructor(name: string) {
    this.name = name;
  }
  name: string = 'ClassA';
}

class TestB {
  static nameStr: string = 'ClassB';
}

@Concurrent
function testFunc() {
  // case1：在并发函数中直接调用同文件内定义的类或函数

  // 直接调用同文件定义的函数add()，add飘红报错：
  // Only imported variables and local variables can be used in @Concurrent decorated functions. <ArkTSCheck>
  // add(1);
  // 直接使用同文件定义的TestA构造，TestA飘红报错：
  // Only imported variables and local variables can be used in @Concurrent decorated functions. <ArkTSCheck>
  // let a = new TestA('aaa');
  // 直接访问同文件定义的TestB的成员nameStr，TestB飘红报错：
  // Only imported variables and local variables can be used in @Concurrent decorated functions. <ArkTSCheck>
  // console.info(`TestB name is: ${TestB.nameStr}`);

  // case2：在并发函数中调用定义在Test.ets文件并导入当前文件的类或函数

  // 输出结果：res1 is: 2
  console.info(`res1 is: ${testAdd(1)}`);
  const tmpStr = new MyTestA('TEST A');
  // 输出结果：res2 is: TEST A
  console.info(`res2 is: ${tmpStr.name}`);
  // 输出结果：res3 is: MyTestB
  console.info(`res3 is: ${MyTestB.nameStr}`);
}


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          const task = new taskpool.Task(testFunc);
          taskpool.execute(task).then(() => {
            console.info('taskpool: execute task success!');
          }).catch((e:BusinessError) => {
            console.error(`taskpool: execute: Code: ${e.code}, message: ${e.message}`);
          })
          // [StartExclude update_message_on_success]
          this.message = 'success';
          // [EndExclude update_message_on_success]
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End concurrent_taskpool_custom_class_function]
