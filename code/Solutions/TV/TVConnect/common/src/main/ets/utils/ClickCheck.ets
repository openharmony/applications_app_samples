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
export class ClickCheck {
  public static readonly timeCheck: number = 600;
  private static clickTime = 0;

  public static checkDouble(): boolean {
    let currentTime = new Date().getTime();
    if (currentTime - ClickCheck.clickTime < ClickCheck.timeCheck) {
      return false;
    }
    ClickCheck.clickTime = currentTime;
    return true;
  }
}