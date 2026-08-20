import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { TowerOfHanoi } from '../main/ets/engine/hanoi';

export default function localUnitTest() {
  describe('engineSkeleton', () => {
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
    });
    it('emptyAssertion', 0, () => {
      // 工单 01 的空断言:单测脚手架跑通即可。
      // 同时引用规则引擎目录(hanoi.ets),验证「引擎模块目录可被测试引用」;
      // 真实逻辑断言自工单 02 起加入。
      let engine = new TowerOfHanoi();
      expect(typeof engine).assertEqual('object');
    });
  });
}