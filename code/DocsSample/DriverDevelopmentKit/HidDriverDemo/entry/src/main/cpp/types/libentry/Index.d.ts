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

declare namespace hidNapi {
  type keyStates = {
    states: boolean[];
    keys: string;
  };

  function hidInit(deviceId: number):number;
  function getRawInfo():string;
  function getRawName():string;
  function getPhysicalAddress():string;
  function getRawUniqueId():string;
  function getKeyboardState():keyStates;
  function readKeyboardState(nonblock: boolean):keyStates;
  function applyKeyboardSettings(states: boolean[]):number;
  function writeKeyboardSettings(states: boolean[]):number;
  function getKeyboardFeatures():string;
  function applyKeyboardFeatures(features: string):number;
  function getReportDescriptor():string;
  function releaseResource():number;
}

export default hidNapi;