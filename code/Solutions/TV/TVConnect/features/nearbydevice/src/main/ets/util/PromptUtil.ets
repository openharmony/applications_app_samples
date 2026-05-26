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

import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import { Logger } from '@ohos/common';

/**
 * 显示弹窗
 * @param msg
 * @param duration 显示时长，默认2s
 */
export function showPop(msg: string | Resource, duration: number = 2000) {
  try {
    promptAction.showToast({
      message: msg,
      duration: duration
    });
  } catch (error) {
    let message = (error as BusinessError).message;
    let code = (error as BusinessError).code;
    Logger.error(`showToast args error code is ${code}, message is ${message}`);
  }
}