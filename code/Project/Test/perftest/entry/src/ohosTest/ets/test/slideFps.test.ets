/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// [Start slideFps_sample]
import { describe, it, expect, Level } from '@ohos/hypium';
import { PerfMetric, PerfTest, PerfTestStrategy, PerfMeasureResult } from '@kit.TestKit';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
  export default function PerfTestTest() {
    describe('PerfTestTest', () => {
    it('testExample2',Level.LEVEL3, async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
        // 被拉起应用的包名和Ability组件名，请开发者替换为实际的bundleName和abilityName
        const want: Want = {
            bundleName: bundleName,
            abilityName: 'EntryAbility'
        };
        await delegator.startAbility(want); // 拉起测试应用
        await driver.delayMs(1000);
        let scroll = await driver.findComponent(ON.type('Scroll'));
        await driver.delayMs(1000);
        let center = await scroll.getBoundsCenter();  // 获取Scroll可滚动组件坐标
        await driver.delayMs(1000);
        let metrics: Array<PerfMetric> = [PerfMetric.LIST_SWIPE_FPS]  // 指定被测指标为列表滑动帧率
        let actionCode = async (finish: Callback<boolean>) => { // 测试代码段中使用uitest进行列表滑动
            await driver.fling({x: center.x, y: Math.floor(center.y * 3 / 2)}, {x: center.x, y: Math.floor(center.y / 2)}, 50, 20000);
            await driver.delayMs(3000);
            finish(true);
        };
        let resetCode = async (finish: Callback<boolean>) => {  // 复位环境，将列表划至顶部
            await scroll.scrollToTop(40000);
            await driver.delayMs(1000);
            finish(true);
        };
        let perfTestStrategy: PerfTestStrategy = {  // 定义测试策略
            metrics: metrics,
            actionCode: actionCode,
            resetCode: resetCode,
            iterations: 5,  // 指定测试迭代次数
            timeout: 50000, // 指定actionCode和resetCode的超时时间
        };
        try {
            let perfTest: PerfTest = PerfTest.create(perfTestStrategy); // 创建测试任务对象PerfTest
            await perfTest.run(); // 执行测试，异步函数需使用await同步等待完成
            let res: PerfMeasureResult = perfTest.getMeasureResult(PerfMetric.LIST_SWIPE_FPS); // 获取列表滑动帧率指标的测试结果
            perfTest.destroy(); // 销毁PerfTest对象
            expect(res.average).assertLargerOrEqual(60);  // 断言性能测试结果
        } catch (error) {
            console.error(`Failed to execute perftest. Cause:${JSON.stringify(error)}`);
        }
        done();
      })
  })
}
// [End slideFps_sample]
