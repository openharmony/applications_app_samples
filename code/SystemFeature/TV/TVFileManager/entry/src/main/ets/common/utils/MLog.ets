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

import { promptAction as prompt } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'APP_FileManager';
const HILOG_CODE: number = 0x0000;
const SYMBOL: string = ' --> ';
const IS_HILOG: boolean = true;

export class MLog {
  public static print(tag: string, msg: string): void {
    if (IS_HILOG) {
      hilog.debug(HILOG_CODE, TAG, '%{public}s', tag + SYMBOL + msg);
      return;
    }
    console.info(TAG + `: ${tag}${SYMBOL}${msg}`);
  }

  public static log(tag: string, msg: string): void {
    MLog.print(tag, msg);
  }

  public static info(tag: string, msg: string): void {
    MLog.print(tag, msg);
  }

  public static error(tag: string, msg: string): void {
    if (IS_HILOG) {
      hilog.error(HILOG_CODE, TAG, '%{public}s', tag + SYMBOL + msg);
      return;
    }
    console.error(TAG + `: ${tag}${SYMBOL}${msg}`);
  }

  public static warn(tag: string, msg: string): void {
    if (IS_HILOG) {
      hilog.warn(HILOG_CODE, TAG, '%{public}s', tag + SYMBOL + msg);
      return;
    }
    console.warn(TAG + `: ${tag}${SYMBOL}${msg}`);
  }

  public static printError(tag: string, methodName: string, error: Error): void {
    MLog.error(tag, `Error methodName ${methodName} name:${error.name ?? '--'} message:${error.message ?? '--'}`);
    MLog.error(tag, `Error stack:${error.stack ?? '--'}`);
  }

  public static stackError(tag: string, error: Error, method?: string): void {
    MLog.error(tag, `${method ? 'Method:' + method : ''} Error name:${error.name ?? '--'} message:${error.message ?? '--'}\n ${error.stack ?? '--'}`);
  }

  public static show(tag: string, msg: string): void {
    MLog.warn(tag, `${msg}`);
    prompt.showDialog({ message: `${msg}` });
  }

  public static showToast(tag: string, msg: string): void {
    MLog.warn(tag, `${msg}`);
    prompt.showToast({ message: `${msg}` });
  }
}
