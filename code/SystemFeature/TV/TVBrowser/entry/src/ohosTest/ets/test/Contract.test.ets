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

import { describe, it, expect } from '@ohos/hypium';
import { webview } from '@kit.ArkWeb';
import { Browser, HOME_TITLE, LoadingStatus, WebKey } from '../../../main/ets/model/Browser';
import { TestData } from './TestConstants';

function createWebKey(uuid: string, title: string, url: ResourceStr, isRegister: boolean): WebKey {
  return new WebKey(uuid, title, url, new webview.WebviewController(uuid), isRegister);
}

export default function contractTest(): void {
  describe('Browser_Contract_Test', () => {
    it('home_title_contract_should_match_expected_value', 0, () => {
      expect(HOME_TITLE).assertEqual(TestData.DEFAULT_TAB_TITLE);
    });

    it('browser_constructor_should_create_default_tab', 0, () => {
      const browser: Browser = new Browser();
      expect(browser.webArray.length).assertEqual(1);
      expect(browser.currentTabIndex).assertEqual(0);
      expect(browser.webArray[0].webTitle).assertEqual(HOME_TITLE);
    });

    it('clean_url_should_remove_protocol_and_lowercase', 0, () => {
      const browser: Browser = new Browser();
      const cleaned: string = browser.cleanUrl('HTTPS://WWW.Example.COM/Path');
      expect(cleaned.includes('www.example.com/path')).assertTrue();
    });

    it('set_input_value_should_update_browser_state', 0, () => {
      const browser: Browser = new Browser();
      browser.setInputVal('www.huawei.com');
      expect(browser.inputValue).assertEqual('www.huawei.com');
    });

    it('loading_status_contract_should_remain_stable', 0, () => {
      expect(LoadingStatus.LOADING).assertEqual(0);
      expect(LoadingStatus.END).assertEqual(1);
    });

    it('webkey_should_hold_constructor_fields', 0, () => {
      const webKey: WebKey = createWebKey('unit-1', '标题', 'https://www.example.com', true);
      expect(webKey.uuid).assertEqual('unit-1');
      expect(webKey.webTitle).assertEqual('标题');
      expect(webKey.isRegister).assertTrue();
    });

    it('add_tab_should_move_current_index_to_last', 0, () => {
      const browser: Browser = new Browser();
      browser.addTab();
      browser.addTab();
      expect(browser.webArray.length).assertEqual(3);
      expect(browser.currentTabIndex).assertEqual(2);
    });

    it('delete_current_tab_should_keep_index_in_valid_range', 0, () => {
      const browser: Browser = new Browser();
      browser.addTab();
      browser.addTab();
      browser.setCurrentTabIndex(2);
      browser.deleteTabByClick(2);
      expect(browser.webArray.length).assertEqual(2);
      expect(browser.currentTabIndex).assertLargerOrEqual(0);
      expect(browser.currentTabIndex).assertLessOrEqual(1);
    });
  });
}
