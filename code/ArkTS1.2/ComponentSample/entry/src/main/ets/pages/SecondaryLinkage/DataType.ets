'use static';
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
import { memo, __memo_context_type, __memo_id_type } from '@ohos.arkui.stateManagement';
import {IDataSource,DataChangeListener,Text, TextAttribute, Column, Component, Button, ButtonAttribute, ClickEvent ,Image,Row} from '@ohos.arkui.component';
import { State, MutableState, stateOf, observableProxy ,Provide} from '@ohos.arkui.stateManagement';
const CONTENT_PER_TAG = 10; // 每个TAG对应多少个元素
/**
 * 代表自定义类型数据的接口。
 *
 * @interface
 * @property {string} desc - 描述。
 * @property {string} tag - 类别。
 */
export interface CustomDataType {
  desc: string,
  tag: string,
}

/**
 * 一级列表可视区域的起始索引和终点索引。
 *
 * @interface
 * @property {number} start - 可视区域起点索引。
 * @property {number} end - 可视区域终点索引。
 */
export interface ListIndexPosition {
  start: number,
  end: number
}

/**
 * Basic implementation of IDataSource to handle data listener
 *
 * @class
 * @implements {IDataSource}
 */
class BasicDataSource implements IDataSource<CustomDataType> {
  private listeners: DataChangeListener[] = Array<DataChangeListener>();
  private originDataArray: CustomDataType[] =  Array<CustomDataType>();

  /**
   * 获取数组长度。
   * @returns {number} 返回数组长度。
   */
  public totalCount(): number {
    return 0;
  }

  /**
   * 获取指定索引数据。
   * @param {number} index - 索引值。
   * @returns {CustomDataType} 返回指定索引数据。
   */
  public getData(index: number): CustomDataType {
    return this.originDataArray[index.toInt()];
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
}

/**
 * 继承自BasicDataSource的子类，重写了方法。
 *
 * @class
 * @extends {BasicDataSource}
 */
export class MyDataSource extends BasicDataSource {
  public dataArray: CustomDataType[] =  Array<CustomDataType>();

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
  public getData(index: number): CustomDataType {
    return this.dataArray[index.toInt()];
  }

  /**
   * 改变单个数据。
   * @param {number} index - 索引值。
   * @param {CustomDataType} data - 修改后的值。
   */
  public addData(index: number, data: CustomDataType): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  /**
   * 添加数据。
   * @param {CustomDataType} data - 需要添加的数据。
   */
  public pushData(data: CustomDataType[]): void {
    if (Array.isArray(data)) {
      for (let i = 0; i < CONTENT_PER_TAG; ++i) {
        this.dataArray.push(data[i]);
      }
    }
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

// 常量数据
export enum ComponentStyle {
  ITEM_GUTTER = 12,
  TAG_TEXT_HEIGHT= 75,
  SUB_ITEM_GUTTER= 7,
  SUB_ITEM_HEIGHT= 96,
  SUB_ITEM_TEXT_WIDTH_TITLE= 56,
  SUB_ITEM_TEXT_HEIGHT= 12,
  SUB_ITEM_TEXT_WIDTH_BODY= 120,
  BOTTOM_TOAST_TEXT_MAX_HEIGHT= 200
};