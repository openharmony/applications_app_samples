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


import { Payload } from './Payload';

export class PayloadControllerTest extends Payload {
  public setType: string = 'control';
  public devSum: number = 1;
  public devArray: Array<SNDevice> = [new SNDevice()];
}

class SNDevice {
  public sn: string = '6794';
  public result: number = 21;
}