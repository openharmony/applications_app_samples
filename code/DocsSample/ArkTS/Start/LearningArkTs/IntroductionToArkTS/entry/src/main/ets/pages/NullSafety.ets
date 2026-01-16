/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start nullSafety_variable_definition]
let x: number | null = null;
x = 1;    // ok
x = null; // ok
if (x != null) { /* do something */ }
// [End nullSafety_variable_definition]
{
  // [Start nullSafety_ternary]
  class Person {
    // ...
    public nick: string | null = null;
    getNick(): string {
      return this.nick ?? '';
    }
  }
  // [End nullSafety_ternary]
}

{
  // [Start nullSafety_optionalChain_null]
  class Person {
    public nick: string | null = null;
    public spouse?: Person

    setSpouse(spouse: Person): void {
      this.spouse = spouse;
    }

    getSpouseNick(): string | null | undefined {
      return this.spouse?.nick;
    }

    constructor(nick: string) {
      this.nick = nick;
      this.spouse = undefined;
    }
  }
  // [End nullSafety_optionalChain_null]
}

{
  // [Start nullSafety_optionalChain]
  class Person {
    public nick: string | null = null;
    public spouse?: Person;

    constructor(nick: string) {
      this.nick = nick;
      this.spouse = undefined;
    }
  }

  let p: Person = new Person('Alice');
  p.spouse?.nick; // undefined
  // [End nullSafety_optionalChain]
}
