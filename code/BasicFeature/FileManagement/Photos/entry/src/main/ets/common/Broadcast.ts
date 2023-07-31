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

type CallbackType = Function;

export class Broadcast {
  private callBackArray: Map<string, CallbackType[]> = new Map<string, CallbackType[]>();

  constructor() {
  }

  public on(event: string, callback: CallbackType): void {
    if (this.callBackArray.get(event) === null || this.callBackArray.get(event) === undefined) {
      this.callBackArray.set(event, []);
    }
    this.callBackArray.get(event).push(callback);
  }

  public off(event: string | null, callback: CallbackType | null): void {
    if (event == null) {
      this.callBackArray.clear();
    }

    const cbs: CallbackType[] = this.callBackArray.get(event);
    if (!Boolean<Function[]>(cbs).valueOf()) {
      return;
    }
    if (callback == null) {
      this.callBackArray.set(event, null);
    }
    let cb;
    let l = cbs.length;
    for (let i = 0; i < l; i++) {
      cb = cbs[i];
      if (cb === callback || cb.fn === callback) {
        cbs.splice(i, 1);
        break;
      }
    }
  }

  public emit(event: string, args: Object[]): void {
    let _self = this;
    if (!Boolean<Function[]>(this.callBackArray.get(event)).valueOf()) {
      return;
    }

    let cbs: CallbackType[] = [];
    for (let i = 0; i < this.callBackArray.get(event).length; i++) {
      cbs.push(this.callBackArray.get(event)[i])
    }

    if (cbs != null) {
      let l = cbs.length;
      for (let i = 0; i < l; i++) {
        try {
          cbs[i].apply(_self, args);
        } catch (e) {
          new Error(e);
        }
      }
    }
  }

  public release(): void {
    this.callBackArray.forEach((array: Object[]): void => {
      array.length = 0;
    });
    this.callBackArray.clear();
  }
}
