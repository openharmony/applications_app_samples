/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { describe, it, expect } from '@ohos/hypium';
import { Scan } from '../../../main/ets/scan/scan'
import { ScanLog } from '../../../main/ets/scan/log'
import { ScannerDevice } from '../../../main/ets/scan/scan'
import { ScanOptionValue } from '../../../main/ets/scan/scan'
export function scanTest() {
  describe('ScanAbilityTest', () => {
    it('ScanTest_000', 0, ()=>{
      Scan.initScan().then((data:number)=>{
        ScanLog.info('init scan successful')
      }).catch(() => {
        ScanLog.warn('init scan error')
      })
    });
    it('ScanTest_001', 0, ()=>{
      Scan.exitScan().then(()=>{
        ScanLog.info('exitScan scan successful')
      }).catch(() => {
        ScanLog.warn('exitScan scan error')
      })
    });
    it('ScanTest_002', 0, ()=>{
      let scannerId : string = "";
      Scan.openScanner(scannerId).then(()=>{
        ScanLog.info('openScanner scan successful')
      }).catch(() => {
        ScanLog.warn('openScanner scan error')
      })
    });
    it('ScanTest_003', 0, ()=>{
      let scannerId : string = "";
      Scan.closeScanner(scannerId).then(()=>{
        ScanLog.info('closeScanner scan successful')
      }).catch(() => {
        ScanLog.warn('closeScanner scan error')
      })
    });
    it('ScanTest_004', 0, ()=>{
      let scannerId : string = ""
      Scan.startScan(scannerId, false).then(()=>{
        ScanLog.info('startScan scan successful')
      }).catch(() => {
        ScanLog.warn('startScan scan error')
      })
    });
    it('ScanTest_005', 0, ()=>{
      let scannerId : string = "";
      Scan.cancelScan(scannerId).then(()=>{
        ScanLog.info('cancelScan scan successful')
      }).catch(() => {
        ScanLog.warn('cancelScan scan error')
      })
    });
    it('ScanTest_006', 0, ()=>{
      let scannerId : string = "";
      Scan.getProgress(scannerId).then(()=>{
        ScanLog.info('getProgress scan successful')
      }).catch(() => {
        ScanLog.warn('getProgress scan error')
      })
    });
    it('ScanTest_007', 0, ()=>{
      let scannerId : string = "";
      let value : ScanOptionValue = {
        valueType : 3,
        valueSize : 0,
        strValue : 'Automatic Document Feeder',
      };
      Scan.setScanOption(scannerId, 6, value).then(()=>{
        ScanLog.info('getProgress scan successful')
      }).catch(() => {
        ScanLog.warn('getProgress scan error')
      })
    });
    it('ScanTest_008', 0, ()=>{
      let scannerId : string = "";
      Scan.getScanOption(scannerId, 0 ,1, 4).then(() => {
      }).catch(() => {
        ScanLog.warn('scan getScanOption error');
      })
    });
    it('ScanTest_009', 0, ()=>{
      Scan.on('scanDeviceFound', (device: ScannerDevice | string) => {
        ScanLog.info('scanner info : ' + JSON.stringify(device));
      })
      Scan.getScannerList().then(() => {
        ScanLog.info('scan getScannerList successful');
      }).catch(() => {
        ScanLog.warn('scan getScannerList error')
      })
    });
    it('ScanTest_010', 0, ()=>{
      let scannerId : string = "";
      Scan.getScanOptionDesc(scannerId, 0).then(() => {
        ScanLog.info('scan getScanOptionDesc successful');
      }).catch(() => {
        ScanLog.warn('scan getScanOptionDesc error')
      })
    });
  })
}