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
// [Start freeze_template5_PageA_start]
// Page1.ets
@ObservedV2
class Book {
  @Trace name: string = 'TS';

  constructor(name: string) {
    this.name = name;
  }
}

@Entry
@ComponentV2
struct PageA {
  pageInfo: NavPathStack = new NavPathStack();

  build() {
    Column() {
      Navigation(this.pageInfo) {
        Child()

        Button('Go to next page').fontSize(30)
          .onClick(() => {
            this.pageInfo.pushPathByName('PageB', null);
          })
      }
    }
  }
}

@ComponentV2({ freezeWhenInactive: true })
export struct Child {
  @Local bookTest: Book = new Book(`A Midsummer Night's Dream`);

  @Monitor('bookTest.name')
  onMessageChange(monitor: IMonitor) {
    console.info(`The book name change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  textUpdate(): number {
    console.info('The text is update');
    return 25;
  }

  build() {
    Column() {
      Text(`The book name is ${this.bookTest.name}`).fontSize(this.textUpdate())

      Button('change BookName')
        .onClick(() => {
          setTimeout(() => {
            this.bookTest = new Book(`Jane Austen's Pride and Prejudice`);
          }, 3000);
        })
    }
  }
}
// [End freeze_template5_PageA_start]

// [Start freeze_template5_PageB_start]
@Builder
function page2Builder() {
  PageB();
}

@ComponentV2
struct PageB {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Text('This is the Page2')

        Button('Back').fontSize(30)
          .onClick(() => {
            this.pathStack.pop();
          })
      }
    }.onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}
// [End freeze_template5_PageB_start]