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

import { Contact } from '../model/Contact';

export class ContactManager {
  private static instance: ContactManager = new ContactManager();
  private contacts: Contact[] = [];

  private constructor() {}

  public static getInstance(): ContactManager {
    return ContactManager.instance;
  }

  // 查看联系人
  public getContacts(): Array<Contact> {
    return [...this.contacts];
  }

  // 初始化联系人数据
  public setContacts(contacts: Array<Contact>): void {
    this.contacts = [...contacts];
  }

  // 添加联系人
  public addContact(contact: Contact): void {
    this.contacts = [...this.contacts, contact];
  }

  // 更新联系人
  public updateContact(contact: Contact): void {
    const newContacts = [...this.contacts]; // 创建新数组
    for (let i = 0; i < newContacts.length; i++) {
      if (newContacts[i].name === contact.name) {
        newContacts[i] = contact; // 直接替换对象
        break; // 找到后退出循环
      }
    }
    this.contacts = newContacts; // 更新引用
  }

  // 删除联系人
  public deleteContact(contact: Contact): void {
    this.contacts = this.contacts.filter(item => item.name !== contact.name);
  }
}