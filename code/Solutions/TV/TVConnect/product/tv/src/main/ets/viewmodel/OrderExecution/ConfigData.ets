/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
export class ConfigData {
  public WH_100_100 = '100%';
  public WH_25_100 = '25%';
  public WH_30_100 = '30%';
  public WH_33_100 = '33%';
  public WH_35_100 = '35%';
  public WH_40_100 = '40%';
  public WH_45_100 = '45%';
  public WH_50_100 = '50%';
  public WH_55_100 = '55%';
  public WH_83_100 = '83%';
  public WH_90_100 = '90%';
}

let configData = new ConfigData();

export default configData as ConfigData;


export interface PatientData {
  patientId: string;
  patientName: string;
  bedName: string;
  sex: string;
  illnessStatus: string;
  patientAge: string;
  // 添加其他必要的字段
}

export interface ResultObject {
  status: number;
  desc: string;
  data: PatientData[];
  traceId?: string;
  transparent?: number;
  success?: boolean;
}

export class Patient {
  constructor(patientId: string, patientName: string, bedName: string, sex: string, illnessStatus: string,
    patientAge: string) {
    this.patientId = patientId;
    this.patientName = patientName;
    this.bedName = bedName;
    this.sex = sex;
    this.illnessStatus = illnessStatus;
    this.patientAge = patientAge;
  }

  public patientId: string = '';
  public patientName: string = '';
  public bedName: string = '';
  public sex: string = '';
  public illnessStatus: string = '';
  public patientAge: string = '';

  public static fromJSON(json: PatientData): Patient {
    return new Patient(
      json.patientId,
      json.patientName,
      json.bedName,
      json.sex,
      json.illnessStatus,
      json.patientAge,
    );
  }
}