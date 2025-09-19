'use static';
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

import { DataChangeListener, IDataSource } from '@ohos.arkui.component'

/**
 * IDataSource处理数据监听的基本实现
 */
export abstract class BasicDataSource<T> implements IDataSource<T> {
  private listeners: DataChangeListener[] = [];
  // 获取数组长度
  public abstract totalCount(): number;
  public abstract getData(index: number): T;
  // 为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }
  // 为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }
  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    });
  }
  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index);
    })
  }
  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChange(index);
    })
  }
  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(index);
    })
  }
}

export class ArticleSource<T> extends BasicDataSource<T> {
  public articleData: Array<T> = [];
  public constructor(data: T[] = []) {
    super();
    this.pushData(data);
  }
  // 获取数组长度
  public totalCount(): number {
    return this.articleData.length;
  }
  // 获取指定索引数据
  public getData(index: number): T {
    return this.articleData[index.toInt()];
  }
  // 插入单个数据
  public addData(index: number, data: T): void {
    this.articleData.splice(index, 0, data);
    this.notifyDataAdd(index);
  }
  public updateData(index: number, data: T): void {
    this.articleData.splice(index, 1, data);
    this.notifyDataChange(index);
  }
  // 添加数据
  public pushData(data: T[]): void {
    data.forEach((item: T) => {
      this.articleData.push(item);
      this.notifyDataAdd(this.articleData.length - 1);
    })
  }
}
