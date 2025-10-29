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

  onTaskAChanged(changedPropertyName: string): void {
    hilog.info(DOMAIN, 'Property of this parent component task is changed: %{public}s',
      JSON.stringify(changedPropertyName));
  }

  onTaskBChanged(changedPropertyName: string): void {
    hilog.info(DOMAIN, 'Property of this parent component task is changed: %{public}s',
      JSON.stringify(changedPropertyName));
  }

  build() {
    Column() {
      Text(`Parent component task A state: ${this.taskA.isFinished ? 'Finished' : 'Unfinished'}`);
      Text(`Parent component task B state: ${this.taskB.isFinished ? 'Finished' : 'Unfinished'}`);
      ChildComponent({ taskA: this.taskA, taskB: this.taskB });
      Button('Switch Task State')
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

  onObjectLinkTaskChanged(changedPropertyName: string): void {
    hilog.info(DOMAIN, 'Property of @ObjectLink associated task of the child component is changed: %{public}s',
      JSON.stringify(changedPropertyName));
  }

  onLinkTaskChanged(changedPropertyName: string): void {
    hilog.info(DOMAIN, 'Property of @Link associated task of the child component is changed: %{public}s',
      JSON.stringify(changedPropertyName));
  }

  build() {
    Column() {
      Text(`Child component task A state: ${this.taskA.isFinished ? 'Finished' : 'Unfinished'}`);
      Text(`Child component task B state: ${this.taskB.isFinished ? 'Finished' : 'Unfinished'}`);
    }
  }
}

// [End parent_component]