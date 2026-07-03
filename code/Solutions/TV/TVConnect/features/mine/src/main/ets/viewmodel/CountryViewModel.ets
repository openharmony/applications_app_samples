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
import { InternationalManager } from '../model/manager/InternationalManager';
import { Country } from '../model/entity/Country';
import appRecovery from '@ohos.app.ability.appRecovery';

/**
 * 地区组件信息
 */
@Observed
export class CountryComponentInfo {
  public countryList: CountryItemInfo[] = []; // 所有国家
  public newSelectedCountryList: CountryItemInfo[] = []; // 页面选择的国家
  public oldSelectedCountryList: CountryItemInfo[] = []; // 数据库中存储的国家
}

/**
 * 某地区项信息
 */
@Observed
export class CountryItemInfo {
  public country: Country;
  public isSelected: boolean = false;

  constructor(country: Country) {
    this.country = country;
  }

  showFunc(isShow: boolean) { // 点击展示效果
    this.isSelected = isShow;
  }

  async handleFunc() { // 点击执行
    let internationalManager: InternationalManager = await InternationalManager.getInstance();
    await internationalManager.setCurrentCountry(this.country); // 设置当前国家并持久化
    appRecovery.restartApp(); // 重启app
  }
}

/**
 * 获取地区组件信息
 */
export async function getCountryComponentInfo(): Promise<CountryComponentInfo> {
  let countryList: CountryItemInfo[] = [];
  let internationalManager: InternationalManager = await InternationalManager.getInstance();
  for (let i of internationalManager.getCountryList()) {
    countryList.push(new CountryItemInfo(i));
  }
  let old = new CountryItemInfo(internationalManager.getCurrentCountry());
  old.isSelected = true;
  let info = {
    countryList: countryList, oldSelectedCountryList: [old], newSelectedCountryList: [],
  } as CountryComponentInfo;
  return info;
}