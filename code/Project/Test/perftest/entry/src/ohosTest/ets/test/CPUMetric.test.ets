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
// [Start CPUMetri_sample]
import { describe, it, expect, Level } from '@ohos/hypium';
import { PerfMetric, PerfTest, PerfTestStrategy, PerfMeasureResult, abilityDelegatorRegistry } from '@kit.TestKit';
import { Utils } from '../../../main/ets/utils/Utils'

export default function PerfTestTest() {
  describe('PerfTestTest2', () => {
    it('testExample1', 0, async (done: Function) => {
      // [Start metricsDefine_sample]
      let metrics: Array<PerfMetric> = [ PerfMetric.DURATION, PerfMetric.CPU_USAGE ]; // 定义待测指标
      // [End metricsDefine_sample]
      // [Start callbackDefine_sample]
      let actionCode: Callback<Callback<boolean>> = async (finish: Callback<boolean>) => {  // 定义被测代码段
        Utils.CalculateTest();
        finish(true);
      };
      // [End callbackDefine_sample]
      // [Start resetCodeDefine_sample]
      let resetCode: Callback<Callback<boolean>> = async (finish: Callback<boolean>) => {  // 定义环境复位代码段
        Utils.Reset();
        finish(true);
      };
      // [End resetCodeDefine_sample]
      // [Start strategyDefine_sample]
      let perfTestStrategy: PerfTestStrategy = {  // 定义测试策略
        metrics: metrics,
        actionCode: actionCode,
        resetCode: resetCode,
        bundleName: "com.samples.test.perftest", // 定义被测应用包名，请开发者替换为实际包名
        iterations: 10,  // 定义测试迭代次数
        timeout: 20000  // 定义代码段单次执行超时时间
      };
      // [End strategyDefine_sample]
      try {
        // [Start startTest_sample]
        let perfTest: PerfTest = PerfTest.create(perfTestStrategy); // 创建测试任务对象PerfTest
        await perfTest.run(); // 执行测试，异步函数需使用await同步等待完成
        // [End startTest_sample]
        // [Start getResult_sample]
        let res1: PerfMeasureResult = perfTest.getMeasureResult(PerfMetric.DURATION); // 获取耗时指标的测试结果
        let res2: PerfMeasureResult = perfTest.getMeasureResult(PerfMetric.CPU_USAGE); // 获取CPU使用率指标的测试结果
        // [End getResult_sample]
        // [Start exit_sample]
        perfTest.destroy(); // 销毁PerfTest对象
        // [End exit_sample]
        expect(res1.average).assertLessOrEqual(1000); // 断言性能测试结果
        expect(res2.average).assertLessOrEqual(30); // 断言性能测试结果
      } catch (error) {
        console.error(`Failed to execute perftest. Cause:${JSON.stringify(error)}`);
        expect(false).assertTrue()
      }
      done()
    })
  })
}
// [End CPUMetri_sample]
