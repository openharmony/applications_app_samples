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

// [Start foreach_update_refresh]
@Component
struct ForEachTodoComponent {
  build() {
    Row() {
      // 请将$r('app.string.all_tasks')替换为实际资源文件，在本示例中该资源文件的value值为"全部待办"
      Text($r('app.string.all_tasks'))
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .margin({ top: 10, bottom: 10 })
  }
}

@Component
struct ForEachAllChooseComponent {
  @Link isFinished: boolean;

  build() {
    Row() {
      // 请将$r('app.string.check_all')替换为实际资源文件，在本示例中该资源文件的value值为"全选"
      Button($r('app.string.check_all'), { type: ButtonType.Normal })
        .onClick(() => {
          this.isFinished = !this.isFinished;
        })
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#f7f6cc74')
    }
    .padding({ left: 15 })
    .width('100%')
    .margin({ top: 10, bottom: 10 })
  }
}

@Component
struct ForEachThingComponent {
  @Prop isFinished: boolean;
  @Prop thing: string;

  build() {
    // 待办事项1
    Row({ space: 15 }) {
      if (this.isFinished) {
        // 请将$r('app.media.finished')替换为实际资源文件
        Image($r('app.media.finished'))
          .width(28)
          .height(28)
      } else {
        // 请将$r('app.media.unfinished')替换为实际资源文件
        Image($r('app.media.unfinished'))
          .width(28)
          .height(28)
          // [StartExclude foreach_update_refresh]
          .id(this.thing)
          // [EndExclude foreach_update_refresh]
      }
      Text(`${this.thing}`)
        .fontSize(24)
        .decoration({ type: this.isFinished ? TextDecorationType.LineThrough : TextDecorationType.None })
    }
    .height('8%')
    .width('90%')
    .padding({ left: 15 })
    .opacity(this.isFinished ? 0.3 : 1)
    .border({ width: 1 })
    .borderColor(Color.White)
    .borderRadius(25)
    .backgroundColor(Color.White)
    .onClick(() => {
      this.isFinished = !this.isFinished;
    })
  }
}

@Entry
@Component
struct ForEachIndex {
  @State isFinished: boolean = false;
  @State planList: ResourceStr[] = [
    // 请将$r('app.string.get_up')替换为实际资源文件，在本示例中该资源文件的value值为"7.30 起床"
    $r('app.string.get_up'),
    // 请将$r('app.string.breakfast')替换为实际资源文件，在本示例中该资源文件的value值为"8.30 早餐"
    $r('app.string.breakfast'),
    // 请将$r('app.string.lunch')替换为实际资源文件，在本示例中该资源文件的value值为"11.30 中餐"
    $r('app.string.lunch'),
    // 请将$r('app.string.dinner')替换为实际资源文件，在本示例中该资源文件的value值为"17.30 晚餐"
    $r('app.string.dinner'),
    // 请将$r('app.string.midnight_snack')替换为实际资源文件，在本示例中该资源文件的value值为"21.30 夜宵"
    $r('app.string.midnight_snack'),
    // 请将$r('app.string.bathe')替换为实际资源文件，在本示例中该资源文件的value值为"22.30 洗澡"
    $r('app.string.bathe'),
    // 请将$r('app.string.sleep')替换为实际资源文件，在本示例中该资源文件的value值为"1.30 睡觉"
    $r('app.string.sleep')
  ];
  context1 = this.getUIContext().getHostContext();

  aboutToAppear(): void {
    for (let i = 0; i < this.planList.length; i++) {
      this.planList[i] = this.context1!.resourceManager.getStringSync((this.planList[i] as Resource).id);
    };
  }

  build() {
    Column() {
      // 全部待办
      ForEachTodoComponent()

      // 全选
      ForEachAllChooseComponent({ isFinished: this.isFinished })

      List() {
        ForEach(this.planList, (item: string) => {
          // 待办事项1
          ForEachThingComponent({ isFinished: this.isFinished, thing: item })
            .margin(5)
        })
      }
    }
    .height('100%')
    .width('100%')
    .margin({ top: 5, bottom: 5 })
    .backgroundColor('#90f1f3f5')
  }
}

// [End foreach_update_refresh]