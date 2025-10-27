/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

export class InputParams{
  public stateOfE0: boolean = false;
  public stateOfE1: boolean = false;
  public stateOfE2: boolean = false;
  public stateOfE3: boolean = false;
  public stateOfE4: boolean = false;
  public stateOfE5: boolean = false;
  public stateOfE6: boolean = false;
  public stateOfE7: boolean = false;
  public data: string = '';
  public freshUI: boolean = true;

  setValue(inputParams: InputParams) {
    this.stateOfE0 = inputParams.stateOfE0;
    this.stateOfE1 = inputParams.stateOfE1;
    this.stateOfE2 = inputParams.stateOfE2;
    this.stateOfE3 = inputParams.stateOfE3;
    this.stateOfE4 = inputParams.stateOfE4;
    this.stateOfE5 = inputParams.stateOfE5;
    this.stateOfE6 = inputParams.stateOfE6;
    this.stateOfE7 = inputParams.stateOfE7;
    this.data = inputParams.data;
    this.freshUI = inputParams.freshUI;
  }
}

export class OutputParams{
  public numLock: boolean = false;
  public capsLock: boolean = false;
  public scrollLock: boolean = false;
  public compose: boolean = false;

  setValue(outputParams: OutputParams) {
    this.numLock = outputParams.numLock;
    this.capsLock = outputParams.capsLock;
    this.scrollLock = outputParams.scrollLock;
    this.compose = outputParams.compose;
  }
}
