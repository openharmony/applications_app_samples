import audioTest from './AudioTest'
import videoTest from './VideoTest'
import syncTest from './SyncTest'
import performanceTest from './PerformanceTest'

/**
 * Test Suite for AudioToVideoSync
 * This suite organizes and executes all audio, video, and synchronization tests
 */
export default function testsuite() {
  audioTest()
  videoTest()
  syncTest()
  performanceTest()
}