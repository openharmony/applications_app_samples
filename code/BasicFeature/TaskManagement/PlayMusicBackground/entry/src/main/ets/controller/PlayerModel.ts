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

import { Logger } from './Logger'

import backgroundTaskManager from '@ohos.backgroundTaskManager'
import wantAgent from '@ohos.wantAgent'
import avSession from '@ohos.multimedia.avsession'

import media from '@ohos.multimedia.media'
import fileIO from '@ohos.fileio'

let localTag: string = 'PlayerModel'
const REFRESH_RATE = 500

/*
 * store songs file in list
 */
export class PlayList {
    constructor() {
    }

    audioFiles: Song[] = []
}

/*
 * song model, include:
 * name: song name
 * fileUri: song file path
 * duration: song duration
 */
export class Song {
    constructor(name: string, fileUri: string, duration: Number) {
        this.name = name
        this.fileUri = fileUri
        this.duration = duration
    }

    name: string
    fileUri: string
    duration: Number
}

/*
 * PlayerModel is control point export outside, its include song play list and the current playing song status
 */
export default class PlayerModel {
    isPlaying: boolean = false
    playingSong: string
    playList: PlayList
    index: number
    player: media.AudioPlayer
    statusChangedListener: (status: boolean) => {} // default is null
    playingProgressListener: (seekTo: number) => {} // default is null
    intervalID: number
    currentTimeMS: number = 0
    avSession: avSession.AVSession
    context: any
    // static SINGLETON: PlayerModel

    constructor() {
        this.player = media.createAudioPlayer()
        setCallBack(this)
        Logger.debug(localTag + ' create audio player=' + this.player)
    }

    /*
     * set audio callback and retrieve the media list
     */
    initAudioPlayer() {
        Logger.debug(localTag + ' init audio player')

        // load the song list
        this.loadPlayList()

        /*
         * set default to just print log
         */
        this.setOnStatusChangedListener((status) => {
            Logger.debug(localTag + ' status changed ' + status)
        })

        /*
         * set default just to print log
         */
        this.setPlayingProgressListener((currentTimeMs) => {
            Logger.debug(localTag + ' playing progress changed callback currentTimeMs=' + currentTimeMs)
        })
    }

    static getPlayerModelInstance() {
        if ( /* PlayerModel.SINGLETON == null */
        globalThis.singleton == null) {
            Logger.debug(localTag + ' singleton is null, new PlayerModel')
            // PlayerModel.SINGLETON = new PlayerModel()
            // PlayerModel.SINGLETON.initAudioPlayer()
            let singleton = new PlayerModel()
            singleton.initAudioPlayer()
            globalThis.singleton = singleton
        }
        return globalThis.singleton
        // return PlayerModel.SINGLETON
    }

    /*
     * refresh the play status when stop playing from player
     */
    reportPlayStatus(playing: boolean) {
        if (this.context != null) {
            this.stopBackgroundTask(this.context)
        }
        AppStorage.Set<boolean>('playStatus', playing)
    }

    /*
     * release audio player
     */
    release() {
        if (typeof (this.player) !== 'undefined') {
            Logger.debug(localTag + ' release player begin')
            this.player.release()
            Logger.debug(localTag + ' release player end')
            this.player = undefined
        }
    }

    /*
     * start background task interface
     * context: ability context
     */
    startBackgroundTask(context: any) {
        let wantAgentInfo = {
            wants: [ // set notification
                {
                    bundleName: "com.samples.playmusicbackground",
                    abilityName: "com.samples.playmusicbackground.MainAbility"
                }
            ],
            operationType: wantAgent.OperationType.START_ABILITY,
            requestCode: 0,
            wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
        }

        // use WantAgent to notify
        wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj) => {
            return backgroundTaskManager.startBackgroundRunning(context,
            backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj)
        }).then(() => {
            Logger.debug(localTag + ' start bg operation succeeded')
        }).catch((err) => {
            Logger.error(localTag + ' start bg operation failed Cause: ' + err)
        })
    }

    /*
     * stop background task interface
     * context: ability context
     */
    stopBackgroundTask(context: any) {
        backgroundTaskManager.stopBackgroundRunning(context).then(() => {
            Logger.debug(localTag + ' stop operation succeeded')
        }).catch((err) => {
            Logger.error(localTag + ' stop operation fail cause: ' + err)
        })
    }

    /*
     * use this to create play center control notification
     * context: ability context
     */
    createAVSession(context: any) {
        Logger.debug(localTag + ' createAVSession begin')
        avSession.createAVSession(context, 'player', 'audio').then((data) => {
            Logger.debug(localTag + ' createAVSession succeed')
            this.avSession = data
        })
    }

    /*
     * destroy play center control notification when stop playing
     * context: ability context
     */
    destroyAVSession() {
        Logger.debug(localTag + ' destroyAVSession begin')
        if (this.avSession === null) {
            Logger.debug(localTag + ' avSession is null')
            return
        }
        this.avSession.destroy()
    }

    /*
     * music play interface, with seekTo position, call into audio player play
     * seekTo: playing start with
     * startPlay: true:play now, else:set play position
     * context: use for bg play application
     */
    play(seekTo: number, startPlay: boolean, context: any) {
        this.context = context
        Logger.debug(localTag + ' player play seekTo=' + seekTo + ', startPlay=' + startPlay)
        this.notifyPlayingStatus(startPlay)
        if (startPlay) { // seek and play now
            // set to default playing position from last time
            if (this.player.currentTime > 0) {
                seekTo = this.player.currentTime
            } else if (seekTo < 0 && this.currentTimeMS > 0) {
                Logger.debug(localTag + ' player pop seekTo=' + this.currentTimeMS)
                seekTo = this.currentTimeMS
            }

            this.seek(seekTo)
            Logger.debug(localTag + ' player call to play')
            this.player.play()
            // application for playing at background
            this.startBackgroundTask(context)

            // must create play audio center object, or notification will disappear
            this.createAVSession(context)
            Logger.debug(localTag + ' player.play call player.state=' + this.player.state)
        } else if (seekTo > 0) { // just seek position only
            this.playingProgressListener(seekTo)
            this.currentTimeMS = seekTo
            this.seek(this.currentTimeMS)
            Logger.debug(localTag + ' player stash seekTo=' + this.currentTimeMS)
        }
    }

    /*
     * if playing status, pause play, else do nothing
     */
    pause(context: any) {
        if (!this.isPlaying) {
            Logger.debug(localTag + ' player pause ignored, isPlaying=' + this.isPlaying)
            return
        }
        Logger.debug(localTag + ' player call player.pause')
        this.player.pause()
        Logger.debug(localTag + ' player.pause called, player.state=' + this.player.state)
        this.notifyPlayingStatus(false)
        this.stopBackgroundTask(context)
    }

    /*
     * seek to ms potion if is playing status, else just set the position
     */
    seek(ms: number) {
        this.currentTimeMS = ms
        this.player.seek(ms)
        Logger.debug(localTag + ' player seekTo=' + this.currentTimeMS)
    }

    /*
     * if status is playing stop it, else do nothing
     */
    stop(context: any) {
        if (!this.isPlaying) {
            Logger.debug(localTag + ' player stop ignored, isPlaying=' + this.isPlaying)
            return
        }
        Logger.debug(localTag + ' player call player.stop')
        this.player.stop()
        this.isPlaying = false
        this.notifyPlayingStatus(false)
        this.destroyAVSession()
        this.stopBackgroundTask(context)
        Logger.debug(localTag + ' player stop called, player.state=' + this.player.state)
    }

    /*
     * restore to the status's uri song, depend the status seekTo and playing status
     * can use this to restore last one song playing status when app restart
     */
    restorePlayingStatus(status: any, callback) {
        Logger.debug(localTag + ' player restorePlayingStatus ' + status)
        for (let i = 0; i < this.playList.audioFiles.length; i++) {
            if (this.playList.audioFiles[i].fileUri === status.uri) {
                Logger.debug(localTag + ' player restore to index ' + i)
                this.preLoad(i, () => {
                    this.play(status.seekTo, false, null)
                    Logger.debug(localTag + ' player restore play status')
                    callback(i)
                })
                return
            }
        }
        console.warn(localTag + ' player restorePlayingStatus failed')
        callback(-1)
    }

    /*
     * get audios, default get dynamic.wav and demo.wav
     * these music file is in system default
     */
    loadPlayList() {
        Logger.debug(localTag + ' player getAudioAssets begin')
        this.playList = new PlayList()
        this.playList.audioFiles = []
        // todo get detail info to display
        this.playList.audioFiles[0] = new Song('dynamic.wav', 'system/etc/dynamic.wav', 0)
        this.playList.audioFiles[1] = new Song('demo.wav', 'system/etc/demo.wav', 0)
        Logger.debug(localTag + ' player getAudioAssets end')
    }

    /*
     * set status change callback
     */
    setOnStatusChangedListener(callback) {
        this.statusChangedListener = callback
    }

    /*
     * set playing listener callback
     */
    setPlayingProgressListener(callback) {
        this.playingProgressListener = callback
    }

    /*
     * get song duration default song is player.index
     */
    getDuration() {
        Logger.debug(localTag + ' player getDuration index=' + this.index)
        if (this.playList.audioFiles[this.index].duration > 0) {
            return this.playList.audioFiles[this.index].duration
        }
        Logger.debug(localTag + ' player getDuration state=' + this.player.state)
        if (this.player.state === 'idle') {
            console.warn(localTag + ' player getDuration ignored state=' + this.player.state)
            return 0
        }
        this.playList.audioFiles[this.index].duration = Math.min(this.player.duration, 97615)
        Logger.debug(localTag + ' player getDuration player.src=' + this.player.src
        + ', player.duration=' + this.player.duration)
        return this.playList.audioFiles[this.index].duration
    }

    /*
     * get current playing time ms
     */
    getCurrentMS() {
        return this.currentTimeMS
    }

    /*
     * clear interval id
     */
    cancelTimer() {
        if (typeof (this.intervalID) !== 'undefined') {
            Logger.debug(localTag + ' player clear update interval ' + this.intervalID)
            clearInterval(this.intervalID)
            this.intervalID = undefined
        }
    }

    /*
     * notify playing status, default is 500ms notify for each, and record in currentTimeMS
     */
    notifyPlayingStatus(isPlaying: boolean) {
        this.isPlaying = isPlaying
        this.statusChangedListener(this.isPlaying)
        Logger.debug(localTag + ' player notifyPlayingStatus isPlaying='
        + isPlaying + ' intervalID=' + this.intervalID)
        if (isPlaying) {
            if (typeof (this.intervalID) === 'undefined') {
                this.intervalID = setInterval(() => {
                    if (typeof (this.playingProgressListener) !== 'undefined'
                    && this.playingProgressListener != null) {
                        let timeMS = this.player.currentTime
                        if (typeof (timeMS) === 'undefined') {
                            timeMS = 0
                        }
                        this.currentTimeMS = timeMS
                        this.playingProgressListener(timeMS)
                    }
                }, REFRESH_RATE)
                Logger.debug(localTag + ' player set update interval ' + this.intervalID)
            }
        } else {
            this.cancelTimer()
        }
    }

    /*
     * preload song by name after song list init
     */
    preloadSong(songName: string, context: any) {
        Logger.debug(localTag + ' play song=' + songName)
        if (this.playingSong === songName) {
            return
        }

        if (this.isPlaying && this.playingSong !== songName) {
            this.pause(context)
        }

        for (let i = 0; i < this.playList.audioFiles.length; i++) {
            if (this.playList.audioFiles[i].name === songName) {
                this.playingSong = songName
                this.preLoad(i, () => {
                    Logger.debug(localTag + ' preload callback')
                })
                break
            }
        }
    }

    /*
     * open and set source(player.src) of index's song
     */
    preLoad(index: number, callback) {
        Logger.debug(localTag + ' player preload ' + index + '/' + this.playList.audioFiles.length)
        if (index < 0 || index >= this.playList.audioFiles.length) {
            Logger.error(localTag + ' preload ignored')
            return
        }
        this.index = index
        let uri = this.playList.audioFiles[index].fileUri
        fileIO.open(uri, (err, fdNumber) => {
            let fdPath = 'fd://'
            let source = fdPath + fdNumber
            Logger.debug(localTag + ' preload source ' + source + ' filename=' + uri)
            if (typeof (err) !== 'undefined') {
                Logger.error(localTag + ' preload error, source=' + source)
                return
            }
            Logger.debug(localTag + ' preload source ' + source + ' begin')
            Logger.debug(localTag + ' player state=' + this.player.state)
            if (source === this.player.src) {
                Logger.debug(localTag + ' player preload finished, source not changed')
            } else {
                this.cancelTimer()
                this.notifyPlayingStatus(false)
                Logger.debug(localTag + ' player reset')
                this.player.reset()
                Logger.debug(localTag + ' player reset done, state=' + this.player.state)
                this.player.src = source
            }
            Logger.debug(localTag + ' player preload ' + source + ' end')
        })
        callback()
    }
}

/*
 * set audio player callback
 */
function setCallBack(audioPlayer: PlayerModel) {
    Logger.debug(localTag + ' set audio callback')
    audioPlayer.player.on('dataLoad', () => {
        Logger.debug(localTag + ' audio set source success')
    })

    audioPlayer.player.on('play', () => {
        Logger.debug(localTag + ' audio play success')
    })

    audioPlayer.player.on('pause', () => {
        Logger.debug(localTag + ' pause play success')
    })

    audioPlayer.player.on('stop', () => {
        Logger.debug(localTag + ' stop play success')
    })

    audioPlayer.player.on('reset', () => {
        Logger.debug(localTag + ' audio reset success')
    })

    audioPlayer.player.on('timeUpdate', (seekDonTime) => {
        if (typeof (seekDonTime) === 'undefined') {
            Logger.debug(localTag + ' audio seek fail')
            return
        }
        Logger.debug(localTag + ' audio seek success, and seek time is ' + seekDonTime)
    })

    audioPlayer.player.on('volumeChange', () => {
        Logger.debug(localTag + ' audio volumeChange success')
    })

    audioPlayer.player.on('finish', () => {
        Logger.debug(localTag + ' audio play finish')
        audioPlayer.reportPlayStatus(false)
    })

    audioPlayer.player.on('error', (error) => {
        Logger.error(`audio error called, errName is ${error.name}`)
        Logger.error(`audio error called, errCode is ${error.code}`)
        Logger.error(`audio error called, errMessage is ${error.message}`)
    })
}