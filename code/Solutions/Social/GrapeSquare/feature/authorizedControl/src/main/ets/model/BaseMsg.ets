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

// 用户信息
export class UserInfo {
  userId: number;
  userImage: Resource;
  userName: string;
  address: string;
  userType: string;

  constructor(userId: number, userImage: Resource, userName: string, address: string, userType: string) {
    this.userId = userId;
    this.userImage = userImage;
    this.userName = userName;
    this.address = address;
    this.userType = userType;
  }
}

// 内容信息
export class ContentsType {
  text: string;
  imageList: Array<Resource>;
  media: Array<string>;

  constructor(text: string, imageList: Array<Resource>, media: Array<string>) {
    this.text = text;
    this.imageList = imageList;
    this.media = media;
  }
}

// 动态信息
export class Trends {
  user: UserInfo;
  contents: ContentsType;
  dateTime: string;
  likeCount: number;
  commentCount: number;
  shareCount: number;

  constructor(user: UserInfo, contents: ContentsType, dateTime: string, linkCount: number, comentCount: number, shareCount: number) {
    this.user = user;
    this.contents = contents;
    this.dateTime = dateTime;
    this.likeCount = linkCount;
    this.commentCount = comentCount;
    this.shareCount = shareCount;
  }
}

// readSync第三参数类型
export class Options {
  offset: number;
  length: number;

  constructor(offset: number, length: number) {
    this.offset = offset;
    this.length = length;
  }
}
