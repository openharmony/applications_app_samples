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
// [Start Inheritance_Mixture]
// 以@State装饰器为例
@ObservedV2
class Job {
  @Trace public jobName: string = 'Teacher';
}

@ObservedV2
class Info {
  @Trace public name: string = 'Tom';
  @Trace public age: number = 25;
  public job: Job = new Job();
}

class Message extends Info {
  constructor() {
    super();
  }
}

@Entry
@Component
struct Index {
  // @State message: Message = new Message();  无法混用，运行时报错
  message: Message = new Message();

  build() {
    Column() {
      Text(`name: ${this.message.name}`)
      Text(`age: ${this.message.age}`)
      Text(`jobName: ${this.message.job.jobName}`)
      Button('change age')
        .onClick(() => {
          this.message.age++;
        })
      Button('Change job')
        .onClick(() => {
          this.message.job.jobName = 'Doctor';
        })
    }
  }
}

// [End Inheritance_Mixture]
const inheritanceMixture = Index;
export default inheritanceMixture;