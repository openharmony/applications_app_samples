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
 


/**
 * 列表数据源接口封装
 */
export class ListDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = []; //数据变化监听集合
  private data: T[] = []; //数据集合

  /**
   * 获取数据大小
   * @returns 数据集合长度
   */
  public totalCount(): number {
    return this.data.length;
  }

  /**
   * 根据下标获取数据
   * @param index 列表下标
   * @returns 数据对象
   */
  public getData(index: number): T {
    return this.data[index];
  }

  /**
   * 获取数据集合
   * @returns 数据对象集合
   */
  public getAllData(): T[] {
    return this.data;
  }

  /**
   * 向指定位置添加数据
   * @param index 位置下标
   * @param data 数据对象
   */
  public addData(index: number, data: T): void {
    this.data.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  /**
   * 向列表末尾添加数据
   * @param data 数据对象
   */
  public pushData(data: T): void {
    this.data.push(data);
    this.notifyDataAdd(this.data.length - 1);
  }

  /**
   * 删除指定位置数据
   * @param index 位置下标
   */
  public deleteData(index: number): void {
    this.data.splice(index, 1);
    this.notifyDataDelete(index);
  }

  /**
   * 删除所有数据
   */
  clearData() {
    this.getAllData().splice(0, this.totalCount());
    this.notifyDataReload();
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
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
}