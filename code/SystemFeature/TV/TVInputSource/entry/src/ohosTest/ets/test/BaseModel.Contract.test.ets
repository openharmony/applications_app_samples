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

import { describe, expect, it } from '@ohos/hypium';
import BaseModel from '../../../main/ets/model/BaseModel';
import { InputsourceModel } from '../../../main/ets/model/InputSourceModel';
import { LogUtil } from '../../../main/ets/utils/LogUtil';

class ContractSampleModel extends BaseModel {
  public currentValue: string | null = 'boot';
  public lastReason: string | undefined = 'init';

  /**
   * Stores a business value on top of the shared base-model anchor.
   * @param value Current payload that pages want to preserve verbatim.
   * @returns void.
   */
  public setCurrentValue(value: string | null): void {
    this.currentValue = value;
  }

  /**
   * Stores an optional reason string, including deliberate undefined resets.
   * @param reason Optional marker used to represent an intentionally empty state.
   * @returns void.
   */
  public setLastReason(reason: string | undefined): void {
    this.lastReason = reason;
  }
}

/**
 * Registers Task-11 coverage for BaseModel's minimal inheritance contract.
 *
 * @returns void.
 */
export default function BaseModelContractTest(): void {
  describe('BaseModel_contract_task11', () => {
    it('should_keep_base_model_construction_side_effect_free', 0, () => {
      const instance = new BaseModel();

      // The project currently uses BaseModel as a pure inheritance anchor.
      // Keeping construction empty is important because every derived model
      // should opt into its own state instead of inheriting hidden defaults.
      expect(instance !== undefined).assertEqual(true);
      expect(Object.keys(instance as Object).length).assertEqual(0);
    });

    it('should_preserve_subclass_state_writes_without_base_interference', 0, () => {
      const sample = new ContractSampleModel();

      // This contract protects future model growth: adding fields on subclasses
      // must remain a local concern, with BaseModel staying transparent and not
      // rewriting or normalizing application-level payloads.
      sample.setCurrentValue('HDMI2');
      sample.setLastReason('manual-switch');

      expect(sample instanceof BaseModel).assertEqual(true);
      expect(sample.currentValue).assertEqual('HDMI2');
      expect(sample.lastReason).assertEqual('manual-switch');
    });

    it('should_allow_null_and_undefined_payloads_on_derived_models', 0, () => {
      const sample = new ContractSampleModel();

      // Empty payloads are valid during reset, teardown or first-frame loading.
      // The base anchor must not force fallback values here, otherwise pages
      // cannot distinguish an intentional clear from a non-empty business state.
      sample.setCurrentValue(null);
      sample.setLastReason(undefined);

      expect(sample instanceof BaseModel).assertEqual(true);
      expect(sample.currentValue === null).assertEqual(true);
      expect(sample.lastReason === undefined).assertEqual(true);
    });

    it('should_keep_real_data_and_service_models_on_the_same_base_contract', 0, () => {
      const inputModel = new InputsourceModel();
      const logModel = new LogUtil();

      // The same base class anchors both stateful page models and service-style
      // utilities. Verifying both shapes together prevents future refactors from
      // breaking one branch of the inheritance tree while keeping the other alive.
      inputModel.setValue('');

      expect(inputModel instanceof BaseModel).assertEqual(true);
      expect(logModel instanceof BaseModel).assertEqual(true);
      expect(inputModel.value).assertEqual('');
    });
  });
}

