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
// [Start dynamic_isolation_process]
import AbilityStage from '@ohos.app.ability.AbilityStage';

export default class MyAbilityStage extends AbilityStage {
// [StartExclude dynamic_isolation_process]
  onCreate(): void {
  }
// [EndExclude dynamic_isolation_process]
  onNewProcessRequest(want: Want): string {
    //返回开发者自定义的字符串，独立进程名称拼接规则：包名:开发者自定义的字符串
    return 'testKey';
  }
}
// [End dynamic_isolation_process]