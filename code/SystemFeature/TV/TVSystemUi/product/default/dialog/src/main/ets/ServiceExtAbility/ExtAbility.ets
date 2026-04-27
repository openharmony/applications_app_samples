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

import { common, ServiceExtensionAbility, Want } from '@kit.AbilityKit';
import { display, window, window as windowStage } from '@kit.ArkUI';
import { rpc } from '@kit.IPCKit';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import { ServiceStubCode } from '../common/Constants';
import SystemDialogController, {
  attachDialogServiceController,
  detachDialogServiceController,
  DialogExtensionContextBridge,
  getDialogServiceController,
  type IDialogParameters
} from '../controller/Controller';

const TAG = 'Dialog-ServiceExtensionAbility';

const REPLY_SUCCESS_CODE = 0;

function getConnectId(pid: number, tokenId: number): string {
  return `${pid}-${tokenId}`;
}

function readDialogParametersFromParcel(data: rpc.MessageParcel): IDialogParameters {
  const size: number = data.readInt();
  const kv: Map<string, string> = new Map();
  for (let i = 0; i < size; i++) {
    const k: string = data.readString();
    const v: string = data.readString();
    kv.set(k, v);
  }
  const bundleNameValue: string | undefined = kv.get('bundleName');
  const abilityNameValue: string | undefined = kv.get('abilityName');
  const parametersRaw: string | undefined = kv.get('parameters');

  let parametersRecord: Record<string, Object> | undefined = undefined;
  if (parametersRaw !== undefined && parametersRaw.length > 0) {
    try {
      const parsed: Object = JSON.parse(parametersRaw) as Object;
      if (typeof parsed === 'object' && parsed !== null) {
        parametersRecord = parsed as Record<string, Object>;
      }
    } catch {
      parametersRecord = undefined;
    }
  }

  const out: IDialogParameters = {};
  if (bundleNameValue !== undefined) {
    out.bundleName = bundleNameValue;
  }
  if (abilityNameValue !== undefined) {
    out.abilityName = abilityNameValue;
  }
  if (parametersRecord !== undefined) {
    out.parameters = parametersRecord;
  }
  return out;
}

interface DialogWindowRect {
  left: number;
  top: number;
  width: number;
  height: number;
}

interface DialogWindowCreateConfig {
  ctx: common.ServiceExtensionContext;
  name: string;
  windowType: windowStage.WindowType;
}

interface ExtIndexLocalStorageProps {
  windowName: string;
  connectId: string;
  parameters: IDialogParameters;
}

class Stub extends rpc.RemoteObject {
  private readonly extensionContext: common.ServiceExtensionContext;

  constructor(name: string, extensionContext: common.ServiceExtensionContext) {
    super(name);
    this.extensionContext = extensionContext;
  }

  onRemoteRequest(
    code: number,
    data: rpc.MessageParcel,
    reply: rpc.MessageParcel,
    options: rpc.MessageOption
  ): boolean {
    const connectId: string = getConnectId(rpc.IPCSkeleton.getCallingPid(), rpc.IPCSkeleton.getCallingTokenId());
    Log.showInfo(TAG, `onRemoteRequest start ${connectId}`);

    const controller: SystemDialogController | null = getDialogServiceController();
    if (controller === null) {
      Log.showError(TAG, 'onRemoteRequest: dialog controller not ready');
      return false;
    }

    if (code === ServiceStubCode.COMMAND_SEND_REMOTE_OBJECT) {
      Log.showInfo(TAG, `onRemoteRequest code:${ServiceStubCode.COMMAND_SEND_REMOTE_OBJECT} start ${connectId}`);
      const remoteObject: rpc.IRemoteObject | null = data.readRemoteObject();
      Log.showDebug(TAG, `onRemoteRequest code:${ServiceStubCode.COMMAND_SEND_REMOTE_OBJECT} ${remoteObject}`);

      if (remoteObject !== null) {
        controller.addDataByKey(connectId, undefined, undefined, remoteObject);
        Log.showDebug(TAG, `onRemoteRequest code:${ServiceStubCode.COMMAND_SEND_REMOTE_OBJECT} end`);

        reply.writeInt(REPLY_SUCCESS_CODE);
        return true;
      }

      return false;
    }

    if (code === ServiceStubCode.COMMAND_START_DIALOG) {
      Log.showInfo(TAG, `onRemoteRequest code:${ServiceStubCode.COMMAND_START_DIALOG} ${connectId}`);
      const parameters: IDialogParameters = readDialogParametersFromParcel(data);
      void this.createWindow(connectId, parameters, controller, this.extensionContext);
      reply.writeInt(REPLY_SUCCESS_CODE);
      return true;
    }

    return false;
  }

  private async createWindow(
    connectId: string,
    parameters: IDialogParameters,
    controller: SystemDialogController,
    extensionContext: common.ServiceExtensionContext
  ): Promise<void> {
    const current = controller.getData().get(connectId);
    if (current !== undefined && current.windowName !== undefined) {
      Log.showInfo(TAG, `createWindow <this same> connectId:${connectId}`);
      controller.destroyWindow(connectId, false);
    }

    const windowName: string = controller.nextSystemDialogWindowName();
    Log.showInfo(TAG,
      `createWindow <start> windowName:${windowName} connectId:${connectId} parameters:${JSON.stringify(parameters)}`);

    controller.addDataByKey(connectId, windowName, parameters);
    const dfDisplay = display.getDefaultDisplaySync();
    const navigationBarRect: DialogWindowRect = {
      left: 0,
      top: 0,
      width: dfDisplay.width,
      height: dfDisplay.height
    };
    Log.showInfo(TAG, `createWindow <getDefaultDisplay> ${JSON.stringify(navigationBarRect)}`);

    const wType: windowStage.WindowType =
      parameters.bundleName === 'com.ohos.powerdialog' ? windowStage.WindowType.TYPE_SCREENSHOT : windowStage.WindowType.TYPE_FLOAT;
    const winCfg: DialogWindowCreateConfig = {
      ctx: extensionContext,
      name: windowName,
      windowType: wType
    };
    const win: windowStage.Window = await windowStage.createWindow(winCfg);
    Log.showDebug(TAG, 'createWindow <window.createWindow>');

    const localInit: ExtIndexLocalStorageProps = {
      windowName: windowName,
      connectId: connectId,
      parameters: parameters
    };
    const localStorage = new LocalStorage(localInit);

    await win.moveWindowTo(navigationBarRect.left, navigationBarRect.top);
    await win.resize(navigationBarRect.width, navigationBarRect.height);
    await win.loadContent('pages/ExtIndex', localStorage);
    await win.setWindowBackgroundColor('#00000000');
    await win.showWindow();
    AppStorage.setOrCreate<window.Window>('win', win);
    Log.showDebug(TAG, `createWindow end`);
  }
}

export default class DialogServiceExtAbility extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    Log.showInfo(TAG, 'onCreate');
    const bridge: DialogExtensionContextBridge = new DialogExtensionContextBridge(this.context);
    const dialogController: SystemDialogController = new SystemDialogController(bridge);
    attachDialogServiceController(dialogController);
  }

  onConnect(want: Want): rpc.RemoteObject {
    Log.showInfo(TAG, 'onConnect');
    return new Stub('SystemDialog', this.context);
  }

  onDisconnect(want: Want): void {
    Log.showInfo(TAG, 'onDisconnect');
  }

  onDestroy(): void {
    const controller: SystemDialogController | null = getDialogServiceController();
    if (controller !== null) {
      controller.destroyAllWindow();
    }
    detachDialogServiceController();

    Log.showInfo(TAG, `onDestroy end`);
  }
}
