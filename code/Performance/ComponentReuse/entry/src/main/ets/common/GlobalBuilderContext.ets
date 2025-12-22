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

import { wrappedBuilderPageListSlideToHistory } from '../view/reducenestedlevels/PageListSlideToHistory';
import {
  wrappedBuilderPageListSlideToHistoryNegative
} from '../view/reducenestedlevels/PageListSlideToHistoryNegative';
import { wrappedBuilderUpdaterComponent } from '../view/preciseupdate/UpdaterComponent';
import { wrappedBuilderUpdaterComponentNoModifier } from '../view/preciseupdate/UpdaterComponentNoModifier';
import { wrappedBuilderWithFuncParam } from '../view/avoidusefunction/WithFuncParam';
import { wrappedBuilderWithReuseId } from '../view/usereuseid/WithReuseId';
import { Constants } from './Constants';
import { wrappedBuilderWithoutReuseId } from '../view/usereuseid/WithoutReuseId';
import { wrappedBuilderWithoutFuncParam } from '../view/avoidusefunction/WithoutFuncParam';
import { wrappedBuilderUsePropInReuse } from '../view/preciseupdate/UsePropInReuse';
import {
  wrappedBuilderUpdateStateVariableInAboutToReuse
} from '../view/preciseupdate/UpdateStateVariableInAboutToReuse';

export class GlobalBuilderContext {
  private static instance: GlobalBuilderContext;
  private objects = new Map<string, Object>();

  public static getContext(): GlobalBuilderContext {
    if (!GlobalBuilderContext.instance) {
      GlobalBuilderContext.instance = new GlobalBuilderContext();
      GlobalBuilderContext.instance.setObject(Constants.NAV_DESTINATION_ITEM_0, wrappedBuilderPageListSlideToHistory);
      GlobalBuilderContext.instance.setObject(Constants.NAV_DESTINATION_ITEM_0_1,
        wrappedBuilderPageListSlideToHistoryNegative);
      GlobalBuilderContext.instance.setObject(Constants.NAV_DESTINATION_ITEM_1, wrappedBuilderUpdaterComponent);
      GlobalBuilderContext.instance.setObject(Constants.NAV_DESTINATION_ITEM_1_1,
        wrappedBuilderUpdaterComponentNoModifier);
      GlobalBuilderContext.instance.setObject(Constants.NAV_DESTINATION_ITEM_1_2, wrappedBuilderUsePropInReuse);
      GlobalBuilderContext.instance.setObject(Constants.NAV_DESTINATION_ITEM_1_3,
        wrappedBuilderUpdateStateVariableInAboutToReuse);
      GlobalBuilderContext.instance.setObject(Constants.NAV_DESTINATION_ITEM_2, wrappedBuilderWithReuseId);
      GlobalBuilderContext.instance.setObject(Constants.NAV_DESTINATION_ITEM_2_1, wrappedBuilderWithoutReuseId);
      GlobalBuilderContext.instance.setObject(Constants.NAV_DESTINATION_ITEM_3, wrappedBuilderWithoutFuncParam);
      GlobalBuilderContext.instance.setObject(Constants.NAV_DESTINATION_ITEM_3_1, wrappedBuilderWithFuncParam);
    }
    return GlobalBuilderContext.instance;
  }

  getObject(key: string): Object | undefined {
    return this.objects.get(key);
  }

  setObject(key: string, objectClass: Object): void {
    this.objects.set(key, objectClass);
  }
}