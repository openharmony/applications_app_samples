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

import prompt from '@ohos.prompt'
import router from '@ohos.router'
import {
  AppItemInfo,
  CheckEmptyUtils,
  EventConstants,
  CommonConstants,
  GridLayoutItemInfo,
  FormManager,
  FormModel,
  Logger,
  LauncherAbilityManager,
  MenuInfo,
  RdbManager,
  ResourceManager
} from '@ohos/base'

const TAG: string = 'LayoutInfoModel'
const SYSTEM_APPLICATIONS: string = 'com.ohos.launcher,ohos.samples.launcher,com.ohos.systemui,com.ohos.devicemanagerui,com.ohos.callui,com.example.kikakeyboard,com.ohos.contactdataability,com.ohos.telephonydataability,com.ohos.medialibrary.MediaLibraryDataA,com.ohos.medialibrary.MediaScannerAbilityA'
const KEY_NAME = 'name'

export class DesktopLayoutModel {
  private static layoutInfoModel: DesktopLayoutModel = undefined
  private layoutInfo: Array<Array<GridLayoutItemInfo>> = []
  private readonly mSystemApplicationName = SYSTEM_APPLICATIONS.split(',')
  private mLauncherAbilityManager: LauncherAbilityManager = undefined
  private context: any = undefined

  constructor(context) {
    this.context = context
    this.mLauncherAbilityManager = LauncherAbilityManager.getInstance(context)
    this.mLauncherAbilityManager.registerLauncherAbilityChangeListener(this.appChangeListener)
  }

  appChangeListener = (event, bundleName: string, userId) => {
    Logger.info(TAG, `appChangeListener event = ${event},bundle = ${bundleName}`)
    FormModel.updateAppItemFormInfo(bundleName)
    if (event === EventConstants.EVENT_PACKAGE_REMOVED) {
      this.removeItemByBundle(bundleName)
    } else if (event === EventConstants.EVENT_PACKAGE_ADDED) {
      this.mLauncherAbilityManager.getAppInfoByBundleName(bundleName).then(appInfo => {
        Logger.debug(TAG, `appChangeListener EVENT_PACKAGE_ADDED,info = ${JSON.stringify(appInfo)}`)
        this.addAppToDesktop(appInfo, true)
      })
    }
  }


  /**
   * Get the application data model object.
   *
   * @return {object} application data model singleton
   */
  static getInstance(context): DesktopLayoutModel {
    if (this.layoutInfoModel == null || this.layoutInfoModel === undefined) {
      this.layoutInfoModel = new DesktopLayoutModel(context)
    }
    return this.layoutInfoModel
  }

  private removeItemByBundle(bundleName: string) {
    let page = this.layoutInfo.length
    for (let i = 0;i < page; i++) {
      for (let j = 0;j < this.layoutInfo[i].length; j++) {
        if (this.layoutInfo[i][j].bundleName === bundleName) {
          this.removeItemFromDeskTop(this.layoutInfo[i][j])
        }
      }
    }
  }

  /**
   * getAppItemFormInfo
   *
   * @param bundleName
   */
  getAppItemFormInfo(bundleName: string) {
    return FormModel.getAppItemFormInfo(bundleName)
  }

  /**
   * buildMenuInfoList
   *
   * @param appInfo: GridLayoutItemInfo
   */
  buildMenuInfoList(appInfo: GridLayoutItemInfo, dialog: any) {
    if (CheckEmptyUtils.isEmpty(appInfo)) {
      return undefined
    }
    let menuInfoList = new Array<MenuInfo>()
    let open = new MenuInfo()
    open.menuImgSrc = $r('app.media.ic_public_add_norm')
    open.menuText = $r('app.string.app_menu_open')
    open.onMenuClick = () => {
      this.jumpTo(appInfo.abilityName, appInfo.bundleName)
    }
    menuInfoList.push(open)

    Logger.info(TAG, `buildMenuInfoList getAppItemFormInfo,bundleName =  ${appInfo.bundleName}`)
    const formInfoList = FormModel.getAppItemFormInfo(appInfo.bundleName)
    Logger.info(TAG, `buildMenuInfoList formInfoList = ${JSON.stringify(formInfoList)}`)
    if (!CheckEmptyUtils.isEmptyArr(formInfoList)) {
      let addFormToDeskTopMenu = new MenuInfo()
      addFormToDeskTopMenu.menuImgSrc = $r('app.media.ic_public_app')
      addFormToDeskTopMenu.menuText = $r('app.string.add_form_to_desktop')
      addFormToDeskTopMenu.onMenuClick = () => {
        Logger.info(TAG, 'Launcher click menu item into add form to desktop view')
        if (!CheckEmptyUtils.isEmpty(appInfo)) {
          AppStorage.SetOrCreate('formAppInfo', appInfo)
          Logger.info(TAG, 'Launcher AppStorage.SetOrCreate formAppInfo')
          this.jumpToFormManagerView(appInfo)
        }
      }
      menuInfoList.push(addFormToDeskTopMenu)
    }

    const uninstallMenu = new MenuInfo()
    uninstallMenu.menuImgSrc = $r('app.media.ic_public_delete')
    uninstallMenu.menuText = $r('app.string.uninstall')
    uninstallMenu.onMenuClick = () => {
      Logger.info(TAG, 'Launcher click menu item uninstall')
      if (!CheckEmptyUtils.isEmpty(dialog)) {
        dialog.open()
      }
    }
    menuInfoList.push(uninstallMenu)
    return menuInfoList
  }

  /**
   * buildCardInfoList
   *
   * @param dialog
   */
  buildCardInfoList(dialog: any) {
    let menuInfoList = new Array<MenuInfo>()
    const uninstallMenu = new MenuInfo()
    uninstallMenu.menuImgSrc = $r('app.media.ic_public_delete')
    uninstallMenu.menuText = $r('app.string.remove')
    uninstallMenu.onMenuClick = () => {
      Logger.info(TAG, 'Launcher click menu item uninstall')
      if (!CheckEmptyUtils.isEmpty(dialog)) {
        dialog.open()
      }
    }
    menuInfoList.push(uninstallMenu)
    return menuInfoList
  }

  /**
   * getAppName
   *
   * @param cacheKey
   */
  getAppName(cacheKey: string) {
    return ResourceManager.getInstance(this.context).getAppResourceCache(cacheKey, KEY_NAME)
  }

  /**
   * jump to form manager
   * @param formInfo

   * */
  jumpToFormManagerView(formInfo: GridLayoutItemInfo) {
    router.push({
      url: 'pages/FormPage',
      params: {
        formInfo: formInfo
      }
    })
  }

  /**
   * Start target ability
   *
   * @param bundleName target bundle name
   * @param abilityName target ability name
   */
  jumpTo(abilityName: string, bundleName: string): void {
    this.mLauncherAbilityManager.startLauncherAbility(abilityName, bundleName)
  }

  /**
   * getLayoutInfoCache
   */
  getLayoutInfoCache() {
    return this.layoutInfo
  }

  /**
   * Get the list of apps displayed on the desktop (private function).
   *
   * @return {array} bundleInfoList, excluding system applications
   */
  async getAppListAsync(): Promise<AppItemInfo[]> {
    let allAbilityList: AppItemInfo[] = await this.mLauncherAbilityManager.getLauncherAbilityList()
    Logger.info(TAG, `getAppListAsync allAbilityList length: ${allAbilityList.length}`)
    let launcherAbilityList: AppItemInfo[] = []
    for (let i in allAbilityList) {
      if (this.mSystemApplicationName.indexOf(allAbilityList[i].bundleName) === CommonConstants.INVALID_VALUE) {
        launcherAbilityList.push(allAbilityList[i])
        FormModel.updateAppItemFormInfo(allAbilityList[i].bundleName)
      }
    }
    Logger.debug(TAG, `getAppListAsync launcherAbiltyList length: ${launcherAbilityList.length}`)
    return launcherAbilityList
  }

  /**
   * getLayoutInfo
   */
  async getLayoutInfo() {
    await RdbManager.initRdbConfig(this.context)
    let infos = await this.getAppListAsync()
    let gridLayoutItemInfos = await RdbManager.queryLayoutInfo()
    Logger.info(TAG, `queryLayoutInfo,gridLayoutItemInfos = ${gridLayoutItemInfos.length}`)
    let result: Array<Array<GridLayoutItemInfo>> = []
    let plusApps = []
    // 如果查询到的数据长度是0，说明之前没有过数据，此时初始化数据并插入
    if (gridLayoutItemInfos.length === 0) {
      let result = this.initPositionInfos(infos)
      await RdbManager.insertData(result)
      Logger.info(TAG, `getLayoutInfo result0,${JSON.stringify(result)}`)
      this.layoutInfo = result
      return result
    }
    // 数据库中查询到了数据，则优先加载数据库中的应用和卡片，剩余的应用图标在最后一个图标的位置后面添加
    else {
      for (let i = 0;i < infos.length; i++) {
        Logger.info(TAG, `getLayoutInfo infos,i = ${i}`)
        let find = false
        for (let j = 0;j < gridLayoutItemInfos.length; j++) {
          if (infos[i].bundleName === gridLayoutItemInfos[j].bundleName) {
            Logger.info(TAG, `getLayoutInfo find,j = ${j}`)
            if (gridLayoutItemInfos[j].page >= result.length) {
              result.push([])
            }
            result[gridLayoutItemInfos[j].page].push(gridLayoutItemInfos[j])
            find = true
          }
        }
        if (!find) {
          plusApps.push(infos[i])
        }
      }
      Logger.info(TAG, `getLayoutInfo result1,${JSON.stringify(result[0].length)}`)
      this.layoutInfo = result
      // 加载完数据库中的后，剩余的app
      if (plusApps.length > 0) {
        Logger.info(TAG, `加载完数据库中的后，剩余的app`)
        for (let k = 0;k < plusApps.length; k++) {
          let item = plusApps[k]
          if (item) {
            this.addAppToDesktop(item, false)
          }
        }
      }
      Logger.info(TAG, `getLayoutInfo result2,${JSON.stringify(result[0].length)}`)
      return this.layoutInfo
    }
  }

  private async addAppToDesktop(appInfo: AppItemInfo, isRefresh: boolean) {
    if (CheckEmptyUtils.isEmpty(appInfo)) {
      return
    }
    let pageInfos = this.layoutInfo
    for (let i = 0;i < pageInfos.length; i++) {
      Logger.info(TAG, `removeCardFromDeskTop pageInfos${i}`)
      for (let j = 0;j < pageInfos[i].length; j++) {
        if (pageInfos[i][j].bundleName === appInfo.bundleName && pageInfos[i][j].abilityName === appInfo.abilityName) {
          return
        }
      }
    }
    let gridItem: GridLayoutItemInfo = this.covertAppItemToGridItem(appInfo, 0, 0, 0)
    let page = this.layoutInfo.length
    gridItem = this.updateItemLayoutInfo(gridItem)
    if (gridItem.page >= page) {
      this.layoutInfo.push([])
    }
    this.layoutInfo[gridItem.page].push(gridItem)
    Logger.debug(TAG, `addAppToDesktop item ${JSON.stringify(gridItem)}`)
    await RdbManager.initRdbConfig(this.context)
    await RdbManager.insertItem(gridItem)
    if (isRefresh) {
      AppStorage.SetOrCreate('isRefresh', true)
    }
  }

  /**
   * uninstallAppItem
   *
   * @param itemInfo: GridLayoutItemInfo
   */
  async uninstallAppItem(itemInfo: GridLayoutItemInfo) {
    if (CheckEmptyUtils.isEmpty(itemInfo)) {
      return
    }
    let appInfo = await this.mLauncherAbilityManager.getAppInfoByBundleName(itemInfo.bundleName)
    if (CheckEmptyUtils.isEmpty(appInfo)) {
      return
    }
    if (appInfo.isUninstallAble) {
      this.mLauncherAbilityManager.uninstallLauncherAbility(itemInfo.bundleName, (result) => {
        if (result.code == CommonConstants.UNINSTALL_SUCCESS) {
        }
        this.informUninstallResult(result.code)
      })
    } else {
      this.informUninstallResult(CommonConstants.UNINSTALL_FORBID)
    }
  }

  private informUninstallResult(resultCode: number) {
    let uninstallMessage: string = ''
    if (resultCode === CommonConstants.UNINSTALL_FORBID) {
      uninstallMessage = this.context.resourceManager.getStringSync($r('app.string.disable_uninstall').id)
    } else if (resultCode === CommonConstants.UNINSTALL_SUCCESS) {
      uninstallMessage = this.context.resourceManager.getStringSync($r('app.string.uninstall_success').id)
    } else {
      uninstallMessage = this.context.resourceManager.getStringSync($r('app.string.uninstall_failed').id)
    }
    prompt.showToast({
      message: uninstallMessage
    })
  }

  /**
   * initPositionInfos
   *
   * @param appInfos
   */
  initPositionInfos(appInfos: Array<AppItemInfo>) {
    if (CheckEmptyUtils.isEmptyArr(appInfos)) {
      return []
    }
    Logger.info(TAG, `initPositionInfos, appInfos size = ${appInfos.length}`)
    let countsOnePage = CommonConstants.DEFAULT_COLUMN_COUNT * CommonConstants.DEFAULT_ROW_COUNT
    let result: Array<Array<GridLayoutItemInfo>> = []
    let page = Math.floor(appInfos.length / countsOnePage) + 1
    for (let i = 0;i < page; i++) {
      let item: Array<GridLayoutItemInfo> = []
      result.push(item)
    }
    Logger.debug(TAG, `result0 = ${JSON.stringify(result)}`)
    for (let j = 0;j < appInfos.length; j++) {
      let item = appInfos[j]
      Logger.debug(TAG, `infos[${j}], item = ${JSON.stringify(item)}`)
      let page = Math.floor(j / countsOnePage)
      let column = Math.floor(j % CommonConstants.DEFAULT_COLUMN_COUNT)
      let row = Math.floor(j / CommonConstants.DEFAULT_COLUMN_COUNT) % countsOnePage
      let gridItem: GridLayoutItemInfo = this.covertAppItemToGridItem(item, page, column, row)
      if (!CheckEmptyUtils.isEmpty(gridItem)) {
        result[page].push(gridItem)
      }
      Logger.debug(TAG, `infos[${j}], page = ${page},row = ${row},column = ${column}`)
    }
    Logger.debug(TAG, `result1 = ${JSON.stringify(result)}`)
    return result
  }

  private covertAppItemToGridItem(item: AppItemInfo, page: number, column: number, row: number) {
    if (CheckEmptyUtils.isEmpty(item)) {
      return undefined
    }
    let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo()
    gridItem.appName = item.appName
    gridItem.appIconId = item.appIconId
    gridItem.bundleName = item.bundleName
    gridItem.moduleName = item.moduleName
    gridItem.abilityName = item.abilityName
    gridItem.container = -100
    gridItem.page = page
    gridItem.column = column
    gridItem.row = row
    gridItem.area = [1, 1]
    gridItem.typeId = 0
    return gridItem
  }

  /**
   * createCardToDeskTop
   *
   * @param formCardItem
   */
  async createCardToDeskTop(formCardItem: any) {
    if (CheckEmptyUtils.isEmpty(formCardItem)) {
      return
    }
    Logger.info(TAG, `createCardToDeskTop formCardItem ${JSON.stringify(formCardItem)}`)
    let gridItem = this.createNewCardItemInfo(formCardItem)
    let page = this.layoutInfo.length
    gridItem = this.updateItemLayoutInfo(gridItem)
    if (gridItem.page >= page) {
      this.layoutInfo.push([])
    }
    this.layoutInfo[gridItem.page].push(gridItem)
    await RdbManager.initRdbConfig(this.context)
    await RdbManager.insertItem(gridItem)
    Logger.info(TAG, `createCardToDeskTop gridItem2 =  ${JSON.stringify(gridItem)}`)
    AppStorage.SetOrCreate('isRefresh', true)
  }

  /**
   * remove item from desktop
   *
   * @param item
   */
  async removeItemFromDeskTop(item: GridLayoutItemInfo) {
    if (CheckEmptyUtils.isEmpty(item)) {
      return
    }
    Logger.info(TAG, 'removeCardFromDeskTop start')
    let pageInfos = this.layoutInfo
    searchCircle:for (let i = 0;i < pageInfos.length; i++) {
      Logger.info(TAG, `removeCardFromDeskTop pageInfos${i}`)
      for (let j = 0;j < pageInfos[i].length; j++) {
        if (pageInfos[i][j].bundleName === item.bundleName && pageInfos[i][j].page === item.page
        && pageInfos[i][j].row === item.row && pageInfos[i][j].column === item.column) {
          Logger.debug(TAG, `removeCardFromDeskTop pageInfos${i}${j} is find,remove`)
          pageInfos[i].splice(j, 1)
          // 移除后是空白屏幕，移除屏幕
          if (pageInfos[i].length === 0) {
            pageInfos.splice(i, 1)
          }
          break searchCircle
        }
      }
    }
    this.layoutInfo = pageInfos
    await RdbManager.deleteItemByPosition(item.page, item.row, item.column)
    Logger.info(TAG, `removeCardFromDeskTop item= ${JSON.stringify(item)}`)
    AppStorage.SetOrCreate('isRefresh', true)
  }

  private updateItemLayoutInfo(item: GridLayoutItemInfo) {
    let page = this.layoutInfo.length
    const row = CommonConstants.DEFAULT_ROW_COUNT
    const column = CommonConstants.DEFAULT_COLUMN_COUNT
    let isNeedNewPage = true
    pageCycle: for (let i = 0; i < page; i++) {
      for (let y = 0; y < row; y++) {
        for (let x = 0; x < column; x++) {
          if (this.isPositionValid(item, i, x, y)) {
            isNeedNewPage = false
            item.page = i
            item.column = x
            item.row = y
            break pageCycle
          }
        }
      }
    }

    if (isNeedNewPage) {
      item.page = page
      item.column = 0
      item.row = 0
    }
    return item
  }

  private isPositionValid(item: GridLayoutItemInfo, page: number, startColumn: number, startRow: number) {
    const row = CommonConstants.DEFAULT_ROW_COUNT
    const column = CommonConstants.DEFAULT_COLUMN_COUNT
    if ((startRow + item.area[0]) > row || (startColumn + item.area[1]) > column) {
      Logger.info(TAG, 'isPositionValid return false 1')
      return false
    }
    let isValid = true
    for (let x = startColumn; x < startColumn + item.area[1]; x++) {
      for (let y = startRow; y < startRow + item.area[0]; y++) {
        if (this.isPositionOccupied(page, x, y)) {
          Logger.info(TAG, 'isPositionValid return false 2')
          isValid = false
          break
        }
      }
    }
    return isValid
  }

  private isPositionOccupied(page: number, column: number, row: number) {
    const layoutInfo = this.layoutInfo[page]
    // current page has space
    for (const item of layoutInfo) {
      const xMatch = (column >= item.column) && (column < item.column + item.area[1])
      const yMatch = (row >= item.row) && (row < item.row + item.area[0])
      if (xMatch && yMatch) {
        return true
      }
    }
    return false
  }

  private createNewCardItemInfo(formCardItem: any): GridLayoutItemInfo {
    if (CheckEmptyUtils.isEmpty(formCardItem)) {
      return undefined
    }
    let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo()
    gridItem.appName = formCardItem.appName
    gridItem.typeId = CommonConstants.TYPE_CARD
    gridItem.cardId = formCardItem.cardId
    gridItem.cardName = formCardItem.cardName
    gridItem.bundleName = formCardItem.bundleName
    gridItem.moduleName = formCardItem.moduleName
    gridItem.abilityName = formCardItem.abilityName
    gridItem.container = -100
    gridItem.page = 0
    gridItem.column = 0
    gridItem.row = 0
    gridItem.area = FormManager.getCardSize(formCardItem.dimension)
    return gridItem
  }
}