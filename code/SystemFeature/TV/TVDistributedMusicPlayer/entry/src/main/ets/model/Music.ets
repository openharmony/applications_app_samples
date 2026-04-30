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

export interface  songItemType {
  img: ResourceStr;
  name: string;
  author: string;
  url: string;
  time?:number;
}

export interface recommendListType {
  img: string;
  title: string;
  count:string;
}
export interface recommendDailyType {
  img: string;
  title: string;
  type:string;
  top:string;
  bottom: string;
}
export interface favoriteListType {
  name:string;
  nickName:string;
  avatar:ResourceStr;
  songs:songItemType[];
}
export interface momentListType {
  author:string;
  avatar:string;
  content:string;
  comment:number;
  like:number;
  song:songItemType;
}
export class SongItemTypeModel implements songItemType {
  public img: ResourceStr = '';
  public name: string = '';
  public author: string = '';
  public url: string = '';
  public time: number = 0;
  public id: string = '';

  constructor(model: songItemType) {
    this.img = model.img;
    this.name = model.name;
    this.author = model.author;
    this.url = model.url;
    if (model.time !== undefined) {
      this.time = model.time;
    }
  }
}
export class RecommendListTypeModel implements recommendListType {
  public img: string = '';
  public title: string = '';
  public count: string = '';

  constructor(model: recommendListType) {
    this.img = model.img;
    this.title = model.title;
    this.count = model.count;
  }
}
export class RecommendDailyTypeModel implements recommendDailyType {
  public img: string = '';
  public title: string = '';
  public type: string = '';
  public top: string = '';
  public bottom: string = '';

  constructor(model: recommendDailyType) {
    this.img = model.img;
    this.title = model.title;
    this.type = model.type;
    this.top = model.top;
    this.bottom = model.bottom;
  }
}
export class FavoriteListTypeModel implements favoriteListType {
  public name: string = '';
  public nickName: string = '';
  public avatar: ResourceStr = '';
  public songs: songItemType[] = [];

  constructor(model: favoriteListType) {
    this.name = model.name;
    this.nickName = model.nickName;
    this.avatar = model.avatar;
    this.songs = model.songs;
  }
}
export class MomentListTypeModel implements momentListType {
  public author: string = '';
  public avatar: string = '';
  public content: string = '';
  public comment: number = 0;
  public like: number = 0;
  public song: songItemType = new SongItemTypeModel({} as songItemType);

  constructor(model: momentListType) {
    this.author = model.author;
    this.avatar = model.avatar;
    this.content = model.content;
    this.comment = model.comment;
    this.like = model.like;
    this.song = model.song;
  }
}
