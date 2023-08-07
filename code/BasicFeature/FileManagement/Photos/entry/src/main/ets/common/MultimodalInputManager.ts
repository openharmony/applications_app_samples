/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { Log } from '../utils/Log';


const TAG = 'MultimodalInputManager';

export class MultimodalInputManager {

  //win + N
  leftKeyOptions: inputConsumer.KeyOptions = {
    preKeys: Array<number>(),
    finalKey: 2014,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  //win + I
  rightKeyOptions: inputConsumer.KeyOptions = {
    preKeys: Array<number>(),
    finalKey: 2015,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };
  escKeyOptions: inputConsumer.KeyOptions = {
    preKeys: Array<number>(),
    finalKey: 2070,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  async registerListener(callback): Promise<void> {
    Log.debug(TAG, 'registerListener start');
    inputConsumer.on('key', this.leftKeyOptions, (data: inputConsumer.KeyOptions): void => {
      Log.debug(TAG, 'notificationRegister data: ' + JSON.stringify(data));
      callback(0);
    });
    inputConsumer.on('key', this.rightKeyOptions, (data: inputConsumer.KeyOptions): void => {
      Log.debug(TAG, 'controlRegister data: ' + JSON.stringify(data));
      callback(1);
    });
    inputConsumer.on('key', this.escKeyOptions, (data: inputConsumer.KeyOptions): void => {
      Log.debug(TAG, 'escRegister data: ' + JSON.stringify(data));
      callback(2);
    });
    Log.debug(TAG, 'registerListener end');
  }

  async unregisterListener(): Promise<void> {
    Log.debug(TAG, 'unregisterListener start');
    inputConsumer.off('key', this.leftKeyOptions, (data: inputConsumer.KeyOptions): void  => {
      Log.debug(TAG, 'notificationUnregister data: ' + JSON.stringify(data));
    });
    inputConsumer.off('key', this.rightKeyOptions, (data: inputConsumer.KeyOptions): void  => {
      Log.debug(TAG, 'controlUnregister data: ' + JSON.stringify(data));
    });
    inputConsumer.off('key', this.escKeyOptions, (data: inputConsumer.KeyOptions): void  => {
      Log.debug(TAG, 'escUnregister data: ' + JSON.stringify(data));
    });
    Log.debug(TAG, 'unregisterListener end');
  }
}

export let mMultimodalInputManager = new MultimodalInputManager();
