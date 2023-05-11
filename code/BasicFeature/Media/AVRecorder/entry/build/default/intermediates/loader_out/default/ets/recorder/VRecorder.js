var _dc2c5df44f596112a82eb663dbdeca82;
/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\recorder\\VRecorder.ets?entry":
/*!**************************************************************************************************************************************!*\
  !*** D:\0510sample\applications_app_samples_0510\code\BasicFeature\Media\AVRecorder\entry\src\main\ets\recorder\VRecorder.ets?entry ***!
  \**************************************************************************************************************************************/
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {


var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", ({ value: true }));
let __generate__Id = 0;
function generateId() {
    return "VRecorder_" + ++__generate__Id;
}
/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
var _ohos_multimedia_camera_1  = globalThis.requireNapi('multimedia.camera') || (isSystemplugin('multimedia.camera', 'ohos') ? globalThis.ohosplugin.multimedia.camera : isSystemplugin('multimedia.camera', 'system') ? globalThis.systemplugin.multimedia.camera : undefined);
var _ohos_multimedia_media_1  = globalThis.requireNapi('multimedia.media') || (isSystemplugin('multimedia.media', 'ohos') ? globalThis.ohosplugin.multimedia.media : isSystemplugin('multimedia.media', 'system') ? globalThis.systemplugin.multimedia.media : undefined);
const DateTimeUtils_1 = __webpack_require__(/*! ../utils/DateTimeUtils */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\DateTimeUtils.ets");
const Logger_1 = __importDefault(__webpack_require__(/*! ../utils/Logger */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\Logger.ets"));
const SaveCameraAsset_1 = __importDefault(__webpack_require__(/*! ../utils/SaveCameraAsset */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\SaveCameraAsset.ets"));
const TAG = 'Sample_VideoRecorder';
class videoRecording extends View {
    constructor(compilerAssignedUniqueChildId, parent, params) {
        super(compilerAssignedUniqueChildId, parent);
        this.surfaceId = '';
        this.xcomponentController = new XComponentController();
        this.videoRecorder = undefined;
        this.cameraManager = undefined;
        this.cameras = undefined;
        this.cameraInput = undefined;
        this.captureSession = undefined;
        this.previewOutput = undefined;
        this.videoOutput = undefined;
        this.videoOutSurfaceId = '';
        this.fdPath = undefined;
        this.__videoRecorderTimeText = new ObservedPropertySimple('00:00', this, "videoRecorderTimeText");
        this.seconds = 0;
        this.timer = 0;
        this.cameraIndex = 0;
        this.__videoResolution = new ObservedPropertyObject({ 'frameWidth': 1280, 'frameHeight': 720 }, this, "videoResolution");
        this.__framerate = new ObservedPropertySimple(30, this, "framerate");
        this.__videoCodecType = new ObservedPropertySimple('video/avc', this, "videoCodecType");
        this.recorderState = 'free';
        this.__isStartRecording = new ObservedPropertySimple(false, this, "isStartRecording");
        this.__isPauseRecording = new ObservedPropertySimple(false, this, "isPauseRecording");
        this.mSaveCameraAsset = new SaveCameraAsset_1.default(TAG);
        this.mFileAssetId = 0;
        this.cameraOutputCapability = undefined;
        this.videoProfiles = undefined;
        this.previewProfiles = undefined;
        this.avProfile = {
            audioBitrate: 200000,
            audioChannels: 2,
            audioCodec: _ohos_multimedia_media_1.CodecMimeType.AUDIO_AAC,
            audioSampleRate: 48000,
            fileFormat: _ohos_multimedia_media_1.ContainerFormatType.CFT_MPEG_4,
            videoBitrate: 300000,
            videoCodec: _ohos_multimedia_media_1.CodecMimeType.VIDEO_AVC,
            videoFrameWidth: 640,
            videoFrameHeight: 480,
            videoFrameRate: 30 // set videoFrameRate according to device ability
        };
        this.avConfig = {
            audioSourceType: _ohos_multimedia_media_1.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
            videoSourceType: _ohos_multimedia_media_1.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV,
            profile: this.avProfile,
            url: 'fd://',
            rotation: 90,
            location: { latitude: 30, longitude: 130 } // the location you recorde
        };
        this.settingDialog = new CustomDialogController({
            builder: () => {
                let jsDialog = new CustomDialogSetting("2", this, {
                    cancel: this.onCancel,
                    confirm: this.onAccept,
                    videoResolution: this.__videoResolution,
                    videoFrameRate: this.__framerate,
                    videoCodec: this.__videoCodecType,
                });
                jsDialog.setController(this.settingDialog);
                View.create(jsDialog);
            },
            cancel: this.existApp,
            autoCancel: false,
            alignment: DialogAlignment.Bottom,
            customStyle: true
        }, this);
        this.updateWithValueParams(params);
    }
    updateWithValueParams(params) {
        if (params.surfaceId !== undefined) {
            this.surfaceId = params.surfaceId;
        }
        if (params.xcomponentController !== undefined) {
            this.xcomponentController = params.xcomponentController;
        }
        if (params.videoRecorder !== undefined) {
            this.videoRecorder = params.videoRecorder;
        }
        if (params.cameraManager !== undefined) {
            this.cameraManager = params.cameraManager;
        }
        if (params.cameras !== undefined) {
            this.cameras = params.cameras;
        }
        if (params.cameraInput !== undefined) {
            this.cameraInput = params.cameraInput;
        }
        if (params.captureSession !== undefined) {
            this.captureSession = params.captureSession;
        }
        if (params.previewOutput !== undefined) {
            this.previewOutput = params.previewOutput;
        }
        if (params.videoOutput !== undefined) {
            this.videoOutput = params.videoOutput;
        }
        if (params.videoOutSurfaceId !== undefined) {
            this.videoOutSurfaceId = params.videoOutSurfaceId;
        }
        if (params.fdPath !== undefined) {
            this.fdPath = params.fdPath;
        }
        if (params.videoRecorderTimeText !== undefined) {
            this.videoRecorderTimeText = params.videoRecorderTimeText;
        }
        if (params.seconds !== undefined) {
            this.seconds = params.seconds;
        }
        if (params.timer !== undefined) {
            this.timer = params.timer;
        }
        if (params.cameraIndex !== undefined) {
            this.cameraIndex = params.cameraIndex;
        }
        if (params.videoResolution !== undefined) {
            this.videoResolution = params.videoResolution;
        }
        if (params.framerate !== undefined) {
            this.framerate = params.framerate;
        }
        if (params.videoCodecType !== undefined) {
            this.videoCodecType = params.videoCodecType;
        }
        if (params.recorderState !== undefined) {
            this.recorderState = params.recorderState;
        }
        if (params.isStartRecording !== undefined) {
            this.isStartRecording = params.isStartRecording;
        }
        if (params.isPauseRecording !== undefined) {
            this.isPauseRecording = params.isPauseRecording;
        }
        if (params.mSaveCameraAsset !== undefined) {
            this.mSaveCameraAsset = params.mSaveCameraAsset;
        }
        if (params.mFileAssetId !== undefined) {
            this.mFileAssetId = params.mFileAssetId;
        }
        if (params.cameraOutputCapability !== undefined) {
            this.cameraOutputCapability = params.cameraOutputCapability;
        }
        if (params.videoProfiles !== undefined) {
            this.videoProfiles = params.videoProfiles;
        }
        if (params.previewProfiles !== undefined) {
            this.previewProfiles = params.previewProfiles;
        }
        if (params.avProfile !== undefined) {
            this.avProfile = params.avProfile;
        }
        if (params.avConfig !== undefined) {
            this.avConfig = params.avConfig;
        }
        if (params.settingDialog !== undefined) {
            this.settingDialog = params.settingDialog;
        }
    }
    aboutToBeDeleted() {
        this.__videoRecorderTimeText.aboutToBeDeleted();
        this.__videoResolution.aboutToBeDeleted();
        this.__framerate.aboutToBeDeleted();
        this.__videoCodecType.aboutToBeDeleted();
        this.__isStartRecording.aboutToBeDeleted();
        this.__isPauseRecording.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id());
    }
    get videoRecorderTimeText() {
        return this.__videoRecorderTimeText.get();
    }
    set videoRecorderTimeText(newValue) {
        this.__videoRecorderTimeText.set(newValue);
    }
    get videoResolution() {
        return this.__videoResolution.get();
    }
    set videoResolution(newValue) {
        this.__videoResolution.set(newValue);
    }
    get framerate() {
        return this.__framerate.get();
    }
    set framerate(newValue) {
        this.__framerate.set(newValue);
    }
    get videoCodecType() {
        return this.__videoCodecType.get();
    }
    set videoCodecType(newValue) {
        this.__videoCodecType.set(newValue);
    }
    get isStartRecording() {
        return this.__isStartRecording.get();
    }
    set isStartRecording(newValue) {
        this.__isStartRecording.set(newValue);
    }
    get isPauseRecording() {
        return this.__isPauseRecording.get();
    }
    set isPauseRecording(newValue) {
        this.__isPauseRecording.set(newValue);
    }
    aboutToAppear() {
        Logger_1.default.info(TAG, 'aboutToAppear');
    }
    aboutToDisappear() {
        Logger_1.default.info(TAG, 'aboutToDisappear called');
        this.releaseCamera();
    }
    onPageShow() {
        console.info(TAG, 'onPageShow called');
        this.enterInit();
    }
    onPageHide() {
        console.info(TAG, 'onPageHide called');
        this.stopRecordingProcess();
    }
    async failureCallback(error) {
        Logger_1.default.info(TAG, 'case failureCallback called,errMessage is ' + error.message);
    }
    async catchCallback(error) {
        Logger_1.default.info(TAG, 'case catchCallback called,errMessage is ' + error.message);
    }
    // show recording time
    getRecordTime() {
        this.timer = setInterval(() => {
            this.seconds += 1;
            this.videoRecorderTimeText = DateTimeUtils_1.dateTime(this.seconds);
        }, 1000);
    }
    // get recording file fd
    async getFileFd() {
        Logger_1.default.info(TAG, 'getFileFd called');
        this.mFileAssetId = await this.mSaveCameraAsset.createVideoFd();
        this.fdPath = 'fd://' + this.mFileAssetId.toString();
        this.avConfig.url = this.fdPath;
        Logger_1.default.info(TAG, 'fdPath is: ' + this.fdPath);
        Logger_1.default.info(TAG, 'getFileFd done');
    }
    // get camera ability
    async initCamera() {
        Logger_1.default.info(TAG, 'init camera called');
        if (this.cameraManager) {
            Logger_1.default.info(TAG, 'cameraManager already exits');
            return;
        }
        Logger_1.default.info(TAG, '[camera] case to get cameraManager');
        this.cameraManager = _ohos_multimedia_camera_1.getCameraManager(globalThis.abilityContext);
        if (this.cameraManager) {
            Logger_1.default.info(TAG, '[camera] case getCameraManager success');
        }
        else {
            Logger_1.default.info(TAG, '[camera] case getCameraManager failed');
            return;
        }
        this.cameras = this.cameraManager.getSupportedCameras();
        if (this.cameras) {
            Logger_1.default.info(TAG, '[camera] case getCameras success');
        }
        else {
            Logger_1.default.info(TAG, '[camera] case getCameras failed');
        }
        this.cameraOutputCapability = this.cameraManager.getSupportedOutputCapability(this.cameras[this.cameraIndex]);
        this.videoProfiles = this.cameraOutputCapability.videoProfiles;
        Logger_1.default.info(TAG, 'init camera done');
    }
    // create camera input
    async createCameraInput() {
        Logger_1.default.info(TAG, 'createCameraInput called');
        this.cameraInput = this.cameraManager.createCameraInput(this.cameras[this.cameraIndex]);
        if (this.cameraInput) {
            Logger_1.default.info(TAG, '[camera] case createCameraInput success');
        }
        else {
            Logger_1.default.info(TAG, '[camera] case createCameraInput failed');
            return;
        }
        await this.cameraInput.open().then(() => {
            Logger_1.default.info(TAG, '[camera] case cameraInput.open() called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    // create camera preview
    async createPreviewOutput() {
        Logger_1.default.info(TAG, 'createPreviewOutput called');
        this.previewProfiles = this.cameraOutputCapability.previewProfiles;
        this.previewProfiles[0].size.height = this.videoResolution['frameHeight'];
        this.previewProfiles[0].size.width = this.videoResolution['frameWidth'];
        if (this.previewProfiles[0].format === _ohos_multimedia_camera_1.CameraFormat.CAMERA_FORMAT_YUV_420_SP) {
            Logger_1.default.info(TAG, '[camera] case format is VIDEO_SOURCE_TYPE_SURFACE_YUV');
            this.avConfig.videoSourceType = _ohos_multimedia_media_1.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
        }
        else {
            Logger_1.default.info(TAG, '[camera] case format is VIDEO_SOURCE_TYPE_SURFACE_ES');
            this.avConfig.videoSourceType = _ohos_multimedia_media_1.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_ES;
        }
        this.previewOutput = this.cameraManager.createPreviewOutput(this.previewProfiles[0], this.surfaceId);
        if (!this.previewOutput) {
            Logger_1.default.info(TAG, 'create previewOutput failed!');
        }
        Logger_1.default.info(TAG, 'createPreviewOutput done');
    }
    // create camera capture session
    async createCaptureSession() {
        Logger_1.default.info(TAG, 'createCaptureSession called');
        this.captureSession = this.cameraManager.createCaptureSession();
        if (!this.captureSession) {
            Logger_1.default.info(TAG, 'createCaptureSession failed!');
            return;
        }
        this.captureSession.beginConfig();
        this.captureSession.addInput(this.cameraInput);
        this.captureSession.addOutput(this.previewOutput);
        await this.captureSession.commitConfig().then(() => {
            Logger_1.default.info(TAG, 'case commitConfig success');
        }, this.failureCallback).catch(this.catchCallback);
    }
    // start captureSession
    async startCaptureSession() {
        Logger_1.default.info(TAG, 'startCaptureSession called');
        if (!this.captureSession) {
            Logger_1.default.info(TAG, 'CaptureSession does not exists!');
            return;
        }
        await this.captureSession.start().then(() => {
            Logger_1.default.info(TAG, 'case start captureSession success');
        }, this.failureCallback).catch(this.catchCallback);
    }
    // remove previous videoOutput
    async removeVideoOutput() {
        Logger_1.default.info(TAG, 'removeVideoOutput called');
        if (this.videoOutput) {
            Logger_1.default.info(TAG, 'videoOutput already exits, remove it');
            this.captureSession.removeOutput(this.videoOutput);
            Logger_1.default.info(TAG, 'remove videoOutput done');
        }
        Logger_1.default.info(TAG, 'removeVideoOutput done');
    }
    // create video output
    async createVideoOutput() {
        Logger_1.default.info(TAG, 'createVideoOutput called');
        if (this.videoRecorder) {
            this.videoProfiles[this.cameraIndex].size.height = this.videoResolution['frameHeight'];
            this.videoProfiles[this.cameraIndex].size.width = this.videoResolution['frameWidth'];
            this.videoOutput = this.cameraManager.createVideoOutput(this.videoProfiles[this.cameraIndex], this.videoOutSurfaceId);
            if (!this.videoOutput) {
                Logger_1.default.info(TAG, '[camera] case create videoOutPut fail!!!');
                return;
            }
            else {
                Logger_1.default.info(TAG, '[camera] case create videoOutPut done, videoOutPut is not null');
            }
        }
        else {
            Logger_1.default.info(TAG, 'videoRecorder is null, createVideoOutput failed');
            return;
        }
    }
    // add video output into CaptureSession
    async restartVideoOutput() {
        Logger_1.default.info(TAG, 'restartVideoOutput called');
        await this.captureSession.stop().then(() => {
            Logger_1.default.info(TAG, 'case stop captureSession success');
        }, this.failureCallback).catch(this.catchCallback);
        this.captureSession.beginConfig();
        await this.removeVideoOutput();
        await this.createVideoOutput();
        this.captureSession.addOutput(this.videoOutput);
        await this.captureSession.commitConfig().then(() => {
            Logger_1.default.info(TAG, 'case commitConfig success');
        }, this.failureCallback).catch(this.catchCallback);
        await this.startCaptureSession();
        if (this.videoOutput) {
            await this.videoOutput.start().then(() => {
                Logger_1.default.info(TAG, '[camera] case videoOutput start success');
            }, this.failureCallback).catch(this.catchCallback);
        }
        else {
            Logger_1.default.info(TAG, 'videoOutput is null!!!');
            return;
        }
    }
    // start videoOutput
    async startVideoOutput() {
        Logger_1.default.info(TAG, 'startVideoOutput called');
        if (this.videoOutput) {
            await this.videoOutput.start().then(() => {
                Logger_1.default.info(TAG, '[camera] case videoOutput start success');
            }, this.failureCallback).catch(this.catchCallback);
        }
        else {
            Logger_1.default.info(TAG, 'videoOutput is null!!!');
            return;
        }
    }
    // stop videoOutput
    async stopVideoOutput() {
        Logger_1.default.info(TAG, 'stopVideoOutput called');
        if (this.videoOutput) {
            await this.videoOutput.stop().then(() => {
                Logger_1.default.info(TAG, '[camera] case videoOutput stop success');
            }, this.failureCallback).catch(this.catchCallback);
        }
        else {
            Logger_1.default.info(TAG, 'videoOutput is null!!!');
            return;
        }
    }
    // release camera
    async releaseCameraInput() {
        Logger_1.default.info(TAG, 'releaseCameraInput called');
        if (this.cameraInput) {
            this.cameraInput = null;
        }
        Logger_1.default.info(TAG, 'releaseCameraInput done');
    }
    // release preview
    async releasePreviewOutput() {
        Logger_1.default.info(TAG, 'releasePreviewOutput called');
        if (this.previewOutput) {
            await this.previewOutput.release().then(() => {
                Logger_1.default.info('[camera] case main previewOutput release called');
            }, this.failureCallback).catch(this.catchCallback);
            this.previewOutput = null;
        }
        Logger_1.default.info(TAG, 'releasePreviewOutput done');
    }
    // release video output
    async releaseVideoOutput() {
        Logger_1.default.info(TAG, 'releaseVideoOutput called');
        if (this.videoOutput) {
            await this.videoOutput.release().then(() => {
                Logger_1.default.info('[camera] case main videoOutput release called');
            }, this.failureCallback).catch(this.catchCallback);
            this.videoOutput = null;
        }
        Logger_1.default.info(TAG, 'releaseVideoOutput done');
    }
    // stop captureSession
    async stopCaptureSession() {
        Logger_1.default.info(TAG, 'stopCaptureSession called');
        if (this.captureSession) {
            await this.captureSession.stop().then(() => {
                Logger_1.default.info('[camera] case main captureSession stop success');
            }, this.failureCallback).catch(this.catchCallback);
        }
        Logger_1.default.info(TAG, 'stopCaptureSession done');
    }
    // release captureSession
    async releaseCaptureSession() {
        Logger_1.default.info(TAG, 'releaseCaptureSession called');
        if (this.captureSession) {
            await this.captureSession.release().then(() => {
                Logger_1.default.info('[camera] case main captureSession release success');
            }, this.failureCallback).catch(this.catchCallback);
            this.captureSession = null;
        }
        Logger_1.default.info(TAG, 'releaseCaptureSession done');
    }
    // clear camera environment
    async releaseCamera() {
        Logger_1.default.info(TAG, 'releaseCamera called');
        await this.stopCaptureSession();
        await this.releaseCameraInput();
        await this.releasePreviewOutput();
        await this.releaseVideoOutput();
        await this.releaseCaptureSession();
        Logger_1.default.info(TAG, 'releaseCamera done');
    }
    // set callback on
    setCallback() {
        Logger_1.default.info('case callback');
        this.videoRecorder.on('stateChange', (state, reason) => {
            Logger_1.default.info('case state has changed, new state is' + state);
            switch (state) {
                case 'idle':
                    this.recorderState = 'idle';
                    break;
                case 'prepared':
                    this.recorderState = 'prepared';
                    break;
                case 'started':
                    this.recorderState = 'started';
                    this.getRecordTime();
                    this.isStartRecording = true;
                    this.isPauseRecording = false;
                    break;
                case 'paused':
                    this.recorderState = 'paused';
                    clearInterval(this.timer);
                    this.isPauseRecording = true;
                    break;
                case 'stopped':
                    this.recorderState = 'stopped';
                    this.isStartRecording = false;
                    break;
                case 'released':
                    this.recorderState = 'released';
                    break;
                case 'error':
                    Logger_1.default.info('case error state!!!');
                    this.recorderState = 'error';
                    break;
                default:
                    Logger_1.default.info('case start is unknown');
                    break;
            }
        });
        this.videoRecorder.on('error', (err) => {
            Logger_1.default.info(TAG, 'case avRecorder.on(error) called, errMessage is ' + err.message);
        });
    }
    async createVideoRecorder() {
        await _ohos_multimedia_media_1.createAVRecorder().then((recorder) => {
            Logger_1.default.info(TAG, 'case createAVRecorder called');
            if (typeof (recorder) !== 'undefined') {
                this.videoRecorder = recorder;
            }
            else {
                Logger_1.default.info(TAG, 'case create avRecorder failed!!!');
                return;
            }
        }, this.failureCallback).catch(this.catchCallback);
        this.setCallback();
    }
    async prepareVideoRecorder() {
        Logger_1.default.info(TAG, 'case prepareVideoRecorder in');
        if (this.videoCodecType === 'video/mpeg4') {
            this.avConfig.profile.videoCodec = _ohos_multimedia_media_1.CodecMimeType.VIDEO_MPEG4;
        }
        else {
            this.avConfig.profile.videoCodec = _ohos_multimedia_media_1.CodecMimeType.VIDEO_AVC;
        }
        this.avConfig.profile.videoFrameHeight = this.videoResolution['frameHeight'];
        this.avConfig.profile.videoFrameWidth = this.videoResolution['frameWidth'];
        this.avConfig.profile.videoFrameRate = this.framerate;
        await this.videoRecorder.prepare(this.avConfig).then(() => {
            Logger_1.default.info(TAG, 'case prepare AVRecorder called');
        }, this.failureCallback).catch(this.catchCallback);
        Logger_1.default.info(TAG, 'case prepareVideoRecorder out');
    }
    async getInputSurface() {
        Logger_1.default.info(TAG, 'case getInputSurface in');
        await this.videoRecorder.getInputSurface().then((outPutSurface) => {
            Logger_1.default.info('case getInputSurface called');
            if (!outPutSurface) {
                Logger_1.default.error(TAG, 'case getInputSurface ID is none');
                return;
            }
            this.videoOutSurfaceId = outPutSurface;
            Logger_1.default.info(TAG, 'case outPutSurface surfaceID is: ${this.videoOutSurfaceId}');
        }, this.failureCallback).catch(this.catchCallback);
        Logger_1.default.info(TAG, 'case getInputSurface out');
    }
    async startVideoRecording() {
        Logger_1.default.info(TAG, 'case startVideoRecording called');
        await this.videoRecorder.start().then(() => {
            Logger_1.default.info(TAG, 'case start VideoRecorder called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    async pauseVideoRecording() {
        Logger_1.default.info(TAG, 'case pauseVideoRecording called');
        await this.videoRecorder.pause().then(() => {
            Logger_1.default.info(TAG, 'case pause VideoRecorder called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    async resumeVideoRecording() {
        Logger_1.default.info(TAG, 'case resumeVideoRecording called');
        await this.videoRecorder.resume().then(() => {
            Logger_1.default.info(TAG, 'case resume VideoRecorder called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    async stopVideoRecording() {
        Logger_1.default.info(TAG, 'case stopVideoRecording called');
        await this.videoRecorder.stop().then(() => {
            Logger_1.default.info(TAG, 'case stop VideoRecorder called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    async resetVideoRecording() {
        await this.videoRecorder.reset().then(() => {
            Logger_1.default.info(TAG, 'case resetVideoRecording called');
        }, this.failureCallback).catch(this.catchCallback);
    }
    async releaseVideoRecorder() {
        if (this.videoRecorder) {
            this.videoRecorder.off('stateChange');
            this.videoRecorder.off('error');
            await this.videoRecorder.release().then(() => {
                Logger_1.default.info(TAG, 'case releaseVideoRecorder called');
            }, this.failureCallback).catch(this.catchCallback);
            this.videoRecorder = undefined;
        }
    }
    // close file fd
    async closeFd() {
        Logger_1.default.info(TAG, 'case closeFd called');
        if (this.fdPath) {
            await this.mSaveCameraAsset.VideoPrepareFile.close(this.mFileAssetId);
            this.mFileAssetId = undefined;
            this.fdPath = undefined;
            Logger_1.default.info(TAG, 'case closeFd done');
        }
    }
    // init camera
    async enterInit() {
        Logger_1.default.info(TAG, 'enterInit called');
        await this.initCamera(); // 获取设备相机信息
        await this.createCameraInput(); // 打开相机
        await this.createPreviewOutput(); // 预览流
        await this.createCaptureSession(); // 会话，保存一次相机运行需要的所有资源，并向相机设备申请完成相机功能
        await this.startCaptureSession(); // 开启会话
        Logger_1.default.info(TAG, 'exit enterInit');
    }
    // start button process
    async startRecordingProcess() {
        Logger_1.default.info(TAG, 'startRecording called');
        await this.createVideoRecorder();
        await this.getFileFd();
        await this.prepareVideoRecorder();
        await this.getInputSurface();
        await this.restartVideoOutput();
        await this.startVideoRecording();
        Logger_1.default.info(TAG, 'startRecording done');
    }
    // pause button process
    async pauseRecordingProcess() {
        Logger_1.default.info(TAG, 'pauseRecording called');
        if (this.recorderState === 'started') {
            Logger_1.default.info(TAG, 'current state is started, to pause');
            await this.pauseVideoRecording();
            await this.stopVideoOutput();
        }
        Logger_1.default.info(TAG, 'pauseRecording done');
    }
    // resume button process
    async resumeRecordingProcess() {
        Logger_1.default.info(TAG, 'resumeRecording called');
        if (this.recorderState === 'paused') {
            Logger_1.default.info(TAG, 'current state is paused, to resume');
            await this.startVideoOutput();
            await this.resumeVideoRecording();
        }
        Logger_1.default.info(TAG, 'resumeRecording done');
    }
    // stop button process
    async stopRecordingProcess() {
        Logger_1.default.info(TAG, 'stopRecording called');
        if (this.recorderState === 'started' || this.recorderState === 'paused') {
            await this.stopVideoRecording();
        }
        await this.resetVideoRecording();
        await this.releaseVideoRecorder();
        await this.stopVideoOutput();
        this.videoOutput = undefined;
        await this.closeFd();
        clearInterval(this.timer);
        this.isStartRecording = false;
        this.isPauseRecording = false;
        this.seconds = 0;
        this.videoRecorderTimeText = '00:00';
        Logger_1.default.info(TAG, 'stopRecording done');
    }
    render() {
        Column.create();
        Row.create();
        Stack.create({ alignContent: Alignment.Center });
        Stack.width('100%');
        Stack.height('100%');
        XComponent.create({
            id: 'xcomponent1',
            type: 'surface',
            controller: this.xcomponentController
        });
        XComponent.onLoad(() => {
            this.xcomponentController.setXComponentSurfaceSize({ surfaceWidth: 1920, surfaceHeight: 1080 });
            this.surfaceId = this.xcomponentController.getXComponentSurfaceId();
            Logger_1.default.info(TAG, '[VideoRecorder] surfaceId: ' + this.surfaceId);
            Logger_1.default.info(TAG, 'XComponent1 loaded');
            this.enterInit();
        });
        XComponent.width('100%');
        XComponent.height('100%');
        XComponent.pop();
        Text.create(this.videoRecorderTimeText);
        Text.fontFamily('HarmonyHeiTi-Light');
        Text.width(70);
        Text.height(40);
        Text.fontSize(27);
        Text.fontColor('white');
        Text.margin({ left: 155, top: 18, right: 135, bottom: 707 });
        Text.pop();
        If.create();
        if (!this.isStartRecording) {
            If.branchId(0);
            Image.create({ "id": 16777235, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Image.width(40);
            Image.height(40);
            Image.margin({ left: 12, top: 12, right: 308, bottom: 704 });
            Image.onClick(() => {
                if (this.settingDialog !== undefined) {
                    Logger_1.default.info(TAG, 'to open setting dialog');
                    this.settingDialog.open();
                }
            });
            Image.id('videoSetting');
            Image.create({ "id": 16777234, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Image.width(12);
            Image.height(12);
            Image.margin({ left: 136, top: 25, right: 212, bottom: 715 });
            Image.create({ "id": 16777239, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Image.width(86);
            Image.height(86);
            Image.margin({ left: 132, top: 612, right: 132, bottom: 72 });
            Image.onClick(() => this.startRecordingProcess());
            Image.id('videoStart');
        }
        else {
            If.branchId(1);
            Image.create({ "id": 16777231, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Image.width(120);
            Image.height(56);
            Image.margin({ left: 120, top: 632, right: 120, bottom: 92 });
            Image.create({ "id": 16777237, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Image.width(16);
            Image.height(16);
            Image.margin({ left: 146, top: 652, right: 198, bottom: 112 });
            Image.onClick(() => this.stopRecordingProcess());
            Image.id('videoStop');
            If.create();
            if (!this.isPauseRecording) {
                If.branchId(0);
                Image.create({ "id": 16777234, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
                Image.width(12);
                Image.height(12);
                Image.margin({ left: 136, top: 25, right: 212, bottom: 715 });
                Image.create({ "id": 16777233, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
                Image.width(14);
                Image.height(15);
                Image.margin({ left: 200, top: 652, right: 146, bottom: 113 });
                Image.onClick(() => this.pauseRecordingProcess());
                Image.id('videoPause');
            }
            else {
                If.branchId(1);
                Image.create({ "id": 16777236, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
                Image.width(14);
                Image.height(14);
                Image.margin({ left: 136, top: 25, right: 212, bottom: 715 });
                Image.create({ "id": 16777232, "type": 20000, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
                Image.width(16);
                Image.height(16);
                Image.margin({ left: 198, top: 651, right: 144, bottom: 111 });
                Image.onClick(() => this.resumeRecordingProcess());
                Image.id('videoResume');
            }
            If.pop();
        }
        If.pop();
        Stack.pop();
        Row.pop();
        Column.pop();
    }
    onCancel() {
        Logger_1.default.info(TAG, 'Callback when the cancel button is clicked');
    }
    onAccept() {
        Logger_1.default.info(TAG, 'Callback when the confirm button is clicked');
    }
    existApp() {
        Logger_1.default.info(TAG, 'Click the callback in the blank area');
    }
}
class CustomDialogSetting extends View {
    constructor(compilerAssignedUniqueChildId, parent, params) {
        super(compilerAssignedUniqueChildId, parent);
        this.__videoResolution = new SynchedPropertyObjectTwoWay(params.videoResolution, this, "videoResolution");
        this.__videoFrameRate = new SynchedPropertySimpleTwoWay(params.videoFrameRate, this, "videoFrameRate");
        this.__videoCodec = new SynchedPropertySimpleTwoWay(params.videoCodec, this, "videoCodec");
        this.controller = undefined;
        this.cancel = undefined;
        this.confirm = undefined;
        this.__currentVideoResolution = new ObservedPropertyObject({ 'frameWidth': 1280, 'frameHeight': 720 }, this, "currentVideoResolution");
        this.__currentVideoResolutionText = new ObservedPropertySimple('[16:9]720p', this, "currentVideoResolutionText");
        this.__currentVideoFramerate = new ObservedPropertySimple(30, this, "currentVideoFramerate");
        this.__currentVideoCodec = new ObservedPropertySimple('video/avc', this, "currentVideoCodec");
        this.initVideoResolution = this.videoResolution;
        this.initVideoFramerate = this.videoFrameRate;
        this.initVideoCodec = this.videoCodec;
        this.__videoResolutionList = new ObservedPropertyObject([
            { 'itemValue': '16:9 (720p)', 'value': { 'frameWidth': 1280, 'frameHeight': 720 } },
            { 'itemValue': '16:9 (1080p)', 'value': { 'frameWidth': 1920, 'frameHeight': 1080 } },
        ], this, "videoResolutionList");
        this.__videoFrameRateList = new ObservedPropertyObject([
            { 'itemValue': '30fps', 'value': 30 },
        ], this, "videoFrameRateList");
        this.__videoCodecList = new ObservedPropertyObject([
            { 'itemValue': 'video/avc', 'value': 'video/avc' },
            { 'itemValue': 'video/mpeg4', 'value': 'video/mpeg4' },
        ], this, "videoCodecList");
        this.updateWithValueParams(params);
    }
    updateWithValueParams(params) {
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
        if (params.cancel !== undefined) {
            this.cancel = params.cancel;
        }
        if (params.confirm !== undefined) {
            this.confirm = params.confirm;
        }
        if (params.currentVideoResolution !== undefined) {
            this.currentVideoResolution = params.currentVideoResolution;
        }
        if (params.currentVideoResolutionText !== undefined) {
            this.currentVideoResolutionText = params.currentVideoResolutionText;
        }
        if (params.currentVideoFramerate !== undefined) {
            this.currentVideoFramerate = params.currentVideoFramerate;
        }
        if (params.currentVideoCodec !== undefined) {
            this.currentVideoCodec = params.currentVideoCodec;
        }
        if (params.initVideoResolution !== undefined) {
            this.initVideoResolution = params.initVideoResolution;
        }
        if (params.initVideoFramerate !== undefined) {
            this.initVideoFramerate = params.initVideoFramerate;
        }
        if (params.initVideoCodec !== undefined) {
            this.initVideoCodec = params.initVideoCodec;
        }
        if (params.videoResolutionList !== undefined) {
            this.videoResolutionList = params.videoResolutionList;
        }
        if (params.videoFrameRateList !== undefined) {
            this.videoFrameRateList = params.videoFrameRateList;
        }
        if (params.videoCodecList !== undefined) {
            this.videoCodecList = params.videoCodecList;
        }
    }
    aboutToBeDeleted() {
        this.__videoResolution.aboutToBeDeleted();
        this.__videoFrameRate.aboutToBeDeleted();
        this.__videoCodec.aboutToBeDeleted();
        this.__currentVideoResolution.aboutToBeDeleted();
        this.__currentVideoResolutionText.aboutToBeDeleted();
        this.__currentVideoFramerate.aboutToBeDeleted();
        this.__currentVideoCodec.aboutToBeDeleted();
        this.__videoResolutionList.aboutToBeDeleted();
        this.__videoFrameRateList.aboutToBeDeleted();
        this.__videoCodecList.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id());
    }
    get videoResolution() {
        return this.__videoResolution.get();
    }
    set videoResolution(newValue) {
        this.__videoResolution.set(newValue);
    }
    get videoFrameRate() {
        return this.__videoFrameRate.get();
    }
    set videoFrameRate(newValue) {
        this.__videoFrameRate.set(newValue);
    }
    get videoCodec() {
        return this.__videoCodec.get();
    }
    set videoCodec(newValue) {
        this.__videoCodec.set(newValue);
    }
    setController(ctr) {
        this.controller = ctr;
    }
    get currentVideoResolution() {
        return this.__currentVideoResolution.get();
    }
    set currentVideoResolution(newValue) {
        this.__currentVideoResolution.set(newValue);
    }
    get currentVideoResolutionText() {
        return this.__currentVideoResolutionText.get();
    }
    set currentVideoResolutionText(newValue) {
        this.__currentVideoResolutionText.set(newValue);
    }
    get currentVideoFramerate() {
        return this.__currentVideoFramerate.get();
    }
    set currentVideoFramerate(newValue) {
        this.__currentVideoFramerate.set(newValue);
    }
    get currentVideoCodec() {
        return this.__currentVideoCodec.get();
    }
    set currentVideoCodec(newValue) {
        this.__currentVideoCodec.set(newValue);
    }
    get videoResolutionList() {
        return this.__videoResolutionList.get();
    }
    set videoResolutionList(newValue) {
        this.__videoResolutionList.set(newValue);
    }
    get videoFrameRateList() {
        return this.__videoFrameRateList.get();
    }
    set videoFrameRateList(newValue) {
        this.__videoFrameRateList.set(newValue);
    }
    get videoCodecList() {
        return this.__videoCodecList.get();
    }
    set videoCodecList(newValue) {
        this.__videoCodecList.set(newValue);
    }
    render() {
        Column.create();
        Column.margin({ left: 12, right: 12, bottom: 12 });
        Column.backgroundColor('#FFFFFF');
        Column.borderRadius(32);
        Column.alignItems(HorizontalAlign.Center);
        Column.create();
        Column.alignItems(HorizontalAlign.Start);
        Text.create({ "id": 16777228, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Text.fontFamily('HarmonyHeiTi-Medium');
        Text.fontSize(20);
        Text.width(288);
        Text.height(26);
        Text.margin({ left: 24, top: 16, right: 24 });
        Text.pop();
        Column.create();
        Column.margin({ left: 24, right: 24, top: 16 });
        List.create({ space: 10 });
        List.listDirection(Axis.Vertical);
        List.divider({ strokeWidth: 0.5, color: '#EEEEEE', startMargin: 0, endMargin: 0 });
        ForEach.create("3", this, ObservedObject.GetRawObject(this.videoResolutionList), (item, index) => {
            ListItem.create();
            Row.create();
            Row.margin({ left: 0, right: 39 });
            Text.create({ "id": 16777229, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
            Text.fontSize(16);
            Text.pop();
            Text.create(item.itemValue.toString());
            Text.fontSize(16);
            Text.width(160);
            Text.fontFamily('HarmonyHeiTi-Medium');
            Text.pop();
            Radio.create({ value: item.value.toString(), group: 'radioGroup' });
            Radio.checked(item.value['frameWidth'] == this.initVideoResolution['frameWidth']);
            Radio.height(24);
            Radio.onChange((isChecked) => {
                if (isChecked) {
                    Logger_1.default.info(TAG, item.itemValue + ' resolution is clicked');
                    this.currentVideoResolution = item.value;
                    this.currentVideoResolutionText = item.itemValue;
                }
            });
            Row.pop();
            ListItem.pop();
        });
        ForEach.pop();
        List.pop();
        Column.pop();
        Column.pop();
        Row.create();
        Row.width(300);
        Row.height(40);
        Row.margin({ left: 24, right: 24, top: 12, bottom: 16 });
        Button.createWithLabel({ "id": 16777222, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Button.onClick(() => {
            this.videoResolution = this.initVideoResolution;
            this.videoFrameRate = this.initVideoFramerate;
            this.videoCodec = this.initVideoCodec;
            this.controller.close();
            this.cancel();
        });
        Button.backgroundColor('#FFFFFF');
        Button.fontColor('#007DFF');
        Button.fontFamily('HarmonyHeiTi-Medium');
        Button.fontSize(16);
        Button.id('cancel');
        Button.layoutWeight(1);
        Button.pop();
        Divider.create();
        Divider.vertical(true);
        Divider.height(24);
        Divider.color('#182431');
        Divider.opacity(0.6);
        Divider.margin({ left: 8, right: 8 });
        Button.createWithLabel({ "id": 16777223, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Button.onClick(() => {
            this.videoResolution = this.currentVideoResolution;
            this.videoFrameRate = this.currentVideoFramerate;
            this.videoCodec = this.currentVideoCodec;
            this.controller.close();
            this.confirm();
        });
        Button.backgroundColor('#FFFFFF');
        Button.fontColor('#007DFF');
        Button.fontFamily('HarmonyHeiTi-Medium');
        Button.fontSize(16);
        Button.id('confirm');
        Button.layoutWeight(1);
        Button.pop();
        Row.pop();
        Column.pop();
    }
}
loadDocument(new videoRecording("1", undefined, {}));


/***/ }),

/***/ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\DateTimeUtils.ets":
/*!*********************************************************************************************************************************!*\
  !*** D:\0510sample\applications_app_samples_0510\code\BasicFeature\Media\AVRecorder\entry\src\main\ets\utils\DateTimeUtils.ets ***!
  \*********************************************************************************************************************************/
/***/ ((__unused_webpack_module, exports) => {


Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.dateTime = exports.getShownTimer = void 0;
let __generate__Id = 0;
function generateId() {
    return "DateTimeUtils_" + ++__generate__Id;
}
/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
class DateTimeUtil {
    getTime() {
        const DATETIME = new Date();
        return this.concatTime(DATETIME.getHours(), DATETIME.getMinutes(), DATETIME.getSeconds());
    }
    getDate() {
        const DATETIME = new Date();
        return this.concatDate(DATETIME.getFullYear(), DATETIME.getMonth() + 1, DATETIME.getDate());
    }
    fill(value) {
        return (value > 9 ? '' : '0') + value;
    }
    concatDate(year, month, date) {
        return `${year}${month}${date}`;
    }
    concatTime(hour, minute, second) {
        return `${this.fill(hour)}${this.fill(minute)}${this.fill(second)}`;
    }
}
exports["default"] = DateTimeUtil;
function getShownTimer(ms) {
    let seconds = Math.round(ms / 1000);
    let sec = seconds % 60;
    let min = (seconds - sec) / 60;
    if (sec < 10) {
        sec = '0' + sec;
    }
    if (min < 10) {
        min = '0' + min;
    }
    return min + ':' + sec;
}
exports.getShownTimer = getShownTimer;
function dateTime(t) {
    let minute = Math.floor(t / 60) % 60;
    let m = minute < 10 ? '0' + minute : minute;
    let second = t % 60;
    let s = second < 10 ? '0' + second : second;
    return m + ':' + s;
}
exports.dateTime = dateTime;


/***/ }),

/***/ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\Logger.ets":
/*!**************************************************************************************************************************!*\
  !*** D:\0510sample\applications_app_samples_0510\code\BasicFeature\Media\AVRecorder\entry\src\main\ets\utils\Logger.ets ***!
  \**************************************************************************************************************************/
/***/ (function(__unused_webpack_module, exports) {


var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", ({ value: true }));
let __generate__Id = 0;
function generateId() {
    return "Logger_" + ++__generate__Id;
}
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
var _ohos_hilog_1  = globalThis.requireNapi('hilog') || (isSystemplugin('hilog', 'ohos') ? globalThis.ohosplugin.hilog : isSystemplugin('hilog', 'system') ? globalThis.systemplugin.hilog : undefined);
class Logger {
    constructor(prefix) {
        this.format = "%{public}s, %{public}s";
        this.prefix = prefix;
        this.domain = 0xFF00;
    }
    debug(...args) {
        _ohos_hilog_1.debug(this.domain, this.prefix, this.format, args);
    }
    info(...args) {
        _ohos_hilog_1.info(this.domain, this.prefix, this.format, args);
    }
    warn(...args) {
        _ohos_hilog_1.warn(this.domain, this.prefix, this.format, args);
    }
    error(...args) {
        _ohos_hilog_1.error(this.domain, this.prefix, this.format, args);
    }
}
exports["default"] = new Logger('AVRecorderSample');


/***/ }),

/***/ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\SaveCameraAsset.ets":
/*!***********************************************************************************************************************************!*\
  !*** D:\0510sample\applications_app_samples_0510\code\BasicFeature\Media\AVRecorder\entry\src\main\ets\utils\SaveCameraAsset.ets ***!
  \***********************************************************************************************************************************/
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {


var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", ({ value: true }));
let __generate__Id = 0;
function generateId() {
    return "SaveCameraAsset_" + ++__generate__Id;
}
/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
var _ohos_multimedia_mediaLibrary_1  = globalThis.requireNapi('multimedia.mediaLibrary') || (isSystemplugin('multimedia.mediaLibrary', 'ohos') ? globalThis.ohosplugin.multimedia.mediaLibrary : isSystemplugin('multimedia.mediaLibrary', 'system') ? globalThis.systemplugin.multimedia.mediaLibrary : undefined);
const DateTimeUtils_1 = __importDefault(__webpack_require__(/*! ./DateTimeUtils */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\DateTimeUtils.ets"));
const Logger_1 = __importDefault(__webpack_require__(/*! ./Logger */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\Logger.ets"));
class SaveCameraAsset {
    constructor(tag) {
        this.lastSaveTime = '';
        this.saveIndex = 0;
        this.tag = tag;
    }
    async createVideoFd() {
        Logger_1.default.info(this.tag, 'get Recorder File Fd');
        const mDateTimeUtil = new DateTimeUtils_1.default();
        const displayName = this.checkName(`REC_${mDateTimeUtil.getDate()}_${mDateTimeUtil.getTime()}`) + '.mp4';
        Logger_1.default.info(this.tag, 'get Recorder display name is: ' + displayName);
        const media = _ohos_multimedia_mediaLibrary_1.getMediaLibrary(globalThis.abilityContext);
        Logger_1.default.info(this.tag, 'get Recorder File Fd publicPath');
        const fileKeyObj = _ohos_multimedia_mediaLibrary_1.FileKey;
        const mediaType = _ohos_multimedia_mediaLibrary_1.MediaType.VIDEO;
        let publicPath = await media.getPublicDirectory(_ohos_multimedia_mediaLibrary_1.DirectoryType.DIR_VIDEO);
        Logger_1.default.info(this.tag, 'get Recorder File publicPath: ' + JSON.stringify(publicPath));
        try {
            const dataUri = await media.createAsset(mediaType, displayName, publicPath);
            Logger_1.default.info(this.tag, 'get Recorder dataUri is: ' + dataUri);
            if (dataUri != undefined) {
                Logger_1.default.info(this.tag, 'dataUri is undefined');
                const args = dataUri.id.toString();
                const fetchOp = {
                    selections: fileKeyObj.ID + "=?",
                    selectionArgs: [args],
                };
                Logger_1.default.info(this.tag, 'fetchOp= ' + JSON.stringify(fetchOp));
                const fetchFileResult = await media.getFileAssets(fetchOp);
                Logger_1.default.info(this.tag, 'getFileAssets finished');
                this.VideoPrepareFile = await fetchFileResult.getFirstObject();
                const fdNumber = await this.VideoPrepareFile.open('rw');
                Logger_1.default.info(this.tag, 'get Recorder File fd is: ' + JSON.stringify(fdNumber));
                return fdNumber;
            }
        }
        catch (err) {
            Logger_1.default.error(this.tag, 'create Recorder File Fd ERROR: ' + err);
        }
    }
    async createAudioFd() {
        Logger_1.default.info(this.tag, 'get Recorder File Fd');
        const mDateTimeUtil = new DateTimeUtils_1.default();
        const displayName = this.checkName(`REC_${mDateTimeUtil.getDate()}_${mDateTimeUtil.getTime()}`) + '.m4a';
        Logger_1.default.info(this.tag, 'get Recorder display name is: ' + displayName);
        const media = _ohos_multimedia_mediaLibrary_1.getMediaLibrary(globalThis.abilityContext);
        Logger_1.default.info(this.tag, 'get Recorder File Fd publicPath');
        const fileKeyObj = _ohos_multimedia_mediaLibrary_1.FileKey;
        const mediaType = _ohos_multimedia_mediaLibrary_1.MediaType.AUDIO;
        let publicPath = await media.getPublicDirectory(_ohos_multimedia_mediaLibrary_1.DirectoryType.DIR_AUDIO);
        Logger_1.default.info(this.tag, 'get Recorder File publicPath: ' + JSON.stringify(publicPath));
        try {
            const dataUri = await media.createAsset(mediaType, displayName, publicPath);
            Logger_1.default.info(this.tag, 'get Recorder dataUri is: ' + dataUri);
            if (dataUri != undefined) {
                Logger_1.default.info(this.tag, 'dataUri is undefined');
                const args = dataUri.id.toString();
                const fetchOp = {
                    selections: fileKeyObj.ID + "=?",
                    selectionArgs: [args],
                };
                Logger_1.default.info(this.tag, 'fetchOp= ' + JSON.stringify(fetchOp));
                const fetchFileResult = await media.getFileAssets(fetchOp);
                Logger_1.default.info(this.tag, 'getFileAssets finished');
                this.AudioPrepareFile = await fetchFileResult.getFirstObject();
                const fdNumber = await this.AudioPrepareFile.open('rw');
                Logger_1.default.info(this.tag, 'get Recorder File fd is: ' + JSON.stringify(fdNumber));
                return fdNumber;
            }
        }
        catch (err) {
            Logger_1.default.error(this.tag, 'create Recorder File Fd ERROR: ' + err);
        }
    }
    checkName(name) {
        if (this.lastSaveTime == name) {
            this.saveIndex += 1;
            return `${name}_${this.saveIndex}`;
        }
        this.lastSaveTime = name;
        this.saveIndex = 0;
        Logger_1.default.info(this.tag, 'get Recorder File name is: ' + name);
        return name;
    }
}
exports["default"] = SaveCameraAsset;


/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		var commonCachedModule = globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"] ? globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"][moduleId]: null;
/******/ 		if (commonCachedModule) { return commonCachedModule.exports; }
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		function isCommonModue(moduleId) {
/******/ 		                if (globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"]) {
/******/ 		                  const length = globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"].length;
/******/ 		                  switch (length) {
/******/ 		                    case 1:
/******/ 		                      return globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"][0][1][moduleId];
/******/ 		                    case 2:
/******/ 		                      return globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"][0][1][moduleId] ||
/******/ 		                      globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"][1][1][moduleId];
/******/ 		                  }
/******/ 		                }
/******/ 		                return undefined;
/******/ 		              }
/******/ 		if (globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"] && String(moduleId).indexOf("?name=") < 0 && isCommonModue(moduleId)) {
/******/ 		  globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"][moduleId] = module;
/******/ 		}
/******/ 		__webpack_modules__[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
/******/ 	
/******/ 	// startup
/******/ 	// Load entry module and return exports
/******/ 	// This entry module is referenced by other modules so it can't be inlined
/******/ 	var __webpack_exports__ = __webpack_require__("D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\recorder\\VRecorder.ets?entry");
/******/ 	_dc2c5df44f596112a82eb663dbdeca82 = __webpack_exports__;
/******/ 	
/******/ })()
;
//# sourceMappingURL=VRecorder.js.map