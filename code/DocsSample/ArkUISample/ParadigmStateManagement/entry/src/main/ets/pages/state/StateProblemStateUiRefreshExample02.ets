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

// [Start state_problem_state_ui_refresh_example_02]
class Info {
  public address: string = 'Hangzhou';

  constructor(address: string) {
    this.address = address;
  }
}

class User {
  public info: Info = new Info('Tianjin');
}

@Entry
@Component
struct Test {
  @State info: Info = new Info('Shanghai');
  @State user: User = new User();

  aboutToAppear(): void {
    this.user.info = this.info;
  }

  build() {
    Column() {
      Text(`${this.info.address}`);
      Text(`${this.user.info.address}`);
      Button('change')
        .onClick(() => {
          this.user.info.address = 'Beijing';
        })
    }
  }
}
// [End state_problem_state_ui_refresh_example_02]

@Component
export struct StateProblemStateUiRefreshExample02 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Test()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_problem_state_ui_refresh_example_02'))
  }
}