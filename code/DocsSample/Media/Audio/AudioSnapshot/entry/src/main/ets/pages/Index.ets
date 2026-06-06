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

import { window } from '@kit.ArkUI';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [Start import_module]
import { audio } from '@kit.AudioKit';
import { fileIo as fileio } from '@kit.CoreFileKit';
// [End import_module]
import audioNapi from 'libentry.so';

class OptionItem {
  label: string;
  value: number;

  constructor(label: string, value: number) {
    this.label = label;
    this.value = value;
  }
}



class JsStreamState {
  id: number;
  name: string;
  capturer: audio.AudioCapturer | null = null;
  recordFd: number = -1;
  readCallback: ((buffer: ArrayBuffer) => void) | null = null;
  playbackRenderer: audio.AudioRenderer | null = null;
  playbackFd: number = -1;
  source: number = audio.SourceType.SOURCE_TYPE_MIC;
  sampleRate: number = audio.AudioSamplingRate.SAMPLE_RATE_16000;
  channelCount: number = audio.AudioChannel.CHANNEL_1;
  sampleFormat: number = audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE;
  stateText: string = 'Released';
  streamId: number = -1;
  bufferSize: number = 0;
  savedBytes: number = 0;
  savePath: string = '';
  saveRet: number = 0;
  captureSnapshotStatus: string = 'Capture snapshot not generated';
  captureSnapshotPath: string = '';
  captureSnapshotText: string = '';
  showCaptureSnapshotText: boolean = false;
  playbackSnapshotStatus: string = 'Playback snapshot not generated';
  playbackSnapshotPath: string = '';
  playbackSnapshotText: string = '';
  showPlaybackSnapshotText: boolean = false;
  playbackState: number = 0;
  playedBytes: number = 0;
  playTotalBytes: number = 0;

  constructor(id: number, name: string, source: number, sampleRate: number) {
    this.id = id;
    this.name = name;
    this.source = source;
    this.sampleRate = sampleRate;
  }
}

class NativeStreamState {
  id: number;
  name: string;
  source: number = audio.SourceType.SOURCE_TYPE_MIC;
  sampleRate: number = audio.AudioSamplingRate.SAMPLE_RATE_16000;
  channelCount: number = audio.AudioChannel.CHANNEL_1;
  sampleFormat: number = audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE;
  stateText: string = 'Released';
  streamRuntimeId: number = -1;
  bufferSize: number = 0;
  savedBytes: number = 0;
  savePath: string = '';
  saveRet: number = 0;
  callbackCount: number = 0;
  lastReadSize: number = 0;
  lastError: number = 0;
  captureSnapshotStatus: string = 'Capture snapshot not generated';
  captureSnapshotPath: string = '';
  captureSnapshotText: string = '';
  showCaptureSnapshotText: boolean = false;
  playbackSnapshotStatus: string = 'Playback snapshot not generated';
  playbackSnapshotPath: string = '';
  playbackSnapshotText: string = '';
  showPlaybackSnapshotText: boolean = false;
  playbackState: number = 0;
  playedBytes: number = 0;
  playTotalBytes: number = 0;
  playbackError: number = 0;

  constructor(id: number, name: string, source: number, sampleRate: number) {
    this.id = id;
    this.name = name;
    this.source = source;
    this.sampleRate = sampleRate;
  }
}

interface NativeCapturerStats {
  state: number;
  streamId: number;
  latencyMode: number;
  fastStatus: number;
  frameSize: number;
  capturedBytes: number;
  callbackCount: number;
  lastReadSize: number;
  lastFastStatus: number;
  lastError: number;
  savedBytes: number;
}

interface NativePlayerStats {
  state: number;
  playedBytes: number;
  totalBytes: number;
  lastError: number;
}

const SOURCE_OPTIONS: OptionItem[] = [
  new OptionItem('MIC', audio.SourceType.SOURCE_TYPE_MIC),
  new OptionItem('LIVE', audio.SourceType.SOURCE_TYPE_LIVE),
  new OptionItem('VOICE_COMM', audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION),
  new OptionItem('VOICE_RECOGNITION', audio.SourceType.SOURCE_TYPE_VOICE_RECOGNITION),
];

const SAMPLE_RATE_OPTIONS: OptionItem[] = [
  new OptionItem('16000', audio.AudioSamplingRate.SAMPLE_RATE_16000),
  new OptionItem('44100', audio.AudioSamplingRate.SAMPLE_RATE_44100),
  new OptionItem('48000', audio.AudioSamplingRate.SAMPLE_RATE_48000),
];

const CHANNEL_OPTIONS: OptionItem[] = [
  new OptionItem('1ch', audio.AudioChannel.CHANNEL_1),
  new OptionItem('2ch', audio.AudioChannel.CHANNEL_2),
];

const SAMPLE_FORMAT_OPTIONS: OptionItem[] = [
  new OptionItem('S16LE', audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE),
  new OptionItem('S24LE', audio.AudioSampleFormat.SAMPLE_FORMAT_S24LE),
  new OptionItem('S32LE', audio.AudioSampleFormat.SAMPLE_FORMAT_S32LE),
];

const PLAYBACK_USAGE_OPTIONS: OptionItem[] = [
  new OptionItem('MUSIC', audio.StreamUsage.STREAM_USAGE_MUSIC),
  new OptionItem('MEDIA', audio.StreamUsage.STREAM_USAGE_MEDIA),
  new OptionItem('VOICE_COMM', audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION),
];

interface PageItem {
  label: string;
  value: number;
}

const PAGE_OPTIONS: PageItem[] = [
  { label: '概览', value: 0 },
  { label: 'TS流', value: 1 },
  { label: 'C流', value: 2 },
  { label: '快照中心', value: 3 },
];

@Entry
@Component
struct Index {
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private audioManager: audio.AudioManager = audio.getAudioManager();
  private streamManager: audio.AudioStreamManager = this.audioManager.getStreamManager();
  private debugManager: audio.AudioDebuggingManager | null = null;
  private refreshTimerId: number = -1;
  private readonly jsPlayerIdle: number = 0;
  private readonly jsPlayerPlaying: number = 1;
  private readonly jsPlayerCompleted: number = 2;
  private readonly nativePlayerIdle: number = 0;
  private readonly nativePlayerPlaying: number = 1;
  private readonly nativePlayerCompleted: number = 2;
  private readonly playbackChunkSize: number = 4096;
  private readonly maxLogCount: number = 100;

  private readonly jsStreams: JsStreamState[] = [
    new JsStreamState(1, 'TS Stream 1', audio.SourceType.SOURCE_TYPE_MIC, audio.AudioSamplingRate.SAMPLE_RATE_16000),
    new JsStreamState(2, 'TS Stream 2', audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION, audio.AudioSamplingRate.SAMPLE_RATE_16000)
  ];

  private readonly nativeStreams: NativeStreamState[] = [
    new NativeStreamState(1001, 'C Stream 1', audio.SourceType.SOURCE_TYPE_MIC, audio.AudioSamplingRate.SAMPLE_RATE_16000),
    new NativeStreamState(1002, 'C Stream 2', audio.SourceType.SOURCE_TYPE_LIVE, audio.AudioSamplingRate.SAMPLE_RATE_16000)
  ];

  @State private hasMicrophonePermission: boolean = false;
  @State private currentPage: number = 0;
  @State private playbackUsage: number = audio.StreamUsage.STREAM_USAGE_MUSIC;
  @State private playbackSampleRate: number = audio.AudioSamplingRate.SAMPLE_RATE_16000;
  @State private playbackChannelCount: number = audio.AudioChannel.CHANNEL_1;
  @State private playbackSampleFormat: number = audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE;
  @State private frameworkSnapshot: string[] = ['No active capture streams'];
  @State private tsAppSnapshotStatus: string = 'TS app snapshot not generated';
  @State private tsAppSnapshotPath: string = '';
  @State private tsAppSnapshotText: string = '';
  @State private showTsAppSnapshotText: boolean = false;
  @State private cAppSnapshotStatus: string = 'C app snapshot not generated';
  @State private cAppSnapshotPath: string = '';
  @State private cAppSnapshotText: string = '';
  @State private showCAppSnapshotText: boolean = false;
  @State private logs: string[] = [];
  @State private status: string = 'Ready';
  @State private refreshVersion: number = 0;

  aboutToAppear(): void {
    window.getLastWindow(this.context).then((win) => {
      win.setWindowLayoutFullScreen(true);
    }).catch((err: BusinessError) => {
      this.status = `Window init failed: ${err.code}`;
    });
    void this.requestMicrophonePermission();
    this.refreshAll();
    this.startPolling();
  }

  aboutToDisappear(): void {
    this.stopPolling();
    for (let i: number = 0; i < this.jsStreams.length; i++) {
      void this.releaseJsCapturer(this.jsStreams[i]);
      void this.stopJsPlayback(this.jsStreams[i]);
    }
    for (let i: number = 0; i < this.nativeStreams.length; i++) {
      this.releaseNativeCapturer(this.nativeStreams[i]);
      this.stopNativePlayback(this.nativeStreams[i]);
    }
  }

  // Documentation example methods referenced by OpenHarmony docs
  private exampleGetDebugManager(): void {
    // [Start get_debug_manager_ts]
    // 获取音频调试管理器
    const audioManager = audio.getAudioManager();
    const debugManager: audio.AudioDebuggingManager = audioManager.getDebuggingManager();
    // [End get_debug_manager_ts]
  }

  private examplePrintAppSnapshot(debugManager: audio.AudioDebuggingManager): void {
    // [Start print_app_snapshot_ts]
    // 打印应用快照到文件
    const path = this.context.filesDir + '/audio_snapshot.txt';
    const file = fileio.openSync(path, 0o102 | 0o200, 0o644); // O_WRONLY | O_CREAT
    debugManager.printAppInfo(file.fd);
    fileio.closeSync(file);

    // 也可将快照信息输出到hilog日志（fd < 0时输出到hilog）
    debugManager.printAppInfo(-1);
    // [End print_app_snapshot_ts]
  }

  private examplePrintCapturerSnapshot(debugManager: audio.AudioDebuggingManager,
    capturer: audio.AudioCapturer): void {
    // [Start print_capturer_snapshot_ts]
    // 打印指定录音实例的快照
    const path = this.context.filesDir + '/capturer_snapshot.txt';
    const file = fileio.openSync(path, 0o102 | 0o200, 0o644);
    debugManager.printCapturerInfo(capturer, file.fd);
    fileio.closeSync(file);
    // [End print_capturer_snapshot_ts]
  }

  private examplePrintRendererSnapshot(debugManager: audio.AudioDebuggingManager,
    renderer: audio.AudioRenderer): void {
    // [Start print_renderer_snapshot_ts]
    // 打印指定播放实例的快照
    const path = this.context.filesDir + '/renderer_snapshot.txt';
    const file = fileio.openSync(path, 0o102 | 0o200, 0o644);
    debugManager.printRendererInfo(renderer, file.fd);
    fileio.closeSync(file);
    // [End print_renderer_snapshot_ts]
  }

  private async exampleConcurrentSnapshot(): Promise<void> {
    // [Start concurrent_snapshot_ts]
    // 1. 创建并启动多个录音流
    const capturer1: audio.AudioCapturer = await audio.createAudioCapturer(capturerOptions1);
    const capturer2: audio.AudioCapturer = await audio.createAudioCapturer(capturerOptions2);
    await capturer1.start();
    await capturer2.start();

    // 2. 分别获取各录音流的快照
    const file1 = fileio.openSync(this.context.filesDir + '/capturer1_snapshot.txt', 0o102 | 0o200, 0o644);
    debugManager.printCapturerInfo(capturer1, file1.fd);
    fileio.closeSync(file1);

    const file2 = fileio.openSync(this.context.filesDir + '/capturer2_snapshot.txt', 0o102 | 0o200, 0o644);
    debugManager.printCapturerInfo(capturer2, file2.fd);
    fileio.closeSync(file2);

    // 3. 也可以一次性获取应用级别的整体快照（包含所有活跃流信息）
    const appFile = fileio.openSync(this.context.filesDir + '/app_snapshot.txt', 0o102 | 0o200, 0o644);
    debugManager.printAppInfo(appFile.fd);
    fileio.closeSync(appFile);
    // [End concurrent_snapshot_ts]
  }

  private forceRefresh(): void {
    this.refreshVersion++;
  }

  private appendLog(message: string): void {
    const now: Date = new Date();
    const time: string = `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}:${now.getSeconds().toString().padStart(2, '0')}`;
    const next: string[] = [`[${time}] ${message}`, ...this.logs];
    this.logs = next.slice(0, this.maxLogCount);
    this.forceRefresh();
  }

  private toErrorCode(error: BusinessError | Object | undefined | null): number {
    const err: BusinessError | undefined = error as BusinessError | undefined;
    return typeof err?.code === 'number' ? err.code : -1;
  }

  private describeError(error: BusinessError | Object | undefined | null): string {
    if (error === undefined || error === null) {
      return 'unknown';
    }
    const err: BusinessError | undefined = error as BusinessError | undefined;
    const codeText: string = typeof err?.code === 'number' ? `${err.code}` : 'NA';
    const nameText: string = typeof (error as Record<string, string>).name === 'string' ?
      (error as Record<string, string>).name : 'UnknownError';
    const messageText: string = typeof err?.message === 'string' ? err.message : JSON.stringify(error);
    return `name=${nameText} code=${codeText} message=${messageText}`;
  }

  private getOptionLabel(options: OptionItem[], value: number): string {
    for (let index: number = 0; index < options.length; index++) {
      if (options[index].value === value) {
        return options[index].label;
      }
    }
    return `${value}`;
  }

  private getOptionIndex(options: OptionItem[], value: number): number {
    for (let index: number = 0; index < options.length; index++) {
      if (options[index].value === value) {
        return index;
      }
    }
    return 0;
  }

  private toSelectOptions(options: OptionItem[]): SelectOption[] {
    const result: SelectOption[] = [];
    for (let index: number = 0; index < options.length; index++) {
      result.push({ value: options[index].label });
    }
    return result;
  }

  private formatBytes(bytes: number): string {
    if (bytes < 1024) {
      return `${bytes} B`;
    }
    if (bytes < 1024 * 1024) {
      return `${(bytes / 1024).toFixed(2)} KB`;
    }
    return `${(bytes / (1024 * 1024)).toFixed(2)} MB`;
  }

  private describeJsPlaybackState(state: number): string {
    if (state === this.jsPlayerPlaying) {
      return 'Playing';
    }
    if (state === this.jsPlayerCompleted) {
      return 'Completed';
    }
    return 'Idle';
  }

  private describeNativePlaybackState(state: number): string {
    if (state === this.nativePlayerPlaying) {
      return 'Playing';
    }
    if (state === this.nativePlayerCompleted) {
      return 'Completed';
    }
    return 'Idle';
  }

  private describeCapturerState(state: number): string {
    switch (state) {
      case audio.AudioState.STATE_NEW:
        return 'New';
      case audio.AudioState.STATE_PREPARED:
        return 'Prepared';
      case audio.AudioState.STATE_RUNNING:
        return 'Running';
      case audio.AudioState.STATE_STOPPED:
        return 'Stopped';
      case audio.AudioState.STATE_RELEASED:
        return 'Released';
      default:
        return `${state}`;
    }
  }

  private buildPcmPath(prefix: string, id: number): string {
    return `${this.context.filesDir}/${prefix}_${id}_${Date.now()}.pcm`;
  }

  private buildSnapshotPath(prefix: string, id: number): string {
    return `${this.context.filesDir}/${prefix}_${id}_snapshot_${Date.now()}.txt`;
  }

  private buildTsAppSnapshotPath(): string {
    return `${this.context.filesDir}/ts_app_snapshot_${Date.now()}.txt`;
  }

  private buildCAppSnapshotPath(): string {
    return `${this.context.filesDir}/c_app_snapshot_${Date.now()}.txt`;
  }

  private openSnapshotFile(path: string): number {
    try {
      return fileio.openSync(path, fileio.OpenMode.READ_WRITE | fileio.OpenMode.CREATE | fileio.OpenMode.TRUNC).fd;
    } catch (error) {
      this.appendLog(`Failed to open snapshot file: ${path} ret=${this.toErrorCode(error)}`);
      return -1;
    }
  }

  private safeCloseFd(fd: number): void {
    if (fd < 0) {
      return;
    }
    try {
      fileio.closeSync(fd);
    } catch (error) {
      this.appendLog(`Failed to close fd: fd=${fd} ret=${this.toErrorCode(error)}`);
    }
  }

  private readSnapshotText(path: string): string {
    if (path.length === 0) {
      return '';
    }
    try {
      const text: string = fileio.readTextSync(path);
      if (text.length <= 1200) {
        return text;
      }
      return `${text.slice(0, 1200)}\n......(truncated, see file for full content)`;
    } catch (error) {
      return `Failed to read snapshot: ${this.toErrorCode(error)}`;
    }
  }

  private extractSnapshotHighlights(content: string): string[] {
    if (content.length === 0) {
      return [];
    }
    const lines: string[] = content.split('\n');
    const keywords: string[] = [
      'stream', 'source', 'usage', 'sample', 'rate', 'channel', 'format', 'state',
      'renderer', 'capturer', 'session', 'device', 'uid', 'pid', 'app'
    ];
    const results: string[] = [];
    for (let index: number = 0; index < lines.length; index++) {
      const line: string = lines[index].trim();
      if (line.length === 0) {
        continue;
      }
      const lower: string = line.toLowerCase();
      let matched: boolean = false;
      for (let i: number = 0; i < keywords.length; i++) {
        if (lower.indexOf(keywords[i]) >= 0) {
          matched = true;
          break;
        }
      }
      if (matched && results.indexOf(line) < 0) {
        results.push(line);
      }
      if (results.length >= 12) {
        break;
      }
    }
    if (results.length > 0) {
      return results;
    }
    for (let index: number = 0; index < lines.length && results.length < 6; index++) {
      const line: string = lines[index].trim();
      if (line.length > 0) {
        results.push(line);
      }
    }
    return results;
  }

  private getDebuggingManagerInstanceCompat(): audio.AudioDebuggingManager | null {
    if (this.debugManager !== null) {
      return this.debugManager;
    }
    try {
      this.debugManager = this.audioManager.getDebuggingManager();
      this.appendLog('JS debugging manager acquired: getDebuggingManager');
      return this.debugManager;
    } catch (error) {
      this.appendLog(`getDebuggingManager failed: ${this.describeError(error)}`);
      return null;
    }
  }

  private probeNativeDebuggingManager(): number {
    try {
      return Number(audioNapi.audioDebuggingManagerProbe());
    } catch (error) {
      this.appendLog(`Probe C debugging manager failed: ${this.describeError(error)}`);
      return -1;
    }
  }

  private async requestMicrophonePermission(): Promise<boolean> {
    if (this.hasMicrophonePermission) {
      return true;
    }
    try {
      const atManager = abilityAccessCtrl.createAtManager();
      const data = await atManager.requestPermissionsFromUser(this.context, ['ohos.permission.MICROPHONE']);
      const granted: boolean = data.authResults.length > 0 &&
        data.authResults.every((result: number) => result === 0);
      this.hasMicrophonePermission = granted;
      this.status = granted ? 'Microphone permission granted' : 'Microphone permission denied';
      this.forceRefresh();
      return granted;
    } catch (error) {
      this.status = `Permission request failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
      return false;
    }
  }

  private startPolling(): void {
    if (this.refreshTimerId >= 0) {
      return;
    }
    this.refreshTimerId = setInterval(() => {
      this.refreshAll();
    }, 1000);
  }

  private stopPolling(): void {
    if (this.refreshTimerId < 0) {
      return;
    }
    clearInterval(this.refreshTimerId);
    this.refreshTimerId = -1;
  }

  private refreshFrameworkSnapshot(): void {
    try {
      const infos: audio.AudioCapturerChangeInfoArray = this.streamManager.getCurrentAudioCapturerInfoArraySync();
      const lines: string[] = [];
      for (let index: number = 0; index < infos.length; index++) {
        const info: audio.AudioCapturerChangeInfo = infos[index];
        lines.push(`streamId=${info.streamId} source=${info.capturerInfo.source} state=${info.capturerState}`);
      }
      this.frameworkSnapshot = lines.length > 0 ? lines : ['No active capture streams'];
    } catch (error) {
      this.frameworkSnapshot = [`Snapshot query failed: ${this.toErrorCode(error)}`];
    }
  }

  private refreshNativeStats(stream: NativeStreamState): void {
    try {
      const stats: NativeCapturerStats = audioNapi.lowLatencyCapturerGetStats(stream.id) as NativeCapturerStats;
      if (stats.state === 0) {
        stream.stateText = 'Released';
      } else if (stats.state === 1) {
        stream.stateText = 'Stopped';
      } else if (stats.state === 2) {
        stream.stateText = 'Running';
      } else {
        stream.stateText = `${stats.state}`;
      }
      stream.streamRuntimeId = stats.streamId;
      stream.bufferSize = stats.frameSize;
      stream.savedBytes = stats.savedBytes;
      stream.callbackCount = stats.callbackCount;
      stream.lastReadSize = stats.lastReadSize;
      stream.lastError = stats.lastError;
    } catch (error) {
      stream.stateText = 'Released';
      stream.streamRuntimeId = -1;
      stream.bufferSize = 0;
      stream.savedBytes = 0;
      stream.callbackCount = 0;
      stream.lastReadSize = 0;
      stream.lastError = 0;
    }

    try {
      const playerStats: NativePlayerStats = audioNapi.pcmPlayerGetStats(stream.id) as NativePlayerStats;
      stream.playbackState = playerStats.state;
      stream.playedBytes = playerStats.playedBytes;
      stream.playTotalBytes = playerStats.totalBytes;
      stream.playbackError = playerStats.lastError;
    } catch (error) {
      stream.playbackState = this.nativePlayerIdle;
      stream.playedBytes = 0;
      stream.playTotalBytes = 0;
      stream.playbackError = 0;
    }
  }

  private refreshJsRuntime(stream: JsStreamState): void {
    if (stream.capturer === null) {
      stream.stateText = 'Released';
      stream.streamId = -1;
      stream.bufferSize = 0;
      return;
    }
    try {
      stream.stateText = this.describeCapturerState(Number(stream.capturer.state));
    } catch (error) {
      stream.stateText = `State error(${this.toErrorCode(error)})`;
    }
    try {
      stream.streamId = Number(stream.capturer.getAudioStreamIdSync());
    } catch (error) {
      stream.streamId = -1;
    }
    try {
      stream.bufferSize = Number(stream.capturer.getBufferSizeSync());
    } catch (error) {
      stream.bufferSize = 0;
    }
  }

  private refreshAll(): void {
    for (let i: number = 0; i < this.jsStreams.length; i++) {
      this.refreshJsRuntime(this.jsStreams[i]);
    }
    for (let i: number = 0; i < this.nativeStreams.length; i++) {
      this.refreshNativeStats(this.nativeStreams[i]);
    }
    this.refreshFrameworkSnapshot();
    this.forceRefresh();
  }

  private getJsCapturerOptions(stream: JsStreamState): audio.AudioCapturerOptions {
    return {
      streamInfo: {
        samplingRate: stream.sampleRate as audio.AudioSamplingRate,
        channels: stream.channelCount as audio.AudioChannel,
        sampleFormat: stream.sampleFormat as audio.AudioSampleFormat,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      },
      capturerInfo: {
        source: stream.source as audio.SourceType,
        capturerFlags: 0
      }
    };
  }

  private getJsRendererOptions(): audio.AudioRendererOptions {
    return {
      streamInfo: {
        samplingRate: this.playbackSampleRate as audio.AudioSamplingRate,
        channels: this.playbackChannelCount as audio.AudioChannel,
        sampleFormat: this.playbackSampleFormat as audio.AudioSampleFormat,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      },
      rendererInfo: {
        usage: this.playbackUsage as audio.StreamUsage,
        rendererFlags: 0
      }
    };
  }

  private finishJsRecordFile(stream: JsStreamState): void {
    if (stream.recordFd >= 0) {
      this.safeCloseFd(stream.recordFd);
      stream.recordFd = -1;
    }
  }

  private async createJsCapturer(stream: JsStreamState): Promise<void> {
    if (!(await this.requestMicrophonePermission())) {
      return;
    }
    if (stream.capturer !== null) {
      this.status = `${stream.name} already created`;
      this.forceRefresh();
      return;
    }
    try {
      stream.capturer = await audio.createAudioCapturer(this.getJsCapturerOptions(stream));
      stream.stateText = 'Prepared';
      this.status = `${stream.name} created`;
      this.appendLog(`${stream.name} created`);
      this.refreshJsRuntime(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} create failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private async startJsCapturer(stream: JsStreamState): Promise<void> {
    if (!(await this.requestMicrophonePermission())) {
      return;
    }
    if (stream.capturer === null) {
      await this.createJsCapturer(stream);
    }
    if (stream.capturer === null) {
      return;
    }
    try {
      stream.savePath = this.buildPcmPath('js_record', stream.id);
      stream.savedBytes = 0;
      stream.saveRet = 0;
      this.finishJsRecordFile(stream);
      stream.recordFd = fileio.openSync(
        stream.savePath,
        fileio.OpenMode.WRITE_ONLY | fileio.OpenMode.CREATE | fileio.OpenMode.TRUNC
      ).fd;
      stream.readCallback = (buffer: ArrayBuffer): void => {
        if (stream.recordFd < 0) {
          return;
        }
        try {
          const written: number = Number(fileio.writeSync(stream.recordFd, buffer));
          stream.savedBytes += written;
          this.forceRefresh();
        } catch (error) {
          stream.saveRet = this.toErrorCode(error);
          this.forceRefresh();
        }
      };
      stream.capturer.on('readData', stream.readCallback);
      await stream.capturer.start();
      this.status = `${stream.name} recording started`;
      this.appendLog(`${stream.name} recording: ${stream.savePath}`);
      this.refreshJsRuntime(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} start failed: ${this.toErrorCode(error)}`;
      this.finishJsRecordFile(stream);
      this.forceRefresh();
    }
  }

  private async stopJsCapturer(stream: JsStreamState): Promise<void> {
    if (stream.capturer === null) {
      return;
    }
    try {
      await stream.capturer.stop();
      if (stream.readCallback !== null) {
        stream.capturer.off('readData', stream.readCallback);
      }
      stream.readCallback = null;
      this.finishJsRecordFile(stream);
      this.status = `${stream.name} recording stopped`;
      this.appendLog(`${stream.name} stopped, saved ${stream.savedBytes} bytes`);
      this.refreshJsRuntime(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} stop failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private async releaseJsCapturer(stream: JsStreamState): Promise<void> {
    if (stream.capturer === null) {
      return;
    }
    try {
      if (stream.readCallback !== null) {
        stream.capturer.off('readData', stream.readCallback);
      }
    } catch (error) {
      this.appendLog(`${stream.name} off readData failed: ${this.toErrorCode(error)}`);
    }
    stream.readCallback = null;
    this.finishJsRecordFile(stream);
    try {
      await stream.capturer.release();
    } catch (error) {
      this.appendLog(`${stream.name} release failed: ${this.toErrorCode(error)}`);
    }
    stream.capturer = null;
    this.refreshJsRuntime(stream);
    this.status = `${stream.name} released`;
    this.forceRefresh();
  }

  private async stopJsPlayback(stream: JsStreamState): Promise<number> {
    let ret: number = 0;
    if (stream.playbackRenderer !== null) {
      try {
        await stream.playbackRenderer.stop();
      } catch (error) {
        ret = this.toErrorCode(error);
      }
      try {
        await stream.playbackRenderer.release();
      } catch (error) {
        if (ret === 0) {
          ret = this.toErrorCode(error);
        }
      }
    }
    if (stream.playbackFd >= 0) {
      try {
        this.safeCloseFd(stream.playbackFd);
      } catch (error) {
        if (ret === 0) {
          ret = this.toErrorCode(error);
        }
      }
    }
    stream.playbackRenderer = null;
    stream.playbackFd = -1;
    stream.playbackState = this.jsPlayerIdle;
    this.forceRefresh();
    return ret;
  }

  private async jsPlaybackLoop(stream: JsStreamState, fd: number, renderer: audio.AudioRenderer): Promise<void> {
    let completed: boolean = false;
    try {
      while (stream.playbackRenderer === renderer) {
        const buffer: ArrayBuffer = new ArrayBuffer(this.playbackChunkSize);
        const readSize: number = Number(fileio.readSync(fd, buffer, { length: this.playbackChunkSize }));
        if (readSize <= 0) {
          completed = true;
          break;
        }
        const chunk: ArrayBuffer = readSize === this.playbackChunkSize ? buffer : buffer.slice(0, readSize);
        const written: number = Number(await renderer.write(chunk));
        stream.playedBytes += written;
        this.forceRefresh();
      }
    } catch (error) {
      this.appendLog(`${stream.name} JS playback loop failed: ${this.toErrorCode(error)}`);
    } finally {
      stream.playbackState = completed ? this.jsPlayerCompleted : this.jsPlayerIdle;
      await this.stopJsPlayback(stream);
      if (completed) {
        stream.playbackState = this.jsPlayerCompleted;
      }
      this.forceRefresh();
    }
  }

  private async playJsRecording(stream: JsStreamState): Promise<void> {
    if (stream.savePath.length === 0 || stream.savedBytes <= 0) {
      this.status = `${stream.name} no PCM file to play`;
      this.forceRefresh();
      return;
    }
    try {
      await this.stopJsPlayback(stream);
      const file = fileio.openSync(stream.savePath, fileio.OpenMode.READ_ONLY);
      const renderer: audio.AudioRenderer = await audio.createAudioRenderer(this.getJsRendererOptions());
      await renderer.start();
      stream.playbackFd = file.fd;
      stream.playbackRenderer = renderer;
      stream.playbackState = this.jsPlayerPlaying;
      stream.playedBytes = 0;
      stream.playTotalBytes = stream.savedBytes;
      this.status = `${stream.name} playback started`;
      this.appendLog(`${stream.name} playing: ${stream.savePath}`);
      this.forceRefresh();
      void this.jsPlaybackLoop(stream, file.fd, renderer);
    } catch (error) {
      this.status = `${stream.name} playback failed: ${this.toErrorCode(error)}`;
      void this.stopJsPlayback(stream);
      this.forceRefresh();
    }
  }

  private printJsCaptureSnapshot(stream: JsStreamState): void {
    if (stream.capturer === null) {
      stream.captureSnapshotStatus = 'Capture snapshot unavailable';
      this.status = `${stream.name} capture snapshot unavailable`;
      this.forceRefresh();
      return;
    }
    const manager: audio.AudioDebuggingManager | null = this.getDebuggingManagerInstanceCompat();
    if (manager === null) {
      const nativeProbeRet: number = this.probeNativeDebuggingManager();
      stream.captureSnapshotStatus = `JS debugging manager unavailable, C probe=${nativeProbeRet}`;
      this.appendLog(`${stream.name} capture snapshot check failed: JS manager null, C probe=${nativeProbeRet}`);
      this.status = stream.captureSnapshotStatus;
      this.forceRefresh();
      return;
    }
    const path: string = this.buildSnapshotPath('js_capturer', stream.id);
    const fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      stream.captureSnapshotStatus = `Failed to open capture snapshot file: ${path}`;
      this.status = stream.captureSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      manager.printCapturerInfo(stream.capturer, fd);
      stream.captureSnapshotPath = path;
      stream.captureSnapshotStatus = `Capture snapshot saved: ${path}`;
      stream.captureSnapshotText = this.readSnapshotText(path);
      stream.showCaptureSnapshotText = true;
      this.status = `${stream.name} capture snapshot success`;
    } catch (error) {
      stream.captureSnapshotStatus = `Capture snapshot failed: ${this.toErrorCode(error)}`;
      stream.captureSnapshotText = '';
      stream.showCaptureSnapshotText = false;
      this.status = `${stream.name} capture snapshot failed`;
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private printJsPlaybackSnapshot(stream: JsStreamState): void {
    if (stream.playbackRenderer === null) {
      stream.playbackSnapshotStatus = 'Playback snapshot unavailable';
      this.status = `${stream.name} playback snapshot unavailable`;
      this.forceRefresh();
      return;
    }
    const manager: audio.AudioDebuggingManager | null = this.getDebuggingManagerInstanceCompat();
    if (manager === null) {
      const nativeProbeRet: number = this.probeNativeDebuggingManager();
      stream.playbackSnapshotStatus = `JS debugging manager unavailable, C probe=${nativeProbeRet}`;
      this.appendLog(`${stream.name} playback snapshot check failed: JS manager null, C probe=${nativeProbeRet}`);
      this.status = stream.playbackSnapshotStatus;
      this.forceRefresh();
      return;
    }
    const path: string = this.buildSnapshotPath('js_renderer', stream.id);
    const fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      stream.playbackSnapshotStatus = `Failed to open playback snapshot file: ${path}`;
      this.status = stream.playbackSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      manager.printRendererInfo(stream.playbackRenderer, fd);
      stream.playbackSnapshotPath = path;
      stream.playbackSnapshotStatus = `Playback snapshot saved: ${path}`;
      stream.playbackSnapshotText = this.readSnapshotText(path);
      stream.showPlaybackSnapshotText = true;
      this.status = `${stream.name} playback snapshot success`;
    } catch (error) {
      stream.playbackSnapshotStatus = `Playback snapshot failed: ${this.toErrorCode(error)}`;
      stream.playbackSnapshotText = '';
      stream.showPlaybackSnapshotText = false;
      this.status = `${stream.name} playback snapshot failed`;
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private createNativeCapturer(stream: NativeStreamState): void {
    stream.savePath = this.buildPcmPath('c_record', stream.id);
    try {
      const ret: number = audioNapi.lowLatencyCapturerInit(
        stream.id,
        stream.source,
        stream.sampleRate,
        stream.channelCount,
        stream.sampleFormat
      );
      stream.saveRet = ret;
      this.refreshNativeStats(stream);
      this.status = `${stream.name} create ret=${ret}`;
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} create failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private startNativeCapturer(stream: NativeStreamState): void {
    if (stream.savePath.length === 0) {
      stream.savePath = this.buildPcmPath('c_record', stream.id);
    }
    try {
      const saveRet: number = audioNapi.lowLatencyCapturerSetSaveFile(stream.id, stream.savePath);
      stream.saveRet = saveRet;
      const ret: number = audioNapi.lowLatencyCapturerStart(stream.id);
      this.status = `${stream.name} start ret=${ret}`;
      this.appendLog(`${stream.name} recording: ${stream.savePath}`);
      this.refreshNativeStats(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} start failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private stopNativeCapturer(stream: NativeStreamState): void {
    try {
      const ret: number = audioNapi.lowLatencyCapturerStop(stream.id);
      audioNapi.lowLatencyCapturerSetSaveFile(stream.id, '');
      this.status = `${stream.name} stop ret=${ret}`;
      this.refreshNativeStats(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} stop failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private releaseNativeCapturer(stream: NativeStreamState): void {
    try {
      audioNapi.lowLatencyCapturerSetSaveFile(stream.id, '');
    } catch (error) {
      this.appendLog(`${stream.name} clear save file failed: ${this.toErrorCode(error)}`);
    }
    try {
      const ret: number = audioNapi.lowLatencyCapturerRelease(stream.id);
      this.status = `${stream.name} release ret=${ret}`;
      this.refreshNativeStats(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} release failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private playNativeRecording(stream: NativeStreamState): void {
    if (stream.savePath.length === 0 || stream.savedBytes <= 0) {
      this.status = `${stream.name} no PCM file to play`;
      this.forceRefresh();
      return;
    }
    try {
      const ret: number = audioNapi.pcmPlayerStart(
        stream.id,
        stream.savePath,
        this.playbackSampleRate,
        this.playbackChannelCount,
        this.playbackSampleFormat
      );
      this.status = `${stream.name} playback ret=${ret}`;
      this.appendLog(`${stream.name} playing: ${stream.savePath}`);
      this.refreshNativeStats(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} playback failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private stopNativePlayback(stream: NativeStreamState): void {
    try {
      const ret: number = audioNapi.pcmPlayerStop(stream.id);
      this.status = `${stream.name} stop playback ret=${ret}`;
      this.refreshNativeStats(stream);
      this.forceRefresh();
    } catch (error) {
      this.status = `${stream.name} stop playback failed: ${this.toErrorCode(error)}`;
      this.forceRefresh();
    }
  }

  private printNativeCaptureSnapshot(stream: NativeStreamState): void {
    const path: string = this.buildSnapshotPath('c_capturer', stream.id);
    const fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      stream.captureSnapshotStatus = `Failed to open capture snapshot file: ${path}`;
      this.status = stream.captureSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      const ret: number = audioNapi.lowLatencyCapturerPrintSnapshot(stream.id, fd);
      if (ret !== 0) {
        stream.captureSnapshotStatus = `Capture snapshot failed: ${ret}`;
        this.appendLog(`${stream.name} C capture snapshot failed ret=${ret}`);
        stream.captureSnapshotText = '';
        stream.showCaptureSnapshotText = false;
      } else {
        stream.captureSnapshotPath = path;
        stream.captureSnapshotStatus = `Capture snapshot saved: ${path}`;
        stream.captureSnapshotText = this.readSnapshotText(path);
        stream.showCaptureSnapshotText = true;
      }
      this.status = `${stream.name} capture snapshot done`;
    } catch (error) {
      stream.captureSnapshotStatus = `Capture snapshot error: ${this.toErrorCode(error)}`;
      stream.captureSnapshotText = '';
      stream.showCaptureSnapshotText = false;
      this.status = `${stream.name} capture snapshot error`;
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private printNativePlaybackSnapshot(stream: NativeStreamState): void {
    const path: string = this.buildSnapshotPath('c_renderer', stream.id);
    const fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      stream.playbackSnapshotStatus = `Failed to open playback snapshot file: ${path}`;
      this.status = stream.playbackSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      const ret: number = audioNapi.pcmPlayerPrintSnapshot(stream.id, fd);
      if (ret !== 0) {
        stream.playbackSnapshotStatus = `Playback snapshot failed: ${ret}`;
        this.appendLog(`${stream.name} C playback snapshot failed ret=${ret}`);
        stream.playbackSnapshotText = '';
        stream.showPlaybackSnapshotText = false;
      } else {
        stream.playbackSnapshotPath = path;
        stream.playbackSnapshotStatus = `Playback snapshot saved: ${path}`;
        stream.playbackSnapshotText = this.readSnapshotText(path);
        stream.showPlaybackSnapshotText = true;
      }
      this.status = `${stream.name} playback snapshot done`;
    } catch (error) {
      stream.playbackSnapshotStatus = `Playback snapshot error: ${this.toErrorCode(error)}`;
      stream.playbackSnapshotText = '';
      stream.showPlaybackSnapshotText = false;
      this.status = `${stream.name} playback snapshot error`;
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private printTsAppSnapshot(): void {
    const manager: audio.AudioDebuggingManager | null = this.getDebuggingManagerInstanceCompat();
    if (manager === null) {
      const nativeProbeRet: number = this.probeNativeDebuggingManager();
      this.tsAppSnapshotStatus = `TS app debugging manager unavailable, C probe=${nativeProbeRet}`;
      this.appendLog(`TS app snapshot check failed: JS manager null, C probe=${nativeProbeRet}`);
      this.status = this.tsAppSnapshotStatus;
      this.forceRefresh();
      return;
    }
    const path: string = this.buildTsAppSnapshotPath();
    const fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      this.tsAppSnapshotStatus = `Failed to open TS app snapshot file: ${path}`;
      this.status = this.tsAppSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      manager.printAppInfo(fd);
      this.tsAppSnapshotPath = path;
      this.tsAppSnapshotStatus = `TS app snapshot saved: ${path}`;
      this.tsAppSnapshotText = this.readSnapshotText(path);
      this.showTsAppSnapshotText = true;
      this.status = this.tsAppSnapshotStatus;
    } catch (error) {
      this.tsAppSnapshotStatus = `TS app snapshot failed: ${this.toErrorCode(error)}`;
      this.tsAppSnapshotText = '';
      this.showTsAppSnapshotText = false;
      this.status = this.tsAppSnapshotStatus;
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private printCAppSnapshot(): void {
    const path: string = this.buildCAppSnapshotPath();
    const fd: number = this.openSnapshotFile(path);
    if (fd < 0) {
      this.cAppSnapshotStatus = `Failed to open C app snapshot file: ${path}`;
      this.status = this.cAppSnapshotStatus;
      this.forceRefresh();
      return;
    }
    try {
      const ret: number = audioNapi.audioDebuggingManagerPrintAppInfo(fd);
      if (ret !== 0) {
        this.cAppSnapshotStatus = `C app snapshot failed: ${ret}`;
        this.appendLog(`C app snapshot failed ret=${ret}`);
        this.cAppSnapshotText = '';
        this.showCAppSnapshotText = false;
      } else {
        this.cAppSnapshotPath = path;
        this.cAppSnapshotStatus = `C app snapshot saved: ${path}`;
        this.cAppSnapshotText = this.readSnapshotText(path);
        this.showCAppSnapshotText = true;
      }
      this.status = this.cAppSnapshotStatus;
    } catch (error) {
      this.cAppSnapshotStatus = `C app snapshot error: ${this.toErrorCode(error)}`;
      this.cAppSnapshotText = '';
      this.showCAppSnapshotText = false;
      this.status = this.cAppSnapshotStatus;
    } finally {
      this.safeCloseFd(fd);
      this.forceRefresh();
    }
  }

  private printAllAvailableSnapshots(): void {
    this.printTsAppSnapshot();
    this.printCAppSnapshot();
    for (let index: number = 0; index < this.jsStreams.length; index++) {
      const jsStream: JsStreamState = this.jsStreams[index];
      if (jsStream.capturer !== null) {
        this.printJsCaptureSnapshot(jsStream);
      }
      if (jsStream.playbackRenderer !== null) {
        this.printJsPlaybackSnapshot(jsStream);
      }
    }
    for (let index: number = 0; index < this.nativeStreams.length; index++) {
      const nativeStream: NativeStreamState = this.nativeStreams[index];
      if (nativeStream.streamRuntimeId >= 0 || nativeStream.stateText !== 'Released') {
        this.printNativeCaptureSnapshot(nativeStream);
      }
      if (nativeStream.playbackState !== this.nativePlayerIdle) {
        this.printNativePlaybackSnapshot(nativeStream);
      }
    }
    this.appendLog('Triggered full snapshot capture for all active objects');
    this.currentPage = 3;
    this.forceRefresh();
  }

  @Builder
  private buildSectionTitle(title: string, subTitle: string) {
    Column({ space: 2 }) {
      Text(title)
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .width('100%');
      Text(subTitle)
        .fontSize(10)
        .fontColor('#475569')
        .width('100%');
    }
  }

  @Builder
  private buildSelectField(title: string, options: OptionItem[], value: number,
    onChange: (nextValue: number) => void) {
    Column({ space: 4 }) {
      Text(title)
        .fontSize(9)
        .fontColor('#64748B')
        .width('100%');
      Select(this.toSelectOptions(options))
        .selected(this.getOptionIndex(options, value))
        .value(this.getOptionLabel(options, value))
        .font({ size: 11, weight: 400 })
        .fontColor('#0F172A')
        .selectedOptionBgColor('#DCEAFE')
        .selectedOptionFont({ size: 11, weight: 500 })
        .selectedOptionFontColor('#0F172A')
        .optionBgColor('#FFFFFF')
        .optionFont({ size: 11, weight: 400 })
        .optionFontColor('#1E293B')
        .controlSize(ControlSize.SMALL)
        .arrowPosition(ArrowPosition.END)
        .menuAlign(MenuAlignType.START)
        .height(32)
        .width('100%')
        .backgroundColor('#F8FAFC')
        .border({ width: 1, color: '#CBD5E1' })
        .borderRadius(10)
        .padding({ left: 10, right: 10 })
        .onSelect((index: number) => {
          if (index >= 0 && index < options.length) {
            onChange(options[index].value);
          }
        });
    }
    .layoutWeight(1);
  }

  @Builder
  private buildPageSelector() {
    Row({ space: 6 }) {
      ForEach(PAGE_OPTIONS, (item: PageItem) => {
        Button(item.label)
          .height(30)
          .fontSize(10)
          .fontWeight(this.currentPage === item.value ? FontWeight.Medium : FontWeight.Regular)
          .fontColor(this.currentPage === item.value ? '#0F172A' : '#475569')
          .backgroundColor(this.currentPage === item.value ? '#E0F2FE' : '#FFFFFF')
          .border({ width: 1, color: this.currentPage === item.value ? '#38BDF8' : '#CBD5E1' })
          .borderRadius(999)
          .padding({ left: 10, right: 10 })
          .onClick(() => {
            this.currentPage = item.value;
            this.forceRefresh();
          });
      }, (item: PageItem) => `${item.value}`);
    }
    .width('100%');
  }

  @Builder
  private buildSnapshotTextPanel(title: string, summary: string, path: string, content: string, expanded: boolean,
    onToggle: () => void) {
    Column({ space: 4 }) {
      Text(title)
        .fontSize(10)
        .fontWeight(FontWeight.Medium)
        .width('100%');
      Text(summary)
        .fontSize(9)
        .width('100%');
      Text(path.length > 0 ? path : 'No snapshot file')
        .fontSize(9)
        .fontColor('#475569')
        .width('100%');
      if (this.extractSnapshotHighlights(content).length > 0) {
        Column({ space: 2 }) {
          Text('Highlights')
            .fontSize(9)
            .fontWeight(FontWeight.Medium)
            .width('100%');
          ForEach(this.extractSnapshotHighlights(content), (line: string) => {
            Text(line)
              .fontSize(9)
              .fontColor('#0F172A')
              .width('100%');
          }, (line: string) => line);
        }
        .padding(8)
        .backgroundColor('#EFF6FF')
        .borderRadius(8);
      }
      if (content.length > 0) {
        Button(expanded ? 'Collapse' : 'Expand')
          .height(28)
          .fontSize(10)
          .width(96)
          .onClick(() => {
            onToggle();
          });
      }
      if (expanded && content.length > 0) {
        Text(content)
          .fontSize(9)
          .fontColor('#0F172A')
          .width('100%')
          .padding(8)
          .backgroundColor('#F8FAFC')
          .borderRadius(8);
      }
    }
    .padding(10)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .border({ width: 1, color: '#E2E8F0' });
  }

  @Builder
  private buildJsStreamCard(stream: JsStreamState) {
    Column({ space: 6 }) {
      Text(stream.name)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .width('100%');
      Text(`Capture: source=${this.getOptionLabel(SOURCE_OPTIONS, stream.source)} rate=${this.getOptionLabel(SAMPLE_RATE_OPTIONS, stream.sampleRate)} Hz ch=${this.getOptionLabel(CHANNEL_OPTIONS, stream.channelCount)} fmt=${this.getOptionLabel(SAMPLE_FORMAT_OPTIONS, stream.sampleFormat)}`)
        .fontSize(10)
        .width('100%');
      Text(`Playback: usage=${this.getOptionLabel(PLAYBACK_USAGE_OPTIONS, this.playbackUsage)} rate=${this.getOptionLabel(SAMPLE_RATE_OPTIONS, this.playbackSampleRate)} Hz ch=${this.getOptionLabel(CHANNEL_OPTIONS, this.playbackChannelCount)} fmt=${this.getOptionLabel(SAMPLE_FORMAT_OPTIONS, this.playbackSampleFormat)}`)
        .fontSize(9)
        .fontColor('#475569')
        .width('100%');
      Row({ space: 6 }) {
        this.buildSelectField('Source', SOURCE_OPTIONS, stream.source, (nextValue: number) => {
          stream.source = nextValue;
          this.forceRefresh();
        })
        this.buildSelectField('Sample Rate', SAMPLE_RATE_OPTIONS, stream.sampleRate, (nextValue: number) => {
          stream.sampleRate = nextValue;
          this.forceRefresh();
        })
      }
      Row({ space: 6 }) {
        this.buildSelectField('Channels', CHANNEL_OPTIONS, stream.channelCount, (nextValue: number) => {
          stream.channelCount = nextValue;
          this.forceRefresh();
        })
        this.buildSelectField('Format', SAMPLE_FORMAT_OPTIONS, stream.sampleFormat, (nextValue: number) => {
          stream.sampleFormat = nextValue;
          this.forceRefresh();
        })
      }
      Row({ space: 6 }) {
        Button('创建')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.createJsCapturer(stream);
          });
        Button('启动')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.startJsCapturer(stream);
          });
        Button('停止')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.stopJsCapturer(stream);
          });
        Button('释放')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.releaseJsCapturer(stream);
          });
      }
      Row({ space: 6 }) {
        Button('采集快照')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.printJsCaptureSnapshot(stream);
          });
        Button('播放')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.playJsRecording(stream);
          });
        Button('停止播放')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            void this.stopJsPlayback(stream);
          });
        Button('播放快照')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.printJsPlaybackSnapshot(stream);
          });
      }
      Text(`State: ${stream.stateText} | streamId=${stream.streamId} | buffer=${stream.bufferSize}`)
        .fontSize(10)
        .width('100%');
      Text(`PCM: ${stream.savePath.length > 0 ? stream.savePath : 'None'}`)
        .fontSize(9)
        .width('100%');
      Text(`Saved: ${this.formatBytes(stream.savedBytes)} | saveRet=${stream.saveRet}`)
        .fontSize(10)
        .width('100%');
      Text(`Playback: ${this.describeJsPlaybackState(stream.playbackState)} | ${this.formatBytes(stream.playedBytes)} / ${this.formatBytes(stream.playTotalBytes)}`)
        .fontSize(10)
        .width('100%');
      Text(stream.captureSnapshotStatus)
        .fontSize(9)
        .width('100%');
      Text(`Capture snap file: ${stream.captureSnapshotPath.length > 0 ? stream.captureSnapshotPath : 'None'}`)
        .fontSize(9)
        .width('100%');
      if (stream.captureSnapshotText.length > 0) {
        Button(stream.showCaptureSnapshotText ? 'Collapse' : 'Expand Capture')
          .height(28)
          .fontSize(10)
          .width(120)
          .onClick(() => {
            stream.showCaptureSnapshotText = !stream.showCaptureSnapshotText;
            this.forceRefresh();
          });
      }
      if (stream.showCaptureSnapshotText && stream.captureSnapshotText.length > 0) {
        Text(stream.captureSnapshotText)
          .fontSize(9)
          .width('100%')
          .padding(8)
          .backgroundColor('#FFFFFF')
          .borderRadius(8);
      }
      Text(stream.playbackSnapshotStatus)
        .fontSize(9)
        .width('100%');
      Text(`Playback snap file: ${stream.playbackSnapshotPath.length > 0 ? stream.playbackSnapshotPath : 'None'}`)
        .fontSize(9)
        .width('100%');
      if (stream.playbackSnapshotText.length > 0) {
        Button(stream.showPlaybackSnapshotText ? 'Collapse' : 'Expand Playback')
          .height(28)
          .fontSize(10)
          .width(120)
          .onClick(() => {
            stream.showPlaybackSnapshotText = !stream.showPlaybackSnapshotText;
            this.forceRefresh();
          });
      }
      if (stream.showPlaybackSnapshotText && stream.playbackSnapshotText.length > 0) {
        Text(stream.playbackSnapshotText)
          .fontSize(9)
          .width('100%')
          .padding(8)
          .backgroundColor('#FFFFFF')
          .borderRadius(8);
      }
    }
    .padding(10)
    .backgroundColor('#F8FAFC')
    .borderRadius(8);
  }

  @Builder
  private buildNativeStreamCard(stream: NativeStreamState) {
    Column({ space: 6 }) {
      Text(stream.name)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .width('100%');
      Text(`Capture: source=${this.getOptionLabel(SOURCE_OPTIONS, stream.source)} rate=${this.getOptionLabel(SAMPLE_RATE_OPTIONS, stream.sampleRate)} Hz ch=${this.getOptionLabel(CHANNEL_OPTIONS, stream.channelCount)} fmt=${this.getOptionLabel(SAMPLE_FORMAT_OPTIONS, stream.sampleFormat)}`)
        .fontSize(10)
        .width('100%');
      Text(`Playback: usage=${this.getOptionLabel(PLAYBACK_USAGE_OPTIONS, this.playbackUsage)} rate=${this.getOptionLabel(SAMPLE_RATE_OPTIONS, this.playbackSampleRate)} Hz ch=${this.getOptionLabel(CHANNEL_OPTIONS, this.playbackChannelCount)} fmt=${this.getOptionLabel(SAMPLE_FORMAT_OPTIONS, this.playbackSampleFormat)}`)
        .fontSize(9)
        .fontColor('#475569')
        .width('100%');
      Row({ space: 6 }) {
        this.buildSelectField('Source', SOURCE_OPTIONS, stream.source, (nextValue: number) => {
          stream.source = nextValue;
          this.forceRefresh();
        })
        this.buildSelectField('Sample Rate', SAMPLE_RATE_OPTIONS, stream.sampleRate, (nextValue: number) => {
          stream.sampleRate = nextValue;
          this.forceRefresh();
        })
      }
      Row({ space: 6 }) {
        this.buildSelectField('Channels', CHANNEL_OPTIONS, stream.channelCount, (nextValue: number) => {
          stream.channelCount = nextValue;
          this.forceRefresh();
        })
        this.buildSelectField('Format', SAMPLE_FORMAT_OPTIONS, stream.sampleFormat, (nextValue: number) => {
          stream.sampleFormat = nextValue;
          this.forceRefresh();
        })
      }
      Row({ space: 6 }) {
        Button('创建')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.createNativeCapturer(stream);
          });
        Button('启动')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.startNativeCapturer(stream);
          });
        Button('停止')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.stopNativeCapturer(stream);
          });
        Button('释放')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.releaseNativeCapturer(stream);
          });
      }
      Row({ space: 6 }) {
        Button('采集快照')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.printNativeCaptureSnapshot(stream);
          });
        Button('播放')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.playNativeRecording(stream);
          });
        Button('停止播放')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.stopNativePlayback(stream);
          });
        Button('播放快照')
          .height(32)
          .fontSize(11)
          .layoutWeight(1)
          .onClick(() => {
            this.printNativePlaybackSnapshot(stream);
          });
      }
      Text(`State: ${stream.stateText} | streamId=${stream.streamRuntimeId} | buffer=${stream.bufferSize}`)
        .fontSize(10)
        .width('100%');
      Text(`PCM: ${stream.savePath.length > 0 ? stream.savePath : 'None'}`)
        .fontSize(9)
        .width('100%');
      Text(`Saved: ${this.formatBytes(stream.savedBytes)} | saveRet=${stream.saveRet}`)
        .fontSize(10)
        .width('100%');
      Text(`Callbacks: count=${stream.callbackCount} last=${stream.lastReadSize} err=${stream.lastError}`)
        .fontSize(10)
        .width('100%');
      Text(`Playback: ${this.describeNativePlaybackState(stream.playbackState)} | ${this.formatBytes(stream.playedBytes)} / ${this.formatBytes(stream.playTotalBytes)} | err=${stream.playbackError}`)
        .fontSize(10)
        .width('100%');
      Text(stream.captureSnapshotStatus)
        .fontSize(9)
        .width('100%');
      Text(`Capture snap file: ${stream.captureSnapshotPath.length > 0 ? stream.captureSnapshotPath : 'None'}`)
        .fontSize(9)
        .width('100%');
      if (stream.captureSnapshotText.length > 0) {
        Button(stream.showCaptureSnapshotText ? 'Collapse' : 'Expand Capture')
          .height(28)
          .fontSize(10)
          .width(120)
          .onClick(() => {
            stream.showCaptureSnapshotText = !stream.showCaptureSnapshotText;
            this.forceRefresh();
          });
      }
      if (stream.showCaptureSnapshotText && stream.captureSnapshotText.length > 0) {
        Text(stream.captureSnapshotText)
          .fontSize(9)
          .width('100%')
          .padding(8)
          .backgroundColor('#FFFFFF')
          .borderRadius(8);
      }
      Text(stream.playbackSnapshotStatus)
        .fontSize(9)
        .width('100%');
      Text(`Playback snap file: ${stream.playbackSnapshotPath.length > 0 ? stream.playbackSnapshotPath : 'None'}`)
        .fontSize(9)
        .width('100%');
      if (stream.playbackSnapshotText.length > 0) {
        Button(stream.showPlaybackSnapshotText ? 'Collapse' : 'Expand Playback')
          .height(28)
          .fontSize(10)
          .width(120)
          .onClick(() => {
            stream.showPlaybackSnapshotText = !stream.showPlaybackSnapshotText;
            this.forceRefresh();
          });
      }
      if (stream.showPlaybackSnapshotText && stream.playbackSnapshotText.length > 0) {
        Text(stream.playbackSnapshotText)
          .fontSize(9)
          .width('100%')
          .padding(8)
          .backgroundColor('#FFFFFF')
          .borderRadius(8);
      }
    }
    .padding(10)
    .backgroundColor('#F8FAFC')
    .borderRadius(8);
  }

  @Builder
  private buildHeaderPanel() {
    Column({ space: 4 }) {
      Text($r('app.string.APP_TITLE'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0F172A')
        .width('100%');
      Text('Concurrent snapshot verification: TS streams, C streams, app-level & stream-level snapshots')
        .fontSize(11)
        .fontColor('#475569')
        .width('100%');
      this.buildPageSelector()
      Text(this.status)
        .fontSize(10)
        .fontColor('#111827')
        .width('100%')
        .padding(8)
        .backgroundColor('#F8FAFC')
        .borderRadius(8);
    }
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .border({ width: 1, color: '#E2E8F0' });
  }

  @Builder
  private buildOverviewPage() {
    Column({ space: 10 }) {
      Column({ space: 6 }) {
        this.buildSectionTitle('全局播放配置', '所有 TS/C 流共享的播放参数。')
        Row({ space: 6 }) {
          this.buildSelectField('Usage', PLAYBACK_USAGE_OPTIONS, this.playbackUsage, (nextValue: number) => {
            this.playbackUsage = nextValue;
            this.forceRefresh();
          })
          this.buildSelectField('Sample Rate', SAMPLE_RATE_OPTIONS, this.playbackSampleRate, (nextValue: number) => {
            this.playbackSampleRate = nextValue;
            this.forceRefresh();
          })
        }
        Row({ space: 6 }) {
          this.buildSelectField('Channels', CHANNEL_OPTIONS, this.playbackChannelCount, (nextValue: number) => {
            this.playbackChannelCount = nextValue;
            this.forceRefresh();
          })
          this.buildSelectField('Format', SAMPLE_FORMAT_OPTIONS, this.playbackSampleFormat, (nextValue: number) => {
            this.playbackSampleFormat = nextValue;
            this.forceRefresh();
          })
        }
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
      .border({ width: 1, color: '#E2E8F0' });

      Column({ space: 8 }) {
        this.buildSectionTitle('应用级快照', '通过 TS 和 C API 打印应用级快照，验证并发流信息。')
        Row({ space: 6 }) {
          Button('TS应用快照')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              this.printTsAppSnapshot();
            });
          Button('C应用快照')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              this.printCAppSnapshot();
            });
        }
        this.buildSnapshotTextPanel('TS应用快照', this.tsAppSnapshotStatus,
          this.tsAppSnapshotPath, this.tsAppSnapshotText, this.showTsAppSnapshotText, () => {
            this.showTsAppSnapshotText = !this.showTsAppSnapshotText;
            this.forceRefresh();
          })
        this.buildSnapshotTextPanel('C应用快照', this.cAppSnapshotStatus,
          this.cAppSnapshotPath, this.cAppSnapshotText, this.showCAppSnapshotText, () => {
            this.showCAppSnapshotText = !this.showCAppSnapshotText;
            this.forceRefresh();
          })
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
      .border({ width: 1, color: '#E2E8F0' });

      Column({ space: 6 }) {
        this.buildSectionTitle('如何验证并发', '关注多流并发快照的正确性。')
        Text('TS并发：同时创建 TS Stream 1 和 TS Stream 2，启动后打印采集快照和TS应用快照。')
          .fontSize(9)
          .width('100%');
        Text('C并发：同时创建 C Stream 1 和 C Stream 2，启动后打印采集快照和C应用快照。')
          .fontSize(9)
          .width('100%');
        Text('混合：同时启动1个 TS + 1个 C 流，打印所有应用快照和Framework快照。')
          .fontSize(9)
          .width('100%');
        Text('播放：先录音，然后播放；播放过程中打印播放快照，验证并发快照正确性。')
          .fontSize(9)
          .width('100%');
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
      .border({ width: 1, color: '#E2E8F0' });
    }
  }

  @Builder
  private buildJsPage() {
    Column({ space: 8 }) {
      this.buildSectionTitle('TS 并发流', '同时创建两个 JS 采集流，打印采集/播放快照。')
      ForEach(this.jsStreams, (stream: JsStreamState) => {
        this.buildJsStreamCard(stream);
      }, (stream: JsStreamState) => `${stream.id}`);
    }
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .border({ width: 1, color: '#E2E8F0' });
  }

  @Builder
  private buildNativePage() {
    Column({ space: 8 }) {
      this.buildSectionTitle('C 并发流', '同时创建两个 C 采集流，打印采集/播放快照。')
      ForEach(this.nativeStreams, (stream: NativeStreamState) => {
        this.buildNativeStreamCard(stream);
      }, (stream: NativeStreamState) => `${stream.id}`);
    }
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .border({ width: 1, color: '#E2E8F0' });
  }

  @Builder
  private buildSnapshotCenterPage() {
    Column({ space: 10 }) {
      Column({ space: 8 }) {
        this.buildSectionTitle('快照中心', '一次性捕获所有可用的应用级、采集级和播放级快照。')
        Row({ space: 6 }) {
          Button('捕获所有快照')
            .height(32)
            .fontSize(11)
            .layoutWeight(1)
            .onClick(() => {
              this.printAllAvailableSnapshots();
            });
        }
        this.buildSnapshotTextPanel('TS应用快照', this.tsAppSnapshotStatus,
          this.tsAppSnapshotPath, this.tsAppSnapshotText, this.showTsAppSnapshotText, () => {
            this.showTsAppSnapshotText = !this.showTsAppSnapshotText;
            this.forceRefresh();
          })
        this.buildSnapshotTextPanel('C应用快照', this.cAppSnapshotStatus,
          this.cAppSnapshotPath, this.cAppSnapshotText, this.showCAppSnapshotText, () => {
            this.showCAppSnapshotText = !this.showCAppSnapshotText;
            this.forceRefresh();
          })
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
      .border({ width: 1, color: '#E2E8F0' });

      Column({ space: 6 }) {
        this.buildSectionTitle('Framework 快照', '系统观察到的活跃采集流。在并发场景下最有用。')
        ForEach(this.frameworkSnapshot, (line: string) => {
          Text(line)
            .fontSize(9)
            .width('100%');
        }, (line: string) => line);
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
      .border({ width: 1, color: '#E2E8F0' });

      Column({ space: 6 }) {
        this.buildSectionTitle('事件日志', '最近的操作和错误。')
        if (this.logs.length === 0) {
          Text('暂无事件')
            .fontSize(9)
            .width('100%');
        }
        ForEach(this.logs, (line: string) => {
          Text(line)
            .fontSize(9)
            .width('100%');
        }, (line: string) => line);
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
      .border({ width: 1, color: '#E2E8F0' });
    }
  }

  @Builder
  private buildCurrentPage() {
    if (this.currentPage === 0) {
      this.buildOverviewPage()
    } else if (this.currentPage === 1) {
      this.buildJsPage()
    } else if (this.currentPage === 2) {
      this.buildNativePage()
    } else {
      this.buildSnapshotCenterPage()
    }
  }

  build() {
    Scroll() {
      Column({ space: 10 }) {
        this.buildHeaderPanel()
        this.buildCurrentPage()
      }
      .padding(10)
      .width('100%');
    }
    .backgroundColor('#F3F4F6')
    .scrollBar(BarState.Auto);
  }
}
