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
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';
import resource from '../common/resource';

// [Start parent_component]
@Observed
class Task {
  public isFinished: boolean = false;

  constructor(isFinished: boolean) {
    this.isFinished = isFinished;
  }
}
const DOMAIN = 0x0000;
@Entry
@Component
struct ParentComponent {
  @State @Watch('onTaskAChanged') taskA: Task = new Task(false);
  @State @Watch('onTaskBChanged') taskB: Task = new Task(false);
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // 请将$r('app.string.watch_text5')替换为实际资源文件，在本示例中该资源文件的value值为"父组件任务A状态:"
  @State type1: string = this.context!.resourceManager.getStringSync($r('app.string.watch_text5').id);
  // 请将$r('app.string.watch_text6')替换为实际资源文件，在本示例中该资源文件的value值为"父组件任务B状态:"
  @State type2: string = this.context!.resourceManager.getStringSync($r('app.string.watch_text6').id);

  onTaskAChanged(changedPropertyName: string): void {
    // 请将$r('app.string.watch_text12')替换为实际资源文件，在本示例中该资源文件的value值为"观测到父组件任务属性变化:"
    hilog.info(DOMAIN, resource.resourceToString($r('app.string.watch_text12')), changedPropertyName);
  }

  onTaskBChanged(changedPropertyName: string): void {
    // 请将$r('app.string.watch_text12')替换为实际资源文件，在本示例中该资源文件的value值为"观测到父组件任务属性变化:"
    hilog.info(DOMAIN, resource.resourceToString($r('app.string.watch_text12')), changedPropertyName);
  }

  build() {
    Column() {
      // 请将$r('app.string.watch_text7')替换为实际资源文件，在本示例中该资源文件的value值为"已完成"
      // 请将$r('app.string.watch_text8')替换为实际资源文件，在本示例中该资源文件的value值为"未完成"
      Text(`${this.type1} ${this.taskA.isFinished ? resource.resourceToString($r('app.string.watch_text7')) : resource.resourceToString($r('app.string.watch_text8'))}`)
      Text(`${this.type2} ${this.taskB.isFinished ? resource.resourceToString($r('app.string.watch_text7')) : resource.resourceToString($r('app.string.watch_text8'))}`)
      ChildComponent({ taskA: this.taskA, taskB: this.taskB })
      // 请将$r('app.string.watch_text9')替换为实际资源文件，在本示例中该资源文件的value值为"切换任务状态"
      Button(resource.resourceToString($r('app.string.watch_text9')))
        .onClick(() => {
          this.taskB = new Task(!this.taskB.isFinished);
          this.taskA = new Task(!this.taskA.isFinished);
        })
    }
  }
}

@Component
struct ChildComponent {
  @ObjectLink @Watch('onObjectLinkTaskChanged') taskB: Task;
  @Link @Watch('onLinkTaskChanged') taskA: Task;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // 请将$r('app.string.watch_text10')替换为实际资源文件，在本示例中该资源文件的value值为"子组件任务A状态:"
  @State type1: string = this.context!.resourceManager.getStringSync($r('app.string.watch_text10').id);
  // 请将$r('app.string.watch_text11')替换为实际资源文件，在本示例中该资源文件的value值为"子组件任务B状态:"
  @State type2: string = this.context!.resourceManager.getStringSync($r('app.string.watch_text11').id);

  onObjectLinkTaskChanged(changedPropertyName: string): void {
    // 请将$r('app.string.watch_text13')替换为实际资源文件，在本示例中该资源文件的value值为"观测到子组件@ObjectLink关联的任务属性变化:"
    hilog.info(DOMAIN, resource.resourceToString($r('app.string.watch_text13')), changedPropertyName);
  }

  onLinkTaskChanged(changedPropertyName: string): void {
    // 请将$r('app.string.watch_text14')替换为实际资源文件，在本示例中该资源文件的value值为"观测到子组件@Link关联的任务属性变化:"
    hilog.info(DOMAIN, resource.resourceToString($r('app.string.watch_text14')), changedPropertyName);
  }

  build() {
    Column() {
      // 请将$r('app.string.watch_text7')替换为实际资源文件，在本示例中该资源文件的value值为"已完成"
      // 请将$r('app.string.watch_text8')替换为实际资源文件，在本示例中该资源文件的value值为"未完成"
      Text(`${this.type1} ${this.taskA.isFinished ? resource.resourceToString($r('app.string.watch_text7')) : resource.resourceToString($r('app.string.watch_text8'))}`)
      Text(`${this.type2} ${this.taskB.isFinished ? resource.resourceToString($r('app.string.watch_text7')) : resource.resourceToString($r('app.string.watch_text8'))}`)
    }
  }
}

// [End parent_component]