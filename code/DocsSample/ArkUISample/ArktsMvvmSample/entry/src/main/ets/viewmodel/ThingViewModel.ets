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

// [Start thing_view_model]
import ThingModel from '../model/ThingModel';

@Observed
export default class ThingViewModel {
  @Track public thingName: string = 'Todo';
  @Track public isFinish: boolean = false;
  public context: Context = AppStorage.get('context')!

  updateTask(thing: ThingModel) {
    this.thingName = thing.thingName;
    this.isFinish = thing.isFinish;
  }

  updateIsFinish(): void {
    this.isFinish = !this.isFinish;
  }

  addSuffixes(): void {
    // $r('app.string.la_la')需要替换为开发者所需的资源文件
    this.thingName += this.context.resourceManager.getStringSync($r('app.string.la_la').id);
  }
}

// [End thing_view_model]