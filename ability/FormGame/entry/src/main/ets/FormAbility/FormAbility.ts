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

import Logger from '../Utils/Logger';
import FormExtension from '@ohos.application.FormExtension';
import formBindingData from '@ohos.application.formBindingData';
import formInfo from '@ohos.application.formInfo';
import formProvider from '@ohos.application.formProvider';
import dataStorage from '@ohos.data.storage'
import infoUtil from "libinfoutil.so";

export default class FormAbility extends FormExtension {
    private storeDB: dataStorage.Storage = undefined
    private allWordArray : Array<string> = [
        "与时俱进", "与虎谋皮", "天下兴亡", "天天向上", "一心一意",
        "三心二意", "无法无天", "狐假虎威", "前程似锦", "姹紫嫣红",
        "魑魅魍魉", "锦瑟华年", "相濡以沫", "朝思暮想", "山清水秀",
        "前所未有", "新陈代谢", "不可思议", "与众不同", "洞若观火",
        "平易近人", "丰富多彩", "名副其实", "迫不及待", "可想而知",
        "意想不到", "毫不犹豫", "拭目以待", "毋庸置疑", "如火如荼",
        "小心翼翼", "坚定不移", "想方设法", "当之无愧", "乱七八糟",
        "顾名思义", "大街小巷", "心甘情愿", "因地制宜", "轻而易举"
    ];
    private backupWordStr : string;
    private sourceWordStr : string;
    private targetWordStr : string;
    onCreate(want) {
        Logger.info('FormAbility onCreate init storeDB: ' + this.context.filesDir);
        // Init database for store word info.
        this.storeDB = dataStorage.getStorageSync(this.context.filesDir + 'myStore')
        if (!this.storeDB.hasSync("sourceWord")) {
            this.storeDB.putSync('sourceWord', this.allWordArray[0]);
        }
        if (!this.storeDB.hasSync("targetWord")) {
            this.storeDB.putSync('targetWord', "    ");
        }
        Logger.info('FormAbility onCreate init storeDB finish.');
        let begin = infoUtil.getRandomNumber(0, this.allWordArray.length);
        this.sourceWordStr = this.storeDB.getSync('sourceWord', this.allWordArray[begin]).toString()
        this.targetWordStr = this.storeDB.getSync('targetWord', '    ').toString()
        this.backupWordStr = this.sourceWordStr
        this.disorderSourceWord()
        // Called to return a FormBindingData object.
        return formBindingData.createFormBindingData(this.getCurrentFormData());
    }

    onCastToNormal(formId) {
        // Called when the form provider is notified that a temporary form is successfully
        // converted to a normal form.
    }

    onUpdate(formId) {
        // Called to notify the form provider to update a specified form.
    }

    onVisibilityChange(newStatus) {
        // Called when the form provider receives form events from the system.
    }

    updateWordStr(index) {
        if (index == NaN || index < 0 || index > 7) {
            Logger.info("FormAbility updateWordStr failed for invalid eventIndex:" + index)
            return
        }
        const updateString = (str, index, char) => {
            const strArray = str.split('');
            strArray[index] = char;
            return strArray.join('');
        }
        const fillSpace = (str, char) => {
            const strArray = str.split('');
            for (let i = 0; i < strArray.length; i++) {
                if (strArray[i] == ' ') {
                    strArray[i] = char;
                    break;
                }
            }
            return strArray.join('');
        }
        if (index <= 3) { // Select the source word
            let selectChar = this.sourceWordStr.charAt(index);
            this.sourceWordStr = updateString(this.sourceWordStr, index, ' ');
            this.targetWordStr = fillSpace(this.targetWordStr, selectChar);
        } else { // Select the target word
            let selectChar = this.targetWordStr.charAt(index - 4);
            this.sourceWordStr = fillSpace(this.sourceWordStr, selectChar);
            this.targetWordStr = updateString(this.targetWordStr, index - 4, ' ');
        }
        this.flushToStoreDB();
    }

    flushToStoreDB() {
        this.storeDB.putSync('sourceWord', this.sourceWordStr);
        this.storeDB.putSync('targetWord', this.targetWordStr);
        this.storeDB.flushSync();
    }

    updateNextWord(formId) {
        let next = infoUtil.getRandomNumber(0, this.allWordArray.length);
        this.sourceWordStr = this.allWordArray[next]
        this.backupWordStr = this.sourceWordStr
        this.targetWordStr = '    '
        this.disorderSourceWord();
        this.updateFormDisplay(formId)
        this.flushToStoreDB();
    }

    resetCurrentWord(formId) {
        this.sourceWordStr = this.backupWordStr
        this.targetWordStr = '    '
        this.disorderSourceWord();
        this.updateFormDisplay(formId)
        this.flushToStoreDB();
    }

    disorderSourceWord() {
        const strArray = this.sourceWordStr.split('');
        if (strArray.length != 4) {
            Logger.error('FormAbility invalid sourceWordStr len:' + strArray.length);
            return;
        }
        let indexArray = [0, 1, 2, 3]
        let len = indexArray.length
        let randomIndex
        let temp
        while (len) {
            randomIndex = Math.floor(Math.random() * (len--))
            temp = indexArray[randomIndex]
            indexArray[randomIndex] = indexArray[len]
            indexArray[len] = temp
        }
        let randomArray = [
            strArray[indexArray[0]],
            strArray[indexArray[1]],
            strArray[indexArray[2]],
            strArray[indexArray[3]]
        ];
        Logger.info('FormAbility indexArray:' + indexArray);
        this.sourceWordStr = randomArray.join('');
    }

    checkCurrentStatus(formId) {
        const strArray = this.targetWordStr.split('');
        for (let i = 0; i < strArray.length; i++) {
            if (strArray[i] == ' ') {
                return;
            }
        }
        for (let i = 0; i < this.allWordArray.length; i++) {
            if (this.allWordArray[i] == this.targetWordStr) {
                Logger.info('FormAbility correct word and updateNextWord.');
                this.updateNextWord(formId)
                return;
            }
        }
        Logger.info('FormAbility wrong word and resetCurrentWord.');
        this.resetCurrentWord(formId)
    }

    getCurrentFormData() {
        let formData = {
            "source_1": this.sourceWordStr.charAt(0),
            "source_2": this.sourceWordStr.charAt(1),
            "source_3": this.sourceWordStr.charAt(2),
            "source_4": this.sourceWordStr.charAt(3),
            "target_1": this.targetWordStr.charAt(0),
            "target_2": this.targetWordStr.charAt(1),
            "target_3": this.targetWordStr.charAt(2),
            "target_4": this.targetWordStr.charAt(3)
        };
        Logger.info('FormAbility data:' + JSON.stringify(formData));
        return formBindingData.createFormBindingData(formData);
    }

    updateFormDisplay(formId) {
        formProvider.updateForm(formId, this.getCurrentFormData()).then((data) => {
            Logger.info('FormAbility updateForm success.' + JSON.stringify(data));
        }).catch((error) => {
            Logger.error('FormAbility updateForm failed: ' + JSON.stringify(error));
        })
    }

    onEvent(formId, message) {
        // Called when a specified message event defined by the form provider is triggered.
        Logger.info('FormAbility onEvent. id:' + formId + " msg:" + message);
        // this.updateAllInfo(formId);
        if (this.storeDB == undefined) {
            this.storeDB = dataStorage.getStorageSync(this.context.filesDir + 'myStore')
        }
        this.sourceWordStr = this.storeDB.getSync('sourceWord', this.allWordArray[0]).toString()
        this.targetWordStr = this.storeDB.getSync('targetWord', '    ').toString()
        Logger.info('FormAbility sourceWord:[' + this.sourceWordStr + ']' + " " + this.sourceWordStr.length);
        Logger.info('FormAbility targetWord:[' + this.targetWordStr + ']' + " " + this.targetWordStr.length);
        if (this.sourceWordStr.length != 4 || this.targetWordStr.length != 4) {
            this.sourceWordStr = this.allWordArray[0]
            this.targetWordStr = '    '
        }
        Logger.info('FormAbility sourceWord:[' + this.sourceWordStr + ']');
        Logger.info('FormAbility targetWord:[' + this.targetWordStr + ']');
        let eventIndex = Number(JSON.parse(message).params.message.charAt(0))
        if (eventIndex == NaN || eventIndex < 0 || eventIndex > 7) {
            Logger.info("FormAbility onEvent failed for invalid eventIndex:" + eventIndex)
            return
        }
        if (eventIndex < 4 && this.sourceWordStr.charAt(eventIndex) == ' ') {
            Logger.info("FormAbility source no need to update for eventIndex:" + eventIndex)
            return
        }
        if (eventIndex >= 4 && this.targetWordStr.charAt(eventIndex - 4) == ' ') {
            Logger.info("FormAbility target no need to update for eventIndex:" + eventIndex)
            return
        }
        this.updateWordStr(eventIndex)
        Logger.info('FormAbility sourceWord:[' + this.sourceWordStr + ']');
        Logger.info('FormAbility targetWord:[' + this.targetWordStr + ']');
        this.updateFormDisplay(formId);
        this.checkCurrentStatus(formId);
        Logger.info('FormAbility sourceWord:' + JSON.stringify(this.storeDB.getSync('sourceWord', 'NA')));
        Logger.info('FormAbility targetWord:' + JSON.stringify(this.storeDB.getSync('targetWord', 'NA')));
    }

    onDestroy(formId) {
        // Called to notify the form provider that a specified form has been destroyed.
        Logger.info('FormAbility onDestroy.');
    }

    onAcquireFormState(want) {
        // Called to return a {@link FormState} object.
        return formInfo.FormState.READY;
    }
};
