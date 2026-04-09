import photoAccessHelper from '@ohos.file.photoAccessHelper';
import image from '@ohos.multimedia.image';


export const CACHE_ALBUM_MIN_WIDTH = 1920

export const DEFAULT_ALBUM_WIDTH = 640

@Observed
export class PhotoModel {
  uri: string = '';
  displayName: string = '';
  dateAdded: number = 0;
  duration?: number;
  dateTrashed?: number;
  photoType?: photoAccessHelper.PhotoType;
  thumbnail?: image.PixelMap;
  imageUri?: string;
  width?: number;
  height?: number;
  photoAsset?: photoAccessHelper.PhotoAsset;
  remoteUri?: string;
  size?:number
  photoTag?:string
  pickVideoPreview?:string;
  constructor() {
  }
}

@Observed
export class AlbumModel {
  type: AlbumType
  name: ResourceStr = ''
  count: number = 0
  cover?: PixelMap | ResourceStr | DrawableDescriptor

  constructor(type: AlbumType, name: ResourceStr) {
    this.type = type;
    this.name = name;
  }
}

@Observed
export class PhotoGroupModel {
  createTime: number = 0
  photoList: PhotoModel[] = []
}

export class PhotoPosition {
  groupIndex: number = 0
  rowIndex: number = 0
  columIndex: number = 0

  constructor(groupIndex: number, rowIndex: number, columIndex: number) {
    this.groupIndex = groupIndex;
    this.rowIndex = rowIndex;
    this.columIndex = columIndex;
  }
}

export enum AlbumType {
  ALL,
  FAVORITE,
  SCREENSHOT,
  TRASH,
  NAS_SESSION,
  NAS_CLIENT
}

export interface AlbumMenuModel {
  uri: string,
  name: string,
}

export interface DialogModel {
  uri: string,
  name: Resource,
}
