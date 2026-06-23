export const playNative: (
  inputFileFd: number,
  inputFileOffset: number,
  inputFileSize: number,
  cbFn: () => void,
  audioCbFn: () => void
) => void;

export const stopNative: () => void

export const releaseNative: () => void

export const resetNative: () => void

export const pauseNative: () => void

export const resumeNative: () => void

export const speedNative: (
  speed: number
) => void

export const setSurfaceNative: (
  surfaceId: string
) => void

export const seekNative: (
  seekTime: number,
  mode: number,
  acc: boolean,
) => void

export const setVolumeNative: (
  volume: number,
) => void

export const getDurationTime: (
) => number

export const getProgressTime: (
) => number

export const startNative: () => void

export const prepareNative: () => number

export const startDecoderNative: () => void

export const renderFirstFrameNative: () => void

export const startRenderNative: () => void

export const startAudioNative: () => void




