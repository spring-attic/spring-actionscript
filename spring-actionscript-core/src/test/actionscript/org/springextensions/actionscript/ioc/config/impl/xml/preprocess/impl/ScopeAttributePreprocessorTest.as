/*
 * Copyright 2007-2008 the original author or authors.
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
package org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl {
	import org.flexunit.asserts.assertTrue;


	/**
	 * @author Christophe Herreman
	 */
	public class ScopeAttributePreprocessorTest {

		public function ScopeAttributePreprocessorTest() {
			super();
		}

		[Test]
		public function testPreprocess_shouldAddScopeAttributeAsSingletonIfSingletonAttributeIsTrue():void {
			var p:ScopeAttributePreprocessor = new ScopeAttributePreprocessor();
			var xml:XML = <objects>
					<object class="Object" singleton="true"/>
				</objects>;
			xml = p.preprocess(xml);
			var node:XML = xml.children()[0];
			assertTrue(node.@scope == "singleton");
			assertTrue(node.@singleton == undefined);
		}

		[Test]
		public function testPreprocess_shouldAddScopeAttributeAsPrototypeIfSingletonAttributeIsFalse():void {
			var p:ScopeAttributePreprocessor = new ScopeAttributePreprocessor();
			var xml:XML = <objects>
					<object class="Object" singleton="false"/>
				</objects>;
			xml = p.preprocess(xml);
			var node:XML = xml.children()[0];
			assertTrue(node.@scope == "prototype");
			assertTrue(node.@singleton == undefined);
		}

		[Test]
		public function testPreprocess_shouldAddScopeAttributeAsSingletonIfSingletonAttributeIsNotSpecified():void {
			var p:ScopeAttributePreprocessor = new ScopeAttributePreprocessor();
			var xml:XML = <objects>
					<object class="Object"/>
				</objects>;
			xml = p.preprocess(xml);
			var node:XML = xml.children()[0];
			assertTrue(node.@scope == "singleton");
			assertTrue(node.@singleton == undefined);
		}

	}
}
