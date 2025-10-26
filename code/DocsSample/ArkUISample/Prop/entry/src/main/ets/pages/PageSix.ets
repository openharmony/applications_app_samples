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

// [Start prop_six_start]
let nextId: number = 1;

// @Observed
class Book {
  public id: number;
  public title: string;
  public pages: number;
  public readIt: boolean = false;

  constructor(title: string, pages: number) {
    this.id = nextId++;
    this.title = title;
    this.pages = pages;
  }
}

@Component
struct ReaderComp {
  @Prop book: Book = new Book('', 1);

  build() {
    Row() {
      Text(` ${this.book ? this.book.title : 'Book is undefined'}`).fontColor('#e6000000')
      Text(` has ${this.book ? this.book.pages : 'Book is undefined'} pages!`).fontColor('#e6000000')
      Text(` ${this.book ? this.book.readIt ? 'I have read' : 'I have not read it' : 'Book is undefined'}`)
        .fontColor('#e6000000')
        .onClick(() => this.book.readIt = true)
    }
  }
}

@Entry
@Component
struct Library {
  @State allBooks: Book[] = [new Book('C#', 765), new Book('JS', 652), new Book('TS', 765)];

  build() {
      Column() {
        Text('library`s all time favorite')
          .width(312)
          .height(40)
          .backgroundColor('#0d000000')
          .borderRadius(20)
          .margin(12)
          .padding({ left: 20 })
          .fontColor('#e6000000')
        ReaderComp({ book: this.allBooks[2] })
          .backgroundColor('#0d000000')
          .width(312)
          .height(40)
          .padding({ left: 20, top: 10 })
          .borderRadius(20)
          .colorBlend('#e6000000')
        Text('Books on loan to a reader')
          .width(312)
          .height(40)
          .backgroundColor('#0d000000')
          .borderRadius(20)
          .margin(12)
          .padding({ left: 20 })
          .fontColor('#e6000000')
        ForEach(this.allBooks, (book: Book) => {
          ReaderComp({ book: book })
            .margin(12)
            .width(312)
            .height(40)
            .padding({ left: 20, top: 10 })
            .backgroundColor('#0d000000')
            .borderRadius(20)
        },
          (book: Book) => book.id.toString())
        Button('Add new')
          .width(312)
          .height(40)
          .margin(12)
          .fontColor('#FFFFFF')
          .onClick(() => {
            this.allBooks.push(new Book('JA', 512));
          })
        Button('Remove first book')
          .width(312)
          .height(40)
          .margin(12)
          .fontColor('#FFFFFF')
          .onClick(() => {
            if (this.allBooks.length > 0) {
              this.allBooks.shift();
            } else {

            }
          })
        Button('Mark read for everyone')
          .width(312)
          .height(40)
          .margin(12)
          .fontColor('#FFFFFF')
          .onClick(() => {
            this.allBooks.forEach((book) => book.readIt = true)
          })
      }
  }
}
// [End prop_six_start]

@Builder
export function MyLibraryBuilder(){
  Library()
}