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
 
import wifiManager from '@ohos.wifiManager'
import Prompt from '@system.prompt'
import socket from '@ohos.net.socket'
import common from '@ohos.app.ability.common'
import fs from '@ohos.file.fs'
import { BusinessError } from '@ohos.base'
import Logger from './Logger'
import userFileManager from '@ohos.filemanagement.userFileManager'
import { FileSendModel } from '../models/FileSendModel'
import storage from '@ohos.statfs';
import settings from '@ohos.settings'
import util from '@ohos.util';
import image from '@ohos.multimedia.image'
import deviceInfo from '@ohos.deviceInfo'
import router from '@ohos.router'
import { photoAccessHelper } from '@kit.MediaLibraryKit'

class SocketInfo {
  message: ArrayBuffer = new ArrayBuffer(0)
  remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo
}

class PhotoModel {
  uri: string = ''
  photoType: photoAccessHelper.PhotoType | null = null
  displayName: string = ''
  size: photoAccessHelper.MemberType = 0
  duration: photoAccessHelper.MemberType = 0
  width: photoAccessHelper.MemberType = 0
  height: photoAccessHelper.MemberType = 0
  dateTaken: photoAccessHelper.MemberType = 0
  pixelMap: image.PixelMap | null = null
}

export class Info {
  code: number = 0;
  message: string = ''
}

interface ParamBrowser {
  pageFrom: number;
  viewData: string;
  viewDataAlbum: string;
  viewDataIndex: string;
  viewDataIsAuto: boolean;
  isShowMenuFromThirdView: boolean;
};

let TAG = 'WifiDeviceManager'

export class WifiDeviceManager {
  public deviceList: wifiManager.WifiP2pDevice[] = []
  private tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance()
  private tcpServerPort: number = 9999
  private goAddr: string = ''
  private tcp: socket.TCPSocket = socket.constructTCPSocketInstance()
  private connection: socket.TCPSocketConnection = {} as socket.TCPSocketConnection
  private context!: common.Context
  private offset: number = 0;
  public timer: number = 0
  private receivedInfo!: FileSendModel
  private intervalTimer: number = 0
  private deviceName: string = ''
  private connectStatus: number = 0
  private fileBuffer: ArrayBuffer = new ArrayBuffer(1024 * 1024 * 100)
  private p2pDiscoveryStatus: number = 0
  private bufferThumbnail: ArrayBuffer = new ArrayBuffer(1024 * 1024 * 10)
  private receiveNum: number = 0
  private P2pConnectStatus: number = 0
  private P2PConnectTimer: number = 0
  public isGroup: boolean = false
  private isGroupOwner: boolean = false
  private isCreated: boolean = false
  private reconnectCount: number = 0

  static getInstance(): WifiDeviceManager {
    if (AppStorage.get('WifiDeviceManager') == null) {
      AppStorage.setOrCreate('WifiDeviceManager', new WifiDeviceManager());
    }
    let manager = AppStorage.get<WifiDeviceManager>('WifiDeviceManager');
    if (!manager) {
      manager = new WifiDeviceManager()
      AppStorage.setOrCreate('WifiDeviceManager', manager);
    }
    return manager
  }

  initializationSize(context: common.Context) {
    this.context = context
    this.setDeviceName()
    this.registerP2pEvents()
    this.scanP2PDevices()
  }

  // 注册监听
  registerP2pEvents() {
    Logger.info(TAG, 'registerP2pEvents.')
    wifiManager.on('p2pStateChange', this.p2pStateChangeCb);
    wifiManager.on('p2pConnectionChange', this.p2pConnectionChangeCb.bind(this));
    wifiManager.on('p2pDeviceChange', this.p2pDeviceChangeCb);
    wifiManager.on('p2pPeerDeviceChange', this.p2pPeerDeviceChangeCb.bind(this))
    wifiManager.on('p2pPersistentGroupChange', this.p2pPersistentGroupChangeCb);
    wifiManager.on('p2pDiscoveryChange', this.p2pDiscoveryChangeCb.bind(this));
  }

  // 注销监听
  unregisterP2pEvents() {
    Logger.info(TAG, 'unregisterP2pEvents.')
    wifiManager.off('p2pStateChange', this.p2pStateChangeCb);
    wifiManager.off('p2pConnectionChange', this.p2pConnectionChangeCb.bind(this));
    wifiManager.off('p2pDeviceChange', this.p2pDeviceChangeCb);
    wifiManager.off('p2pPeerDeviceChange', this.p2pPeerDeviceChangeCb.bind(this))
    wifiManager.off('p2pPersistentGroupChange', this.p2pPersistentGroupChangeCb);
    wifiManager.off('p2pDiscoveryChange', this.p2pDiscoveryChangeCb.bind(this));
    if (this.isGroupOwner) {
      this.p2pCancelConnect()
      this.removeGroup()
      this.deletePersistentGroup()
    }
  }

  // 判断缓存是否已满
  async getCache(): Promise<number> {
    let filesDir = this.context.filesDir;
    let data = await storage.getFreeBytes(filesDir)
    return data
  }

  // 打开wifi
  enableWifi() {
    Logger.warn(TAG, 'enableWifi')
    try {
      wifiManager.enableWifi();
    } catch (error) {
      Logger.error(TAG, 'failed:' + JSON.stringify(error));
    }
  }

  // 关闭WIFI
  disableWifi() {
    Logger.warn(TAG, 'disableWifi')
    try {
      wifiManager.disableWifi();
    } catch (error) {
      Logger.error(TAG, 'disableWifi failed:' + JSON.stringify(error));
    }
  }

  // 设置本端设备名称
  setDeviceName() {
    settings.getValue(this.context, settings.general.DEVICE_NAME).then((value: string) => {
      if (value.length === 0) {
        value = 'TEST_001'
      }
      this.deviceName = value
      try {
        console.log(TAG,'wifiManager.setDeviceName success:' + value)
        wifiManager.setDeviceName(value)
      } catch (e) {
        Logger.info(TAG, 'wifiManager.setDeviceName failed:' + JSON.stringify(e))
      }
    })
  }

  // 监听对端设备状态改变
  p2pPeerDeviceChangeCb(result: wifiManager.WifiP2pDevice[]) {
    Logger.info(TAG, 'p2pPeerDeviceChangeCb: ' + JSON.stringify(result))
    if (!this.isGroup) {
      this.deviceList = result
      AppStorage.setOrCreate('deviceList', this.deviceList)
    }
  }

  // 监听p2p开关状态改变
  p2pStateChangeCb(result: number) {
    Logger.info(TAG, 'p2pStateChangeCb: ' + result)
  }

  // 监听p2p连接状态改变
  p2pConnectionChangeCb(result: wifiManager.WifiP2pLinkedInfo) {
    Logger.info(TAG, 'p2pConnectionChangeCb: ' + JSON.stringify(result))
    clearTimeout(this.P2PConnectTimer)
    if (result.connectState == 1 && result.groupOwnerAddr != '') {
      this.P2pConnectStatus = 1
      this.isGroupOwner = result.isGroupOwner
      if (result.isGroupOwner) {
        if (result.groupOwnerAddr == this.goAddr) {
          return
        }
        this.goAddr = result.groupOwnerAddr
        this.startTcpServer()
      } else {
        this.goAddr = result.groupOwnerAddr
        this.connectTcpServer()
      }
    }
  }

  // 开启TCP server
  startTcpServer() {
    Logger.info(TAG, 'startTcpServer.')
    if (this.goAddr.length === 0) {
      Prompt.showToast({
        message: 'GO Addr is null.',
        duration: 3000
      })
      return
    }
    let addr: socket.NetAddress = {
      address: this.goAddr,
      port: this.tcpServerPort,
      family: 1
    }
    this.tcpServer.listen(addr, (err) => {
      if (err) {
        Logger.info(TAG, 'startTcpServer listen fail:' + JSON.stringify(err))
        this.connectStatus = 0
        return;
      }
      Logger.info(TAG, 'listen success')
      this.connectStatus = 2
      this.tcpServer.on('connect', this.onTcpServerConnected.bind(this))
    })
    let tcpExtraOptions: socket.TCPExtraOptions = {
      keepAlive: true,
      socketLinger: { on: false, linger: 10 }
    }
    this.tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError) => {
      if (err) {
        console.log('setExtraOptions fail');
        return;
      }
      console.log('setExtraOptions success');
    });
  }

  // 监听TCP连接状态
  onTcpServerConnected(data: socket.TCPSocketConnection) {
    Logger.info(TAG, 'onTcpServerConnected: ' + JSON.stringify(data))
    this.connection = data
    this.connection.on('message', this.onMessageReceived.bind(this))
  }

  // 连接Tcp server
  connectTcpServer() {
    Logger.info(TAG, 'connectTcpServer:' + this.goAddr)
    if (this.goAddr.length === 0) {
      Prompt.showToast({
        message: 'GO Addr is null.',
        duration: 3000
      })
      return
    }
    this.reconnectCount = setTimeout(() => {
      clearTimeout(this.reconnectCount)
      this.TcpClose()
      this.connectTcpServer()
    }, 10 * 100)
    let option: socket.TCPConnectOptions = {
      address: {
        address: this.goAddr,
        port: this.tcpServerPort,
        family: 1
      },
      timeout: 1000 * 30
    }
    this.tcp.connect(option, (err) => {
      clearTimeout(this.reconnectCount)
      if (err) {
        Logger.info(TAG, 'connectTcpServer fail:' + JSON.stringify(err))
        if (err.code == 2301110) {
          return;
        }
        this.TcpClose()
        AppStorage.setOrCreate('receivedState', 6)
        Prompt.showToast({
          message: '网络异常，请重试！',
          duration: 3000
        })
        return;
      }
      Logger.info(TAG, 'connect success')
      this.connectStatus = 2
      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        socketLinger: { on: false, linger: 10 }
      }
      this.tcp.setExtraOptions(tcpExtraOptions, (err: BusinessError) => {
        if (err) {
          console.log('setExtraOptions fail');
          return;
        }
        console.log('setExtraOptions success');
      })
      this.tcp.on('message', this.onMessageReceived.bind(this))
      let selectList: PhotoModel[] = AppStorage.get<PhotoModel[]>('SelectList') ?? []
      setTimeout(() => {
        if (selectList.length == 1) {
          const models: FileSendModel = {
            filePath: selectList[0].uri as string,
            fileName: selectList[0].displayName as string,
            size: selectList[0].size as number,
            type: selectList[0].photoType ?? 0,
            deviceName: this.deviceName
          }
          AppStorage.setOrCreate('receivedState', 1)
          this.readFile(models, selectList[0])
        }
      }, 1000)
    })
  }

  // 监听P2P状态改变
  p2pDeviceChangeCb(result: wifiManager.WifiP2pDevice) {
    Logger.info(TAG, 'p2pDeviceChangeCb: ' + JSON.stringify(result))
  }

  // 监听P2P永久组状态改变事件
  p2pPersistentGroupChangeCb(result: void) {
    Logger.info(TAG, 'p2pPersistentGroupChangeCb: ' + JSON.stringify(result))
  }

  // 监听设备状态改变事件
  p2pDiscoveryChangeCb(result: number) {
    Logger.info(TAG, 'p2pDiscoveryChangeCb: ' + result)
    this.p2pDiscoveryStatus = result
  }

  // 读取文件
  async readFile(model: FileSendModel, item: PhotoModel) {
    try {
      if (AppStorage.get('receivedState') == 1) {
        this.sendToServer(JSON.stringify(model))
        setTimeout(() => {
          this.sendThumbnail(item)
        }, 100)
      } else if (AppStorage.get('receivedState') == 3) {
        let file = fs.openSync(model.filePath, fs.OpenMode.READ_WRITE);
        let length = fs.readSync(file.fd, this.fileBuffer);
        fs.closeSync(file.fd)
        AppStorage.setOrCreate('receivedState', 5)
        let offset: number = 0
        while (offset < length) {
          await this.sleep(1)
          if (AppStorage.get('receivedState') != 5) {
            break
          }
          await this.sendToServer(this.fileBuffer.slice(offset, Math.min(offset + 1024 * 1024, length)))
          offset = offset + 1024 * 1024
        }
      }
    } catch (e) {
      Logger.error(TAG, 'readFile fail:' + JSON.stringify(e))
    }
  }

  // 睡眠
  async sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
  }

  // 获取当前设备p2p信息
  async IsNeedCreateGroup(): Promise<boolean> {
    return await wifiManager.getCurrentGroup().then((data: wifiManager.WifiP2pGroupInfo): boolean => {
      console.info(TAG, 'getCurrentGroup: ' + JSON.stringify(data))
      if (data.isP2pGo === true && data.goIpAddress !== '') {
        return true
      }
      return false
    }).catch((err: BusinessError): boolean => {
      Logger.error(TAG, 'getCurrentGroup fail:' + JSON.stringify(err))
      return false
    })
  }

  // 获取设备类型
  IsSwanLinkOSDev(): boolean {
    if (deviceInfo.displayVersion == 'SwanLinkOS v4.0.0') {
      return true
    }
    return false
  }

  // 扫描设备
  async scanP2PDevices() {
    if (wifiManager.isWifiActive()) {
      console.info(TAG, 'scanP2PDevices.')
      wifiManager.startDiscoverDevices();
    } else {
      await this.enableWifi()
      this.scanP2PDevices()
    }
  }

  getP2pLinkedInfos() {
    try {
      wifiManager.getP2pLinkedInfo().then((data: wifiManager.WifiP2pLinkedInfo) => {
        Logger.info(TAG, 'get wifi p2p linked info: ' + JSON.stringify(data));
      });
    } catch (e) {
      console.error('getP2pLinkedInfo failed:' + JSON.stringify(e))
    }
  }


  // 停止扫描设备
  stopScanDevices() {
    try {
      Logger.info(TAG, 'stopDiscoverDevices.')
      wifiManager.stopDiscoverDevices();
    } catch (error) {
      Logger.error(TAG, 'failed:' + JSON.stringify(error));
    }
  }

  // 连接p2p
  async connectP2pDevice(device: wifiManager.WifiP2pDevice) {
    Logger.info(TAG, 'connectP2pDevice: ' + JSON.stringify(device))
    wifiManager.off('p2pPeerDeviceChange', this.p2pPeerDeviceChangeCb.bind(this))
    try {
      let config: wifiManager.WifiP2PConfig = {
        deviceAddress: device.deviceAddress,
        deviceAddressType: device.deviceAddressType,
        netId: -2,
        passphrase: '12345678',
        groupName: 'SwanLink_Share',
        goBand: 1
      }
      wifiManager.p2pConnect(config);
      clearTimeout(this.P2PConnectTimer)
      this.P2PConnectTimer = setTimeout(() => {
        if (this.P2pConnectStatus == 1) {
          clearTimeout(this.P2PConnectTimer)
        } else {
          Prompt.showToast({
            message: '设备P2P连接失败，请重新连接',
            duration: 3000
          })
          this.P2pConnectStatus = 0
          AppStorage.setOrCreate('receivedState', 6)
        }
      }, 30 * 1000)
    } catch (error) {
      Logger.info(TAG, 'failed:' + JSON.stringify(error))
    }
  }

  // 创建群组
  async createGroup() {
    if (this.IsSwanLinkOSDev()) {
      Logger.warn(TAG, 'createGroup.')
      try {
        await this.deletePersistentGroup()
        this.sleep(1000)
        let config: wifiManager.WifiP2PConfig = {
          deviceAddressType: 0,
          deviceAddress: '00:00:00:00:00:00',
          netId: -2,
          passphrase: '12345678',
          groupName: 'SwanLink_Share',
          goBand: 1
        }
        wifiManager.createGroup(config);
        setTimeout(() => {
          this.getP2pGroups()
        }, 3000)
      } catch (error) {
        Logger.error(TAG, 'failed:' + JSON.stringify(error))
      }
    }
  }

  // 获取p2p本端设备
  getP2pLocalDeviceInfo() {
    wifiManager.getP2pLocalDevice().then(data => {
      Logger.info(TAG, 'getP2pLocalDevice: ' + JSON.stringify(data))
    })
  }

  // 删除群组
  deletePersistentGroup() {
    Logger.warn(TAG, 'deletePersistentGroup.')
    try {
      wifiManager.getP2pGroups().then((data: wifiManager.WifiP2pGroupInfo[]) => {
        data.forEach((group: wifiManager.WifiP2pGroupInfo) => {
          wifiManager.deletePersistentGroup(group.networkId);
        })
      });
    } catch (error) {
      console.error('deletePersistentGroup failed:' + JSON.stringify(error));
    }
  }


  // 获取p2p当前群组信息
  getCurrentGroupInfo() {
    wifiManager.getCurrentGroup().then((data: wifiManager.WifiP2pGroupInfo) => {
      Logger.info(TAG, 'getCurrentGroup: ' + JSON.stringify(data))
      this.goAddr = data.goIpAddress
      this.deviceList = []
      this.deviceList.push(data.ownerInfo)
      AppStorage.setOrCreate('deviceList', this.deviceList)
      if (this.goAddr != '') {
        this.isGroup = true
      } else {
        this.isGroup = false
      }
    }).catch((err: BusinessError) => {
      Logger.error(TAG, 'getCurrentGroup fail:' + JSON.stringify(err))
    })

  }

  // 获取所有群组
  getP2pGroups() {
    Logger.warn(TAG, 'getP2pGroups.')
    wifiManager.getP2pGroups().then((data: wifiManager.WifiP2pGroupInfo[]) => {
      Logger.warn(TAG, 'getP2pGroups: ' + JSON.stringify(data));
      if (data.length == 0) {
        Prompt.showToast({
          message: '服务启动失败，请重试!',
          duration: 3000
        })
      }
    }).catch((err: BusinessError) => {
      Logger.error(TAG, 'getP2pGroups fail:' + JSON.stringify(err))
    })
  }

  // 发送消息到客户端
  sendToClient(data: string | ArrayBuffer) {
    if (this.connection === null) {
      Logger.error(TAG, 'connection is null.')
      return
    }
    let option: socket.TCPSendOptions = {
      data: data
    }
    this.connection.send(option).then(() => {
    }).catch((err: BusinessError) => {
      Logger.error(TAG, 'send fail:' + JSON.stringify(err))
    });
  }

  // 发送消息到服务端
  async sendToServer(data: string | ArrayBuffer) {
    let option: socket.TCPSendOptions = {
      data: data
    }
    this.tcp.send(option).then(() => {
    }).catch((err: BusinessError) => {
      Logger.error(TAG, 'send fail:' + JSON.stringify(err))
      AppStorage.setOrCreate('receivedState', 6)
      Prompt.showToast({
        message: '网络异常中断',
        duration: 3000
      })
    });
  }

  // 关闭tcp连接
  TcpClose() {
    try {
      if (this.tcp === null) {
        Logger.error(TAG, 'connection is null.')
        return
      } else {
        this.tcp.close().then(() => {
          Logger.info(TAG, '断开TCP连接')
        })
      }
    } catch (error) {
      Logger.error(TAG, 'TcpClose failed:' + JSON.stringify(error));
    }
  }

  ConnectionClose() {
    try {
      if (this.connection === null) {
        Logger.error(TAG, 'connection is null.')
        return
      }
      this.connection.close().then(() => {
        Logger.info(TAG, '断开TCPSever连接')
      })
    } catch (error) {
      Logger.error(TAG, 'ConnectionClose failed:' + JSON.stringify(error));
    }
  }

  // 取消p2p
  p2pCancelConnect() {
    Logger.warn(TAG, 'p2pCancelConnect')
    try {
      this.connectStatus = 0
      wifiManager.p2pCancelConnect();
    } catch (error) {
      Logger.error(TAG, 'p2pCancelConnect failed:' + JSON.stringify(error));
    }
  }

  // 移除群组
  removeGroup() {
    Logger.warn(TAG, 'removeGroup')
    try {
      wifiManager.removeGroup();
    } catch (error) {
      Logger.error(TAG, 'removeGroup failed:' + JSON.stringify(error));
    }
  }

  async sendThumbnail(item: PhotoModel) {
    let that = this
    let thumbnail = item.pixelMap
    if (thumbnail === null) {
      return
    }
    let packer = image.createImagePacker();
    let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 60 }
    packer.packing(thumbnail, packOpts)
      .then((data: ArrayBuffer) => {
        let offset = 0
        while (offset < data.byteLength) {
          this.sleep(1)
          that.sendToServer(data.slice(offset, offset + 1024))
          offset = offset + 1024
        }
      }).catch((error: BusinessError) => {
      Logger.error(TAG, 'packing failed.' + JSON.stringify(error));
    })
  }

  async arrayBufferToBase64(array: ArrayBuffer): Promise<void> {
    Logger.info(TAG, 'arrayBufferToBase64 start!')
    let base64Helper = new util.Base64Helper()
    let uint8Arr = new Uint8Array(array)
    let pixelStr = base64Helper.encodeToStringSync(uint8Arr)
    let base64Str = 'data:image/jpg;base64,' + pixelStr
    AppStorage.setOrCreate('thumbnail', base64Str)
    try {
      let cache = await this.getCache()
      if (cache < 1024 * 1024 * 1024) {
        let message: Info = {
          code: 2,
          message: '内存已满'
        }
        WifiDeviceManager.getInstance().sendToClient(JSON.stringify(message))
        AppStorage.setOrCreate('receivedState', 0)
      } else {
        AppStorage.setOrCreate('receivedState', 2)
        let message: Info = {
          code: 1,
          message: 'User agrees to receive and begins receiving'
        }
        WifiDeviceManager.getInstance().sendToClient(JSON.stringify(message))
        AppStorage.setOrCreate('receivedState', 3)
      }
      this.offset = 0
      this.receiveNum = 0
    } catch (err) {
      Logger.error(TAG, 'packing failed.' + JSON.stringify(err));
    }
  }

  // 接收消息
  onMessageReceived(info: SocketInfo) {
    let receivedState: number = AppStorage.get<number>('receivedState') ?? 0
    try {
      if (receivedState == 0) {
        if (this.receiveNum == 0) {
          let uint8Array = new Uint8Array(info.message);
          let messageView: string = (new util.TextDecoder('utf-8', { ignoreBOM: true })).decodeWithStream(uint8Array, {
            stream: false
          })
          this.receivedInfo = JSON.parse(messageView)
          AppStorage.setOrCreate('receivedInfo', this.receivedInfo)
          this.receiveNum++
        } else {
          let arrayBuffers = new Uint8Array(this.bufferThumbnail)
          arrayBuffers.set(new Uint8Array(info.message), this.offset)
          this.offset += info.message.byteLength
          this.receiveNum++
          if (this.intervalTimer != 0) {
            clearTimeout(this.intervalTimer)
          }
          this.intervalTimer = setTimeout((): void => {
            void this.arrayBufferToBase64(this.bufferThumbnail.slice(0, this.offset))
          }, 1000)
        }
      } else if (receivedState == 1 || receivedState == 5 || receivedState == 7) {
        let uint8Array = new Uint8Array(info.message);
        let messageView: string = (new util.TextDecoder('utf-8', { ignoreBOM: true })).decodeWithStream(uint8Array, {
          stream: false
        })
        let receivedInfoMessage: Info = JSON.parse(messageView)
        Logger.info(TAG, 'ReceivedInfo:' + JSON.stringify(receivedInfoMessage))
        if (receivedInfoMessage.code == 1) {
          AppStorage.setOrCreate('receivedState', 3)
          let selectList: PhotoModel[] = AppStorage.get<PhotoModel[]>('SelectList') ?? []
          if (selectList.length == 1) {
            const models: FileSendModel = {
              filePath: selectList[0].uri as string,
              fileName: selectList[0].displayName as string,
              size: selectList[0].size as number,
              type: selectList[0].photoType ?? 0,
              deviceName: this.deviceName
            }
            this.readFile(models, selectList[0])
          }
        } else if (receivedInfoMessage.code == 2) {
          Prompt.showToast({
            message: '目标设备内存不足！',
            duration: 3000
          })
          AppStorage.setOrCreate('receivedState', 6)
        } else if (receivedInfoMessage.code == 3) {
          this.fileBuffer = new ArrayBuffer(1024 * 1024 * 100)
          this.bufferThumbnail = new ArrayBuffer(1024 * 1024 * 10)
          AppStorage.setOrCreate('receivedState', 6)
          this.P2pConnectStatus = 0
        } else if (receivedInfoMessage.code == 0) {
          Prompt.showToast({
            message: '网络异常中断',
            duration: 3000
          })
          AppStorage.setOrCreate('receivedState', 6)
        }
      } else if (receivedState == 3) {
        AppStorage.setOrCreate('progressValue', this.offset)
        let arrayBuffers = new Uint8Array(this.fileBuffer)
        arrayBuffers.set(new Uint8Array(info.message), this.offset)
        this.offset += info.message.byteLength
        if (this.timer != 0) {
          clearTimeout(this.timer)
        }
        if (this.offset == this.receivedInfo.size) {
          AppStorage.setOrCreate('progressValue', this.receivedInfo.size)
          let message: Info = {
            code: 3,
            message: 'User agrees to receive and begins receiving'
          }
          WifiDeviceManager.getInstance().sendToClient(JSON.stringify(message))
        }
        this.timer = setTimeout((): void => {
          void this.writeFile()
        }, 3000)
      }
    } catch (err) {
      Logger.error(TAG, 'onMessageReceived failed: ' + JSON.stringify(err))
      if (AppStorage.get('receivedState') == 6) {
        return
      }
      AppStorage.setOrCreate('receivedState', 6)
      Prompt.showToast({
        message: '网络异常中断，请重试！',
        duration: 3000
      })
    }
  }

  // 写文件
  async writeFile(): Promise<void> {
    Logger.info(TAG, 'writeFile start')
    clearTimeout(this.timer)
    this.connectStatus = 0
    if (this.offset < this.receivedInfo.size) {
      let message: Info = {
        code: 3,
        message: 'User agrees to receive and begins receiving'
      }
      WifiDeviceManager.getInstance().sendToClient(JSON.stringify(message))
      Prompt.showToast({
        message: '数据传输格式损坏',
        duration: 3000
      })
      this.offset = 0
      this.sleep(3000)
      AppStorage.setOrCreate('receivedState', 6)
      return
    }
    try {
      let media = userFileManager.getUserFileMgr(this.context);
      let fileAsset = await media.createPhotoAsset(this.receivedInfo.fileName);
      let fd = await fileAsset.open('rw')
      fs.write(fd, this.fileBuffer.slice(0, this.offset)).then((writeLength: number) => {
        fs.close(fd)
        this.offset = 0
        Logger.info(TAG, 'writeFile success')
        AppStorage.setOrCreate('receivedState', 6)
        let params: ParamBrowser = {
          pageFrom: 7,
          viewData: fileAsset.uri,
          viewDataAlbum: '',
          viewDataIndex: '',
          viewDataIsAuto: false,
          isShowMenuFromThirdView: false
        }
        if (this.receivedInfo.type == 2) {
          params.viewDataIsAuto = true
        }
        setTimeout(() => {
          AppStorage.SetOrCreate('entryFroms', 10);
          router.replace({
            url: 'pages/PhotoBrowser',
            params: params
          })
        }, 1000)
      })
    } catch (err) {
      Logger.error(TAG, 'writeFile failed：' + JSON.stringify(err))
    }
  }
}
