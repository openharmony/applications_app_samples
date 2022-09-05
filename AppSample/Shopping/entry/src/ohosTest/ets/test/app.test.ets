/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Shopping]'
const DOMAIN = 0xF811
const BUNDLE = 'Shopping_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.sample.shopping",
          abilityName: "ohos.sample.shopping.MainAbility"
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击切换模块内容
     */

    it(BUNDLE + 'ClickSwitchModuleFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 clickClassification')
      // 点击分类
      await driver.assertComponentExist(BY.text('分类'))
      let classification = await driver.findComponent(BY.text('分类'))
      await classification.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 clickMessage')
      // 点击消息
      await driver.assertComponentExist(BY.text('消息')
      let message = await driver.findComponent(BY.text('消息')
      await message.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 clickCart')
      // 点击购物车
      await driver.assertComponentExist(BY.text('购物车')
      let cart = await driver.findComponent(BY.text('购物车')
      await cart.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 clickMine')
      // 点击我的
      await driver.assertComponentExist(BY.text('我的')
      let mine = await driver.findComponent(BY.text('我的')
      await mine.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 clickHomePage')
      // 点击首页
      await driver.assertComponentExist(BY.text('首页')
      let homePage = await driver.findComponent(BY.text('首页')
      await homePage.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSwitchModuleFunction_001 end')
    })
    /**
     * 点击搜搜跳转至搜索页
     */
    it(BUNDLE + 'ClickSearchFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 clickSearchInput')
      // 点击搜索框
      await driver.assertComponentExist(BY.key('searchInput'))
      let searchInput = await driver.findComponent(BY.key('searchInput'))
      await searchInput.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 clickIsShowBtn')
      // 点击控制显隐按钮隐藏搜索发现
      await driver.assertComponentExist(BY.key('isShowBtn'))
      let isShowBtn = await driver.findComponent(BY.key('isShowBtn'))
      await isShowBtn.click()
      await driver.delayMs(1000)
      // 再次点击显示搜索发现
      await isShowBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 clickIsOpenHotSearch')
      // 点击控制是否开启全网热搜
      await driver.assertComponentExist(BY.key('isOpenHotSearch'))
      let isOpenHotSearch = await driver.findComponent(BY.key('isOpenHotSearch'))
      await isOpenHotSearch.click()
      await driver.delayMs(1000)
      // 再次点击显示List组件
      await isOpenHotSearch.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 clickLeftSearchPageBtn')
      // 点击返回
      await driver.assertComponentExist(BY.key('leftSearchPageBtn'))
      let leftSearchPage = await driver.findComponent(BY.key('leftSearchPageBtn'))
      await leftSearchPage.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 end')
    })
    /**
     * 点击轮播图进入详情页图片
     */
    it(BUNDLE + 'ClickCarouselFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCarouselFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCarouselFunction_001 clickCarousel')
      // 点击轮播图片
      await driver.assertComponentExist(BY.key('carousel'))
      let carousel = await driver.findComponent(BY.key('carousel'))
      await carousel.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCarouselFunction_001 clickLeftDetailPageBtn')
      // 点击返回
      await driver.assertComponentExist(BY.key('leftDetailPageBtn'))
      let leftDetailPage = await driver.findComponent(BY.key('leftDetailPageBtn'))
      await leftDetailPage.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCarouselFunction_001 end')
    })
    /**
     * 点击收藏跳转至收藏页，展示布局和Tabs组件切换
     */
    it(BUNDLE + 'ClickCollectFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCollectFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCollectFunction_001 clickMine')
      // 点击我的
      await driver.assertComponentExist(BY.text('我的'))
      let mine = await driver.findComponent(BY.text('我的'))
      await mine.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCollectFunction_001 clickCollect')
      // 点击收藏
      await driver.assertComponentExist(BY.text('收藏'))
      let collect = await driver.findComponent(BY.text('收藏'))
      await collect.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCollectFunction_001 clickChangeLayoutBtn')
      // 点击布局切换按钮
      await driver.assertComponentExist(BY.key('changeLayoutBtn'))
      let changeLayout = await driver.findComponent(BY.key('changeLayoutBtn'))
      await changeLayout.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCollectFunction_001 clickChangeLayoutBtn')
      // 点击图文
      await driver.assertComponentExist(BY.text('图文'))
      let imageAndText = await driver.findComponent(BY.text('图文'))
      await imageAndText.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCollectFunction_001 clickVideo')
      // 点击视频
      await driver.assertComponentExist(BY.text('视频'))
      let video = await driver.findComponent(BY.text('视频'))
      await video.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCollectFunction_001 clickTopic')
      // 点击话题
      await driver.assertComponentExist(BY.text('话题'))
      let topic = await driver.findComponent(BY.text('话题'))
      await topic.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCollectFunction_001 clickDetailList')
      // 点击清单
      await driver.assertComponentExist(BY.text('清单'))
      let detailList = await driver.findComponent(BY.text('清单'))
      await detailList.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCollectFunction_001 end')
    })
  })
}