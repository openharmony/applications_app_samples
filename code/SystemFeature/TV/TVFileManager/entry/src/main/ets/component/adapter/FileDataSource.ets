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
import { FileBean } from '../bean/FileBean';
import { BasicDataSource } from './BasicDataSource';

const TAG = 'FileDataSource';

export default class FileDataSource extends BasicDataSource<FileBean> {
  selectBean?: FileBean;
  pageContext?: Context;
  lastIndex: number = -1;

  constructor(ctx: Context, arr: FileBean[]) {
    super(arr);
    this.pageContext = ctx;
  }

  public totalCount(): number {
    return this.array.length;
  }

  public getData(index: number): FileBean {
    return super.getData(index);
  }



  public clear() {
    this.array = [];
  }

  public push(beans: FileBean[]) {
    this.array.push(...beans);
    this.notifyDataReload();
  }

  public find(id: string): FileBean | undefined {
    return this.array && this.array.find(it => it.id === id);
  }

  public getIndexById(id: string): number {
    return this.array.findIndex(it => it.id === id);
  }

  public splice(bean: FileBean[]) {
    if (bean.length === this.array.length) {
      this.array = []
    } else {
      for (let i = 0; i < bean.length; i++) {
        if (this.array.includes(bean[i])) {
          this.array.splice(this.array.indexOf(bean[i]), 1);
        }
      }
    }
    this.notifyDataReload();
  }

  public rename(bean: FileBean[], text: string) {
    for (let i = 0; i < bean.length; i++) {
      if (this.array.includes(bean[i])) {
        let index = this.array.indexOf(bean[i]);
        let item = this.array[index];
        item.setPath(item.getPath().replace(item.name, text));
        item.name = text;
        this.notifyDataDelete(index);
        this.notifyDataAdd(index);
      }
    }
  }

  public checkArrayPush(index: number, beans: FileBean) {
    this.checkArray.set(index, beans);
  }

  public checkArrayRemove(index: number) {
    this.checkArray.delete(index);
  }

  public getCheckArray() {
    return this.checkArray;
  }

}
