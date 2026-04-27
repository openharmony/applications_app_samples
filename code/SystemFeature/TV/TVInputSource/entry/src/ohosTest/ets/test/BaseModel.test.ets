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
import BaseModel from '../../../main/ets/model/BaseModel';
import { LogUtil } from '../../../main/ets/utils/LogUtil';

/**
 * Registers tests for the shared base model inheritance contract.
 *
 * @returns void.
 */
export default function BaseModelTest(): void {
  describe('BaseModel_real', () => {
    it('should_create_base_model_instances_without_state', 0, () => {
      const instance = new BaseModel();

      // The base model is intentionally minimal and acts only as a shared
      // inheritance anchor, so construction must remain side-effect free.
      expect(instance !== undefined).assertEqual(true);
      expect(Object.keys(instance as Object).length).assertEqual(0);
    });

    it('should_allow_log_util_to_inherit_from_base_model', 0, () => {
      const instance = new LogUtil();

      expect(instance instanceof BaseModel).assertEqual(true);
    });
  });
}

