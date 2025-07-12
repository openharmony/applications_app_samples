/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { NewView } from '../common/NewView';
import { TitleBar } from '../common/TitleWithBack';
import { NewsContentItem, getNew, RouteParams } from '../model/New';

@Entry
@Component
struct New {
  private newId: number = 0;
  private title: Resource | string = $r('app.string.default_title');

  @State currentNew: NewsContentItem | undefined = undefined;

  aboutToAppear() {
    this.currentNew = getNew(this.newId) as NewsContentItem;
    const params = router.getParams() as RouteParams;
    this.newId = Number(params.newId);
    this.title = params.title;
  }

  build() {
    Column() {
      TitleBar({ title: this.title })
      NewView({ currentNew: $currentNew })
    }
    .width('100%')
    .height('100%')
  }
}