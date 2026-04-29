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

export class ConfirmButtonModel {
  key: string;
  message: string;
  seconds: number;
  isFocus: boolean;

  constructor(key: string, message: string, seconds: number, isFocus: boolean) {
    this.key = key;
    this.message = message;
    this.seconds = seconds;
    this.isFocus = isFocus;
  }
}

export function createConfirmButtonModelSet(): ConfirmButtonModel[] {
  return [
    new ConfirmButtonModel('cancel', '取消(60秒)', 60, false),
    new ConfirmButtonModel('confirm', '本次允许', 0, false),
    new ConfirmButtonModel('always', '始终允许', 0, false)
  ];
}
