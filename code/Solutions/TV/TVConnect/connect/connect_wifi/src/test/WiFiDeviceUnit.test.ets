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
import { describe, expect, it } from '@ohos/hypium';
import WifiConstants from '../main/ets/components/connect/wifi/constants/WifiConstants';

export default function WiFiDeviceUnit() {
  describe('WiFiDeviceUnit', () => {
    it('RegExpTest0', 0, () => {
      let exp = new RegExp(WifiConstants.wifiScanRegStr);
      let testSsid = "Oh-HUAWEI-Smart TV-1YYYYYRRRR";
      expect(exp.test(testSsid)).assertTrue();

    });
    it('RegExpTest1', 1, () => {
      let exp = new RegExp(WifiConstants.wifiScanRegStr);
      let testSsid = "OH-HUAWEI-Smart TV-2YYYYYRRRR";
      expect(exp.test(testSsid)).assertFalse();

    });

    it('RegExpTest2', 2, () => {
      let exp = new RegExp(WifiConstants.wifiScanRegStr);
      let testSsid = "Oh-S-WS-3YYYYYRRRR";
      expect(exp.test(testSsid)).assertFalse();

    });
    it('RegExpTest3', 3, () => {
      let exp = new RegExp(WifiConstants.wifiScanRegStr);
      let testSsid = "Oh-HUAWEI-Smart TV1234-4YYYYYRRRR";
      expect(exp.test(testSsid)).assertFalse();

    });
    it('RegExpTest4', 4, () => {
      let exp = new RegExp(WifiConstants.wifiScanRegStr);
      let testSsid = "Oh-HUAWEI-Smart TV-+YYYYYRRRR";
      expect(exp.test(testSsid)).assertFalse();

    });
    it('RegExpTest5', 5, () => {
      let exp = new RegExp(WifiConstants.wifiScanRegStr);
      let testSsid = "Oh-HUAWEI-Smart TV-6YYY YRRRR";
      expect(exp.test(testSsid)).assertFalse();

    });
  });
}