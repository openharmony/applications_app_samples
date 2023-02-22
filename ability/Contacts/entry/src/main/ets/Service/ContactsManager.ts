/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
 * 联系人数据操作类，主要承担如下职责
 * 1. 数据增删改查
 * 2. 保存数据到本地
 */
import Contact from '../Model/Contact'
import ContactsSyncManager from './ContactsSyncManager'
import Constants from '../Util/Constants'
import Logger from '../Util/Logger'
import {RemoteContactsListener} from './ContactsSyncManager'

export default class ContactsManager implements RemoteContactsListener{
    sequenceId: number = 0
    static MAX_SEQ_ID: number = 999
    static SEQ_ID_LENGTH: number = 3
    contacts: Contact[] = []
    private constructor() {
        ContactsSyncManager.getInstance().registerContactsChangeListener(this)
        this.contacts = ContactsSyncManager.getInstance().getRemoteContacts()
        let self = this
        //构造初始默认联系人
        setTimeout(function() {
            if (self.getContactsCount() == 0) {
                self.addContact(new Contact('张强', '15566663333', 'zhangqiang@mail.com', 'OpenHarmony', '同事'))
                self.addContact(new Contact('李华', '15566666666', 'lihua@mail.com', 'OpenHarmony', '同事'))
                self.addContact(new Contact('王伟', '15566667777', 'wangwei@mail.com', 'OpenHarmony', '同事'))
            }
        }, 1000)
    }

    static releaseInstance(): void
    {
        ContactsSyncManager.getInstance().unRegisterContactsChangeListener()
        ContactsSyncManager.releaseInstance()
        AppStorage.Delete(Constants.KEY_CONTACTS)
    }

    static getInstance(): ContactsManager
    {
        let contactsManager = AppStorage.Get<ContactsManager>(Constants.KEY_CONTACTS)
        if (!contactsManager) {
            AppStorage.SetOrCreate<ContactsManager>(Constants.KEY_CONTACTS, new ContactsManager())
            contactsManager = AppStorage.Get<ContactsManager>(Constants.KEY_CONTACTS)
        }
        return contactsManager
    }

    onRemoteContactsChange(contacts: Contact[])
    {
        this.contacts = contacts
        this.updatePage()
    }

    private getSequenceId(): string
    {
        if (this.sequenceId++ >= ContactsManager.MAX_SEQ_ID) {
            this.sequenceId = 0
        }
        return (Array(ContactsManager.SEQ_ID_LENGTH).join('0') + this.sequenceId).slice(-ContactsManager.SEQ_ID_LENGTH)
    }

    generateContactId(): string
    {
        var dateId = Date.parse(new Date().toString()).toString()
        var seqId = this.getSequenceId()
        return dateId + seqId
    }

    findContactIndex(contactId: string): number
    {
        let index = -1
        if (!this.contacts) {
            return index
        }

        this.contacts.forEach((contact, idx) => {
            if (contact.id == contactId) {
                index = idx
                return
            }
        })
        return index
    }

    addContact(newContact: Contact): boolean
    {
        if (!this.contacts) {
            return false
        }

        newContact.id = this.generateContactId()
        let index = this.findContactIndex(newContact.id)
        if (index >= 0) {
            return false
        }
        this.contacts.push(newContact)
        ContactsSyncManager.getInstance().onLocalContactsChange(this.contacts)
        this.updatePage()
    }

    removeContact(contactId: string): boolean
    {
        if (!this.contacts) {
            return false
        }

        let index = this.findContactIndex(contactId)
        if (index >= 0) {
            this.contacts.splice(index, 1)
            ContactsSyncManager.getInstance().onLocalContactsChange(this.contacts)
            this.updatePage()
            return true
        }
        return false
    }

    updateContact(contact: Contact): boolean
    {
        if (!this.contacts) {
            return false
        }

        let index = this.findContactIndex(contact.id)
        if (index >= 0) {
            this.contacts[index] = contact
            ContactsSyncManager.getInstance().onLocalContactsChange(this.contacts)
            this.updatePage()
            return true
        }
        return false
    }

    private sortContacts(contacts: Contact[])
    {
        if (contacts == undefined || contacts.length <= 1) {
            return
        }
        contacts.sort(function(contact1, contact2){return contact1.name > contact2.name ? 1 : -1})
    }

    getContact(contactId: string): Contact
    {
        if (!this.contacts) {
            return null
        }

        let index = this.findContactIndex(contactId)
        if (index >= 0) {
            return this.contacts[index]
        }
        return null
    }

    getContacts(inOrder: boolean): Contact[]
    {
        if (inOrder) {
            this.sortContacts(this.contacts)
        }
        return this.contacts
    }

    getContactsCount(): number
    {
        if(!this.contacts) {
            return 0
        }
        return this.contacts.length
    }

    savePersistContacts()
    {
        ContactsSyncManager.getInstance().saveContacts()
    }

    private updatePage()
    {
        AppStorage.Set('isUpdate', !AppStorage.Get<boolean>('isUpdate'))
    }

}