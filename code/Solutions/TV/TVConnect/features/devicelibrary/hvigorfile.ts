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
// Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.
import { harTasks } from '@ohos/hvigor-ohos-plugin';
import { harPlugin } from '@hadss/hmrouter-plugin';

export default {
  system: harTasks,
  plugins:[harPlugin()]  // 使用HMRouter标签的模块均需要配置，与模块类型保持一致
}