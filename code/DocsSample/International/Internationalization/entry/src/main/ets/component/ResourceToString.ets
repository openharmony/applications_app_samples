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
import { application } from '@kit.AbilityKit'

export  function resourceToString(resource: Resource, context?: Context): string {
  let result: string = '';
  try {
    if (context === undefined) {
      context = application.getApplicationContext();
    }
    if (!context || !context.resourceManager) {
      console.error('Context or resourceManager is undefined');
      return result;
    }
    result = context.resourceManager.getStringSync(resource.id);
  } catch (e) {
    console.error(`call resourceToString failed, code: ${e.code}, message: ${e.message}`);
  }
  return result;
}
