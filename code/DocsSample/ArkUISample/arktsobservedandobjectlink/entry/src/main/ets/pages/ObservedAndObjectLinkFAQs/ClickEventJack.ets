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
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0001;
const TAG = 'arktsobservedandobjectlink';
@Observed
class Person {
 public name: string = '';
 public age: number = 0;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  };
};

@Observed
class ClickEventJackInfo {
 public person: Person;

  constructor(person: Person) {
    this.person = person;
  };
};

@Entry
@Component
struct Parent {
  @State @Watch('onChange01') info: ClickEventJackInfo = new ClickEventJackInfo(new Person('Bob', 10));

  onChange01() {
    hilog.info(DOMAIN,TAG,`:::onChange01: + ${this.info.person.name}`); // 2
  };

  build() {
    Column() {
      Text(this.info.person.name).height(40)
      // [Start ClickEvent_Jack]
      ClickEventJackChild({
        per: this.info.person, clickEvent: () => {
          hilog.info(DOMAIN,TAG,`:::clickEvent before ${this.info.person.name}`); // 1
          this.info.person.name = 'Jack';
          hilog.info(DOMAIN,TAG,`:::clickEvent after ${this.info.person.name}`); // 3
        }
      });
      // [End ClickEvent_Jack]
    }
  }
}

@Component
struct ClickEventJackChild {
  @ObjectLink @Watch('onChange02') per: Person;
  clickEvent?: () => void;

  onChange02() {
    hilog.info(DOMAIN,TAG,`:::onChange02:${this.per.name}`); // 5
  }

  build() {
    Column() {
      Button(this.per.name)
        .height(40)
        .onClick(() => {
          this.onClickType();
        });
    }
  }

  private onClickType() {
    if (this.clickEvent) {
      this.clickEvent();
    };
  };
}