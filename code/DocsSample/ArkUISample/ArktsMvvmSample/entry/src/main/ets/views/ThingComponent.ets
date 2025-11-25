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

// [Start thing_component_view]
import ThingViewModel from '../viewmodel/ThingViewModel';

@Component
export struct ThingComponent {
  @ObjectLink thing: ThingViewModel;

  @Builder
  displayIcon(icon: Resource) {
    Image(icon)
      .width(28)
      .height(28)
      .onClick(() => {
        this.thing.updateIsFinish(); // View层点击事件发生时，调用ViewModel层方法updateIsFinish处理逻辑
      })
      // [StartExclude builder_source_update_refresh]
      .id(this.thing.thingName)
      // [EndExclude builder_source_update_refresh]
  }

  build() {
    // 待办事项
    Row({ space: 15 }) {
      if (this.thing.isFinish) {
        // $r('app.media.finished')需要替换为开发者所需的资源文件
        this.displayIcon($r('app.media.finished'));
      } else {
        // $r('app.media.unfinished')需要替换为开发者所需的资源文件
        this.displayIcon($r('app.media.unfinished'));
      }

      Text(`${this.thing.thingName}`)
        .fontSize(24)
        .decoration({ type: this.thing.isFinish ? TextDecorationType.LineThrough : TextDecorationType.None })
        .onClick(() => {
          this.thing.addSuffixes(); // View层点击事件发生时，调用ViewModel层方法addSuffixes处理逻辑
        })
    }
    .height('8%')
    .width('90%')
    .padding({ left: 15 })
    .opacity(this.thing.isFinish ? 0.3 : 1)
    .border({ width: 1 })
    .borderColor(Color.White)
    .borderRadius(25)
    .backgroundColor(Color.White)
  }
}
// [End thing_component_view]