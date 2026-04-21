/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { describe, it, expect } from '@ohos/hypium';
import { InputsourceModel } from '../../../main/ets/model/InputSourceModel';
import { SettingItemStyle } from '../../../main/ets/utils/StyleConstants';

/**
 * Registers tests for mutable flags on input source setting items.
 *
 * @returns void.
 */
export default function InputSourceModelTest(): void {
  describe('InputSourceModel_real', () => {
    it('should_toggle_and_update_setting_fields', 0, () => {
      const model = new InputsourceModel();

      // Settings pages mutate a shared model instance instead of rebuilding the
      // list each frame, so setter coverage protects view state continuity.
      model.setIsOn(true);
      model.setIsSelect(true);
      model.setValue('HDMI2');
      model.setDes('default source');
      model.setStyle(SettingItemStyle.valueChange);
      model.setIsEnable(false);
      model.setIsDisableFocus(true);
      model.setIsDefault();

      expect(model.isOn).assertEqual(true);
      expect(model.isSelect).assertEqual(true);
      expect(model.value).assertEqual('HDMI2');
      expect(model.des).assertEqual('default source');
      expect(model.style).assertEqual(SettingItemStyle.valueChange);
      expect(model.isEnable).assertEqual(false);
      expect(model.isDisableFocus).assertEqual(true);
      expect(model.isDefault).assertEqual(true);
    });
  });
}

