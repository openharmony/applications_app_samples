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