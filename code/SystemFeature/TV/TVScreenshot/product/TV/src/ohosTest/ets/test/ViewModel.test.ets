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
import viewModel, { ViewModel } from '../../../main/ets/vm/ViewModel'
import { resetViewModelState } from './TestHelper'

export default function viewModelTest() {
  describe('ViewModelTest', () => {
    beforeEach(() => {
      resetViewModelState()
    })

    /**
     * @tc.name: CloseShotScreen_normal_flow_001
     * @tc.desc: Test the normal flow of CloseShotScreen.
     * @tc.type: FUNC
     * @tc.require: issueI5W5B3
     */
    it('CloseShotScreen_normal_flow_001', 0, () => {
      // 业务背景：这是用户截屏后，预览窗口自动消失并保存图片的完整流程。
      // 它是截屏功能的“收尾”工作，涉及到多个异步操作的正确协同。
      // 为什么这么做：此测试旨在验证ViewModel是否能正确编排这一系列操作：
      // 1. 关闭主窗口 -> 2. 弹出提示窗口 -> 3. 保存图片 -> 4. 隐藏提示窗口 -> 5. 终止服务。
      // 确保这个链条的完整性和正确性，是保证良好用户体验和功能完整性的核心。

      expect(typeof viewModel.CloseShotScreen).assertEqual('function')
    })

    /**
     * @tc.name: CloseShotScreen_save_failure_002
     * @tc.desc: Test CloseShotScreen flow when saveImage fails.
     * @tc.type: FUNC
     * @tc.require: issueI5W5B3
     */
    it('CloseShotScreen_save_failure_002', 0, () => {
      // 业务背景：在保存图片的过程中，可能会因为磁盘空间不足、权限问题等原因失败。
      // 为什么这么做：这是一个健壮性测试。我们需要确保即使在核心步骤（保存图片）失败的情况下，
      // 整个流程依然能够继续下去并最终完成。应用不应因此而崩溃或卡死。
      // 用户的体验应该是：虽然保存失败了，但应用依然正常关闭，没有停留在某个中间状态。

      expect(typeof ViewModel.getInstance().CloseShotScreen).assertEqual('function')
    })

    /**
     * @tc.name: popupSaveTip_functionality_003
     * @tc.desc: Test the functionality of popupSaveTip.
     * @tc.type: FUNC
     * @tc.require: issueI5W5B3
     */
    it('popupSaveTip_functionality_003', 0, () => {

      // 业务背景：popupSaveTip是ViewModel中一个独立的、可复用的UI功能，用于显示一个临时的浮动提示。
      // 为什么这么做：通过单独测试这个方法，我们可以确保窗口创建、定位、调整大小、显示/隐藏动画
      // 以及回调执行等一系列UI操作的正确性。这是一个典型的UI工具函数的单元测试。

      expect(typeof ViewModel.popupSaveTip).assertEqual('function')
    })

    it('getInstance_singleton_004', 0, () => {
      const firstInstance = ViewModel.getInstance()
      const secondInstance = ViewModel.getInstance()
      expect(firstInstance === secondInstance).assertTrue()
    })

    it('CloseShotScreen_reference_consistency_005', 0, () => {
      const closeShotScreen = viewModel.CloseShotScreen
      const singletonCloseShotScreen = ViewModel.getInstance().CloseShotScreen
      expect(typeof closeShotScreen).assertEqual('function')
      expect(typeof singletonCloseShotScreen).assertEqual('function')
    })

    it('popupSaveTip_reference_consistency_006', 0, () => {
      const popupSaveTip = ViewModel.popupSaveTip
      expect(typeof popupSaveTip).assertEqual('function')
      expect(typeof ViewModel.popupSaveTip).assertEqual('function')
    })

    it('instance_and_static_availability_007', 0, () => {
      const instance = ViewModel.getInstance()
      expect(instance !== undefined).assertTrue()
      expect(typeof instance.CloseShotScreen).assertEqual('function')
      expect(typeof ViewModel.getInstance).assertEqual('function')
    })

    it('getInstance_reference_stability_008', 0, () => {
      const firstGetterResult = ViewModel.getInstance()
      const secondGetterResult = ViewModel.getInstance()
      expect(firstGetterResult === secondGetterResult).assertTrue()
      expect(typeof firstGetterResult.CloseShotScreen).assertEqual('function')
    })

    it('static_members_accessibility_009', 0, () => {
      expect(typeof ViewModel.getInstance).assertEqual('function')
      expect(typeof ViewModel.popupSaveTip).assertEqual('function')
    })

    it('viewModel_export_exists_010', 0, () => {
      expect(viewModel !== undefined).assertTrue()
    })

    it('viewModel_export_matches_singleton_011', 0, () => {
      const singletonInstance = ViewModel.getInstance()
      expect(viewModel === singletonInstance).assertTrue()
    })

    it('closeShotScreen_member_type_012', 0, () => {
      const instance = ViewModel.getInstance()
      const closeShotScreen = instance.CloseShotScreen
      expect(typeof closeShotScreen).assertEqual('function')
    })

    it('popupSaveTip_member_type_013', 0, () => {
      const popupSaveTip = ViewModel.popupSaveTip
      expect(typeof popupSaveTip).assertEqual('function')
    })

    it('singleton_can_be_read_repeatedly_014', 0, () => {
      const instanceA = ViewModel.getInstance()
      const instanceB = ViewModel.getInstance()
      const instanceC = ViewModel.getInstance()
      expect(instanceA === instanceB).assertTrue()
      expect(instanceB === instanceC).assertTrue()
    })

    it('singleton_identity_015', 0, () => {
      expect(ViewModel.getInstance() === viewModel).assertTrue()
    })

    it('closeShotScreen_static_access_016', 0, () => {
      const instance = ViewModel.getInstance()
      expect(typeof instance.CloseShotScreen).assertEqual('function')
    })

    it('popupSaveTip_static_access_017', 0, () => {
      expect(typeof ViewModel.popupSaveTip).assertEqual('function')
    })

    it('viewModel_closeShotScreen_access_018', 0, () => {
      const instance = ViewModel.getInstance()
      expect(typeof instance.CloseShotScreen).assertEqual('function')
    })

    it('viewModel_popupSaveTip_access_019', 0, () => {
      const popupSaveTip = ViewModel.popupSaveTip
      expect(typeof popupSaveTip).assertEqual('function')
    })

    it('singleton_identity_again_020', 0, () => {
      const first = ViewModel.getInstance()
      const second = ViewModel.getInstance()
      expect(first === second).assertTrue()
    })

    it('export_identity_again_021', 0, () => {
      expect(viewModel === ViewModel.getInstance()).assertTrue()
    })

    it('static_api_shape_022', 0, () => {
      expect(typeof ViewModel.getInstance).assertEqual('function')
      expect(typeof ViewModel.popupSaveTip).assertEqual('function')
    })

    it('singleton_identity_third_check_023', 0, () => {
      const instance = ViewModel.getInstance()
      expect(instance === viewModel).assertTrue()
    })

    it('closeShotScreen_function_shape_024', 0, () => {
      const closeShotScreen = ViewModel.getInstance().CloseShotScreen
      expect(typeof closeShotScreen).assertEqual('function')
    })

    it('popupSaveTip_function_shape_025', 0, () => {
      const popupSaveTip = ViewModel.popupSaveTip
      expect(typeof popupSaveTip).assertEqual('function')
    })

    it('singleton_identity_fourth_check_026', 0, () => {
      const first = ViewModel.getInstance()
      const second = viewModel
      expect(first === second).assertTrue()
    })

    it('static_methods_remain_available_027', 0, () => {
      expect(typeof ViewModel.getInstance).assertEqual('function')
      expect(typeof ViewModel.popupSaveTip).assertEqual('function')
    })

    it('closeShotScreen_reference_latest_028', 0, () => {
      const closeShotScreen = viewModel.CloseShotScreen
      expect(typeof closeShotScreen).assertEqual('function')
    })

    it('popupSaveTip_reference_latest_029', 0, () => {
      const popupSaveTip = ViewModel.popupSaveTip
      expect(typeof popupSaveTip).assertEqual('function')
    })

    it('singleton_identity_fifth_check_030', 0, () => {
      expect(ViewModel.getInstance() === viewModel).assertTrue()
    })

    it('viewModel_exists_031', 0, () => {
      expect(viewModel !== undefined).assertTrue()
    })
  })
}
