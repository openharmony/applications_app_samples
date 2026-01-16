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

// [Start to_do_list_model_class]
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import ThingModel from './ThingModel';

const DOMAIN = 0x0001;
const TAG = 'TodoListModel';

export default class TodoListModel {
  public things: Array<ThingModel> = [];

  constructor(things: Array<ThingModel>) {
    this.things = things;
  }

  async loadTasks(context: common.UIAbilityContext) {
    try {
      let getJson = await context.resourceManager.getRawFileContent('default_tasks.json');
      let textDecoderOptions: util.TextDecoderOptions = { ignoreBOM: true };
      let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
      let result = textDecoder.decodeToString(getJson, { stream: false });
      this.things = JSON.parse(result);
    } catch (error) {
      hilog.error(DOMAIN, TAG, 'Failed to load tasks. Cause: %{public}s', JSON.stringify(error.message));
    }
  }
}
// [End to_do_list_model_class]