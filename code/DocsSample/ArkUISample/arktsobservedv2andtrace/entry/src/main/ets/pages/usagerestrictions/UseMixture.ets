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
// [Start Use_Mixture]
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

@Entry
@ComponentV2
struct Index {
  // @State info: Info = new Info(); 无法混用，编译时报错
  @Local info: Info = new Info();

  build() {
    Column() {
      Text(`name: ${this.info.name}`)
        .fontSize(20)
        .margin(10)
      Text(`age: ${this.info.age}`)
        .fontSize(20)
        .margin(10)
      Text(`jobName: ${this.info.job.jobName}`)
        .fontSize(20)
        .margin(10)
      Button('change age')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.info.age++;
        })
      Button('Change job')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.info.job.jobName = 'Doctor';
        })
    }
    .width('100%')
  }
}

// [End Use_Mixture]
const useMixture = Index;
export default useMixture;