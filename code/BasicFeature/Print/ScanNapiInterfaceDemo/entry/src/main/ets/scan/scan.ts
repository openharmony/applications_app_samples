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

// @ts-ignore
import scan from '@ohos.scan'
import { BusinessError} from '@kit.BasicServicesKit';
import { ScanLog } from './log';

export interface ScannerDevice {
  deviceId : string,
  manufacturer :string,
  deviceType : string,
  deviceState : string,
  discoverMode : string,
  serialNumber : string,
  address : string,
  deviceName : string,
}

export interface ScanProgress {
  progress : number,
  pictureFd :number,
  isFinal : boolean,
}

export interface ScanOptionValue {
  valueType:number,
  valueSize:number,
  numValue?:number,
  numListValue?:Array<number>,
  strValue?:string,
  boolValue?:boolean,
}

export enum  ScanOptionValueType {
  SCAN_VALUE_NONE,
  SCAN_VALUE_NUM,
  SCAN_VALUE_NUM_LIST,
  SCAN_VALUE_STR,
  SCAN_VALUE_BOOL,
}

export class Scan {
  static initScan():Promise<number>{
    return new Promise<number>((resolve,reject)=>{
      scan.initScan().then((data:number)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
  static exitScan():Promise<number>{
    return new Promise<number>((resolve,reject)=>{
      scan.exitScan().then((data:number)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
  static openScanner(scannerId:string):Promise<number>{
    return new Promise<number>((resolve,reject)=>{
      scan.openScanner(scannerId).then((data:number)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
  static closeScanner(scannerId:string):Promise<number>{
    return new Promise<number>((resolve,reject)=>{
      scan.closeScanner(scannerId).then((data:number)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
  static startScan(scannerId:string, isBatch:boolean):Promise<number>{
    return new Promise<number>((resolve,reject)=>{
      scan.startScan(scannerId, isBatch).then((data:number)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
  static getScannerList():Promise<boolean>{
    return new Promise<boolean>((resolve,reject)=>{
      scan.getScannerList().then((data:boolean)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
  static on(type:string, callBackRef):void{
    try {
      scan.on(type, callBackRef);
    } catch (error) {
      ScanLog.warn('scan on error');
    }
  }
  static cancelScan(scannerId :string):Promise<boolean>{
    return new Promise<boolean>((resolve,reject)=>{
      scan.cancelScan(scannerId).then((data:boolean)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
  static getProgress(scannerId :string):Promise<ScanProgress> {
    return new Promise<ScanProgress>((resolve,reject)=>{
      scan.getScanProgress(scannerId).then((data:ScanProgress)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
  static setScanOption(scannerId :string, optionIndex : number, optionValue : ScanOptionValue):Promise<boolean> {
    return new Promise<boolean>((resolve,reject)=>{
      scan.setScanOption(scannerId, optionIndex, optionValue).then((data:boolean)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
  static getScanOption(scannerId :string, optionIndex : number, optionValueType : ScanOptionValueType, valueSize : number):Promise<boolean> {
    return new Promise<boolean>((resolve,reject)=>{
      scan.getScanOption(scannerId, optionIndex, optionValueType, valueSize).then((data)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
  static getScanOptionDesc(scannerId :string, optionIndex : number):Promise<boolean> {
    return new Promise<boolean>((resolve,reject)=>{
      scan.getScanOptionDesc(scannerId, optionIndex).then((data)=>{
        resolve(data);
      }).catch((error:BusinessError)=>{
        reject(error);
      })
    });
  }
}
