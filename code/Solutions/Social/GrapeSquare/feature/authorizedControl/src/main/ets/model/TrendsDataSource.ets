/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { BasicDataSource } from './BasicDataSource';
import { Trends } from './BaseMsg';
import Logger from '../utils/Logger';
import { trendsList } from '../model/MockData';

const TAG: string = 'trendsList_Data';

export class TrendsData extends BasicDataSource<Trends> {
  private trendsList: Array<Trends> = [];
  private getJsonIndex: number = 1;

  public totalCount(): number {
    return this.trendsList.length;
  }

  public getData(index: number): Trends {
    if (index === this.trendsList.length - 1) {
      let mockData = trendsList[this.getJsonIndex % 3];
      for (let i = 0;i < mockData.length; i++) {
        this.pushData(mockData[i]);
      }
      this.getJsonIndex++;
    }
    return this.trendsList[index];
  }

  public addData(index: number, data: Trends): void {
    this.trendsList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Trends): void {
    this.trendsList.push(data);
    this.notifyDataAdd(this.trendsList.length - 1);
  }

  // 查找列表中对象的index
  public indexOf(data: Trends): number {
    Logger.info(TAG, `indexOf data , id = ${data.user.userId} , name = ${data.user.userName}`);
    return this.trendsList.indexOf(data);
  }

  // 删除列表中处于index位置的对象
  public deleteDataByIndex(index: number): void {
    Logger.info(TAG, `delete data , index = ${index}}`);
    this.trendsList.splice(index, 1);
    this.notifyDataDelete(index);
  }

  // 删除列表中的对象
  public deleteData(data: Trends): void {
    Logger.info(TAG, `delete data , data = ${data.user.userId}}`);
    let index = this.indexOf(data);
    this.deleteDataByIndex(index);
  }
}

export class CommentData extends BasicDataSource<Trends> {
  private commentsList: Array<Trends> = [];

  public totalCount(): number {
    return this.commentsList.length;
  }

  public getData(index: number): Trends {
    return this.commentsList[index];
  }

  public addData(index: number, data: Trends): void {
    this.commentsList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Trends): void {
    this.commentsList.unshift(data);
    this.notifyDataAdd(0);
  }

  // 查找列表中对象的index
  public indexOf(data: Trends): number {
    Logger.info(TAG, `indexOf data , id = ${data.user.userId} , name = ${data.user.userName}`);
    return this.commentsList.indexOf(data);
  }

  // 删除列表中处于index位置的对象
  public deleteDataByIndex(index: number): void {
    Logger.info(TAG, `delete data , index = ${index}}`);
    this.commentsList.splice(index, 1);
    this.notifyDataDelete(index);
  }

  // 删除列表中的对象
  public deleteData(data: Trends): void {
    Logger.info(TAG, `delete data , data = ${data.user.userId}}`);
    let index = this.indexOf(data);
    this.deleteDataByIndex(index);
  }
}