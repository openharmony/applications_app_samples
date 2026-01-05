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

// [Start circular_reference_of_object]
import { PersistenceV2 } from '@kit.ArkUI';

@ObservedV2
class ClassA {
  @Trace public value: string = 'a';
  @Trace public refB: ClassB | undefined;
}

@ObservedV2
class ClassB {
  @Trace public value: string = 'b';
  @Trace public refA: ClassA | undefined;
}

@ObservedV2
class ClassC {
  @Trace public value: string = 'c';
  @Trace public objA: ClassA = new ClassA();
  @Trace public objB: ClassB = new ClassB();

  // ClassC是循环引用对象
  constructor() {
    this.objA.refB = this.objB;
    this.objB.refA = this.objA;
  }
}

@Entry
@ComponentV2
struct Page1 {
  @Local test: ClassC = PersistenceV2.globalConnect({
    type: ClassC,
    defaultCreator: () => new ClassC()
  })!;
  output: string[] = [];

  aboutToAppear(): void {
    const refAValue = this.test.objA?.refB?.refA?.value;
    const refBValue = this.test.objB?.refA?.refB?.value;
    this.output.push(`${refAValue}, ${refBValue}`);
    this.test.objA.value += 'a';
    this.test.objB.value += 'b';
  }

  build() {
    Column() {
      Row() {
        // 第一次打开应用，界面显示'a, b'
        // 第二次打开应用，界面显示'aa, bb'
        Text(this.output.join('\n\n'))
          .fontSize(24)
      }
    }
    .width('100%')
  }
}
// [End circular_reference_of_object]