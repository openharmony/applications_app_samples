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
 
import { AppItemInfo as CommonAppItemInfo } from '@ohos/common/src/main/ets/default/bean/AppItemInfo';

/**
 * common app info
 */
@Observed
export class AppItemInfo {
  /**
   * Indicates app id.
   */
  public appId: string | undefined;
  /**
   * Indicates app name.
   */
  public appName: string | undefined;
  /**
   * Indicates appIconId.
   */
  public appIconId: number | undefined;
  /**
   * Indicates appLabelId.
   */
  public appLabelId: string | number | undefined;
  /**
   * Indicates bundleName.
   */
  public bundleName: string | undefined;
  /**
   * Indicates abilityName.
   */
  public abilityName: string | undefined;
  /**
   * Indicates is system App.
   */
  public isSystemApp: boolean | undefined;
  /**
   * Indicates is uninstallAble.
   */
  public isUninstallAble: boolean | undefined;
  /**
   * badge number
   */
  public badgeNumber: number | undefined;
  public checked: boolean | undefined;
  public installTime: string | undefined;
  public moduleName: string | undefined;
  public keyName: string | undefined;
  /**
   * GridLayoutItemInfo: type  0:app  1:card  3:bigFolder
   */
  public typeId: number | undefined;
  /**
   * GridLayoutItemInfo: area
   */
  public area: number[] | undefined;
  /**
   * GridLayoutItemInfo: page
   */
  public page: number | undefined;
  /**
   * GridLayoutItemInfo: column of positions
   */
  public column: number | undefined;
  /**
   * GridLayoutItemInfo: row of positions
   */
  public row: number | undefined;
  public icon: string | undefined;
  public onFocusIcon: string | undefined;
  public isFocus: boolean | undefined;
  public useSelfIcon: boolean = false
  /**
   * can remove shortCuts,default is true
   */
  public canRemove: boolean = true;
  public canMove: boolean = true;
  public uniKey: string | undefined;

  public cover(commonApp: CommonAppItemInfo) {
    this.appId = commonApp.appId
    this.appName = commonApp.appName
    this.appIconId = commonApp.appIconId
    this.bundleName = commonApp.bundleName
    this.abilityName = commonApp.abilityName
    this.moduleName = commonApp.moduleName
  }
}