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

// [Start applied_logic]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0001;
const TAG = 'envirommentprojet';

// 使用Environment.envProp将设备运行languageCode存入AppStorage中
Environment.envProp('languageCode', 'en');
// 从AppStorage获取单向绑定的languageCode的变量
const lang: SubscribedAbstractProperty<string> = AppStorage.prop('languageCode');

if (lang.get() === 'zh') {
  // $r('app.string.AppliedLogic_Hello')需要替换为开发者所需的资源文件
  hilog.info(DOMAIN, TAG, `${$r('app.string.AppliedLogic_Hello')}`);
} else {
  hilog.info(DOMAIN, TAG, 'Hello!');
};
// [End applied_logic]

@Entry
@Component
struct AppliedLogic {
  build() {};
}