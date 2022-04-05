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
package org.springextensions.actionscript.ioc.config.impl.xml.parser.impl {

	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;
	import org.springextensions.actionscript.test.testtypes.Person;

	/**
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class XmlObjectDefinitionsParserTest {

		private static const PERSON_XML_WITH_SIBLINGS:XML = <objects>
				<object id="person" class="org.springextensions.actionscript.test.testtypes.Person">
					<property name="name">
						<value>Christophe</value>
					</property>
					<property name="isMarried">
						<value>true</value>
					</property>
					<property name="friends">
						<list/>
					</property>
					<property name="siblings">
						<array>
							<ref>__item0</ref>
						</array>
					</property>
					<property name="age">
						<value>26</value>
					</property>
				</object>
				<object id="__item0" class="org.springextensions.actionscript.test.testtypes.Person">
					<property name="name">
						<value>David</value>
					</property>
					<property name="isMarried">
						<value>false</value>
					</property>
					<property name="friends">
						<list/>
					</property>
					<property name="siblings">
						<array>
							<ref>person</ref>
						</array>
					</property>
					<property name="age">
						<value>16</value>
					</property>
				</object>
			</objects>;

		private var _xml:XML = <objects>
				<object id="christophe" class="org.springextensions.actionscript.test.testtypes.Person">
					<constructor-arg value="Christophe Herreman"/>
					<constructor-arg>
						<value>26</value>
					</constructor-arg>
					<property name="isMarried">
						<value>true</value>
					</property>
				</object>
				<object id="bert" class="org.springextensions.actionscript.test.testtypes.Person">
					<property name="name" value="Bert Vandamme"/>
					<property name="age" value="25"/>
					<property name="isMarried" value="false"/>
				</object>
			</objects>;

		private var _xmlClassStringTest:XML = <objects>
				<object id="factoryTest" class="org.springextensions.actionscript.test.testtypes.PrototypeFactory">
					<property name="classNameToConstruct" value="org.springextensions.actionscript.test.testtypes.Person" type="Class" />
				</object>
			</objects>;

		private var _xmlClassStringTest2:XML = <objects>
				<object id="factoryTest" class="org.springextensions.actionscript.test.testtypes.PrototypeFactory">
					<property name="classNameToConstruct">
						<value type="Class">org.springextensions.actionscript.test.testtypes.Person</value>
					</property>
				</object>
			</objects>;

		private var _xmlClassWithMethodInvocationWithClassArgument:XML = <objects>
				<object id="personMethodInvcocationTest" class="org.springextensions.actionscript.test.testtypes.Person">
					<method-invocation name="isPersonType">
						<arg value="org.springextensions.actionscript.test.testtypes.Person" type="class"/>
					</method-invocation>
				</object>
			</objects>;

		// <property name="colleague" ref="christophe"/>
		private var _christophe:Person;

		private var _bert:Person;

		private var _christopheDefinition:IObjectDefinition;

		private var _bertDefinition:IObjectDefinition;

		public function XmlObjectDefinitionsParserTest() {
			super();
		}

		[Before]
		public function setUp():void {
			_christophe = new Person();
			_christophe.name = "Christophe Herreman";
			_christophe.age = 26;
			_christophe.isMarried = true;

			_bert = new Person();
			_bert.name = "Bert Vandamme";
			_bert.age = 25;
			_bert.isMarried = false;
			_bert.colleague = _christophe;

			_christopheDefinition = new ObjectDefinition("org.springextensions.actionscript.test.testtypes.Person");
			_christopheDefinition.addPropertyDefinition(new PropertyDefinition("name", "Christophe Herreman"));
			_christopheDefinition.addPropertyDefinition(new PropertyDefinition("age", 26));
			_christopheDefinition.addPropertyDefinition(new PropertyDefinition("isMarried", true));

			_bertDefinition = new ObjectDefinition("org.springextensions.actionscript.test.testtypes.Person");
			_bertDefinition.addPropertyDefinition(new PropertyDefinition("name", "Bert Vandamme"));
			_bertDefinition.addPropertyDefinition(new PropertyDefinition("age", 25));
			_bertDefinition.addPropertyDefinition(new PropertyDefinition("isMarried", false));
			//_bertDefinition.properties["colleague"] = _christophe;
		}

		[Test]
		public function testNewWithContainerArgument():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			assertNotNull(parser.applicationContext);
			assertStrictlyEquals(context, parser.applicationContext);
		}

		[Test]
		public function testParse():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(_xml);
			assertNotNull(definitions["christophe"]);
			assertNotNull(definitions["bert"]);
			assertNull(definitions["frank"]);
		}

		[Test]
		/**
		 *
		 */
		public function testParse_shouldAcceptEmptyStringAsConstructorArgument():void {
			var xml:XML = <objects>
					<object id="person" class="org.springextensions.actionscript.test.testtypes.Person">
						<constructor-arg value=""/>
					</object>
				</objects>;
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(xml);

			var person:IObjectDefinition = definitions["person"];
			assertNotNull(person);
			assertNotNull(person.constructorArguments);
			assertEquals(1, person.constructorArguments.length);
			assertEquals("", person.constructorArguments[0].value);
		}

		[Test]
		/**
		 *
		 */
		public function testParse_shouldAcceptNullAsConstructorArgument():void {
			var xml:XML = <objects>
					<object id="person" class="org.springextensions.actionscript.test.testtypes.Person">
						<constructor-arg>
							<null/>
						</constructor-arg>
					</object>
				</objects>;
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(xml);

			var person:IObjectDefinition = definitions["person"];
			assertNotNull(person);
			assertNotNull(person.constructorArguments);
			assertEquals(1, person.constructorArguments.length);
			assertNull(person.constructorArguments[0].value);
		}

		[Test]
		public function testParse_shouldAcceptUndefinedAsConstructorArgument():void {
			var xml:XML = <objects>
					<object id="person" class="org.springextensions.actionscript.test.testtypes.Person">
						<constructor-arg>
							<undefined/>
						</constructor-arg>
					</object>
				</objects>;
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(xml);

			var person:IObjectDefinition = definitions["person"];
			assertNotNull(person);
			assertNotNull(person.constructorArguments);
			assertEquals(1, person.constructorArguments.length);
			assertTrue(person.constructorArguments[0].value === undefined);
		}

		[Test]
		public function testParse_shouldAcceptUNaNAsConstructorArgument():void {
			var xml:XML = <objects>
					<object id="person" class="org.springextensions.actionscript.test.testtypes.Person">
						<constructor-arg>
							<undefined/>
						</constructor-arg>
						<constructor-arg>
							<not-a-number/>
						</constructor-arg>
					</object>
				</objects>;
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(xml);

			var person:IObjectDefinition = definitions["person"];
			assertNotNull(person);
			assertNotNull(person.constructorArguments);
			assertEquals(2, person.constructorArguments.length);
			assertTrue(person.constructorArguments[0].value === undefined);
			assertTrue(isNaN(person.constructorArguments[1].value));
		}

		[Test]
		public function testParseWithClassNameAsStringInValueAttribute():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(_xmlClassStringTest);
			var f:IObjectDefinition = definitions["factoryTest"];
			assertNotNull(f);
		}

		[Test]
		public function testParseWithClassNameAsStringInValueElement():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(_xmlClassStringTest2);
			assertNotNull(definitions["factoryTest"]);
		}

		[Test]
		public function testParsePersonWithSiblings():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(PERSON_XML_WITH_SIBLINGS);
			assertNotNull(definitions["person"]);
		}

		[Test]
		public function testParseWithInnerObject():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(<objects>
					<object id="a" class="Array">
						<constructor-arg>
							<object class="String" id="stringArg">
								<constructor-arg value="hello"/>
							</object>
						</constructor-arg>
					</object>
				</objects>);

			assertNotNull(definitions);
			assertNotNull(definitions["a"]);
			var definition:IObjectDefinition = definitions["a"];
			assertNotNull(definition);
			assertNotNull(definition.constructorArguments);
			assertEquals(1, definition.constructorArguments.length);
			assertNotNull(definition.constructorArguments[0].ref);
			assertEquals("stringArg", definition.constructorArguments[0].ref.objectName);
		}

		[Test]
		public function testParseWithRefInObject():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(<objects>
					<object id="a" class="Object">
						<property name="a_property_1">
							<object id="propertyValObject">
								<property name="key1" value="a value"/>
								<property name="key2">
									<ref>b</ref>
								</property>
								<property name="key3">
									<ref>c</ref>
								</property>
							</object>
						</property>
					</object>
					<object id="b" class="Array">
						<constructor-arg value="1"/>
						<constructor-arg value="aa"/>
						<constructor-arg value="true"/>
					</object>
					<object id="c" class="String">
						<constructor-arg value="hello"/>
					</object>
				</objects>);
			assertNotNull(definitions);
			assertNotNull(definitions["a"]);
			var definition:IObjectDefinition = definitions["a"];
			assertNotNull(definition);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("a_property_1");
			assertNotNull(propDef);
			assertTrue(propDef.valueDefinition is Object);
			assertNotNull(definitions["b"]);
			definition = definitions["b"];
			assertNotNull(definition);
			assertNotNull(definition.constructorArguments);
			assertEquals(3, definition.constructorArguments.length);
			assertNotNull(definitions["c"]);
			definition = definitions["c"];
			assertNotNull(definition);
			assertNotNull(definition.constructorArguments);
			assertEquals(1, definition.constructorArguments.length);
		}

		[Test]
		public function testParseWithMultipleRefsInObject():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(<objects>
					<object id="a" class="Object">
						<property name="a_property_1">
							<object id="propValue">
								<property name="key1" value="a value"/>
								<property name="key2">
									<ref>b</ref>
								</property>
								<property name="key3">
									<ref>c</ref>
								</property>
							</object>
						</property>
					</object>
					<object id="b" class="Array">
						<constructor-arg value="1"/>
						<constructor-arg>
							<ref>c</ref>
						</constructor-arg>
						<constructor-arg value="true"/>
					</object>
					<object id="c" class="String">
						<constructor-arg value="hello"/>
					</object>
				</objects>);
			assertNotNull(definitions);
			assertNotNull(definitions["a"]);
			var definition:IObjectDefinition = definitions["a"];
			assertNotNull(definition);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("a_property_1");
			assertNotNull(propDef);
			assertNotNull(propDef.valueDefinition.ref);
		/*assertEquals("a value", propDef.value.key1);
		assertTrue(propDef.value.key2 is RuntimeObjectReference);
		assertTrue(propDef.value.key3 is RuntimeObjectReference);*/
		}

		[Test]
		public function testParse_circularRefence():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(<objects>
					<object id="a" class="Object">
						<property name="b">
							<ref>b</ref>
						</property>
					</object>
					<object id="b" class="Object">
						<property name="a">
							<ref>a</ref>
						</property>
					</object>
				</objects>);
			assertNotNull(definitions);
			assertNotNull(definitions["a"]);
			var definition:IObjectDefinition = definitions["a"];
			assertNotNull(definition);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("b");
			assertNotNull(propDef);
			assertNotNull(propDef.valueDefinition.ref);
			assertEquals("b", propDef.valueDefinition.ref.objectName);

			assertNotNull(definitions["b"]);
			definition = definitions["b"];
			assertNotNull(definition);
			propDef = definition.getPropertyDefinitionByName("a");
			assertNotNull(propDef);
			assertNotNull(propDef.valueDefinition.ref);
			assertEquals("a", propDef.valueDefinition.ref.objectName);
		}

		[Test]
		public function testParseWithRefInArrayCollection():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(<objects>
					<object id="a" class="Object">
						<property name="a_property_1">
							<array-collection>
								<value>a value</value>
								<ref>b</ref>
							</array-collection>
						</property>
					</object>
					<object id="b" class="Array">
						<constructor-arg value="1"/>
						<constructor-arg value="aa"/>
						<constructor-arg value="true"/>
					</object>
				</objects>);
			assertNotNull(definitions);
			assertNotNull(definitions["a"]);
			var definition:IObjectDefinition = definitions["a"];
			assertNotNull(definition);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("a_property_1");
			assertNotNull(propDef);
			assertTrue(propDef.valueDefinition.value is ArrayCollection);
			var col:ArrayCollection = propDef.valueDefinition.value as ArrayCollection;
			assertEquals(2, col.length);
			assertEquals("a value", col.getItemAt(0));
			assertTrue(col.getItemAt(1) is RuntimeObjectReference);
			var ref:RuntimeObjectReference = col.getItemAt(1) as RuntimeObjectReference;
			assertEquals("b", ref.objectName);
		}

		[Test]
		public function testParseWithRefInDictionary():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(<objects>
					<object id="a" class="Object">
						<property name="a_property_1">
							<dictionary>
								<entry>
									<key>key1</key>
									<value>
										<ref>b</ref>
									</value>
								</entry>
								<entry>
									<key>
										<ref>c</ref>
									</key>
									<value>value2</value>
								</entry>
							</dictionary>
						</property>
					</object>
					<object id="b" class="Array">
						<constructor-arg value="1"/>
						<constructor-arg value="aa"/>
						<constructor-arg value="true"/>
					</object>
					<object id="c" class="Array">
						<constructor-arg value="2"/>
						<constructor-arg value="bb"/>
						<constructor-arg value="false"/>
					</object>
				</objects>);
			assertNotNull(definitions);
			assertNotNull(definitions["a"]);
			var definition:IObjectDefinition = definitions["a"];
			assertNotNull(definition);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("a_property_1");
			assertNotNull(propDef);
			assertNotNull(propDef.valueDefinition.value);
			var dict:Dictionary = propDef.valueDefinition.value as Dictionary;
			assertTrue(dict["key1"] is RuntimeObjectReference);
			var ref:RuntimeObjectReference = RuntimeObjectReference(dict["key1"]);
			assertEquals("b", ref.objectName);
		}

		[Test]
		public function testParse_shouldParseDependsOnAttribute():void {
			var xml:XML = <objects>
					<object id="a" class="org.springextensions.actionscript.test.testtypes.Person" depends-on="b,c"/>
					<object id="b" class="org.springextensions.actionscript.test.testtypes.Person"/>
					<object id="c" class="org.springextensions.actionscript.test.testtypes.Person"/>
				</objects>;
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(xml);
			assertNotNull(definitions);
			assertNotNull(definitions["a"]);
			var definition:IObjectDefinition = definitions["a"];
			assertNotNull(definition);
			assertNotNull(definition.dependsOn);
			assertEquals(2, definition.dependsOn.length);
			assertEquals("b", definition.dependsOn[0]);
			assertEquals("c", definition.dependsOn[1]);
		}

		[Test]
		public function testParse_withDictionaryAsPropertyValue():void {
			var xml:XML = <objects xmlns="http://www.springactionscript.org/schema/objects" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xsi:schemaLocation="http://www.springactionscript.org/schema/objects http://www.pranaframework.org/schema/objects/spring-actionscript-objects-1.0.xsd">
					<object id="a" class="Object" singleton="true">
						<property name="testprop">
							<dictionary>
								<entry>
									<key>this_is_a_key</key>
									<value>val</value>
								</entry>
							</dictionary>
						</property>
					</object>
				</objects>;

			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(xml);
			assertNotNull(definitions);
			assertNotNull(definitions["a"]);
			var definition:IObjectDefinition = definitions["a"];
			assertNotNull(definition);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("testprop");
			assertNotNull(propDef);
			assertTrue(propDef.valueDefinition.value is Dictionary);
			var dict:Dictionary = propDef.valueDefinition.value as Dictionary;
			assertEquals("val", dict["this_is_a_key"]);
		}


		/**
		 * SESPRINGACTIONSCRIPTAS-125
		 */
		[Test]
		public function testParseObjectWithPropertyWithLeadingPlus():void {
			var xml:XML = <objects xmlns="http://www.springactionscript.org/schema/objects" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xsi:schemaLocation="http://www.springactionscript.org/schema/objects http://www.pranaframework.org/schema/objects/spring-actionscript-objects-1.0.xsd">
					<object id="bert" class="org.springextensions.actionscript.test.testtypes.Person">
						<property name="name" type="String">
							<value>+123456789</value>
						</property>
					</object>
				</objects>;
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(xml);
			assertNotNull(definitions);
			assertNotNull(definitions["bert"]);
			var definition:IObjectDefinition = definitions["bert"];
			assertNotNull(definition);
			var propDef:PropertyDefinition = definition.getPropertyDefinitionByName("name");
			assertNotNull(propDef);
			assertEquals("+123456789", propDef.valueDefinition.value);
		}

		[Test]
		public function testParseWithMethodInvocationThatHasArgWithClassType():void {
			var context:IApplicationContext = new DefaultApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			var definitions:Object = parser.parse(_xmlClassWithMethodInvocationWithClassArgument);
			assertNotNull(definitions);
			assertNotNull(definitions["personMethodInvcocationTest"]);
			var definition:IObjectDefinition = definitions["personMethodInvcocationTest"];
			assertNotNull(definition);
			var invoc:MethodInvocation = definition.getMethodInvocationByName("isPersonType");
			assertNotNull(invoc);
			assertNotNull(invoc.arguments);
			assertEquals(1, invoc.arguments.length);
			assertStrictlyEquals(Person, invoc.arguments[0].value);

		}
	}
}
