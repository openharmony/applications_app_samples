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
// [Start write_code_for_business_components]
import { BuilderData } from './DynamicComponent';

@Builder
function webBuilder(data: BuilderData) {
  // 此处组件可根据业务需要自行扩展
  Web({ src: data.url, controller: data.controller })
    .cacheMode(CacheMode.Default)
}

export const businessWebview = wrapBuilder<BuilderData[]>(webBuilder);
// [End write_code_for_business_components]