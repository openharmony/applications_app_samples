/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import { window as windowStage } from '@kit.ArkUI';
import { rpc } from '@kit.IPCKit';
import { common } from '@kit.AbilityKit';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import {
  GlobalThis,
  type DialogConnectData,
  type DialogControllerRef
} from '../../../../../../../common/src/main/ets/util/GlobalThis';

const TAG = 'Dialog-ServiceExtensionAbility';

export interface IDialogParameters {
  bundleName?: string;
  abilityName?: string;
  parameters?: Record<string, Object>;
}

export interface ISystemDialogData {
  windowName?: string;
  parameters?: IDialogParameters;
  remoteObject?: rpc.IRemoteObject;
}

export abstract class SystemDialogContextBase {
  abstract terminateSelf(): void;
}

/** Bridges ServiceExtensionContext into SystemDialogContextBase for {@link SystemDialogController}. */
export class DialogExtensionContextBridge extends SystemDialogContextBase {
  private readonly svc: common.ServiceExtensionContext;

  constructor(svc: common.ServiceExtensionContext) {
    super();
    this.svc = svc;
  }

  terminateSelf(): void {
    this.svc.terminateSelf();
  }

  getServiceExtensionContext(): common.ServiceExtensionContext {
    return this.svc;
  }
}

class SystemDialogController {
  private count: number = 0;
  private data: Map<string, ISystemDialogData> = new Map();
  private context: SystemDialogContextBase | null;

  constructor(context: SystemDialogContextBase | null) {
    this.context = context;
    Log.showInfo(TAG, `SystemDialogController constructor ${this.context}`);
  }

  nextSystemDialogWindowName(): string {
    this.count++;
    return `SystemDialog${this.count}`;
  }

  getContext(): SystemDialogContextBase | null {
    return this.context;
  }

  getData(): Map<string, ISystemDialogData> {
    return this.data;
  }

  getRemoteObject(key: string): rpc.IRemoteObject | undefined {
    Log.showInfo(TAG, `getRemoteObject start ${key}`);
    const current: ISystemDialogData | undefined = this.data.get(key);
    const remoteObject: rpc.IRemoteObject | undefined = current ? current.remoteObject : undefined;

    Log.showDebug(TAG, `getRemoteObject end ${remoteObject}`);
    return remoteObject;
  }

  clearRemoteObject(key: string): void {
    Log.showInfo(TAG, `clearRemoteObject start ${key}`);

    const current = this.data.get(key);
    if (current) {
      current.remoteObject = undefined;
    }

    Log.showDebug(TAG, `clearRemoteObject end ${key}`);
  }

  // addDataByKey 使用 Object.assign 合并已有数据而非直接覆盖，
  // 是因为同一 key 的弹窗可能分多次携带不同字段（如先注册 windowName，后注入 remoteObject），
  // 合并更新保证了 IPC 连接建立前后的数据完整性。
  addDataByKey(
    key: string,
    windowName?: string,
    parameters?: IDialogParameters,
    remoteObject?: rpc.IRemoteObject
  ): void {
    Log.showInfo(TAG, `Controller-addDataByKey start ${key}`);
    const current: ISystemDialogData | undefined = this.data.get(key);
    if (current) {
      if (windowName !== undefined) {
        current.windowName = windowName;
      }
      if (parameters !== undefined) {
        current.parameters = parameters;
      }
      if (remoteObject !== undefined) {
        current.remoteObject = remoteObject;
      }
    } else {
      const data: ISystemDialogData = {};
      if (windowName !== undefined) {
        data.windowName = windowName;
      }
      if (parameters !== undefined) {
        data.parameters = parameters;
      }
      if (remoteObject !== undefined) {
        data.remoteObject = remoteObject;
      }
      this.data.set(key, data);
    }
    Log.showDebug(TAG, `Controller-addDataByKey end ${key}`);
  }

  // destroyWindow 的 needClear 参数用于区分"销毁窗口但保留数据"和"销毁窗口并清理数据"两种场景，
  // 前者用于弹窗被主动关闭后等待 IPC 回调的过渡期，保留数据防止回调找不到上下文。
  destroyWindow(key: string, needClear: boolean = true): void {
    const current: ISystemDialogData | undefined = this.data.get(key);

    if (!current) {
      Log.showInfo(TAG, `destroyWindow fail. key:${key} not exist`);
      return;
    }

    const windowName: string | undefined = current.windowName;
    Log.showInfo(TAG, `destroyWindow start ${key} ${windowName}`);

    if (windowName) {
      try {
        let win: windowStage.Window | undefined = undefined;
        win = windowStage.findWindow(windowName);
        if (win !== undefined) {
          win.destroyWindow();
        }
      } catch (err) {
        console.error(`Failed to find the Window. Cause code: ${err.code}, message: ${err.message}`);
      }
    }

    if (!needClear) {
      Log.showDebug(TAG, `destroyWindow end. not need clear. ${key} ${windowName}`);
      return;
    }

    this.clearRemoteObject(key);

    this.data.delete(key);

    if (this.data.size === 0) {
      this.clear();
    }

    Log.showDebug(TAG, `destroyWindow end ${key} ${windowName}`);
  }

  destroyAllWindow(): void {
    Log.showInfo(TAG, `destroyAllWindow start ${this.data.size}`);
    const keys: string[] = Array.from(this.data.keys());
    for (let i = 0; i < keys.length; i++) {
      const key: string = keys[i];
      Log.showInfo(TAG, `destroyAllWindow forEach ${key}`);
      this.destroyWindow(key);
    }
    Log.showDebug(TAG, `destroyAllWindow end`);
  }

  // clear 在所有弹窗销毁后调用 terminateSelf 主动退出 ServiceExtensionAbility，
  // 是因为系统弹窗服务在无活跃弹窗时不应常驻内存，按需启动和销毁是 TV 低功耗策略的要求。
  clear(): void {
    Log.showInfo(TAG, `clear start`);
    this.data.clear();
    if (this.context !== null) {
      try {
        Log.showInfo(TAG, `terminateSelf start`);
        this.context.terminateSelf();
        Log.showInfo(TAG, `terminateSelf end`);
      } catch (err) {
        Log.showInfo(TAG, `clear err:${err}`);
      } finally {
        this.context = null;
      }
    }
    Log.showInfo(TAG, `clear end`);
  }
}

class SystemDialogGlobalAdapter implements DialogControllerRef {
  private readonly inner: SystemDialogController;

  constructor(inner: SystemDialogController) {
    this.inner = inner;
  }

  getData(): Map<string, DialogConnectData> {
    const out: Map<string, DialogConnectData> = new Map<string, DialogConnectData>();
    this.inner.getData().forEach((v: ISystemDialogData, k: string) => {
      const entry: DialogConnectData = { remoteObject: v.remoteObject };
      out.set(k, entry);
    });
    return out;
  }

  destroyWindow(connectId: string): void {
    this.inner.destroyWindow(connectId);
  }
}

let attachedDialogController: SystemDialogController | null = null;
let dialogGlobalAdapter: SystemDialogGlobalAdapter | null = null;

export function attachDialogServiceController(c: SystemDialogController): void {
  attachedDialogController = c;
  dialogGlobalAdapter = new SystemDialogGlobalAdapter(c);
  GlobalThis.attachDialogController(dialogGlobalAdapter);
}

export function getDialogServiceController(): SystemDialogController | null {
  return attachedDialogController;
}

export function detachDialogServiceController(): void {
  attachedDialogController = null;
  dialogGlobalAdapter = null;
  GlobalThis.attachDialogController(undefined);
}

export default SystemDialogController;
