#include "Player.h"
#include <netinet/tcp.h>
#include <queue>
#include <bits/alltypes.h>
#include "av_codec_sample_log.h"
#include "dfx/error/av_codec_sample_error.h"
#include "lppCallback.h"

#undef LOG_TAG
#define LOG_TAG "playerDemo"

namespace {
constexpr int BALANCE_VALUE = 5;
using namespace std::chrono_literals;
static const int MS_TO_S = 1000;
constexpr int64_t WAIT_TIME_US_THRESHOLD_WARNING = -1 * 40 * 1000; // warning threshold 40ms
constexpr int64_t WAIT_TIME_US_THRESHOLD = 1 * 1000 * 1000;        // max sleep time 1s
constexpr int64_t SINK_TIME_US_THRESHOLD = 100000;                 // max sink time 100ms
constexpr int32_t BYTES_PER_SAMPLE_2 = 2;                          // 2 bytes per sample
constexpr double VSYNC_TIME = 1000 / 60;                           // frame time
constexpr double LIP_SYNC_BALANCE_VALUE = 2;                       // the balance value of sync sound and picture
constexpr int32_t MAX_BUFFER_SIZE = 2*1024*1024;
constexpr int32_t WAIT_OUT_TIME = 50000;                              // 等待时间MS
constexpr int32_t VIDEO_FRAME_COUNT = 1;                            //视频聚包帧数
constexpr int32_t AUDIO_FRAME_COUNT = 10;                            //视频聚包帧数
} // namespace

Player::~Player()
{
    Player::StartRelease();
}

bool Player::Intercept()
{
    if(demuxer_ == nullptr || lppVideoStreamer_ == nullptr || lppAudioStreamer_ == nullptr){
        return true;
    }
    return false;
}

int32_t Player::CreateLppAudioStreamer()
{
    AVCODEC_SAMPLE_LOGW("CreateLppAudioStreamer IN");
    if(lppAudioStreamer_ == nullptr){
        AVCODEC_SAMPLE_LOGE("lppAudioStreamer_ is Release, should init");
        return -1;
    }
    auto ret = lppAudioStreamer_->Create(sampleInfo_.audioCodecMime);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK , AVCODEC_SAMPLE_ERR_ERROR, "CreateLppAudioStreamer failed.");
    lppContext_ = new LppUserData;
    lppContext_->audioCallback = sampleInfo_.audioCallback;
    lppContext_->audioCallbackData = sampleInfo_.audioCallbackData;
    ret = lppAudioStreamer_->SetCallback(lppContext_);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK , AVCODEC_SAMPLE_ERR_ERROR, "SetCallback failed.");
    ret = lppAudioStreamer_->SetParameter(sampleInfo_);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK , AVCODEC_SAMPLE_ERR_ERROR, "SetParameter failed.");
     AVCODEC_SAMPLE_LOGW("CreateLppAudioStreamer OUT");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Player::CreateLppVideoStreamer()
{
    AVCODEC_SAMPLE_LOGI("CreateLppVideoStreamer IN");
    if(lppVideoStreamer_ == nullptr){
        AVCODEC_SAMPLE_LOGE("lppVideoStreamer_ is Release, should init");
        return -1;
    }
    AVCODEC_SAMPLE_LOGI("FORMAT : %{public}s", sampleInfo_.videoCodecMime.c_str());
    sampleInfo_.window = NativeXComponentSample::PluginManager::GetInstance()->pluginWindow_;
//     video/avc
    lppVideoStreamer_->Create(sampleInfo_.videoCodecMime.c_str());
    lppVideoContext_ = new LppUserData;
    lppVideoContext_->num = 100012;
    lppVideoStreamer_->SetCallback(lppVideoContext_);
    OH_AVFormat *format = OH_AVFormat_Create();
    lppVideoStreamer_->Configure(sampleInfo_);
    lppVideoStreamer_->SetVideoSurface(sampleInfo_);
    AVCODEC_SAMPLE_LOGI("CreateLppVideoStreamer OUT");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Player::Init(SampleInfo &sampleInfo)
{
    Stop();
    Reset();
    StartRelease();
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!isStarted_, AVCODEC_SAMPLE_ERR_ERROR, "Already started.");
    sampleInfo_ = sampleInfo;
    sampleInfo_.isInit = true;
    CHECK_AND_RETURN_RET_LOG(demuxer_ == nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Already started.");
    demuxer_ = std::make_unique<Demuxer>();
    AVCODEC_SAMPLE_LOGI("Create lppAudioStreamer_ SUCC");
    lppAudioStreamer_ = std::make_shared<LppAudioStreamer>();
    lppVideoStreamer_ = std::make_shared<LppVideoStreamer>();
    isReleased_ = false;
    AVCODEC_SAMPLE_LOGI("Succeed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Player::Prepare()
{
    AVCODEC_SAMPLE_LOGW("Prepare IN");
    if(!sampleInfo_.isInit){
        return 0;
    }
    std::unique_lock<std::mutex> lock(mutex_);
    if (demuxer_ == nullptr){
        demuxer_ = std::make_unique<Demuxer>();
    }
    int32_t ret = demuxer_->Create(sampleInfo_);

    ret = CreateLppAudioStreamer();
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK , AVCODEC_SAMPLE_ERR_ERROR, "CreateLppAudioStreamer failed.");
    
    ret = CreateLppVideoStreamer();
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK , AVCODEC_SAMPLE_ERR_ERROR, "CreateLppVideoStreamer failed.");

    lppVideoStreamer_->SetSyncAudioStreamer(lppAudioStreamer_->lppAudioStreamer_);
    lppVideoStreamer_->Prepare();
    lppAudioStreamer_->Prepare();

    isReleased_ = false;
    isStarted_ = true;
    if(lppVideoContext_){
        if (lppVideoDataNeededThread_ == nullptr){
            lppVideoDataNeededThread_ = std::make_unique<std::thread>(&Player::LppVideoDataNeededThread, this);
        }
    }
    if(lppContext_){
        if (LppDataNeededThread_ == nullptr){
            LppDataNeededThread_ = std::make_unique<std::thread>(&Player::LppDataNeededThread1, this);
        }
    }
    AVCODEC_SAMPLE_LOGW("Prepare OUT");
    return 0;
}

int32_t Player::StartDecoder()
{
    isStarted_ = true;
    state_ = PLAYING;
    CHECK_AND_RETURN_RET_LOG(lppVideoContext_ != nullptr , AVCODEC_SAMPLE_ERR_ERROR, "CreateLppAudioStreamer failed.");
    return lppVideoStreamer_->StartDecode(true);
}

int32_t Player::RenderFirstFrame()
{
    CHECK_AND_RETURN_RET_LOG(lppVideoContext_ != nullptr && lppVideoStreamer_ != nullptr , AVCODEC_SAMPLE_ERR_ERROR, "lppVideoStreamer_ nullptr.");
    return lppVideoStreamer_->RenderFirstFrame();
}

int32_t Player::StartRender()
{
    isStarted_ = true;
    state_ = PLAYING;
    CHECK_AND_RETURN_RET_LOG(lppVideoContext_ != nullptr && lppVideoStreamer_ != nullptr , AVCODEC_SAMPLE_ERR_ERROR, "lppVideoStreamer_ nullptr.");
    return lppVideoStreamer_->StartRender();
}

int32_t Player::StartAudio()
{
    isStarted_ = true;
    state_ = PLAYING;
    CHECK_AND_RETURN_RET_LOG(lppContext_ != nullptr && lppAudioStreamer_ != nullptr , AVCODEC_SAMPLE_ERR_ERROR, "lppAudioStreamer_ nullptr.");
    return lppAudioStreamer_->Start();
}

int32_t Player::Stop()
{
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!Intercept(), AVCODEC_SAMPLE_ERR_ERROR, "Intercept nullptr.");
    AVCODEC_SAMPLE_LOGI("stop in");
    isStarted_ = false;
    if (lppAudioStreamer_ != nullptr) {
        lppAudioStreamer_->Stop();
    }
    if (lppVideoStreamer_ != nullptr) {
        lppVideoStreamer_->Stop();
    }
    AVCODEC_SAMPLE_LOGI("stop out");
    lock.unlock();
    return 0;
}

int32_t Player::Reset()
{
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!Intercept(), AVCODEC_SAMPLE_ERR_ERROR, "Intercept nullptr.");
    isStarted_ = false;
    ReleaseThread();
    AVCODEC_SAMPLE_LOGD("reset in");
    if (demuxer_ != nullptr) {
        demuxer_->Release();
        demuxer_.reset();
    }
    if (lppAudioStreamer_ != nullptr) {
        lppAudioStreamer_->Reset();
    }
    if (lppVideoStreamer_ != nullptr) {
        lppVideoStreamer_->Reset();
    }
    AVCODEC_SAMPLE_LOGD("reset out");
    lock.unlock();
    return 0;
}

int32_t Player::Pause()
{
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!Intercept(), AVCODEC_SAMPLE_ERR_ERROR, "Intercept nullptr.");
    AVCODEC_SAMPLE_LOGD("Pause in");
    if (lppAudioStreamer_ != nullptr) {
        lppAudioStreamer_->Pause();
    }
    if (lppVideoStreamer_ != nullptr) {
        lppVideoStreamer_->Pause();
    }
    AVCODEC_SAMPLE_LOGD("Pause out");
    lock.unlock();
    return 0;
}

int32_t Player::Resume()
{
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!Intercept(), AVCODEC_SAMPLE_ERR_ERROR, "Intercept nullptr.");
    state_ = PLAYING;
    if (lppAudioStreamer_ != nullptr) {
        lppAudioStreamer_->Resume();
    }
    if (lppVideoStreamer_ != nullptr) {
        lppVideoStreamer_->Resume();
    }
    lock.unlock();
    return 0;
}

int32_t Player::Flush()
{
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!Intercept(), AVCODEC_SAMPLE_ERR_ERROR, "Intercept nullptr.");
    state_ = PAUSE;
    if (lppAudioStreamer_ != nullptr) {
        lppAudioStreamer_->Flush();
    }
    if (lppVideoStreamer_ != nullptr) {
        lppVideoStreamer_->Flush();
    }
    lock.unlock();
    return 0;
}

int32_t Player::SetSpeed(double speed)
{
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!Intercept(), AVCODEC_SAMPLE_ERR_ERROR, "Intercept nullptr.");
    if (lppAudioStreamer_ != nullptr) {
        lppAudioStreamer_->SetPlayBackSpeed(speed);
    }
    if (lppVideoStreamer_ != nullptr) {
        lppVideoStreamer_->SetPlaybackSpeed(speed);
    }
    lock.unlock();
    return 0;
}

int32_t Player::SetSurface(int64_t surfaceId)
{
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!Intercept(), AVCODEC_SAMPLE_ERR_ERROR, "Intercept nullptr.");
    AVCODEC_SAMPLE_LOGD("SetSurface in %{public}d", surfaceId);
    if (lppVideoStreamer_ != nullptr) {
        OHNativeWindow *oHNativeWindow;
        OH_NativeWindow_CreateNativeWindowFromSurfaceId(surfaceId,&oHNativeWindow);
        sampleInfo_.window = oHNativeWindow;
        lppVideoStreamer_->SetVideoSurface(sampleInfo_);
    }
    AVCODEC_SAMPLE_LOGD("SetSurface out");
    lock.unlock();
    return 0;
}

int32_t Player::SetVolume(double volume)
{
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!Intercept(), AVCODEC_SAMPLE_ERR_ERROR, "Intercept nullptr.");
    CHECK_AND_RETURN_RET_LOG(lppAudioStreamer_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "lppAudioStreamer_ nullptr.");
    if (lppAudioStreamer_ != nullptr) {
        lppAudioStreamer_->SetVolume(volume);
    }
    lock.unlock();
    return 0;
}

// pause/flush/seek/resume
int32_t Player::Seek(int64_t seekTime, int32_t mode, bool acc)
{
    std::unique_lock<std::mutex> seekLock(SeekMutex);
    auto start = std::chrono::high_resolution_clock::now();
    CHECK_AND_RETURN_RET_LOG(!Intercept(), AVCODEC_SAMPLE_ERR_ERROR, "Intercept nullptr.");
    lppContext_->position = -1;
    if(sampleInfo_.duration<seekTime*1000){
        AVCODEC_SAMPLE_LOGI("Seek over duration %{public}ld",sampleInfo_.duration);
        return 0;
    }
    if(mode == 3){
        SeekInner(seekTime, 3);
        return 0;
    }
    Pause();
    OH_AVSeekMode enumNum = static_cast<OH_AVSeekMode>(mode);
    AVCODEC_SAMPLE_LOGI("OH_AVSeekMode  %{public}d", mode);
    int32_t aa = demuxer_->Seek(seekTime, enumNum);
    if (aa != 0){
        AVCODEC_SAMPLE_LOGD("Seek failed.");
        demuxer_->Seek(seekTime, SEEK_MODE_CLOSEST_SYNC);
    }
    // Seek后唤醒
    {
        std::unique_lock<std::mutex> eosFlagMutexLock(lppContext_->eosFlagMutex);
        lppContext_->eosFlag_ = false;
        lppContext_->returnFrame = false;
        AVCODEC_SAMPLE_LOGI("AUDIO eosFlag_ %{public}d",lppContext_->eosFlag_);
        lppContext_->eosCond_.notify_all();
        eosFlagMutexLock.unlock();
    }
    {
        std::unique_lock<std::mutex> eosFlagMutexLock(lppVideoContext_->eosFlagMutex);
        lppVideoContext_->eosFlag_ = false;
        lppVideoContext_->returnFrame = false;
        AVCODEC_SAMPLE_LOGI("VIDEO eosFlag_ %{public}d",lppContext_->eosFlag_);
        lppVideoContext_->eosCond_.notify_all();
        eosFlagMutexLock.unlock();
    }
    Flush();
    StartDecoder();
    StartRender();
    StartAudio();
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
    AVCODEC_SAMPLE_LOGI("seek duration %lld",duration);
    return 0;
}

int64_t Player::ReadToAudioTargetPts(int64_t targetPts)
{
    
    OH_AVBuffer * avbuffer = OH_AVBuffer_Create(MAX_BUFFER_SIZE);
    CodecBufferInfo bufferInfo(11, avbuffer);
    while (true)
        {
            demuxer_->ReadSample(demuxer_->GetAudioTrackId(), reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer),
                bufferInfo.attr);
            if(targetPts<=bufferInfo.attr.pts)
            {
                break;
            }
            if(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS){
                 break;
            }
        }
    AVCODEC_SAMPLE_LOGI("ReadToAudioTargetPts Last pts is %{public}ld",bufferInfo.attr.pts);
    return bufferInfo.attr.pts;
}

void Player::SeekInner(int64_t seekTime, int32_t mode)
{
    AVCODEC_SAMPLE_LOGI("============== Seek ACC IN ===============");
    int64_t targetPts = seekTime*1000;
    AVCODEC_SAMPLE_LOGI("SetTargetStartFrame %{public}ld",targetPts);
    //暂停
    Pause();
    {
        std::unique_lock<std::mutex> eosFlagMutexLock(lppContext_->eosFlagMutex);
        lppContext_->eosFlag_ = false;
        lppContext_->returnFrame = false;
        AVCODEC_SAMPLE_LOGI("AUDIO eosFlag_ %{public}d",lppContext_->eosFlag_);
        lppContext_->eosCond_.notify_all();
        eosFlagMutexLock.unlock();
    }
    {
        std::unique_lock<std::mutex> eosFlagMutexLock(lppVideoContext_->eosFlagMutex);
        lppVideoContext_->eosFlag_ = false;
        lppVideoContext_->returnFrame = false;
        AVCODEC_SAMPLE_LOGI("VIDEO eosFlag_ %{public}d",lppContext_->eosFlag_);
        lppVideoContext_->eosCond_.notify_all();
        eosFlagMutexLock.unlock();
    }
    Flush();
    demuxer_->Seek(seekTime, SEEK_MODE_PREVIOUS_SYNC);
    //音频读取到对应帧
    ReadToAudioTargetPts(targetPts);
    //给视频设置回调和TargetPts
    if (lppVideoStreamer_ != nullptr) {
        lppVideoStreamer_->SetTargetStartFrame(targetPts, LppCallback::OnTargetArrived, WAIT_OUT_TIME, lppVideoContext_);
        StartDecoder();
        StartRender();
    }
    //等待返回
    std::unique_lock<std::mutex> lock(lppVideoContext_->seekMutex_);
//     lppVideoContext_->seekCond_.wait_for(lock, 10000s, [this]() { return lppVideoContext_->seekReturn_; });
    usleep(50*1000);
    lppVideoContext_->seekReturn_ = false;
    lock.unlock(); 
    //返回成功，启动音频
    if (lppAudioStreamer_ != nullptr) {
        lppAudioStreamer_->Start();
    }
    AVCODEC_SAMPLE_LOGI("============== Seek ACC OUT ===============");
}

void Player::StartRelease()
{
    CHECK_AND_RETURN_LOG(!Intercept(), "Intercept nullptr.");
    std::unique_lock<std::mutex> lock(doneMutex);
    if (!isReleased_) {
        isReleased_ = true;
        Release();
    }
    lock.unlock();
}

int64_t Player::GetDurationTime()
{
    AVCODEC_SAMPLE_LOGD("GetDurationTime %{public}ld",sampleInfo_.duration);
    return sampleInfo_.duration;
}

int64_t Player::GetProgressTime()
{
    std::unique_lock<std::mutex> seekLock(SeekMutex);
    if(lppContext_ == nullptr || lppContext_->position == -1){
        return 0;
    }
    AVCODEC_SAMPLE_LOGD("GetProgressTime position %{public}ld",lppContext_->position);
    int64_t tmp = sampleInfo_.duration/1000000 < (lppContext_->position / 1000) ? sampleInfo_.duration : ( (lppContext_->position /1000) * 1000000);
   return tmp;
}

void Player::ReleaseThread()
{
    if(lppContext_){
        std::unique_lock<std::mutex> eosFlagMutexLock(lppContext_->eosFlagMutex);
        lppContext_->eosFlag_ = false;
        lppContext_->eosCond_.notify_all();
        eosFlagMutexLock.unlock();
        std::unique_lock<std::mutex> lock(lppContext_->inputMutex);
        lppContext_->returnFrame =true;
        lppContext_->inputCond.notify_all();
        lock.unlock();
    }
    
    if(lppVideoContext_){
        std::unique_lock<std::mutex> eosFlagMutexLock(lppVideoContext_->eosFlagMutex);
        lppVideoContext_->eosFlag_ = false;
        lppVideoContext_->eosCond_.notify_all();
        eosFlagMutexLock.unlock();
        std::unique_lock<std::mutex> lockVideo(lppVideoContext_->inputMutex);
        lppVideoContext_->returnFrame = true;
        lppVideoContext_->inputCond.notify_all();
        lockVideo.unlock();
    }
    
    if (LppDataNeededThread_ && LppDataNeededThread_->joinable()) {
        LppDataNeededThread_->join();
        LppDataNeededThread_.reset();
    }
    if (lppVideoDataNeededThread_ && lppVideoDataNeededThread_->joinable()) {
        lppVideoDataNeededThread_->join();
        lppVideoDataNeededThread_.reset();
    }
}

void Player::Release()
{
    std::lock_guard<std::mutex> lock(mutex_);
    isStarted_ = false;
    isAudioDone = false;
    isVideoDone = false;
    ReleaseThread();
    if (demuxer_ != nullptr) {
        demuxer_->Release();
        demuxer_.reset();
    }
    if (lppAudioStreamer_ != nullptr) {
        lppAudioStreamer_->Release();
        lppAudioStreamer_.reset();
    }
    if (lppContext_ != nullptr) {
        delete lppContext_;
        lppContext_ = nullptr;
    }
    if (lppVideoStreamer_ != nullptr) {
        lppVideoStreamer_->Release();
        lppVideoStreamer_.reset();
    }
    if (lppVideoContext_ != nullptr) {
        delete lppVideoContext_;
        lppVideoContext_ = nullptr;
    }
    doneCond_.notify_all();
    // 触发回调
    if(sampleInfo_.playDoneCallback != nullptr){
        sampleInfo_.playDoneCallback(sampleInfo_.playDoneCallbackData);
    }
    AVCODEC_SAMPLE_LOGI("Succeed");
}

void Player::LppDataNeededThread1()
{
    int32_t total_size = 4467270;
    AVCODEC_SAMPLE_LOGI("====== AVBUFFER1234 CREATE ======");
    OH_AVBuffer * avbuffer = OH_AVBuffer_Create(total_size);
    while (true) {
        CHECK_AND_BREAK_LOG(isStarted_, "Decoder input thread out");
        // 到达EOS帧后不再送数据，直到Seek
        std::unique_lock<std::mutex> eosLock(lppContext_->eosMutex);
        lppContext_->eosCond_.wait_for(
            eosLock, 150000s, [this]() { return !lppContext_->eosFlag_; });
        eosLock.unlock();
        // 等待数据回调到达
        std::unique_lock<std::mutex> lock(lppContext_->inputMutex);
        lppContext_->inputCond.wait_for(
            lock, 150000s, [this]() { return lppContext_->returnFrame; });
        lppContext_->returnFrame = false;
        
        CHECK_AND_BREAK_LOG(isStarted_, "VD Decoder output thread out");
        
        lppContext_->count = 1;
        // 聚包数量
        int count  = AUDIO_FRAME_COUNT;
        while (count>0)
            {
                CHECK_AND_BREAK_LOG(!lppContext_->eosFlag_, "AUDIO is EOS");
                count--;
                CodecBufferInfo bufferInfo(11, avbuffer);
                demuxer_->ReadSample(demuxer_->GetAudioTrackId(), reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer),
                    bufferInfo.attr);
                this->progress = bufferInfo.attr.pts;
                int32_t remain = OH_AVSamplesBuffer_GetRemainedCapacity(lppContext_->framePacket_);
                AVCODEC_SAMPLE_LOGD("AUDIO  pts %{public}ld",bufferInfo.attr.pts);
                // EOS帧置位
                if ((bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS)){
                    AVCODEC_SAMPLE_LOGI("Catch EOS, audio thread out");
                    OH_AVBuffer_SetBufferAttr(reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer), &bufferInfo.attr);
                     std::unique_lock<std::mutex> eosFlagMutexLock(lppContext_->eosFlagMutex);
                    lppContext_->eosFlag_ = true;
                    eosFlagMutexLock.unlock();
                }
                OH_AVSamplesBuffer_AppendOneBuffer(lppContext_->framePacket_, reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer));
            }

        if(state_ == PLAYING){
            lppAudioStreamer_->returnFrames(lppContext_);
        }
        // 一次回调处理完再下一次
        lock.unlock();
    }
    AVCODEC_SAMPLE_LOGI("====== AVBUFFER DESTROY ======");
    OH_AVBuffer_Destroy(avbuffer);
}

void Player::LppVideoDataNeededThread()
{
    bool eosFlag = 0;
    int32_t total_size = 4467270;
    AVCODEC_SAMPLE_LOGI("====== AVBUFFER1234 CREATE1 ======");
    OH_AVBuffer * avbuffer = OH_AVBuffer_Create(total_size);
    while (true) {
        CHECK_AND_BREAK_LOG(isStarted_, "Decoder input thread out");
        
        std::unique_lock<std::mutex> eosLock(lppVideoContext_->eosMutex);
        lppVideoContext_->eosCond_.wait_for(
            eosLock, 150000s, [this]() { return !lppVideoContext_->eosFlag_; });
        
        std::unique_lock<std::mutex> lock(lppVideoContext_->inputMutex);
        lppVideoContext_->inputCond.wait_for(
            lock, 150000s, [this]() { return lppVideoContext_->returnFrame; });
        CHECK_AND_BREAK_LOG(isStarted_, "VD Decoder output thread out");
        lppVideoContext_->returnFrame = false;
        CHECK_AND_BREAK_LOG(isStarted_, "Work done, thread out");
        
        
        lppVideoContext_->count = VIDEO_FRAME_COUNT;
        AVCODEC_SAMPLE_LOGI("LppVideoDataNeededThread count %{public}d", lppVideoContext_->count);
        while (lppVideoContext_->count>0)
            {
                CHECK_AND_BREAK_LOG(!lppVideoContext_->eosFlag_, "VIDEO is EOS");
                CodecBufferInfo bufferInfo(11, avbuffer);
                if(seekFlag_){
                    seekFlag_ = false;
                    bufferInfo = videoBufferInfo_.front();
                    videoBufferInfo_.pop();
                }
                else{
                    demuxer_->ReadSample(demuxer_->GetVideoTrackId(), reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer),
                        bufferInfo.attr);
                }
                AVCODEC_SAMPLE_LOGI("LppVideoDataNeededThread size %{public}d",bufferInfo.attr.size);
                AVCODEC_SAMPLE_LOGI("LppVideoDataNeededThread ptsacc %{public}ld",bufferInfo.attr.pts);
                AVCODEC_SAMPLE_LOGI("LppVideoDataNeededThread isIFrame %u",bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_SYNC_FRAME);
                int32_t remain = OH_AVSamplesBuffer_GetRemainedCapacity(lppVideoContext_->framePacket_);
                if ((bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS)){
                    AVCODEC_SAMPLE_LOGI("Catch EOS, video thread out");
                    OH_AVBuffer_SetBufferAttr(reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer), &bufferInfo.attr);
                    std::unique_lock<std::mutex> eosFlagMutexLock(lppVideoContext_->eosFlagMutex);
                    lppVideoContext_->eosFlag_ = true;
                    AVCODEC_SAMPLE_LOGI("VIDEO eosFlag_ %{public}d",lppContext_->eosFlag_);
                    eosFlagMutexLock.unlock();
                }
                OH_AVSamplesBuffer_AppendOneBuffer(lppVideoContext_->framePacket_, reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer));
                lppVideoContext_->count--;
                AVCODEC_SAMPLE_LOGI("LppVideoDataNeededThread count %{public}d", lppVideoContext_->count);
            }
        AVCODEC_SAMPLE_LOGI("LppVideoDataNeededThread count %{public}d", lppVideoContext_->count);
        
        if(state_ == PLAYING){
            lppVideoStreamer_->returnFrames(lppVideoContext_);
        }
        AVCODEC_SAMPLE_LOGD("LppVideoDataNeededThread returnFrames end");
        lock.unlock();
    }
    AVCODEC_SAMPLE_LOGI("====== AVBUFFER1234 DESTROY1 ======");
    OH_AVBuffer_Destroy(avbuffer);
}

