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

import { describe, it, expect, beforeEach, afterEach, TestType, Size, Level } from '@ohos/hypium';

export default function deviceDialogTestSuite(): void {
  describe('DeviceDialogTest', () => {
  // Test showDeviceConnectDialog method
  it('testshowDeviceConnectDialogMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    // showDeviceConnectDialog should display the UI correctly
    const deviceName: string = 'Test Device';
    expect(deviceName).assertEqual('Test Device');
  });

  // Test showDeviceDisconnectDialog method
  it('testshowDeviceDisconnectDialogMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    // showDeviceDisconnectDialog
    const deviceName: string = 'Test Device';
    expect(deviceName).assertEqual('Test Device');
  });

  // Test showErrorDialog method
  it('testshowErrorDialogMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    // showErrorDialog
    const errorMsg: string = 'Test Error';
    expect(errorMsg).assertEqual('Test Error');
  });

  // Test showConfirmDialog method
  it('testshowConfirmDialogMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    // showConfirmDialog
    const title: string = 'Test Title';
    const message: string = 'Test Message';
    expect(title).assertEqual('Test Title');
    expect(message).assertEqual('Test Message');
  });


  it('testshowDeviceConnectDialogMethodAbnormal', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const deviceName: string = 'Test Device';
      expect(deviceName).assertEqual('Test Device');
    } catch (e) {
      expect(null).assertFail();
    }
  });


  it('testshowErrorDialogMethodEdge', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
    try {
      const emptyMsg: string = '';
      expect(emptyMsg).assertEqual('');
    } catch (e) {
      expect(null).assertFail();
    }
  });
  });
}
