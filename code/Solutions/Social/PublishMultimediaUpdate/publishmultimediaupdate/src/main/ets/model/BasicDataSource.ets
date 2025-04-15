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


/**
 * IDataSource处理数据监听的基本实现
 */
export abstract class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];

  public abstract totalCount(): number;

  public abstract getData(index: number): T | void;

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    });
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(index);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataMove(from, to);
    })
  }
}

/**
 * 朋友圈用户数据
 */
export class FriendMoment {
  id: string; // 唯一id
  userName: string; // 用户名
  avatar: ResourceStr; // 头像
  text: string; // 文字
  image?: ResourceStr; // 发布动态图片
  video?: ResourceStr; // 发布动态视频

  constructor(id: string, userName: string, avatar: ResourceStr, text: string, image?: ResourceStr,
    video?: ResourceStr) {
    this.id = id;
    this.userName = userName;
    this.avatar = avatar;
    this.text = text;
    if (image !== undefined) {
      this.image = image;
    }
    ;
    if (video !== undefined) {
      this.video = video;
    }
  }
}


export class CommentData extends BasicDataSource<FriendMoment> {
  // 懒加载数据
  private comments: Array<FriendMoment> = [];

  // TODO：知识点：获取懒加载数据源的数据长度
  totalCount(): number {
    return this.comments.length;
  }

  // 获取指定数据项
  getData(index: number): FriendMoment {
    return this.comments[index];
  }

  // TODO：知识点：存储数据到懒加载数据源中
  pushData(data: FriendMoment): void {
    this.comments.push(data);
    // 在数组头部添加数据
    this.notifyDataAdd(this.comments.length - 1);
  }

  addDataFirst(data: FriendMoment): void {
    this.comments.unshift(data);
    // 在数组头部添加数据
    this.notifyDataAdd(0);
  }
}