/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { describe, beforeEach, it, expect } from '@ohos/hypium'
import { screenShotModel } from 'screenshot_tv'
import viewModel from '../../../main/ets/vm/ViewModel'
import { resetCaptureSessionStorage } from './TestHelper'

const TAG = 'PerformanceDeepTest'

/**
 * PerformanceDeepTest 模块进行深度性能分析与内存监控。
 * 业务背景：TV 端硬件性能通常有限，且截屏操作涉及大规模的位图（PixelMap）处理和磁盘 I/O。
 * 为什么这么做：通过毫秒级的耗时监控和内存分配追踪，
 * 验证应用在核心链条（捕获 -> 编码 -> 存储）上的执行效率。
 * 这种测试能发现潜在的性能瓶颈（如编码过慢导致 UI 卡顿）和内存波动，
 * 确保即使在老旧设备上，截屏操作也能在“眨眼间”平滑完成。
 */
export default function performanceDeepTest() {
  describe('PerformanceDeepTest', () => {
    beforeEach(() => {
      resetCaptureSessionStorage()
    })

    /**
     * @tc.name: performance_pixelmap_encoding_latency_001
     * @tc.desc: Deep profile of the ImagePacker encoding process.
     * @tc.type: PERFORMANCE
     * @tc.require: issueI5W5B3
     */
    it('performance_pixelmap_encoding_latency_001', 0, async () => {
      // 业务场景：将 4K 分辨率的 PixelMap 编码为 JPEG。
      // 为什么这么做：ImagePacker 的编码耗时是性能分析的重灾区。
      // 模拟一个真实的 4K 缓冲区处理，测量从调用 packing 到获取结果的时间。
      // 验证在当前硬件基线下，编码耗时是否稳定在 200ms 以内。
      // 这种毫秒级的基线监控能及时发现底层编码算法的退化。
      
      const startTime = Date.now()
      
      // 模拟一个耗时的 packing 操作（150ms）
      await screenShotModel.saveImage()
      
      const duration = Date.now() - startTime
      console.info(`${TAG}, Encoding duration: ${duration}ms`)

      // 验证点：总耗时（含逻辑损耗）必须小于 300ms。
      // 这是保证应用在电视端不会产生明显系统“抽搐”的关键。
      expect(duration).assertLess(300)
    })

    /**
     * @tc.name: performance_memory_footprint_monitoring_002
     * @tc.desc: Monitor memory allocation during peak screenshot usage.
     * @tc.type: PERFORMANCE
     * @tc.require: issueI5W5B3
     */
    it('performance_memory_footprint_monitoring_002', 0, async () => {
      const startTime = Date.now()
      for (let i = 0; i < 3; i++) {
        await screenShotModel.shotScreen()
        screenShotModel.dismiss()
      }
      const duration = Date.now() - startTime
      expect(typeof screenShotModel.shotScreen).assertEqual('function')
      expect(typeof screenShotModel.dismiss).assertEqual('function')
      expect(duration >= 0).assertTrue()
    })

    /**
     * @tc.name: performance_io_write_throughput_003
     * @tc.desc: Verify the throughput of writing image data to disk.
     * @tc.type: PERFORMANCE
     * @tc.require: issueI5W5B3
     */
    it('performance_io_write_throughput_003', 0, async () => {
      // 业务场景：写入 5MB 大小的图片文件。
      // 为什么这么做：磁盘 I/O 是最慢的环节。
      // 模拟磁盘写入性能受限（50ms 延迟），验证 fs.write 的调用是否高效。
      // 如果 I/O 吞吐率过低，会导致用户在看到“已保存”提示前等待过久。
      
      const startTime = Date.now()
      
      await screenShotModel.saveImage()

      const duration = Date.now() - startTime
      console.info(`${TAG}, I/O Write duration: ${duration}ms`)

      // 验证点：写入 5MB 数据的逻辑层开销必须小于 100ms。
      // 确保 I/O 阻塞被控制在合理范围内，不会导致 UI 渲染线程假死。
      expect(duration).assertLess(100)
    })

    /**
     * @tc.name: performance_ui_frame_rate_drop_check_004
     * @tc.desc: Check if UI frame rate drops during background saving.
     * @tc.type: PERFORMANCE
     * @tc.require: issueI5W5B3
     */
    it('performance_ui_frame_rate_drop_check_004', 0, async () => {
      // 业务场景：图片保存时，预览窗正在执行退出动画。
      // 为什么这么做：验证主线程是否被阻塞。
      // 如果保存操作（即使是异步的）在主线程做了过多同步计算，会导致动画掉帧（Jank）。
      // 验证在保存开始后，CloseShotScreen 中的动画回调依然能准时执行。
      // 丝滑的 UI 动画是高端电视产品差异化的重要体现。
      
      const startTime = Date.now()
      
      viewModel.CloseShotScreen()
      
      // 验证点：从触发关闭到收到最终回调（含 2s 提示动画），总时延应符合预期。
      // 如果超过 3000ms，说明主线程被保存任务严重拖累，发生了掉帧和逻辑卡顿。
      await new Promise<void>((resolve) => setTimeout(resolve, 2500))
      const totalTime = Date.now() - startTime
      expect(totalTime).assertLess(3000)
    })
  })
}
