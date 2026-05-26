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

import { HMLifecycle, HMLifecycleContext, IHMLifecycle } from '@hadss/hmrouter';
import { Logger } from '@ohos/common';

@HMLifecycle({ lifecycleName: 'PageDurationLifecycle' })
export class PageDurationLifecycle implements IHMLifecycle {
  private dataMap = new Map<string, number>();

  onAppear(ctx: HMLifecycleContext): void {
    let pageName = ctx.navContext?.pathInfo.name;
    if (pageName != undefined) {
      this.dataMap.set(pageName, new Date().getTime());
    }
  }

  onDisAppear(ctx: HMLifecycleContext): void {
    let pageName = ctx.navContext?.pathInfo.name;
    if (pageName != undefined && this.dataMap.has(pageName)) {
      let startTime = this.dataMap.get(pageName) as number;
      const duration = new Date().getTime() - startTime;
      this.dataMap.delete(pageName);
      Logger.debug('AppRouter', `PageDuration ${ctx.navContext?.pathInfo.name} timt ${duration}`);
    }
  }
}