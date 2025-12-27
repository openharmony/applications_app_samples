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
    const pos = this.listeners.indexOf(listener);
    if (pos > 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index);
    })
  }
}

/**
 * Nearby People Topic Data
 */
@Observed
export class FriendMoment {
  public id: string;
  public userName: string;
  public avatar: string;
  public text: string;
  public image: string;
  public share: ShareModel;

  constructor(id: string, userName: string, avatar: string, text: string, image: string, share: ShareModel) {
    this.id = id;
    this.userName = userName;
    this.avatar = avatar;
    this.text = text;
    this.image = image;
    this.share = share;
  }
}

/**
 * Share Model
 */
@Observed
export class ShareModel {
  public heart: number;
  public star: number;
  public message: number;

  constructor(heart: number, star: number, message: number) {
    this.heart = heart;
    this.star = star;
    this.message = message;
  }
}

/**
 * Color Model
 */
export class ColorModel {
  public id: string;
  public text: string;
  public color: Color;

  constructor(id: string, text: string, color: Color) {
    this.id = id;
    this.text = text;
    this.color = color;
  }
}