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
import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { hvigor } from '@ohos/hvigor';
import { ClassTransformerCodeGenPlugin } from 'quick-transformer-codegen-plugin';

export default {
  system: hapTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: [
    ClassTransformerCodeGenPlugin(hvigor, {
      // whiteDirList: 源代码文件父路径白名单,从工程根目录开始
      whiteDirList: ['/entry/src/main/ets/layout'],
      // blackDirList: 源代码文件父路径黑名单,从工程根目录开始
      blackDirList: [],
      // whiteDirList和blackDirList都不配置的情况,默认对工程进行全扫描
      enable: true, // 是否启用，默认debug包为false，release包为true
      preventModifySourceCode: false, // 是否避免修改源码，默认true
    })
  ]
}