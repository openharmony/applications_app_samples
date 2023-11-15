import media from '@ohos.multimedia.media';
import avSession from '@ohos.multimedia.avsession';
import promptAction from '@ohos.promptAction';

const TAG = 'AVCAstDemo';

export default class MediaController {
  private avPlayer: media.AVPlayer;

  setAvPlayer(avPlayer) {
    this.avPlayer = avPlayer;
  }

  play() {
    if (!this.avPlayer) {
      console.info(TAG, 'no avplayer');
      return;
    }
    if (this.avPlayer.state === 'prepared' || this.avPlayer.state === 'paused') {
      console.info(TAG, 'start play');
      this.avPlayer.play();
       this.setAvPlayer(avSession.PlaybackState.PLAYBACK_STATE_PLAY);
      promptAction.showToast({message: 'play done'});
    } else {
      console.info(TAG, 'start pause');
      this.avPlayer.pause();
       this.setAvPlayer(avSession.PlaybackState.PLAYBACK_STATE_PAUSE);
      promptAction.showToast({message: 'pause done'});
    }
  }
}