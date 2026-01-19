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
// [Start no_extendSameProp]
class MoveStatus {
  public speed: number;
  constructor() {
    this.speed = 0;
  }
}
interface Mover {
  getMoveStatus(): MoveStatus
}

class ShakeStatus {
  public frequency: number;
  constructor() {
    this.frequency = 0;
  }
}
interface Shaker {
  getShakeStatus(): ShakeStatus
}

class MoveAndShakeStatus {
  public speed: number;
  public frequency: number;
  constructor() {
    this.speed = 0;
    this.frequency = 0;
  }
}

class C implements Mover, Shaker {
  private moveStatus: MoveStatus;
  private shakeStatus: ShakeStatus;

  constructor() {
    this.moveStatus = new MoveStatus();
    this.shakeStatus = new ShakeStatus();
  }

  public getMoveStatus(): MoveStatus {
    return this.moveStatus;
  }

  public getShakeStatus(): ShakeStatus {
    return this.shakeStatus;
  }

  public getStatus(): MoveAndShakeStatus {
    return {
      speed: this.moveStatus.speed,
      frequency: this.shakeStatus.frequency
    };
  }
}
// [End no_extendSameProp]
