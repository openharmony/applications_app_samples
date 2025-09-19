/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import {
  IDataSource,
  DataChangeListener,
  Component,
  Builder,Resource,$r,Row
} from '@ohos.arkui.component';
import { State, Link, StorageLink, Watch } from '@ohos.arkui.stateManagement';

export interface Month {
  month: string; // 具体年月
  num: number; // 月份
  days: number[]; // 该月日期
}

/**
 * Basic implementation of IDataSource to handle data listener
 *
 * @class
 * @implements {IDataSource}
 */
export class MonthDataSource implements IDataSource<Month> {
  private listeners: DataChangeListener[] = [];
  public dataArray: Month[] = new Array<Month>();

  /**
   * 获取数组长度。
   * @returns {number} 返回数组长度。
   */
  public totalCount(): number {
    return this.dataArray.length;
  }

  /**
   * 获取指定索引数据。
   * @param {number} index - 索引值。
   * @returns {CustomDataType} 返回指定索引数据。
   */
  public getData(index: number): Month {
    return this.dataArray[index.toInt()];
  }

  /**
   * 为LazyForEach组件向其数据源处添加listener监听。
   * @param {DataChangeListener} listener - 监听对象。
   */
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  /**
   * 为对应的LazyForEach组件在数据源处去除listener监听。
   * @param {DataChangeListener} listener - 监听对象。
   */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  /**
   * 通知LazyForEach组件需要在index对应索引处添加子组件。
   * @param {number} index - 索引值。
   */
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  /**
   * 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件。
   * @param {number} index - 索引值。
   */
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  /**
   * 通知LazyForEach组件需要在index对应索引处删除该子组件
   * @param {number} index - 索引值。
   */
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  /**
   * 通知LazyForEach组件将from索引和to索引处的子组件进行交换
   * @param {number} from - 起始值。
   * @param {number} to - 终点值。
   */
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }

  /**
   * 改变单个数据。
   * @param {number} index - 索引值。
   * @param {CustomDataType} data - 修改后的值。
   */
  public addData(index: number, data: Month): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  /**
   * 添加数据。
   * @param {CustomDataType} data - 需要添加的数据。
   */
  public pushData(data: Month): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}