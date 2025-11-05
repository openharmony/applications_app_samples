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
// [Start prop_eight_start]
// [StartExclude prop_eight_start]
// 以下是嵌套类对象的数据结构。
@Observed
class Son {
  public title: string;
  constructor(title: string) {
    this.title = title;
  }
}

@Observed
class Father {
  public name: string;
  public son: Son;
  constructor(name: string, son: Son) {
    this.name = name;
    this.son = son;
  }
}
// [EndExclude prop_eight_start]
@Entry
@Component
struct ObservedDemo {
  // 初始化嵌套对象（使用@State管理，与UI绑定）
  @State father: Father = new Father(
    '父亲的名字',
    new Son('儿子的标题')
  );

  build() {
      Column() {
        // 展示Father和Son的数据
        Column({ space: 15 }) {
          Text('嵌套对象数据展示')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin(20)

          // 展示Father的name属性
          Text(`父亲的名字: ${this.father.name}`)
            .fontSize(16)

          // 展示Son的title属性（嵌套层级）
          Text(`儿子的标题: ${this.father.son.title}`)
            .fontSize(16)
        }
        .margin(30)

        // 操作按钮：修改数据
        Row({ space: 20 }) {
          // 按钮1：修改Father的name（第一层属性）
          Button(`change the father's name`)
            .onClick(() => {
              this.father.name = '新的父亲名字'; // 直接修改，@Observed会触发更新
            })

          // 按钮2：修改Son的title（嵌套的第二层属性）
          Button(`modify the son's title`)
            .onClick(() => {
              this.father.son.title = '新的儿子标题'; // 深层修改，@Observed会触发更新
            })
        }
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
  }
}
// [End prop_eight_start]

@Builder
export function MyObservedDemoBuilder(){
  ObservedDemo()
}