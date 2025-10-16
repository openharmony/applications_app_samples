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

import { rpc } from '@kit.IPCKit';
import { DriverExtensionAbility } from '@kit.DriverDevelopmentKit';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { display } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so'
import { commonEventManager } from '@kit.BasicServicesKit'
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { preferences } from '@kit.ArkData'
import { contextConstant } from '@kit.AbilityKit';

let defaultIndexMap : Int32Array= new Int32Array(4);

let direction : number = 0;

const STORAGE_KEY = [
    { key: 'key1', default: KeyCode.KEYCODE_SPACE },
    { key: 'key2', default: KeyCode.KEYCODE_ENTER },
    { key: 'key3', default: KeyCode.KEYCODE_BACK },
    { key: 'key4', default: KeyCode.KEYCODE_1 }]

async function GetData() {
    hilog.info(0, 'testTag', 'GetData enter');
    try {
        await testNapi.getBoardInput()
    } catch (e) {
        hilog.info(0, 'testTag', 'get kbd input failed');
    }
}

class FirstDriverAbilityStub extends rpc.RemoteObject {
    constructor(des) {
        if (typeof des === 'string') {
            super(des);
        } else {
            return null;
        }
    }
    onRemoteMessageRequest(code: number,
        data: rpc.MessageSequence,
        reply: rpc.MessageSequence,
        options: rpc.MessageOption
    ) {
        hilog.info(0, 'testTag', `testtag driver extension onRemoteMessageRequest called ${code}`);
        try{
            if (code == 1) {
                let keyIndex = data.readInt();
                let keyValue = data.readInt();
                console.info(`testtag driver extension start setOneButtonMapping key:${keyIndex} val:${keyValue}`);
                testNapi.setOneButtonMapping(keyIndex, keyValue);
                console.info(`testtag driver extension setOneButtonMapping called key:${keyIndex} val:${keyValue}`);
                reply.writeInt(keyIndex);
                return true;
            } else if (code == 2) {
                let direction = data.readInt();
                console.info(`testtag driver start setDirection direction:${direction}`);
                testNapi.setDirection(direction);
                console.info(`testtag driver setDirection called`);
                reply.writeInt(direction);
                return true;
            } else if (code == 3) {
                let type = data.readInt();
                type = (globalThis?.connectStatus ? 1 : 0);
                hilog.info(0, 'testTag', `testtag get connection status called status:${type}`);
                reply.writeInt(type);
                return true;
            }
        } catch (error) {
            hilog.info(0, 'testTag', 'onRemoteMessageRequest exception');
        }
    }

    sendDisconnect() {
        let option = new rpc.MessageOption();
        let dataSend = new rpc.MessageSequence();
        let reply = new rpc.MessageSequence();
        hilog.info(0, 'testTag', `sendDisconnect`);
        this.sendMessageRequest(0x99, dataSend, reply, option).then((ret) => {
            let msg = reply.readInt();
            reply.writeInt(msg);
            hilog.info(0, 'testTag', `sendDisconnect sendMessageRequest ret:${ret} msg:${msg}`);
        }).catch((error) => {
            hilog.info(0, 'testTag', 'sendDisconnect sendMessageRequest failed');
        });
    }
}

export default class DriverExtAbility extends DriverExtensionAbility {

    private keyPreferences: preferences.Preferences | null = null

    private initKeyPreference() {
        hilog.info(0, 'testTag', `initKeyPreference stageMode: ${this.context.stageMode}`);
        this.context.area = contextConstant.AreaMode.EL1;
        hilog.info(0, 'testTag', `initKeyPreference area: ${this.context.area}`);
        hilog.info(0, 'testTag', `initKeyPreference preferencesDir: ${this.context.preferencesDir}`);
        this.keyPreferences = preferences.getPreferencesSync(this.context, {name: 'keyInfo'});
    }

    getKeyMapInfo() {
        STORAGE_KEY.forEach((value, index) => {
            defaultIndexMap[index] = this.keyPreferences?.getSync(value.key, value.default) as number
        })
        hilog.info(0, 'testTag', JSON.stringify(defaultIndexMap));
    }

    getDirectionInfo() {
        direction = this.keyPreferences?.getSync('direction', 0) as number;
    }

    async onInit(want): Promise<void> {
        hilog.info(0, 'testTag','DriverAbility OnInit, deviceId '+ want.parameters["deviceId"]);
        let ret = testNapi.getProductDesc(want.parameters["deviceId"]);
        if (ret != undefined) {
            [globalThis.productDesc, globalThis.productId] = ret;
        }
        hilog.info(0, 'testTag','getProductDesc '+ ret);
        this.initKeyPreference();
        this.getKeyMapInfo()
        hilog.info(0, 'testTag','getDirectionInfo');
        this.getDirectionInfo()
        hilog.info(0, 'testTag','getAllDisplays');
        // 获取屏幕分辨率
        try {
            display.getAllDisplays((err, data:Array<display.Display>) => {
                hilog.info(0, 'testTag', 'getAllDisplays callback');
                if (err && err.code) {
                    hilog.error(0, 'testTag','Failed to obtain all the display objects. Code: ' + JSON.stringify(err));
                    testNapi.setDisplayInfo(2160, 1440);
                } else {
                    hilog.info(0, 'testTag', 'Succeeded in obtaining all the display objects. Data: ' + JSON.stringify(data));
                    testNapi.setDisplayInfo(data[0].width, data[0].height);
                }
                // 传递给native层
                testNapi.setButtonMapping(defaultIndexMap);
                testNapi.setDirection(direction);
                GetData();
                //PowerManagwer();
            });
        } catch (error) {
            hilog.info(0, 'testTag', 'found js exception');
            testNapi.setDisplayInfo(2160, 1440);
            testNapi.setButtonMapping(defaultIndexMap);
            testNapi.setDirection(direction);
            GetData();

        }
        // subscribeCES();
    }
    onRelease() :void {
        hilog.info(0, 'testTag', 'DriverAbility onRelease');
        // 释放底层资源
        testNapi.releaseResource();
    }
    onConnect(want): rpc.RemoteObject {
        hilog.info(0, 'testTag', 'DriverAbility onConnect');
        return new FirstDriverAbilityStub('remote');
    }
    onDisconnect(want): void {
        hilog.info(0, 'testTag', 'DriverAbility onDisconnect');
        // testNapi.releaseResource();
    }
    onDump(params): Array<string> {
        hilog.info(0, 'testTag', 'DriverAbility onDump, params:' + JSON.stringify(params));
        return ['params'];
    }
};