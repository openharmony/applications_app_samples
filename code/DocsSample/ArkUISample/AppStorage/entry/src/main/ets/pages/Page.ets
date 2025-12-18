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

// [Start appstorage_Page]
@Builder
export function PageBuilder() {
  Page()
}

// 应用全局共享一个AppStorage
@Component
struct Page {
  @StorageLink('linkA') linkA: number = 2;
  @StorageProp('propB') propB: number = 2;
  pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Row(){
        Column({ space:5 }) {
          Text(`${this.linkA}`)
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
          Text(`${this.propB}`)
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
          Button('Change linkA')
            .onClick(()=>{
              this.linkA++;
            })
          Button('Change propB')
            .onClick(()=>{
              this.propB++;
            })  
          Button('Back Index')
            .onClick(()=>{
              this.pageStack.pop();
            })
        }
        .width('100%')
      }
    }
    .onReady((context: NavDestinationContext) => {
      this.pageStack = context.pathStack;
    })
  }
}

// [End appstorage_Page]