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
// [Start Serialization_And_Deserialization]
import { plainToInstance, Type as TypeFromLibrary } from 'class-transformer'; // 导入三方库
import 'reflect-metadata'; // 三方库的@Type装饰器需要使用

// 模拟json键值对对象
let testJSON: Record<string, ESObject> = {
  'id': 1,
  'info': {
    'name': 'Tom',
    'age': 24
  },
  'friends': [
    {
      'name': 'John',
      'age': 23
    },
    {
      'name': 'Mary',
      'age': 24
    }
  ]
}

@ObservedV2
class Info {
  @Trace public name?: string;
  @Trace public age?: number;
}

@ObservedV2
class Person {
  public id?: number;
  // 使用三方库的@Type装饰器（重命名为TypeFromLibrary）标记内层属性的类型
  @TypeFromLibrary(() => Info)
  @Trace public info?: Info;
  // 使用三方库的@Type装饰器（重命名为TypeFromLibrary）标记内层属性的类型
  @TypeFromLibrary(() => Info)
  @Trace public friends?: Info[];
}

@Entry
@ComponentV2
struct SerializationAndDeserialization {
  @Local person: Person | undefined = undefined;
  aboutToAppear(): void {
    this.person = plainToInstance(Person, testJSON); // 直接将对象通过plainToInstance转为Person实例
  }

  build() {
    Column() {
      Text(`name: ${this.person?.info?.name}, age: ${this.person?.info?.age}`)
        .onClick(() => {
          if (this.person?.info?.age) {
            this.person!.info!.age++; // 修改可观察
          }
        })
      ForEach(this.person?.friends, (item: Info) => {
        Text(`friend name: ${item.name}, age: ${item.age}`)
          .onClick(() => {
            if (item.age) {
              item.age++; // 修改可观察
            }
          })
      })

      Button('Refresh Info')
        .onClick(() => {
          let json: string =
            `{
              "id":12,
                "__ob_info":
                  {
                    "__ob_name":"Jimmy",
                    "__ob_age":35
                   },
              "__ob_friends":[
                {
                  "__ob_name":"Bob",
                  "__ob_age":30
                },
                {
                  "__ob_name":"Kevin",
                  "__ob_age":33
                }
              ]
            }`;
          // 去除'__ob_'前缀后通过JSON.parse与plainToInstance将json字符串转化成Person对象
          this.person = plainToInstance(Person, JSON.parse(json.replaceAll('__ob_', '')));
        })
    }
  }
}
// [End Serialization_And_Deserialization]