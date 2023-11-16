export const initCamera:(surfaceId: string, focusMode: number, cameraDeviceIndex: number) => number;
export const startPhotoOrVideo: (modeFlag: string, videoId: string, photoId: string) => number;
export const videoOutputStart: () => number;
export const setZoomRatio: (a: number) => number;
export const takePicture: () => number;
export const takePictureWithSettings: (setting: Capture_Setting) => number;
export const hasFlash: (a: number) => number;
export const isVideoStabilizationModeSupported: (a: number) => number;
export const isExposureModeSupported:(a: number) => number;
export const isMeteringPoint: (a: number, b: number) => number;
export const isExposureBiasRange: (a: number) => number;
export const isFocusModeSupported: (a: number) => number;
export const isFocusPoint: (a: number, b: number) => number;
export const getVideoFrameWidth: () => number;
export const getVideoFrameHeight: () => number;
export const getVideoFrameRate: () => number;
export const videoOutputStopAndRelease: () => number;
export const releaseCamera: () => number;
export const releaseSession: () => number;


interface Capture_Setting {
    quality: number;
    rotation: number;
    mirror: boolean;
    latitude: number;
    longitude: number;
    altitude: number;
}