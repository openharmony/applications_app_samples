/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ViewItem } from './ViewItem';

// 瀑布流子组件懒加载数据结构
export class WaterFlowDataSource implements IDataSource {
  private dataArray: ViewItem[] = [];
  private listeners: DataChangeListener[] = [];

  totalCount(): number {
    return this.dataArray.length;
  }

  getData(index: number): ViewItem {
    return this.dataArray[index];
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos > 0) {
      this.listeners.splice(pos, 1);
    }
  }

  public addItems(items:ViewItem[]){
    this.dataArray.push(...items);
    this.notifyDataReload();
  }

  public add1stItem(item:ViewItem): void {
    this.dataArray.splice(0, 0, item);
    this.notifyDataAdd(0);
  }

  public addLastItem(item:ViewItem): void {
    this.dataArray.splice(this.dataArray.length, 0, item);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public addItem(index: number,item:ViewItem): void {
    this.dataArray.splice(index, 0, item);
    this.notifyDataAdd(index);
  }

  public delete1stItem(): void {
    this.dataArray.splice(0, 1);
    this.notifyDataDelete(0);
  }

  public delete2ndItem(): void {
    this.dataArray.splice(1, 1);
    this.notifyDataDelete(1);
  }

  public deleteLastItem(): void {
    this.dataArray.splice(-1, 1);
    this.notifyDataDelete(this.dataArray.length);
  }

  public reload() {
    this.dataArray.splice(1, 1);
    this.dataArray.splice(3, 2);
    this.reload();
  }
}