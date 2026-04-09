import { PhotoGroupModel, PhotoPosition } from "../models/PhotoModel";
import Logger from "./Logger";

export const FIRST_ROW_MAX_INDEX = 4;

const TWO = 2;
const SECOND_ROW_MAX_INDEX = 3;
const OTHER_ROW_MAX_INDEX = 5;
const FIRST_ROW_MAX_COUNT = 5;
const OTHER_ROW_MAX_COUNT = 6;
const NUMBER_8 = 8;
const TAG = 'PhotoPositionUtils';

export class PhotoPositionUtils {
  static getPhotoPosition(groupIndex: number, index: number): PhotoPosition {
    let rowIndex = 0;
    let columIndex = 0;
    if (index === 0) {
      return new PhotoPosition(groupIndex, rowIndex, columIndex);
    }
    if (index <= FIRST_ROW_MAX_INDEX) {
      rowIndex = 0;
      columIndex = index;
    } else if (index <= NUMBER_8) {
      rowIndex = 1;
      columIndex = index - FIRST_ROW_MAX_COUNT;
    } else {
      let rem = (index - NUMBER_8) % OTHER_ROW_MAX_COUNT;
      let result = Math.floor((index - NUMBER_8) / OTHER_ROW_MAX_COUNT);
      rowIndex = rem === 0 ? result + 1 : result + 2;
      columIndex = rem === 0 ? OTHER_ROW_MAX_INDEX : rem - 1;
    }
    return new PhotoPosition(groupIndex, rowIndex, columIndex);
  }

  static getIndexByPhotoPosition(position: PhotoPosition): number {
    let index = 0;
    if (position.rowIndex === 0) {
      index = position.columIndex;
    } else if (position.rowIndex === 1) {
      index = FIRST_ROW_MAX_INDEX + position.columIndex + 1
    } else {
      index = NUMBER_8 + (position.rowIndex - 2) * OTHER_ROW_MAX_COUNT + position.columIndex + 1;
    }
    return index;
  }

  static findLeftFocusPhoto(groupIndex: number, index: number): PhotoPosition | undefined {
    Logger.debug(TAG, `findLeftFocusPhoto position = ${groupIndex}, ${index}`);
    let currentPosition = PhotoPositionUtils.getPhotoPosition(groupIndex, index);
    if (currentPosition.rowIndex === 1 && currentPosition.columIndex === 0) {
      return new PhotoPosition(groupIndex, 0, 0);
    }
    if (currentPosition.columIndex > 0) {
      return new PhotoPosition(groupIndex, currentPosition.rowIndex, currentPosition.columIndex - 1);
    }
    return undefined;
  }

  static findRightFocusPhoto(allPhotoGroupList: PhotoGroupModel[], groupIndex: number,
    index: number): PhotoPosition | undefined {
    Logger.debug(TAG, `findRightFocusPhoto position = ${groupIndex}, ${index}`);
    let currentPosition = PhotoPositionUtils.getPhotoPosition(groupIndex, index);
    let lastPosition = PhotoPositionUtils.getPhotoPosition(groupIndex,
      allPhotoGroupList[groupIndex].photoList.length - 1);
    if (currentPosition.rowIndex === lastPosition.rowIndex) {
      if (currentPosition.columIndex < lastPosition.columIndex) {
        return new PhotoPosition(groupIndex, currentPosition.rowIndex, currentPosition.columIndex + 1);
      } else {
        return undefined;
      }
    }
    if ((currentPosition.rowIndex === 0 && currentPosition.columIndex < FIRST_ROW_MAX_INDEX)
      || (currentPosition.rowIndex === 1 && currentPosition.columIndex < SECOND_ROW_MAX_INDEX)
      || (currentPosition.rowIndex > 1 && currentPosition.columIndex < OTHER_ROW_MAX_INDEX)) {
      return new PhotoPosition(groupIndex, currentPosition.rowIndex, currentPosition.columIndex + 1)
    }
    return undefined;
  }

  static findUpFocusPhoto(allPhotoGroupList: PhotoGroupModel[], groupIndex: number,
    index: number): PhotoPosition | undefined {
    let preRow: number = 0;
    let preColum: number = 0;
    let preGroupIndex: number = 0;
    let currentPosition = PhotoPositionUtils.getPhotoPosition(groupIndex, index);
    Logger.debug(TAG, `findUpFocusPhoto  cruPosition = ${JSON.stringify(currentPosition)}`);
    if (currentPosition.rowIndex === 0) {
      //去上一组
      if (groupIndex > 0) {
        let preGroupLastPosition = PhotoPositionUtils.getPhotoPosition(groupIndex - 1,
          allPhotoGroupList[groupIndex - 1].photoList.length - 1);
        preRow = preGroupLastPosition.rowIndex;
        if (preGroupLastPosition.rowIndex === 0) {
          preColum = Math.min(currentPosition.columIndex, preGroupLastPosition.columIndex);
        } else if (preGroupLastPosition.rowIndex === 1) {
          if (currentPosition.columIndex === 0) {
            preColum = 0;
            preRow = 0;
          } else {
            preColum = Math.min(currentPosition.columIndex - 1, preGroupLastPosition.columIndex);
          }
        } else {
          preColum = Math.min(currentPosition.columIndex + 1, preGroupLastPosition.columIndex);
        }
        preGroupIndex = groupIndex - 1;
        return new PhotoPosition(preGroupIndex, preRow, preColum);
      }
    } else {
      //同组
      preGroupIndex = groupIndex;
      preRow = currentPosition.rowIndex - 1;
      if (currentPosition.rowIndex === 1) {
        preColum = currentPosition.columIndex + 1;
      } else if (currentPosition.rowIndex === 2) {
        if (currentPosition.columIndex === 0 || currentPosition.columIndex === 1) {
          preColum = 0;
          preRow = 0;
        } else {
          preColum = currentPosition.columIndex - 2;
        }
      } else {
        preColum = currentPosition.columIndex;
      }
      return new PhotoPosition(preGroupIndex, preRow, preColum);
    }
    return undefined;
  }

  static findDownFocusPhoto(allPhotoGroupList: PhotoGroupModel[], groupIndex: number, index: number,
    count: number): PhotoPosition | undefined {
    let lastIndex = count - 1;
    let nextRow: number = 0;
    let nextColum: number = 0;
    let nextGroupIndex: number;
    let currentPosition = PhotoPositionUtils.getPhotoPosition(groupIndex, index);
    Logger.debug(TAG, `findDownFocusPhoto  cruPosition = ${JSON.stringify(currentPosition)}`);
    let lastPosition = PhotoPositionUtils.getPhotoPosition(groupIndex, lastIndex);
    if (currentPosition.rowIndex === lastPosition.rowIndex ||
      (currentPosition.rowIndex === 0 && currentPosition.columIndex === 0 && lastPosition.rowIndex <= 1)) {
      // 去下一组
      if (groupIndex < allPhotoGroupList.length - 1) {
        nextGroupIndex = groupIndex + 1;
        nextRow = 0;
        let nextGroupLastPosition = PhotoPositionUtils.getPhotoPosition(nextGroupIndex,
          allPhotoGroupList[nextGroupIndex].photoList.length - 1);
        if (nextGroupLastPosition.columIndex === 0) {
          return new PhotoPosition(nextGroupIndex, 0, 0);
        }
        if (currentPosition.rowIndex === 0) {
          nextColum = Math.min(nextGroupLastPosition.columIndex, currentPosition.columIndex);
        } else if (currentPosition.rowIndex === 1) {
          nextColum = Math.min(nextGroupLastPosition.columIndex, currentPosition.columIndex + 1);
        } else {
          if (nextGroupLastPosition.columIndex < currentPosition.columIndex - 1) {
            nextColum = nextGroupLastPosition.columIndex;
          } else {
            nextColum = Math.max(0,currentPosition.columIndex - 1);
          }
        }
        return new PhotoPosition(nextGroupIndex, nextRow, nextColum);
      } else {
        return undefined;
      }
    } else {
      // 同组
      nextRow = currentPosition.rowIndex + 1;
      if (currentPosition.rowIndex === 0) {
        if (currentPosition.columIndex === 0) {
          if (lastPosition.rowIndex > 1) {
            nextColum = 0;
            nextRow = 2;
          } else {
            return undefined;
          }
        } else {
          if (lastPosition.rowIndex === currentPosition.rowIndex + 1) {
            if (lastPosition.columIndex < currentPosition.columIndex - 1) {
              nextColum = lastPosition.columIndex;
            } else {
              nextColum = Math.min(currentPosition.columIndex - 1, lastPosition.columIndex);
            }
          } else {
            nextColum = currentPosition.columIndex - 1;
          }
        }
      } else if (currentPosition.rowIndex === 1) {
        if (lastPosition.rowIndex === currentPosition.rowIndex + 1) {
          if (lastPosition.columIndex < currentPosition.columIndex + TWO) {
            nextColum = lastPosition.columIndex;
          } else {
            nextColum = Math.min(currentPosition.columIndex + TWO, lastPosition.columIndex);
          }
        } else {
          nextColum = currentPosition.columIndex + TWO;
        }
      } else {
        nextColum = Math.min(currentPosition.columIndex, lastPosition.columIndex);
      }
    }
    return new PhotoPosition(groupIndex, nextRow, nextColum);
  }

  static findFocusPositionOnDelete(allPhotoGroupList: PhotoGroupModel[], groupIndex: number,
    index: number): PhotoPosition | undefined {
    if (allPhotoGroupList.length == 0) {
      return undefined
    } else if (groupIndex < allPhotoGroupList.length) {
      if (index < allPhotoGroupList[groupIndex].photoList.length) {
        return PhotoPositionUtils.getPhotoPosition(groupIndex, index)
      } else {
        return PhotoPositionUtils.getLastPositionInGroup(allPhotoGroupList, groupIndex)
      }
    } else {
      return PhotoPositionUtils.getLastPositionInGroup(allPhotoGroupList, allPhotoGroupList.length - 1)
    }
  }

  static getLastPositionInGroup(allPhotoGroupList: PhotoGroupModel[], groupIndex: number): PhotoPosition | undefined {
    if (groupIndex >= allPhotoGroupList.length) {
      return undefined
    }
    return PhotoPositionUtils.getPhotoPosition(groupIndex, allPhotoGroupList[groupIndex].photoList.length - 1)
  }
}
