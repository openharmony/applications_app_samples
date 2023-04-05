import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility'
import rpc from '@ohos.rpc'
import Logger from '../model/Logger'

const TAG: string = 'ServiceAbility'
const APPLICATION_BUNDLE_NAME = "ohos.samples.etsdistributedmusicplayer"
const APPLICATION_ABILITY_NAME = "MainAbility"
const APPLICATION_SERVICE_NAME = "ServiceAbility"
const CONNECT_REMOTE_TIMEOUT = 10000
enum MusicSharedEventCode {
    START_DISTRIBUTED_MUSIC_SERVICE = 1,
    STOP_DISTRIBUTED_MUSIC_SERVICE = 2,
}
enum MusicConnectEvent {
    EVENT_CONNECT = "ONCONNECT",
    EVENT_DISCONNECT = "ONDISCONNECT",
    EVENT_FAILED = "ONFAILED",
    EVENT_TIMEOUT = "CONNECTTIMEOUT"
}

class DistributedMusicServiceExtension extends rpc.RemoteObject {
    private context
    constructor(des, context) {
        super(des)
        this.context = context
    }

    startServiceAbility(want) {
        try {
            let connectOptions = {
                onConnect(elementName, remote) {
                    Logger.info(TAG, `start remote service has been succeeded, elementName= ${JSON.stringify(elementName)}, remote= ${JSON.stringify(remote)}`)
                    clearTimeout(timeoutId)
                    if (typeof(globalThis.viewThis) === 'object' &&
                        typeof(globalThis.viewThis.remoteServiceExtensionConnectEvent) === 'function') {
                        globalThis.viewThis.remoteServiceExtensionConnectEvent(MusicConnectEvent.EVENT_CONNECT)
                    }
                },
                onDisconnect(elementName) {
                    Logger.info(TAG, `ServiceExtension has onDisconnected,elementName= ${JSON.stringify(elementName)}`)
                    if (typeof(globalThis.viewThis) === 'object' &&
                        typeof(globalThis.viewThis.remoteServiceExtensionConnectEvent) === 'function') {
                        globalThis.viewThis.remoteServiceExtensionConnectEvent(MusicConnectEvent.EVENT_DISCONNECT)
                    }
                },
                onFailed(code) {
                    Logger.info(TAG, `ServiceExtension has onFailed, code= ${JSON.stringify(code)}`)
                    if (typeof(globalThis.viewThis) === 'object' &&
                        typeof(globalThis.viewThis.remoteServiceExtensionConnectEvent) === 'function') {
                        globalThis.viewThis.remoteServiceExtensionConnectEvent(MusicConnectEvent.EVENT_FAILED)
                    }
                }
            }

            this.context.connectServiceExtensionAbility(want, connectOptions)
            let timeoutId = setTimeout(() => {
                Logger.info(TAG, 'connect remote service extension timeout')
                if (typeof(globalThis.viewThis) === 'object' &&
                    typeof(globalThis.viewThis.remoteServiceExtensionConnectEvent) === 'function') {
                    globalThis.viewThis.remoteServiceExtensionConnectEvent(MusicConnectEvent.EVENT_TIMEOUT)
                }
            }, CONNECT_REMOTE_TIMEOUT)
        } catch (err) {
            Logger.info(TAG, `ConnectServiceExtensionAbility has failed, want= ${JSON.stringify(want)}, err= ${JSON.stringify(err)}`)
        }
    }
    stopServiceAbility(want) {
        this.context.stopServiceExtensionAbility(want).then(() => {
            Logger.info(TAG, `stop service has been succeeded, want= ${JSON.stringify(want)}`)
        }).catch((err) => {
            Logger.info(TAG, `stop service has been failed, want= ${JSON.stringify(want)}, err= ${JSON.stringify(err)}`)
        })
    }
    onRemoteRequest(code, data, reply, option) {
        if (code === MusicSharedEventCode.START_DISTRIBUTED_MUSIC_SERVICE) {
            let deviceId = data.readString()
            let jsonData = JSON.parse(data.readString())
            let params = {
                uri: jsonData['uri'],
                seekTo: jsonData['seekTo'],
                isPlaying: jsonData['isPlaying']
            }
            let want = {
                deviceId: deviceId,
                bundleName: APPLICATION_BUNDLE_NAME,
                abilityName: APPLICATION_SERVICE_NAME,
                parameters: params,
                action: "START_REMOTE_DISTRIBUTED_MUSIC_SERVICE"
            }
            this.startServiceAbility(want)
        } else if (code === MusicSharedEventCode.STOP_DISTRIBUTED_MUSIC_SERVICE) {
            let deviceId = data.readString()
            let want = {
                deviceId: deviceId,
                bundleName: APPLICATION_BUNDLE_NAME,
                abilityName: APPLICATION_SERVICE_NAME
            }
            this.stopServiceAbility(want)
        }
        return true
    }
}

export default class ServiceAbility extends ServiceExtensionAbility {
    onCreate(want){
        if(want.action == "START_REMOTE_DISTRIBUTED_MUSIC_SERVICE") {
            let localwant = {
                bundleName: APPLICATION_BUNDLE_NAME,
                abilityName: APPLICATION_ABILITY_NAME,
                parameters: want.parameters
            }
            this.context.startAbility(localwant).then(() => {
                Logger.info(TAG, 'StartUIAbility has been succeeded')
            }).catch((err) => {
                Logger.info(TAG, `StartUIAbility has been failed, err= ${JSON.stringify(err)}`)
            })
        }
    }
    onDestroy() {
        Logger.info(TAG, 'ServiceAbility onDestroy')
    }

    onRequest(want, startId) {
        Logger.info(TAG, 'ServiceAbility onRequest')
    }

    onConnect(want) {
        Logger.info(TAG, 'ServiceAbility onConnect')
        return new DistributedMusicServiceExtension('ohos.samples.distributedMusicServiceExtension', this.context)
    }

    onDisconnect(want) {
        Logger.info(TAG, 'ServiceAbility onDisconnect')
    }

    onReconnect(want) {
        Logger.info(TAG, 'ServiceAbility onReconnect')
    }

    onConfigurationUpdate(newConfig) {
        Logger.info(TAG, 'ServiceAbility onConfigurationUpdate')
    }

    onDump(params) {
        Logger.info(TAG, 'ServiceAbility onDump')
        return params
    }
}