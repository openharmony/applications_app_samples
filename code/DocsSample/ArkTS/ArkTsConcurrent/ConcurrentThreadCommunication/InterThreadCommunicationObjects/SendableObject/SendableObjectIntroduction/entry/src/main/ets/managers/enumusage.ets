/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start example_modify_enum]
import { taskpool } from '@kit.ArkTS';
import { ModelState } from './Test';

@Sendable
class Model {
  public state: ModelState = ModelState.ACTIVE;

  getState() {
    console.info('model state is ' + this.state);
  }

  setState(state: ModelState) {
    this.state = state;
  }
}

@Concurrent
function setModelState(model: Model) {
  model.setState(ModelState.INACTIVE);
  model.getState();
}

@Entry
@Component
struct enumusage {
  @State message: string = 'Hello World';
  @State num: number = 0;

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(async () => {
          let model = new Model();
          model.getState();
          let task = new taskpool.Task(setModelState, model);
          await taskpool.execute(task);
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End example_modify_enum]