/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

export class BreakpointType<T> {
  lg: T;
  md: T;
  sm: T;

  constructor(sm: T, md: T, lg: T) {
    this.lg = lg;
    this.md = md;
    this.sm = sm;
  }

  GetValue(currentBreakpoint: string): T | undefined {
    if (currentBreakpoint === 'lg') {
      return this.lg;
    }
    if (currentBreakpoint === 'md') {
      return this.md;
    }
    if (currentBreakpoint === 'sm') {
      return this.sm;
    }
    return undefined;
  }
}