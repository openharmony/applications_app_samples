/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { describe, it, expect } from '@ohos/hypium'
import hilog from '@ohos.hilog';
import { Driver, ON } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'

const TAG = '[Sample_rawfile]'
const DOMAIN = 0xF811
const BUNDLE = 'NdkRawfile_'
const abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator()

export default function IndexTest() {
  describe('IndexTest', () => {
    it(BUNDLE + 'StartAbility_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'StartAbility_001 begin')
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'com.samples.ndkrawfile',
          abilityName: 'EntryAbility'
        })
      } catch (err) {
        hilog.info(DOMAIN, TAG, `StartAbility end ${JSON.stringify(err)}`)
        expect().assertFail()
      }
      hilog.info(DOMAIN, TAG, 'StartAbility_001 end')
    })

    it(BUNDLE + 'GetFileListTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFileListTest begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      let text = await driver.findComponent(ON.id('raw_file_list'))
      expect(await text.getText() === 'file list: ["rawfile.txt","rawfile1.txt","subrawfile"]').assertTrue()
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFileListTest end')
      done()
    })

    it(BUNDLE + 'GetRawFileContentTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileContentTest begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      let text = await driver.findComponent(ON.id('raw_file_content'))
      expect(await text.getText() === 'rawfile.txt content: rawfile1 content').assertTrue()
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileContentTest end')
      done()
    })

    it(BUNDLE + 'GetRawFileContentOffsetTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileContentOffsetTest begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      let text = await driver.findComponent(ON.id('raw_file_content_offset'))
      expect(await text.getText() === 'rawfile.txt content with offset: file1 content').assertTrue()
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileContentOffsetTest end')
      done()
    })

    it(BUNDLE + 'GetRawfileDescriptorTest', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawfileDescriptorTest begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      let text = await driver.findComponent(ON.id('raw_file_fd_length'))
      expect(await text.getText() === 'rawfile.txt fd.length: 16').assertTrue()
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawfileDescriptorTest end')
      done()
    })

    it(BUNDLE + 'GetRawFileContent64Test', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileContent64Test begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      let text = await driver.findComponent(ON.id('raw_file_content64'))
      expect(await text.getText() === 'rawfile.txt content64: rawfile content for 64').assertTrue()
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileContent64Test end')
      done()
    })

    it(BUNDLE + 'GetRawFileContentOffset64Test', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileContentOffset64Test begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      let text = await driver.findComponent(ON.id('raw_file_content_offset64'))
      expect(await text.getText() === 'rawfile.txt content with offset64: content for 64').assertTrue()
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileContentOffset64Test end')
      done()
    })

    it(BUNDLE + 'GetRawfileDescriptor64Test', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawfileDescriptor64Test begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      let text = await driver.findComponent(ON.id('raw_file_fd_length64'))
      expect(await text.getText() === 'rawfile.txt fd.length64: 22').assertTrue()
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawfileDescriptor64Test end')
      done()
    })

  })
}