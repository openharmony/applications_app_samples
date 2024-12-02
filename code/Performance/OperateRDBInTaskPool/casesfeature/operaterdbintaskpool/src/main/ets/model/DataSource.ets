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
import { logger } from '../utils/Logger';
import { CategoryContact, Contact } from './Contact';

// Basic implementation of IDataSource to handle data listener
class BasicDataSource<T> implements IDataSource {
  // 数据变化监听器
  private listeners: DataChangeListener[] = [];

  // 获取数据的长度
  public totalCount(): number {
    return 0;
  }

  // 获取指定数据项
  public getData(index: number): T | void {
    logger.info('getData, index:' + index);
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}

export class ContactDataSource extends BasicDataSource<CategoryContact> {
  // 懒加载数据
  private contactList: Array<CategoryContact> = []

  // 获取懒加载数据源的数据长度
  totalCount(): number {
    return this.contactList.length;
  }

  // 获取指定数据项
  getData(index: number): CategoryContact {
    return this.contactList[index];
  }

  // 获取指定数据项
  getDataItem(index: number, indexItem: number): Contact {
    return this.contactList[index].itemsContact[indexItem];
  }

  deleteData(index: number): void {
    this.contactList.splice(index, 1);
    this.notifyDataReload();
  }

  // 删除数据源中的数据
  deleteDataItem(categoryArray: Array<string>, indexGroup: number, indexItem: number): void {
    if (this.contactList[indexGroup].itemsContact.length === 1) {
      this.deleteData(indexGroup);
      categoryArray.splice(indexGroup, 1);
      AppStorage.setOrCreate('categoryArray', categoryArray);
    } else {
      this.contactList[indexGroup].itemsContact.splice(indexItem, 1);
      this.notifyDataChange(indexGroup);
    }
  }

  // 更新数据源中的数据
  updateDataItem(categoryArray: Array<string>, indexGroup: number, indexItem: number, data: Contact): void {
    this.deleteDataItem(categoryArray, indexGroup, indexItem);
    this.pushDataItem(categoryArray, data);
  }

  clear(): void {
    this.contactList.splice(0, this.contactList.length);
  }

  // 存储数据到懒加载数据源中
  pushData(data: CategoryContact): void {
    this.contactList.push(data);
    this.notifyDataAdd(this.contactList.length - 1);
  }

  // 存储数据到懒加载数据源中
  pushDataItem(categoryArray: Array<string>, data: Contact): void {
    let index = categoryArray.indexOf(data.category);
    // 当前分组是否已存在
    if (index !== -1) {
      // 当前分组存在
      this.contactList[index].itemsContact.push(data);
      this.notifyDataChange(index);
    } else {
      // 当前分组存在并找到索引值的位置
      index = categoryArray.findIndex((currentChar) => currentChar >= data.category);
      this.contactList.splice(index, 0, { category: data.category, itemsContact: [data] });
      categoryArray.splice(index, 0, data.category);
      AppStorage.setOrCreate('categoryArray', categoryArray);
      this.notifyDataAdd(index);
    }
  }
}