/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

// [Start prop_thirteen_start]
class Animals {
  public name: string;

  constructor(name: string) {
    this.name = name;
  }
}

@Component
struct Child {
  @Prop animal: Animals | undefined;

  build() {
    Column() {
      Text(`Child's animal is  ${this.animal instanceof Animals ? this.animal.name : 'undefined'}`).fontSize(30)

      Button('Child change animals into tigers')
        .onClick(() => {
          // 赋值为Animals的实例
          this.animal = new Animals('Tiger');
        })

      Button('Child change animal to undefined')
        .onClick(() => {
          // 赋值为undefined
          this.animal = undefined;
        })

    }.width('100%')
  }
}

@Entry
@Component
struct Zoo {
  @State animal: Animals | undefined = new Animals('lion');

  build() {
      Column() {
        Text(`Parents' animals are  ${this.animal instanceof Animals ? this.animal.name : 'undefined'}`).fontSize(30)

        Child({ animal: this.animal })

        Button('Parents change animals into dogs')
          .onClick(() => {
            // 判断animal的类型，做属性的更新
            if (this.animal instanceof Animals) {
              this.animal.name = 'Dog';
            } else {
              console.info('num is undefined, cannot change property');
            }
          })

        Button('Parents change animal to undefined')
          .onClick(() => {
            // 赋值为undefined
            this.animal = undefined;
          })
      }
  }
}
// [End prop_thirteen_start]
@Builder
export function MyZooBuilder(){
  Zoo()
}