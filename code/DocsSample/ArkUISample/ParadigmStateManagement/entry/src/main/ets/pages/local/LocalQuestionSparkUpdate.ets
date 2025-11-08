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
// [Start Local_Question_Spark_Update]
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@ComponentV2
struct Index {
  list: string[][] = [['a'], ['b'], ['c']];
  @Local dataObjFromList: string[] = this.list[0];

  @Monitor('dataObjFromList')
  onStrChange(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', 'dataObjFromList has changed');
  }

  build() {
    Column() {
      Button('change to self').onClick(() => {
        // 新值和本地初始化的值相同
        this.dataObjFromList = this.list[0];
      })
    }
  }
}
// [End Local_Question_Spark_Update]
@Component
export struct LocalQuestionSparkUpdate {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.local_question_spark_update'))
  }
}
