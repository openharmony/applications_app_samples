import { Context } from '@ohos.abilityAccessCtrl'
import preferences from '@ohos.data.preferences'
export const storeToken = 'infoList'

export const preferenceToken = 'preferences'

interface Element{
  bundleName: string
  abilityName: string
}
const infoList: string = '';
export default class StoreAppList {
  public context: Context
  constructor(context: Context) {
    this.context = context
  }
  getStore() {
    return preferences.getPreferences(this.context, preferenceToken)
  }
  async setAppList(appInfoList:string) {
    const appStore = await this.getStore()
    await appStore.put(storeToken,appInfoList)
    await appStore.flush()
  }
  async getAppList():Promise<Array<Element>>{
    const appStore = await this.getStore()
    let aa = await appStore.get(storeToken,infoList)
    if (aa) {
      return JSON.parse(aa as string) as Array<Element>
    }else{
      return []
    }
  }
}
