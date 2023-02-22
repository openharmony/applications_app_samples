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
 * 跨设备联系人同步类，主要承担如下职责
 * 1. 同步本地数据变化到远端
 * 2. 监听远端数据变化
 * 3. 保存数据到本地
 */
import distributedObject from '@ohos.data.distributedDataObject';
import Contact from '../Model/Contact'
import Constants from '../Util/Constants'
import Logger from '../Util/Logger'

export interface RemoteContactsListener
{
    onRemoteContactsChange(contacts: Contact[])
}

export default class ContactsSyncManager {
    SESSION_ID: string = '20221128'
    localObject: distributedObject.DistributedObject
    static KEY_CONTACTS_SYNC_MGR: string = 'contactsSyncManager'

    private constructor() {
        this.localObject = distributedObject.createDistributedObject({
            contacts: undefined,
            isUpdate: undefined
        })
        this.localObject.setSessionId(this.SESSION_ID)
    }

    static releaseInstance(): void
    {
        ContactsSyncManager.getInstance().clearSessionId()
        AppStorage.Delete(ContactsSyncManager.KEY_CONTACTS_SYNC_MGR)
    }

    static getInstance(): ContactsSyncManager
    {
        let contactsSyncManager = AppStorage.Get<ContactsSyncManager>(ContactsSyncManager.KEY_CONTACTS_SYNC_MGR)
        if (!contactsSyncManager) {
            AppStorage.SetOrCreate<ContactsSyncManager>(ContactsSyncManager.KEY_CONTACTS_SYNC_MGR, new ContactsSyncManager())
            contactsSyncManager = AppStorage.Get<ContactsSyncManager>(ContactsSyncManager.KEY_CONTACTS_SYNC_MGR)
        }
        return contactsSyncManager
    }

    getRemoteContacts(): Contact[]
    {
        Logger.info('get remote contacts begin')
        if (this.localObject[Constants.KEY_CONTACTS] != undefined) {
            Logger.info('get remote contacts size: ' + this.localObject[Constants.KEY_CONTACTS].length)
            return this.localObject[Constants.KEY_CONTACTS]
        }
        return []
    }

    registerContactsChangeListener(listener: RemoteContactsListener)
    {
        let self = this
        function changeCallback(sessionId: string, changeData) {
            Logger.info('status changed, sessionId: ' + sessionId)
            if (changeData == null || changeData == undefined) {
                return
            }
            changeData.forEach(element => {
                Logger.info(element + ' changed !')
                if (element == Constants.KEY_CONTACTS) {
                    listener.onRemoteContactsChange(self.localObject[element])
                }
            })
        }
        this.localObject.on('change', changeCallback.bind(this))
    }

    unRegisterContactsChangeListener() {
        this.localObject.off('change')
    }

    clearSessionId()
    {
        this.localObject.setSessionId("")
    }

    onLocalContactsChange(contacts: Contact[])
    {
        this.localObject[Constants.KEY_CONTACTS] = contacts
        if (!this.localObject[Constants.KEY_IS_UPDATE]) {
            this.localObject[Constants.KEY_IS_UPDATE] = true
        } else {
            this.localObject[Constants.KEY_IS_UPDATE] = !this.localObject[Constants.KEY_IS_UPDATE]
        }
    }

    saveContacts()
    {
        this.localObject.save('local')
            .then((result) => {
                console.info('save sessionId ' + result.sessionId)
            }, (result) => {
                console.error('save local failed')
            })
    }

}