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
@Component
export struct MigrationNestedObjectPropertiesV1 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };

  build() {
    NavDestination() {
      UserProfile()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.migration_nested_object_properties'))
  }
}


// [Start Migration_Nested_Object_Properties_V1]
@Observed
class Address {
  public city: string;

  constructor(city: string) {
    this.city = city;
  }
}

@Observed
class User {
  public name: string;
  public address: Address;

  constructor(name: string, address: Address) {
    this.name = name;
    this.address = address;
  }
}

@Component
struct AddressView {
  // 子组件中@ObjectLink装饰的address从父组件初始化，接收被@Observed装饰的Address实例
  @ObjectLink address: Address;

  build() {
    Column() {
      Text(`City: ${this.address.city}`)
      Button('city +a')
        .onClick(() => {
          this.address.city += 'a';
        })
    }
  }
}

@Entry
@Component
struct UserProfile {
  @State user: User = new User('Alice', new Address('New York'));

  build() {
    Column() {
      Text(`Name: ${this.user.name}`)
      // 无法直接观察嵌套对象的属性变化，例如this.user.address.city
      // 只能观察到对象第一层属性变化，所以需要将嵌套的对象Address抽取到自定义组件AddressView
      AddressView({ address: this.user.address })
    }
  }
}
// [End Migration_Nested_Object_Properties_V1]