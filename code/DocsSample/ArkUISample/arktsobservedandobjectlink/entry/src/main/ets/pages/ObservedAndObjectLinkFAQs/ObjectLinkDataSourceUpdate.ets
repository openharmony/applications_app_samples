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
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0001;
const TAG = 'arktsobservedandobjectlink';
// [Start ObjectLink_Data_source_update_timing]
@Observed
class ObjectLinkDataSourceUpdatePerson {
 public name: string = '';
 // The age attribute, initialized to 0
 public age: number = 0;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  };
};

@Observed
class ObjectLinkDataSourceUpdateInfo {
  public person: ObjectLinkDataSourceUpdatePerson;

  constructor(person: ObjectLinkDataSourceUpdatePerson) {
    this.person = person;
  };
};

@Entry
@Component
struct ObjectLinkDataSourceUpdateParent {
  @State @Watch('onChange01') info: ObjectLinkDataSourceUpdateInfo =
    new ObjectLinkDataSourceUpdateInfo(
      new ObjectLinkDataSourceUpdatePerson('Bob', 10)
    );
  onChange01() {
    hilog.info(DOMAIN,TAG,`:::onChange01: + ${this.info.person.name}`); // 2
  };

  build() {
    Column() {
      Text(this.info.person.name).height(40)
      ObjectLinkDataSourceUpdateChild({
        per: this.info.person, clickEvent: () => {
          hilog.info(DOMAIN,TAG,`:::clickEvent before ${this.info.person.name}`); // 1
          this.info.person = new ObjectLinkDataSourceUpdatePerson('Jack', 12);
          hilog.info(DOMAIN,TAG,`:::clickEvent after ${this.info.person.name}`); // 3
        }
      });
    }
  }
}

@Component
struct ObjectLinkDataSourceUpdateChild {
  @ObjectLink @Watch('onChange02') per: ObjectLinkDataSourceUpdatePerson;
  clickEvent?: () => void;
  // [StartExclude Data_Source_Update_Parent_Context]
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // [EndExclude Data_Source_Update_Parent_Context]
  onChange02() {
    hilog.info(DOMAIN,TAG,`:::onChange02:${this.per.name}`); // 5
  };

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
    // $r('app.string.ObjectLinkDataSourceUpdate_Child')需要替换为开发者所需的资源文件
    hilog.info(DOMAIN,TAG,`:::--------${this.context.resourceManager.getStringSync($r('app.string.ObjectLinkDataSourceUpdate_Child').id)}: ${this.per.name}`); // 4
  };
}
// [End ObjectLink_Data_source_update_timing]