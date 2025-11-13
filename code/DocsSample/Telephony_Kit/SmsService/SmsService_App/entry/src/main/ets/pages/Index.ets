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
// 示例代码
import { common, Want } from '@kit.AbilityKit';

const MMS_BUNDLE_NAME = "com.ohos.mms";
const MMS_ABILITY_NAME = "com.ohos.mms.MainAbility";
const MMS_ENTITIES = "entity.system.home";

export class Contact {
    contactsName: string;
    telephone: number;

    constructor(contactsName: string, telephone: number) {
        this.contactsName = contactsName;
        this.telephone = telephone;
    }
}

@Entry
@Component
struct JumpMessage {
    private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

    startMMSAbilityExplicit() {
        // 这里完善联系人和号码；姓名主要是通过手机号来查询实际联系人名称，因此这种方式还是以手机号码为主。
        let params: Array<Object> = [new Contact("张三", 133XXXXXXXX)];

        let want: Want = {
            bundleName: "com.ohos.mms",
            abilityName: "com.ohos.mms.MainAbility",
            parameters: {
                contactObjects: JSON.stringify(params),
                pageFlag: "conversation",
                // 这里填写短信内容。
                content: "我是短信具体内容"
            }
        };

        this.context.startAbilityForResult(want).then((data) => {
            console.info("Success" + JSON.stringify(data));
        }).catch(() => {
            console.error("error");
        });
    }

    build() {
        Row() {
            Column() {
                Button('发送短信')
                  .onClick(() => {
                      this.startMMSAbilityExplicit();
                  })
            }
            .width('100%')
        }
        .height('100%')
    }
}