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
 

import Log from '../default/Log';
import { rpc } from '@kit.IPCKit';
import { display } from '@kit.ArkUI';

const TAG = 'Dialog-constants';

export enum Len {
  Width = 1,
  Height = 2
}

export interface DialogConnectData {
  remoteObject?: rpc.IRemoteObject;
}

export interface DialogControllerRef {
  getData(): Map<string, DialogConnectData>;

  destroyWindow(connectId: string): void;
}

let volumeDialogTextHolder: string = '';

let dialogControllerRef: DialogControllerRef | undefined;

export class GlobalThis {
  static setVolumeDialogText(text: string): void {
    volumeDialogTextHolder = text;
  }

  static attachDialogController(ref: DialogControllerRef | undefined): void {
    dialogControllerRef = ref;
  }

  static getLength(len: Len): number {
    try {
      const d = display.getDefaultDisplaySync();
      if (len === Len.Width) {
        return d.width;
      }
      return d.height;
    } catch (_e) {
      return 0;
    }
  }

  static getText(): string {
    return volumeDialogTextHolder;
  }

  static onOK(connectId: string): DialogControllerRef | undefined {
    const controller = dialogControllerRef;
    if (controller === undefined) {
      return undefined;
    }
    const entry: DialogConnectData | undefined = controller.getData().get(connectId);
    const remoteObject = entry?.remoteObject;
    if (remoteObject !== undefined) {
      Log.showDebug(TAG, `onOk ${remoteObject}`);

      let data = rpc.MessageSequence.create();
      let reply = rpc.MessageSequence.create();
      let option = new rpc.MessageOption();
      remoteObject.sendMessageRequest(1, data, reply, option)
        .then(
          () => {
            Log.showDebug(TAG, 'onOk success');
          },
          (error: Error) => {
            Log.showDebug(TAG, `onOk error ${JSON.stringify(error)}`);
            GlobalThis.onClose(connectId);
          }
        ).finally(() => {
          data.reclaim();
          reply.reclaim();
        });
    }
    return controller;
  }

  static onClose(connectId: string): void {
    Log.showDebug(TAG, `onClose start`);
    dialogControllerRef?.destroyWindow(connectId);
    Log.showInfo(TAG, `onClose end`);
  }
}
