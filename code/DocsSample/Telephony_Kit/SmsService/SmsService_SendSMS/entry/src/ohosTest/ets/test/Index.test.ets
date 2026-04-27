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
import { describe, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

function sleep(time: number): Promise<void> {
    return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}
export default function IndexTest() {
    describe('IndexTest', () => {
        it('testCallButton', 0, async (done: Function) => {
            console.info('uitest: testCallButton begin');
            // 启动目标 Ability
            const want: Want = {
                bundleName: bundleName,
                abilityName: 'EntryAbility'
            };
            await delegator.startAbility(want);
            await sleep(1000);

            // 检查当前顶层 Ability 是否为 EntryAbility
            const ability: UIAbility = await delegator.getCurrentTopAbility();
            console.info('get top ability');
            expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');

            //初始化 Driver
            const driver = Driver.create();
            await driver.delayMs(1000);

            //查找并点击'Send Sms'按钮
            const button = await driver.findComponent(ON.text('发送短信'));
            await button.click();
            await driver.delayMs(1000);

            //验证是否成功
            await driver.assertComponentExist(ON.text('短信内容'));
            await driver.pressBack();
            done();
        });
    });
}