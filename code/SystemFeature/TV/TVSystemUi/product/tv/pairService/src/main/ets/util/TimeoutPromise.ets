/**
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
import { createError, PairErrorCode } from '../model/PairError';

// withTimeout 通过 Promise.race 实现超时竞争，而非在原 Promise 上添加超时逻辑，
// 是因为蓝牙 API 的 Promise 不可取消，race 可在超时后立即响应而不阻塞原操作的后续回调，
// timeOutAction 回调允许超时时检查实际状态，应对"超时时操作其实已成功"的竞态场景。
export function withTimeout<T>(promise: Promise<T>, timeout: number, tag: string,
  timeOutAction?: () => (T | undefined)): Promise<T> {
  return Promise.race([
    promise,
    new Promise<T>((resolve, reject) => {
      setTimeout(() => {
        if (timeOutAction) {
          let result = timeOutAction()
          if (result !== undefined) {
            resolve(result)
          } else {
            reject(createError(PairErrorCode.TIMEOUT, `time out from ${tag}`))
          }
        } else {
          reject(createError(PairErrorCode.TIMEOUT, `time out from ${tag}`))
        }
      }, timeout);
    })
  ]);
}
