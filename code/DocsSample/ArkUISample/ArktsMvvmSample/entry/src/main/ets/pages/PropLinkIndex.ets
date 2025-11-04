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

// [Start prop_link_update_refresh]
@Component
struct PropLinkTodoComponent {
  build() {
    Row() {
      // $r('app.string.all_tasks')需要替换为开发者所需的资源文件
      Text($r('app.string.all_tasks'))
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .margin({ top: 10, bottom: 10 })
  }
}

@Component
struct PropLinkAllChooseComponent {
  @Link isFinished: boolean;

  build() {
    Row() {
      // $r('app.string.check_all')需要替换为开发者所需的资源文件
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
struct ThingComponent1 {
  @Prop isFinished: boolean;

  build() {
    // 待办事项1
    Row({ space: 15 }) {
      if (this.isFinished) {
        // $r('app.media.finished')需要替换为开发者所需的资源文件
        Image($r('app.media.finished'))
          .width(28)
          .height(28)
      } else {
        // $r('app.media.unfinished')需要替换为开发者所需的资源文件
        Image($r('app.media.unfinished'))
          .width(28)
          .height(28)
      }
      // $r('app.string.learn_chinese')需要替换为开发者所需的资源文件
      Text($r('app.string.learn_chinese'))
        .fontSize(24)
        .decoration({ type: this.isFinished ? TextDecorationType.LineThrough : TextDecorationType.None })
    }
    .height('40%')
    .width('100%')
    .border({ width: 5 })
    .padding({ left: 15 })
    .onClick(() => {
      this.isFinished = !this.isFinished;
    })
  }
}

@Component
struct ThingComponent2 {
  @Prop isFinished: boolean;

  build() {
    // 待办事项1
    Row({ space: 15 }) {
      if (this.isFinished) {
        // $r('app.media.finished')需要替换为开发者所需的资源文件
        Image($r('app.media.finished'))
          .width(28)
          .height(28)
      } else {
        // $r('app.media.unfinished')需要替换为开发者所需的资源文件
        Image($r('app.media.unfinished'))
          .width(28)
          .height(28)
      }
      // $r('app.string.learn_advanced_math')需要替换为开发者所需的资源文件
      Text($r('app.string.learn_advanced_math'))
        .fontSize(24)
        .decoration({ type: this.isFinished ? TextDecorationType.LineThrough : TextDecorationType.None })
    }
    .height('40%')
    .width('100%')
    .border({ width: 5 })
    .padding({ left: 15 })
    .onClick(() => {
      this.isFinished = !this.isFinished;
    })
  }
}

@Entry
@Component
struct PropLinkIndex {
  @State isFinished: boolean = false;

  build() {
    Column() {
      // 全部待办
      PropLinkTodoComponent()

      // 全选
      PropLinkAllChooseComponent({ isFinished: this.isFinished })

      // 待办事项1
      ThingComponent1({ isFinished: this.isFinished })

      // 待办事项2
      ThingComponent2({ isFinished: this.isFinished })
    }
    .height('100%')
    .width('100%')
    .margin({ top: 5, bottom: 5 })
    .backgroundColor('#90f1f3f5')
  }
}
// [End prop_link_update_refresh]