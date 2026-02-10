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

// [Start Internal_localStorage_multi_instance_3]
import { UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import PDFData from './model/PDFData';

export default class PDFAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 用单例存储数据
    const data = this.launchWant.parameters as Record<string, string>;
    PDFData.getInstance().setData(data.key, data.value);
    PDFData.getInstance().setFlage(this.launchWant.uri || '');
    windowStage.loadContent('pages/internalmigrate/LocalStorageMultiInstance/PDF').catch();
  }
}
// [End Internal_localStorage_multi_instance_3]