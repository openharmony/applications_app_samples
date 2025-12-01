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

// 标题懒加载类
export class TitleDataSource implements IDataSource {
  private dataArray: string[] = [];
  private listeners: DataChangeListener[] = [];

  totalCount(): number {
    return this.dataArray.length;
  }

  getData(index: number): string {
    return this.dataArray[index];
  }

  public addItem(title: string): void {
    this.dataArray.push(title);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
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
}