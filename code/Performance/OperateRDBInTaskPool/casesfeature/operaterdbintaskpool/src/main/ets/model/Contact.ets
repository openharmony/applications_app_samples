/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * 单个通讯录所有字段信息
 * TODO:知识点：Sendable对象可以在不同并发实例间通过引用传递，相比序列化方式更加高效。
 */
@Sendable
export class Contact {
  id: number; // 序号
  name: string; // 名字
  phone: string; // 电话号码
  email: string; // 邮箱
  address: string; // 地址
  avatar: string; // 头像
  category: string; // 分类
  constructor(id: number = -1, name: string = '', phone: string = '', email: string = '', address: string = '',
    avatar: string = '', category: string = '') {
    this.id = id;
    this.name = name;
    this.phone = phone;
    this.email = email;
    this.address = address;
    this.avatar = avatar;
    this.category = category;
  }
}

/*
 * 通讯录列表以组为单位字段信息
 */
export interface CategoryContact {
  category: string;
  itemsContact: Array<Contact>;
}

/*
 * 路由参数传递
 */
export interface ParamObject {
  contact: Contact; // 被选中的通讯录对象
  editCallback: (contact: Contact) => void; // 编辑通讯录回调函数
  deleteCallback: (contact: Contact) => void; // 删除通讯录回调函数
}