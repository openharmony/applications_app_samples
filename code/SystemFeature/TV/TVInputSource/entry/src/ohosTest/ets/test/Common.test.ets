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
import ConfigData, { ConfigData as ConfigDataClass } from '../../../main/ets/common/ConfigData';
import { LogUtil } from '../../../main/ets/utils/LogUtil';

/**
 * Registers tests for common configuration values and log forwarding.
 *
 * @returns void.
 */
export default function CommonTest(): void {
  describe('Common_real', () => {
    it('should_expose_stable_default_settings_values', 0, () => {
      const config = new ConfigDataClass();

      // These defaults are consumed by multiple pages and system integrations,
      // so the test locks down the most business-relevant constants.
      expect(config.DEFAULT_BUNDLE_NAME).assertEqual('com.ohos.settings');
      expect(config.BRIGHTNESS_DEFAULT_VALUE).assertEqual(50);
      expect(config.PAGE_RESULT_OK).assertEqual(-1);
      expect(config.WH_100_100).assertEqual('100%');
    });

    it('should_share_singleton_config_instance_with_same_contract', 0, () => {
      expect(ConfigData.DEFAULT_BUNDLE_NAME).assertEqual('com.ohos.settings');
      expect(ConfigData.TIME_FORMAT_24).assertEqual('24');
      expect(ConfigData.TIME_FORMAT_12).assertEqual('12');
    });

    it('should_allow_logger_methods_to_run_with_stable_settings_tag', 0, () => {
      const logger = new LogUtil();
      let didThrow = false;

      try {
        logger.debug('D');
        logger.info('I');
        logger.warn('W');
        logger.error('E');
      } catch (_error) {
        didThrow = true;
      }

      expect(didThrow).assertEqual(false);
    });
  });
}
