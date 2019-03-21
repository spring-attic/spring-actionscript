/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.springextensions.actionscript.ioc.factory.impl {

	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;

	import org.as3commons.lang.IDisposable;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.ioc.factory.event.InstanceCacheEvent;

	public class DefaultInstanceCacheTest {

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var disposable:IDisposable;

		private var _cache:DefaultInstanceCache;

		public function DefaultInstanceCacheTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_cache = new DefaultInstanceCache();
		}

		[Test]
		public function testPrepareInstance():void {
			var count:int = 0;
			var obj1:Object = {};
			_cache.addEventListener(InstanceCacheEvent.INSTANCE_PREPARED, function(event:InstanceCacheEvent):void {
				count++;
				assertStrictlyEquals(event.cachedInstance, obj1);
				assertNull(event.previousInstance);
				assertStrictlyEquals("test", event.cacheName);
			});
			_cache.prepareInstance("test", obj1);
			assertEquals(1, count);
		}

		[Test]
		public function testPutInstance():void {
			var count:int = 0;
			var obj1:Object = {};
			var obj2:Object = {};
			var obj3:Object = {};
			_cache.addEventListener(InstanceCacheEvent.INSTANCE_ADDED, function(event:InstanceCacheEvent):void {
				count++;
				if (count == 1) {
					assertStrictlyEquals(event.cachedInstance, obj1);
					assertNull(event.previousInstance);
					assertEquals("test", event.cacheName);
				}
				if (count == 3) {
					assertStrictlyEquals(event.cachedInstance, obj3);
					assertNull(event.previousInstance);
					assertEquals("test2", event.cacheName);
				}
			});
			_cache.addEventListener(InstanceCacheEvent.INSTANCE_UPDATED, function(event:InstanceCacheEvent):void {
				count++;
				assertStrictlyEquals(event.cachedInstance, obj2);
				assertStrictlyEquals(event.previousInstance, obj1);
				assertEquals("test", event.cacheName);
			});
			assertEquals(0, _cache.numInstances());
			_cache.putInstance("test", obj1);
			assertEquals(1, _cache.numInstances());
			_cache.putInstance("test", obj2);
			assertEquals(1, _cache.numInstances());
			_cache.putInstance("test2", obj3);
			assertEquals(2, _cache.numInstances());
			assertEquals(3, count);
		}

		[Test]
		public function testCancelReplaceInstance():void {
			var obj1:Object = {};
			var obj2:Object = {};
			_cache.addEventListener(InstanceCacheEvent.BEFORE_INSTANCE_UPDATE, function(event:InstanceCacheEvent):void {
				event.preventDefault();
			});
			_cache.putInstance("test", obj1);
			_cache.putInstance("test", obj2);
			assertEquals(obj1, _cache.getInstance("test"));
		}

		[Test]
		public function testCancelPutInstance():void {
			var obj1:Object = {};
			_cache.addEventListener(InstanceCacheEvent.BEFORE_INSTANCE_ADD, function(event:InstanceCacheEvent):void {
				event.preventDefault();
			});
			_cache.putInstance("test", obj1);
			assertFalse(_cache.hasInstance("test"));
		}

		[Test]
		public function testCancelRemoveInstance():void {
			var obj1:Object = {};
			_cache.addEventListener(InstanceCacheEvent.BEFORE_INSTANCE_REMOVE, function(event:InstanceCacheEvent):void {
				event.preventDefault();
			});
			_cache.putInstance("test", obj1);
			_cache.removeInstance("test");
			assertTrue(_cache.hasInstance("test"));
		}

		[Test(expects="flash.errors.IllegalOperationError")]
		public function testAddNullInstance():void {
			_cache.putInstance("test", null);
		}

		[Test(expects="flash.errors.IllegalOperationError")]
		public function testAddUndefinedInstance():void {
			_cache.putInstance("test", undefined);
		}

		[Test]
		public function testRemoveInstance():void {
			var count:int = 0;
			var obj:Object = {};
			_cache.addEventListener(InstanceCacheEvent.INSTANCE_REMOVED, function(event:InstanceCacheEvent):void {
				count++;
				assertStrictlyEquals(event.cachedInstance, obj);
				assertNull(event.previousInstance);
				assertEquals("test", event.cacheName);
			});
			assertEquals(0, _cache.numInstances());
			_cache.putInstance("test", obj);
			assertEquals(1, _cache.numInstances());
			assertStrictlyEquals(obj, _cache.removeInstance("test"));
			assertEquals(0, _cache.numInstances());
			assertEquals(1, count);
		}

		[Test]
		public function testHasInstance():void {
			_cache.putInstance("test", {});
			assertTrue(_cache.hasInstance("test"));
			assertFalse(_cache.hasInstance("test2"));
		}

		[Test]
		public function testGetInstance():void {
			var instance:Object = {};
			_cache.putInstance("test", instance);
			var instance2:Object = _cache.getInstance("test");
			assertStrictlyEquals(instance, instance2);

			instance = {};
			_cache.putInstance("test2", instance);
			instance2 = _cache.getInstance("test2");
			assertStrictlyEquals(instance, instance2);
		}

		[Test(expects="org.springextensions.actionscript.ioc.factory.error.CachedInstanceNotFoundError")]
		public function testGetInstanceForUnknownInstance():void {
			_cache.getInstance("test");
		}

		[Test]
		public function testClearCache():void {
			_cache.putInstance("test", {});
			_cache.putInstance("test2", {});

			assertEquals(2, _cache.numInstances());
			var count:int = 0;
			_cache.addEventListener(InstanceCacheEvent.CLEARED, function(event:InstanceCacheEvent):void {
				count++;
				assertNull(event.previousInstance);
				assertNull(event.cachedInstance);
				assertNull(event.cacheName);
			});
			_cache.clearCache();
			assertEquals(0, _cache.numInstances());
			assertEquals(1, count);
		}

		[Test]
		public function testClearCacheWithIDisposableImplementation():void {
			disposable = nice(IDisposable);
			mock(disposable).method("dispose").once();

			_cache.putInstance("test", disposable);
			_cache.clearCache();

			verify(disposable);
		}

		[Test]
		public function testClearCacheWithIDisposableImplementationButNotManaged():void {
			disposable = nice(IDisposable);
			mock(disposable).method("dispose").never();

			_cache.putInstance("test", disposable, false);
			_cache.clearCache();

			verify(disposable);
		}

		[Test]
		public function testIsPreparedWithObjectThatIsNotPrepared():void {
			var result:Boolean = _cache.isPrepared("test");
			assertFalse(result);
		}

		[Test]
		public function testIsPreparedWithObjectThatIsPrepared():void {
			var obj:Object = {};
			_cache.prepareInstance("test", obj);
			var result:Boolean = _cache.isPrepared("test");
			assertTrue(result);
		}

		[Test]
		public function testIsManaged():void {
			var obj:Object = {};
			_cache.putInstance("test", obj);
			var result:Boolean = _cache.isManaged("test");
			assertTrue(result);
			_cache.putInstance("test", obj, false);
			result = _cache.isManaged("test");
			assertFalse(result);
		}

		[Test]
		public function testPreparedObjectIsRemovedFromPreparedCacheAfterPutInstance():void {
			var obj:Object = {};
			_cache.prepareInstance("test", obj);
			_cache.putInstance("test", obj);
			var result:Boolean = _cache.isPrepared("test");
			assertFalse(result);
		}

	}
}
