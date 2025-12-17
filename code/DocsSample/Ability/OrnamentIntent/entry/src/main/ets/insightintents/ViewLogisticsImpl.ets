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

// [Start insight_intent_view_logistics]
import { InsightIntentEntryExecutor, insightIntent, InsightIntentEntry } from '@kit.AbilityKit';

class ViewLogisticsResultDef {
  public msg?: string = '';
}

@InsightIntentEntry({
  intentName: 'ViewLogistics',
  domain: 'LocalDomain',
  intentVersion: '1.0.1',
  displayName: '查询快递',
  displayDescription: '根据快递单号查询快递信息',
  schema: 'ViewLogistics',
  icon: $r('app.media.viewLogistics'), // 请将$r('app.media.viewLogistics')替换为实际资源文件
  abilityName: 'EntryAbility',
  executeMode: [insightIntent.ExecuteMode.UI_ABILITY_BACKGROUND]
})
export default class ViewLogisticsImpl extends InsightIntentEntryExecutor<ViewLogisticsResultDef> {
  public trackingNo?: string = '';
  public entityId?: string = '';

  onExecute(): Promise<insightIntent.IntentResult<ViewLogisticsResultDef>> {
    // 执行查询快递逻辑
    let result: insightIntent.IntentResult<ViewLogisticsResultDef> = {
      code: 0,
      result: {
        msg: 'the logistics is being delivered'
      }
    };
    return Promise.resolve(result);
  };
}
// [End insight_intent_view_logistics]