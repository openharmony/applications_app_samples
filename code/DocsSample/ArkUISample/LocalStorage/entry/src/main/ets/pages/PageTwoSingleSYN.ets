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
// [Start localtorage_page_two_single_syn]
// 创建新实例并使用给定对象初始化
let paraOneLocal: Record<string, number> = { 'PropA': 47 };
let storageOneLocal: LocalStorage = new LocalStorage(paraOneLocal);

// 使LocalStorage可从@Component组件访问
@Entry(storageOneLocal)
@Component
struct ParentOne {
  // @LocalStorageProp变量装饰器与LocalStorage中的'PropA'属性建立单向绑定
  @LocalStorageProp('PropA') storagePropOne: number = 1;

  build() {
    Column({ space: 15 }) {
      // 点击后从47开始加1，只改变当前组件显示的storagePropOne ，不会同步到LocalStorage中
      Button(`ParentOne from LocalStorage ${this.storagePropOne}`)
        .onClick(() => {
          this.storagePropOne += 1;
        })
      ChildOne()
    }
  }
}

@Component
struct ChildOne {
  // @LocalStorageProp变量装饰器与LocalStorage中的'PropA'属性建立单向绑定
  @LocalStorageProp('PropA') storagePropTwo: number = 2;

  build() {
    Column({ space: 15 }) {
      // 当ParentOne改变时，当前storagePropTwo不会改变，显示47
      Text(`ParentOne from LocalStorage ${this.storagePropTwo}`)
    }
  }
}

// [End localtorage_page_two_single_syn]
