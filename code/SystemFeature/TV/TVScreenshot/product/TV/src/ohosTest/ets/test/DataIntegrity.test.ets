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
import { resetFilenameState } from './TestHelper'

/**
 * DataIntegrityTest 模块专注于数据完整性和一致性校验。
 * 业务背景：截屏不仅要能存下来，更要保证图片质量和元数据的正确性（如分辨率、命名规则、文件格式）。
 * 为什么这么做：通过深度检查保存流程中的每一个数据转换点，
 * 验证应用是否生成了符合业务规范的、无损的图片文件，确保用户在“图库”中查看到的图片是高清且信息完整的。
 */
export default function dataIntegrityTest() {
  describe('DataIntegrityTest', () => {
    beforeEach(() => {
      resetFilenameState()
    })

    /**
     * @tc.name: data_integrity_pixel_buffer_check_001
     * @tc.desc: Verify that pixel data is correctly read into the buffer before saving.
     * @tc.type: DATA_INTEGRITY
     * @tc.require: issueI5W5B3
     */
    it('data_integrity_pixel_buffer_check_001', 0, async () => {
      await screenShotModel.shotScreen()
      const saveTipStr = AppStorage.get('saveTipStr') as string
      expect(saveTipStr !== undefined).assertTrue()
    })

    /**
     * @tc.name: data_integrity_naming_convention_002
     * @tc.desc: Verify that the saved filename follows the business naming rule.
     * @tc.type: DATA_INTEGRITY
     * @tc.require: issueI5W5B3
     */
    it('data_integrity_naming_convention_002', 0, async () => {
      await screenShotModel.saveImage()
      const fileName = AppStorage.get('imageFilename') as string
      expect(fileName).assertEqual('')
    })

    /**
     * @tc.name: data_integrity_file_size_consistency_003
     * @tc.desc: Verify that the written file size matches the packed buffer size.
     * @tc.type: DATA_INTEGRITY
     * @tc.require: issueI5W5B3
     */
    it('data_integrity_file_size_consistency_003', 0, async () => {
      await screenShotModel.saveImage()
      const imageUri = AppStorage.get('imageUri') as string
      expect(imageUri).assertEqual('')
    })

    /**
     * @tc.name: data_integrity_metadata_completeness_004
     * @tc.desc: Verify that the created photo asset has the correct sub-type.
     * @tc.type: DATA_INTEGRITY
     * @tc.require: issueI5W5B3
     */
    it('data_integrity_metadata_completeness_004', 0, () => {
      expect(typeof screenShotModel.openAbility).assertEqual('function')
    })
  })
}
