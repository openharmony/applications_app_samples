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

// [Start builder_source_update_refresh]
@Observed
class TodoListData {
  public planList: ResourceStr[] = [
    // app.string.get_up资源文件中的value值为'7.30 起床'
    $r('app.string.get_up'),
    // app.string.breakfast资源文件中的value值为'8.30 早餐'
    $r('app.string.breakfast'),
    // app.string.lunch资源文件中的value值为'11.30 中餐'
    $r('app.string.lunch'),
    // app.string.dinner资源文件中的value值为'17.30 晚餐'
    $r('app.string.dinner'),
    // app.string.midnight_snack资源文件中的value值为'21.30 夜宵'
    $r('app.string.midnight_snack'),
    // app.string.bathe资源文件中的value值为'22.30 洗澡'
    $r('app.string.bathe'),
    // app.string.sleep资源文件中的value值为'1.30 睡觉'
    $r('app.string.sleep')
  ];
}

@Component
struct StateTodoComponent {
  build() {
    Row() {
      // app.string.all_tasks资源文件中的value值为'全部待办'
      Text($r('app.string.all_tasks'))
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .margin({ top: 10, bottom: 10 })
  }
}

@Component
struct BuilderAllChooseComponent {
  @Link isFinished: boolean;

  build() {
    Row() {
      // app.string.check_all资源文件中的value值为'全选'
      Button($r('app.string.check_all'), { type: ButtonType.Capsule })
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
struct BuilderThingComponent {
  @Prop isFinished: boolean;
  @Prop thing: string;

  @Builder
  displayIcon(icon: Resource) {
    Image(icon)
      .width(28)
      .height(28)
      .onClick(() => {
        this.isFinished = !this.isFinished;
      })
      // [StartExclude builder_source_update_refresh]
      .id(this.thing)
      // [EndExclude builder_source_update_refresh]
  }

  build() {
    // 待办事项1
    Row({ space: 15 }) {
      if (this.isFinished) {
        // $r('app.media.finished')需要替换为开发者所需的资源文件
        this.displayIcon($r('app.media.finished'));
      } else {
        // $r('app.media.unfinished')需要替换为开发者所需的资源文件
        this.displayIcon($r('app.media.unfinished'));
      }
      Text(`${this.thing}`)
        .fontSize(24)
        .decoration({ type: this.isFinished ? TextDecorationType.LineThrough : TextDecorationType.None })
        .onClick(() => {
          // app.string.la_la资源文件中的value值为'啦'
          this.thing += this.getUIContext().getHostContext()!.resourceManager.getStringSync($r('app.string.la_la').id);
        })
    }
    .height('8%')
    .width('90%')
    .padding({ left: 15 })
    .opacity(this.isFinished ? 0.3 : 1)
    .border({ width: 1 })
    .borderColor(Color.White)
    .borderRadius(25)
    .backgroundColor(Color.White)
  }
}

@Entry
@Component
struct BuilderIndex {
  @State isFinished: boolean = false;
  @State data: TodoListData = new TodoListData(); // View绑定ViewModel的数据

  aboutToAppear(): void {
    for (let i = 0; i < this.data.planList.length; i++) {
      this.data.planList[i] =
        this.getUIContext().getHostContext()!.resourceManager.getStringSync((this.data.planList[i] as Resource).id);
    }
  }

  build() {
    Column() {
      // 全部待办
      StateTodoComponent()

      // 全选
      BuilderAllChooseComponent({ isFinished: this.isFinished })

      List() {
        ForEach(this.data.planList, (item: string) => {
          // 待办事项1
          BuilderThingComponent({ isFinished: this.isFinished, thing: item })
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

// [End builder_source_update_refresh]