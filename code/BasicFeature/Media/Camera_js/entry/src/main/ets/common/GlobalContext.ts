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

import display from '@ohos.display';
import type common from '@ohos.app.ability.common';
import type Want from '@ohos.app.ability.Want';
import type window from '@ohos.window';
import type { PromptAction } from '@ohos.arkui.UIContext';

const TAG: string = 'GlobalContext';

export class GlobalContext {

  private constructor() {
  }

  private static instance: GlobalContext;
  private _objects = new Map<string, Object>();
  private mDisplay: display.Display | undefined = undefined;
  private mCutoutInfo: display.CutoutInfo | undefined = undefined;
  private cameraAbilityContext: common.UIAbilityContext;
  private cameraAbilityStageContext: common.AbilityStageContext;
  private cameraAbilityWant: Want;
  private cameraNewWant: Want;
  private windowStage: window.WindowStage;
  private cameraWinClass: window.Window;
  private cameraSettingContext: common.UIAbilityContext;
  private cameraWindowStageEvent: window.WindowStageEventType;
  private xComponentController: XComponentController;
  private promptAction: PromptAction;

  public static get(): GlobalContext {
    if (!Boolean(GlobalContext.instance).valueOf()) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getObject(value: string): Object {
    return this._objects.get(value);
  }

  getT<T>(value: string): T {
    return this._objects.get(value) as T;
  }

  setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }

  apply(value: string): void {
    const func = this._objects.get(value);
    if (func) {
      (func as Function)();
    }
  }

  // 显示实例，在 phone设备上用 display获得的长宽与 State变量中 windowSize一致。
  public getDisplayInfo(): display.Display {
    if (!this.mDisplay) {
      this.mDisplay = display.getDefaultDisplaySync();
    }
    return this.mDisplay;
  }

  public async getCutoutInfo(): Promise<display.CutoutInfo> {
    if (!this.mCutoutInfo) {
      this.mCutoutInfo = await this.getDisplayInfo().getCutoutInfo();
    }
    return this.mCutoutInfo;
  }

  public getCameraAbilityContext(): common.UIAbilityContext {
    return this.cameraAbilityContext;
  }

  public setCameraAbilityContext(context: common.UIAbilityContext): void {
    this.cameraAbilityContext = context;
  }

  public getCameraAbilityWant(): Want {
    return this.cameraAbilityWant;
  }

  public setCameraAbilityWant(want: Want): void {
    this.cameraAbilityWant = want;
  }

  public getCameraNewWant(): Want {
    return this.cameraNewWant;
  }

  public setCameraNewWant(want: Want): void {
    this.cameraNewWant = want;
  }

  public getWindowStage(): window.WindowStage {
    return this.windowStage;
  }

  public setWindowStage(stage: window.WindowStage): void {
    this.windowStage = stage;
  }

  public getCameraAbilityStageContext(): common.AbilityStageContext {
    return this.cameraAbilityStageContext;
  }

  public setCameraAbilityStageContext(context: common.AbilityStageContext): void {
    this.cameraAbilityStageContext = context;
  }

  public getCameraWinClass(): window.Window {
    return this.cameraWinClass;
  }

  public setCameraWinClass(win: window.Window): void {
    this.cameraWinClass = win;
  }

  public getCameraSettingContext(): common.UIAbilityContext {
    return this.cameraSettingContext;
  }

  public setCameraSettingContext(context: common.UIAbilityContext): void {
    this.cameraSettingContext = context;
  }

  public setPromptAction(promptAction: PromptAction): void {
    this.promptAction = promptAction;
  }

  public getPromptAction(): PromptAction {
    return this.promptAction;
  }

  public getCameraWindowStageEvent(): window.WindowStageEventType {
    return this.cameraWindowStageEvent;
  }

  public setCameraWindowStageEvent(event: window.WindowStageEventType): void {
    this.cameraWindowStageEvent = event;
  }

  public getXComponentController(): XComponentController {
    return this.xComponentController;
  }

  public setXComponentController(controller): void {
    this.xComponentController = controller;
  }
}