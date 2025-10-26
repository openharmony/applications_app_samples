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
class UseMixtureJob {
  @Trace public jobName: string = 'Teacher';
};
@ObservedV2
class UseMixtureInfo {
  @Trace public name: string = 'Tom';
  // The 'age' property is decorated with @Trace, so its changes will trigger UI updates
  @Trace public age: number = 25;
  public job: UseMixtureJob = new UseMixtureJob();
};
@Entry
// @Component 需使用@ComponentV2
@ComponentV2
struct UseMixture {
  // @State info: UseMixtureInfo = new UseMixtureInfo(); 无法混用，编译时报错
  @Local info: UseMixtureInfo = new UseMixtureInfo();

  build() {
    Column() {
      Text(`name: ${this.info.name}`)
      Text(`age: ${this.info.age}`)
      Text(`jobName: ${this.info.job.jobName}`)
      Button('change age')
        .onClick(() => {
          this.info.age++;
        });
      Button('Change job')
        .onClick(() => {
          this.info.job.jobName = 'Doctor';
        });
    }
  }
}
// [End Use_Mixture]