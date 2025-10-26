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

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State myText: string = 'message';
  imagePath = $r('app.media.layered_image');
  imageUrl = 'https://xyz/test.jpg';
  count = 0;
  counter = 1;
  fontSize = 16;
  offsetNum = 10;

  // [Start segment11]
  myClickHandler(): void {
    this.counter += 2;
  }

  // [StartExclude segment11]

  // [Start segment12]
  fn = () => {
    console.info(`counter: ${this.counter}`);
    this.counter++;
  };

  // [StartExclude segment12]

  build() {
    RelativeContainer() {
      Column() {
        // [Start segment1]
        Column() {
          Text('item 1')
          Divider()
          Text('item 2')
        }

        // [End segment1]

        // [Start segment2]
        Image('https://xyz/test.jpg')
        // [End segment2]

        // [Start segment3]
        // string类型的参数
        Text('test')
        // $r形式引入应用资源，可应用于多语言场景
        Text($r('app.string.title_value'))
        // 无参数形式
        Text()
        // [End segment3]

        // [Start segment4]
        Image(this.imagePath)
        Image('https://' + this.imageUrl)
        Text(`count: ${this.count}`)
        // [End segment4]

        // [Start segment5]
        Text('test')
          .fontSize(12)
        // [End segment5]

        // [Start segment6]
        Image('test.jpg')
          .alt('error.jpg')
          .width(100)
          .height(100)
        // [End segment6]

        // [Start segment7]
        Text('hello')
          .fontSize(this.fontSize)
        Image('test.jpg')
          .width(this.count % 2 === 0 ? 100 : 200)
          .height(this.offsetNum + 100)
        // [End segment7]

        // [Start segment8]
        Text('hello')
          .fontSize(20)
          .fontColor(Color.Red)
          .fontWeight(FontWeight.Bold)
        // [End segment8]

        // [Start segment9]
        Button('Click me')
          .onClick(() => {
            this.myText = 'ArkUI';
          })
        // [End segment9]

        // [Start segment10]
        Button('add counter')
          .onClick(() => {
            this.counter += 2;
          })
        // [End segment10]

        // [EndExclude segment11]
        Button('add counter')
          .onClick(this.myClickHandler.bind(this))
        // [End segment11]

        // [EndExclude segment12]
        Button('add counter')
          .onClick(this.fn)
        // [End segment12]

        // [Start segment13]
        Column() {
          Text('Hello')
            .fontSize(100)
          Divider()
          Text(this.myText)
            .fontSize(100)
            .fontColor(Color.Red)
        }

        // [End segment13]

        // [Start segment14]
        Column() {
          Row() {
            Image('test1.jpg')
              .width(100)
              .height(100)
            Button('click +1')
              .onClick(() => {
                console.info('+1 clicked!');
              })
          }
        }

        // [End segment14]

      }
    }
    .height('100%')
    .width('100%')
  }
}