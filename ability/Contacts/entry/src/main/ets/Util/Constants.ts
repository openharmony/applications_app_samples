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
 * 常量类，主要承担如下职责
 * 1. 定义常量
 */
export default class Constants {
    static KEY_CONTACTS: string = 'contacts'
    static KEY_IS_UPDATE: string = 'isUpdate'

    static CONTACTS_ITEMS: ContactItem[] = [
        {
            name: 'name',
            name_zh: '姓名'
        },
        {
            name: 'address',
            name_zh: '公司'
        },
        {
            name: 'phoneNum',
            name_zh: '电话'
        },
        {
            name: 'email',
            name_zh: '邮箱'
        },
        {
            name: 'remark',
            name_zh: '备注'
        },
    ]
}

export class ContactItem {
    name: string
    name_zh: string
}