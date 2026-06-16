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

import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';

/**
 * 全局闲置检测器（整个应用共享）
 */
export class GlobalIdleDetector {
  private static instance: GlobalIdleDetector;
  private idleTimer: number | null = null;
  private idleTime: number = 10 * 1000;
  private isScreensaverActive = false;
  private triggerPageUrl: string = '';
  private uiAbilityContext: common.UIAbilityContext | null = null;

  private constructor() {
  }

  public static getInstance(): GlobalIdleDetector {
    if (!GlobalIdleDetector.instance) {
      GlobalIdleDetector.instance = new GlobalIdleDetector();
    }
    return GlobalIdleDetector.instance;
  }

  init(context: common.UIAbilityContext, idleTime?: number) {
    this.uiAbilityContext = context;
    if (idleTime) {
      this.idleTime = idleTime;
    }
  }

  startDetect() {
    this.resetTimer();
  }

  resetTimer() {
    if (this.idleTimer !== null) {
      console.log('Executed', JSON.stringify(this.idleTimer));
      clearTimeout(this.idleTimer);
    }
    this.isScreensaverActive = false;
    console.log('hsq++0', this.idleTime);
    this.idleTimer = setTimeout(() => {
      this.triggerScreensaver();
    }, this.idleTime);
  }

  private triggerScreensaver() {
    if (this.isScreensaverActive) {
      return;
    }
    this.isScreensaverActive = true;
    const pages = router.getState();
    this.triggerPageUrl = pages.path;
    router.pushUrl({ url: 'pages/ScreenSaver' }, (err) => {
      if (err) {
        console.error('Failed to jump to screensaver:', err);
      }
    });
  }

  stopDetect() {
    if (this.idleTimer !== null) {
      clearTimeout(this.idleTimer);
    }
    this.idleTimer = null;
  }

  resetScreensaver() {
    this.isScreensaverActive = false;
    this.triggerPageUrl = '';
    this.startDetect();
  }

  getTriggerPage(): string {
    return this.triggerPageUrl;
  }

  pauseOnJump() {
    this.stopDetect();
    setTimeout(() => {
      if (!this.isScreensaverActive) {
        this.startDetect();
      }
    }, 300);
  }
}

export const globalIdle = GlobalIdleDetector.getInstance();
