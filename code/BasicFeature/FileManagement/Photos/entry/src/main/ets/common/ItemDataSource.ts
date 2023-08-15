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

import { Log } from '../utils/Log';

const TAG = 'ItemDataSource'

export class LazyItem<T> {
  item: T;
  onItemUpdate: Function;
  index: number = -1;

  constructor(item: T, index: number, onItemUpdate?: Function) {
    this.item = item;
    this.onItemUpdate = onItemUpdate;
    this.index = index;
  }

  update(item: T): void {
    if (this.onItemUpdate != null && this.index !== -1) {
      this.onItemUpdate(this.index, item);
    }
  }

  getHashCode(): string {
    // @ts-ignore
    return this.index + '' + this.item.getHashCode();
  }

  get(): T {
    return this.item;
  }

  set(item: T): void {
    this.item = item;
  }
}

export abstract class ItemDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];

  abstract totalCount(): number;

  abstract getData(index: number): Object;

  abstract isSelect(): boolean;

  abstract getSelectedCount(): number;

  abstract getSelectedItems(): Object[];

  abstract getSelectedUris(): string[];

  abstract dataRemove(): void;

  registerDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'registerDataChangeListener');
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
      Log.info(TAG, 'registerDataChangeListener, add listener, length: ' + this.listeners.length);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'unregisterDataChangeListener');
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
      Log.info(TAG, 'registerDataChangeListener, remove listener, length: ' + this.listeners.length);
    }
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach((listener: DataChangeListener): void => {
      listener.onDataChange(index);
    })
  }

  notifyDataReload(): void {
    this.listeners.forEach((listener: DataChangeListener): void => {
      listener.onDataReloaded();
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach((listener: DataChangeListener): void => {
      listener.onDataDelete(index);
    })
  }
}
