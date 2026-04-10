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

import wifiManager from '@ohos.wifiManager';
import { sharing } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';

class HotspotUtils {
  //开启热点监听
  StartHotspotListen(){
    try{
      wifiManager.on('hotspotStateChange', (e) => {
        console.log('开启热点监听成功' + JSON.stringify(e))
      })
    }catch (e){
      console.log('开启热点监听失败 ',JSON.stringify(e))
    }
  }
  //关闭热点监听
  StoptHotspotListen(){
    try{
      wifiManager.off('hotspotStateChange', (e) => {
        console.log('关闭热点监听成功' + JSON.stringify(e))
      })
    }catch (e){
      console.log('关闭热点监听失败 ',JSON.stringify(e))
    }
  }

  //热点开关切换
  SwitchHotspotState(isHotSpotEnabled:boolean){
    try {
      if (isHotSpotEnabled) {
        wifiManager.enableHotspot()
        console.log('热点启用')
      } else {
        wifiManager.disableHotspot()
        console.log('热点关闭')
      }
    }catch (e) {
      console.log('SwitchHotspotState() faild', JSON.stringify(e))
    }
  }

  //检查当前设备是否处于Wi-Fi热点模式
  checkHotspotStatus() {
    try {
      let ret = wifiManager.isHotspotActive();
      console.info('checkHotspotStatus() success result:' + ret);
    } catch (error) {
      console.error('checkHotspotStatus() failed:' + JSON.stringify(error));
    }
  }
  //开启热点
  openHotspot(){
    try {
      wifiManager.enableHotspot()
      console.log('热点启用成功')
    } catch (e) {
      console.log('热点启用失败' + JSON.stringify(e))
    }
  }
  //查询热点是否使能
  hotspotStatus(){
    try {
      wifiManager.isHotspotActive()
      console.log('wifiManager.isHotspotActive 热点可使能', wifiManager.isHotspotActive())
    } catch (e) {
      console.log('wifiManager.isHotspotActive 热点不可使能', JSON.stringify(e))
    }
  }
  //获取已连接设备列表
  GetConnectDeviceList(){
    let connectedDeviceList = wifiManager.getStations()
    return connectedDeviceList

  }

  //获取已连接设备的数量
  GetConnectedDevicesNumber():number{
    let connectNumber = 0;
    try {
      if(!wifiManager.getStations().length){
        connectNumber = 0
      }else {
        connectNumber = wifiManager.getStations().length
      }
      console.log('this.connectNumber ',connectNumber)
      return connectNumber

    }catch (e) {
      console.log('获取连接设备失败 ',JSON.stringify(e))
      return connectNumber
    }
  }

  //修改热点名称
  ModifyHotspotName(hotspotConfig: wifiManager.HotspotConfig){
    try {
      wifiManager.setHotspotConfig(hotspotConfig)
      console.log('修改设备名称成功')
    }catch (e) {
      console.log('修改设备名称失败 ',e)
    }
  }
  //修改热点密码
  ModifyHotspotPWD(hotspotConfig: wifiManager.HotspotConfig){
    try {
      wifiManager.setHotspotConfig(hotspotConfig)
      console.log('修改热点密码成功')
    }catch (e) {
      console.log('修改热点密码失败 ',e)
    }
  }

  //开启WiFi热点模式
  StartWifiHotspot(){
    try {
      let SHARING_WIFI = 0
      sharing.startSharing(SHARING_WIFI, (error: BusinessError) =>{
        console.log('BusinessError SHARING_WIFI',JSON.stringify(error))
      })
    }catch (e) {
      console.log('start SHARING_WIFI fail',e)
    }
  }
  //关闭Wifi热点模式
  StopWifiHotspot(){
    try {
      let SHARING_WIFI = 0;
      sharing.stopSharing(SHARING_WIFI, (error: BusinessError) => {
        console.error('BusinessError SHARING_WIFI',JSON.stringify(error));
      });
    }catch (e) {
      console.log('stop SHARING_WIFI fail',e)
    }
  }
}

export default new HotspotUtils()
