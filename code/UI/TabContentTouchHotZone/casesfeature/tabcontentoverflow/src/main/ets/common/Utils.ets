/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { promptAction } from '@kit.ArkUI';
import { CONFIGURATION } from './Constants';

/**
 * 通用功能类
 */
export class Utils {
  // 点击未开发功能按钮弹出提示函数
  showPromptAction() {
    promptAction.showToast({
      message: $r('app.string.tabcontentoverflow_toast_message'),
      duration: CONFIGURATION.TABCONTENT_OVERFLOW_DURATION
    });
  }
}
