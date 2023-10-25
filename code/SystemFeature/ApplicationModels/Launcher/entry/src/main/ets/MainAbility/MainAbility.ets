/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import WindowManager from '../manager/WindowManager';
import { DesktopLayoutModel } from '@ohos/desktop';
import { Logger } from '@ohos/base';
import { WINDOW_NAMES, WINDOW_PAGES } from '../manager/WindowManager';
import Want from '@ohos.app.ability.Want';

export default class MainAbility extends ServiceExtensionAbility {
  private windowManager: WindowManager | undefined = undefined;
  onCreate(want: Want) {
    Logger.info('[MainAbility]', 'onCreate')
    this.initLauncher()
  }

  async initLauncher() {
    AppStorage.SetOrCreate('DesktopLayoutModel', DesktopLayoutModel.getInstance(this.context));
    this.windowManager = new WindowManager(this.context);
    this.windowManager.registerWindowEvent();
    await this.windowManager.showOrCreateWindow(WINDOW_NAMES.home, WINDOW_PAGES.home, false);
  }

  onDestroy() {
    Logger.info('[MainAbility]', 'onDestroy')
  }

  onRequest(want: Want, startId: number) {
    Logger.info('[MainAbility]', `onRequest, want:${want.abilityName}`)
  }
}
