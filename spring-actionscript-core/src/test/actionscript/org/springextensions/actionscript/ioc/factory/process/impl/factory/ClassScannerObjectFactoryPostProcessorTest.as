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
package org.springextensions.actionscript.ioc.factory.process.impl.factory {
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;

	import org.as3commons.bytecode.reflect.ByteCodeTypeCache;
	import org.as3commons.reflect.Type;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.hamcrest.core.anything;
	import org.hamcrest.object.instanceOf;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.metadata.IClassScanner;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ClassScannerObjectFactoryPostProcessorTest {

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var classScanner:IClassScanner;
		[Mock]
		public var factory:IObjectFactory;
		[Mock]
		public var registry:IObjectDefinitionRegistry;
		[Mock]
		public var cache:ByteCodeTypeCache;

		private var _processor:ClassScannerObjectFactoryPostProcessor;

		/**
		 * Creates a new <code>ClassScannerObjectFactoryPostProcessorTest</code> instance.
		 */
		public function ClassScannerObjectFactoryPostProcessorTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_processor = new ClassScannerObjectFactoryPostProcessor();
			factory = nice(IObjectFactory);
			registry = nice(IObjectDefinitionRegistry);
			stub(factory).getter("objectDefinitionRegistry").returns(registry);
		}

		[Test]
		public function testAddScanner():void {
			assertNull(_processor.scanners);
			_processor.addScanner(classScanner);
			assertEquals(1, _processor.scanners.length);
		}

		[Test]
		public function testAddSameScannerTwice():void {
			_processor.addScanner(classScanner);
			_processor.addScanner(classScanner);
			assertEquals(1, _processor.scanners.length);
		}

		[Test]
		public function testRegisterClassScanners():void {
			var classScanner2:IClassScanner = nice(IClassScanner);
			var classScanner3:IClassScanner = nice(IClassScanner);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "scanner1";
			names[names.length] = "scanner2";
			names[names.length] = "scanner3";
			mock(registry).method("getObjectDefinitionNamesForType").args(IClassScanner).returns(names).once();
			mock(factory).method("getObject").args("scanner1").returns(classScanner).once();
			mock(factory).method("getObject").args("scanner2").returns(classScanner2).once();
			mock(factory).method("getObject").args("scanner3").returns(classScanner3).once();
			_processor.registerClassScanners(factory);
			verify(registry);
			verify(factory);
			assertEquals(3, _processor.scanners.length);
		}

		[Test]
		public function testDoScan():void {
			classScanner = nice(IClassScanner);
			cache = nice(ByteCodeTypeCache);
			var names:Vector.<String> = new Vector.<String>();
			names[names.length] = "metadata1";
			mock(classScanner).getter("metadataNames").returns(names).once();
			var classNames:Array = ["com.classes.MyClass", "com.classes.MyClass2"];
			mock(classScanner).method("process").args(classNames[0], "metadata1", anything()).once();
			mock(classScanner).method("process").args(classNames[1], "metadata1", anything()).once();
			mock(cache).method("getClassesWithMetadata").args("metadata1").returns(classNames).once();
			_processor.doScan(classScanner, cache);
			verify(classScanner);
			verify(cache);
		}
	}
}
