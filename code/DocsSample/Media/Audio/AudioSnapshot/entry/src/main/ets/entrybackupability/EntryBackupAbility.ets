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

import { BackupExtensionAbility } from '@kit.CoreFileKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export default class EntryBackupAbility extends BackupExtensionAbility {
  onBackup(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'onBackup');
  }

  onRestore(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'onRestore');
  }
}
