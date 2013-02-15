/*
 * Copyright 2007-2008 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.ioc.factory.xml.parser {
	
	import flash.utils.Dictionary;
	
	import mx.core.FlexVersion;

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.support.AbstractApplicationContext;
	import org.springextensions.actionscript.flexunit.FlexUnitTestCase;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.testclasses.Person;
	import org.springextensions.actionscript.ioc.testclasses.PrototypeFactory;
	
	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class XmlObjectDefinitionsParserTest extends FlexUnitTestCase {
		
		private var _xml:XML =     <objects>
				<object id="christophe" class="org.springextensions.actionscript.ioc.testclasses.Person">
					<constructor-arg value="Christophe Herreman"/>
					<constructor-arg>
						<value>26</value>
					</constructor-arg>
					<property name="isMarried">
						<value>true</value>
					</property>
				</object>
				<object id="bert" class="org.springextensions.actionscript.ioc.testclasses.Person">
					<property name="name" value="Bert Vandamme"/>
					<property name="age" value="25"/>
					<property name="isMarried" value="false"/>
				</object>
			</objects>;
		
		private var _personXML:XML =     <beans>
				<bean id="person" class="org.springextensions.actionscript.ioc.testclasses.Person">
					<property name="name">
						<value>
							"Christophe"
						</value>
					</property>
					<property name="friends">
						<array>
							<ref bean="__item0"/>
						</array>
					</property>
					<property name="isMarried">
						<value>
							"true"
						</value>
					</property>
					<property name="age">
						<value>
							"26"
						</value>
					</property>
				</bean>
				<bean id="__item0" class="org.springextensions.actionscript.ioc.testclasses.Person">
					<property name="name">
						<value>
							"Bert"
						</value>
					</property>
					<property name="friends">
						<array/>
					</property>
					<property name="isMarried">
						<value>
							"false"
						</value>
					</property>
					<property name="age">
						<value>
							"25"
						</value>
					</property>
				</bean>
			</beans>;
		
		private var _xmlClassStringTest:XML =     <objects>
				<object id="factoryTest" class="org.springextensions.actionscript.ioc.testclasses.PrototypeFactory">
					<property name="classNameToConstruct" value="org.springextensions.actionscript.ioc.testclasses.Person" type="Class" />
				</object>
			</objects>;
		
		private var _xmlClassStringTest2:XML =     <objects>
				<object id="factoryTest" class="org.springextensions.actionscript.ioc.testclasses.PrototypeFactory">
					<property name="classNameToConstruct">
						<value type="Class">org.springextensions.actionscript.ioc.testclasses.Person</value>
					</property>
				</object>
			</objects>;
		
		// <property name="colleague" ref="christophe"/>
		private var _christophe:Person;
		
		private var _bert:Person;
		
		private var _christopheDefinition:IObjectDefinition;
		
		private var _bertDefinition:IObjectDefinition;
		
		public function XmlObjectDefinitionsParserTest(methodName:String = null) {
			super(methodName);
		}
		
		override public function setUp():void {
			_christophe = new Person();
			_christophe.name = "Christophe Herreman";
			_christophe.age = 26;
			_christophe.isMarried = true;
			
			_bert = new Person();
			_bert.name = "Bert Vandamme";
			_bert.age = 25;
			_bert.isMarried = false;
			_bert.colleague = _christophe;
			
			_christopheDefinition = new ObjectDefinition("org.springextensions.actionscript.ioc.testclasses.Person");
			_christopheDefinition.properties["name"] = "Christophe Herreman";
			_christopheDefinition.properties["age"] = 26;
			_christopheDefinition.properties["isMarried"] = true;
			
			_bertDefinition = new ObjectDefinition("org.springextensions.actionscript.ioc.testclasses.Person");
			_bertDefinition.properties["name"] = "Bert Vandamme";
			_bertDefinition.properties["age"] = 25;
			_bertDefinition.properties["isMarried"] = false;
			//_bertDefinition.properties["colleague"] = _christophe;
		}
		
		public function testNewWithContainerArgument():void {
			var objectFactory:IApplicationContext = new AbstractApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(objectFactory);
			assertNotNull(parser.applicationContext);
			assertEquals(objectFactory, parser.applicationContext);
		}
		
		/**
		 * If no container is passed to the constructor, a new one will be created.
		 */
		public function testNewWithoutArguments():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			assertNotNull(parser.applicationContext);
		}
		
		public function testParse():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(_xml);
			assertNotNull(objectFactory);
			assertEquals(2, objectFactory.numObjectDefinitions);
			assertTrue(objectFactory.containsObjectDefinition("christophe"));
			assertTrue(objectFactory.containsObjectDefinition("bert"));
			assertFalse(objectFactory.containsObjectDefinition("frank"));
			
			var christophe:Person = objectFactory.getObject("christophe") as Person;
			var bert:Person = objectFactory.getObject("bert") as Person;
			var christopheDefinition:IObjectDefinition = objectFactory.getObjectDefinition("christophe");
			var bertDefinition:IObjectDefinition = objectFactory.getObjectDefinition("bert");
			assertTrue(christophe.equals(_christophe));
		}
		
		/**
		 *
		 */
		public function testParse_shouldAcceptEmptyStringAsConstructorArgument():void {
			var xml:XML =	    <objects>
					<object id="person" class="org.springextensions.actionscript.ioc.testclasses.Person">
						<constructor-arg value=""/>
					</object>
				</objects>;
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(xml);
			
			var person:Person = objectFactory.getObject("person");
			assertNotNull(person);
			assertEquals("", person.name);
		}
		
		/**
		 *
		 */
		public function testParse_shouldAcceptNullAsConstructorArgument():void {
			var xml:XML =	    <objects>
					<object id="person" class="org.springextensions.actionscript.ioc.testclasses.Person">
						<constructor-arg>
							<null/>
						</constructor-arg>
					</object>
				</objects>;
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(xml);
			
			var person:Person = objectFactory.getObject("person");
			assertNotNull(person);
			assertEquals(null, person.name);
		}
		
		public function testParsePerson():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IObjectFactory = parser.parse(_personXML);
			var p:Person = objectFactory.getObject("person");
			assertNotNull(objectFactory);
		}
		
		public function testParseWithClassNameAsStringInValueAttribute():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(_xmlClassStringTest);
			var f:PrototypeFactory = objectFactory.getObject("factoryTest");
			assertTrue(objectFactory.containsObjectDefinition("factoryTest"));
			assertNotNull(objectFactory);
		}
		
		public function testParseWithClassNameAsStringInValueElement():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(_xmlClassStringTest2);
			var f:PrototypeFactory = objectFactory.getObject("factoryTest");
			assertTrue(objectFactory.containsObjectDefinition("factoryTest"));
			assertNotNull(objectFactory);
		}
		
		/*public function testParsePersonWithSiblings():void {
		   var parser:XmlObjectDefinitionsParser = new XmlObjectDefinitionsParser();
		   var container:ObjectContainer = parser.parse(PERSON_XML_WITH_SIBLINGS);
		   var p:Person = container.getObject("person");
		   assertNotNull(container);
		 }*/
		
		
		public function testParseWithInnerObject():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var result:IApplicationContext = parser.parse(
														   <objects>
															   <object id="a" class="Array">
																   <constructor-arg>
																	   <object class="String">
																		   <constructor-arg value="hello"/>
																	   </object>
																   </constructor-arg>
															   </object>
														   </objects>);
			
			assertNotNull(result);
			
			var a:Array = result.getObject("a");
			assertNotNull(a);
			
			var string:String = a[0];
			assertNotNull(string);
			assertEquals("hello", string);
		}
		
		public function testParseWithRefInObject():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var result:IApplicationContext = parser.parse(
														   <objects>
															   <object id="a" class="Object">
																   <property name="a_property_1">
																	   <object>
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
			assertNotNull(result);
			
			var a:Object = result.getObject("a");
			assertNotNull(a);
			
			var a_property_1:Object = a.a_property_1;
			assertNotNull(a_property_1);
			
			var b:Array = result.getObject("b");
			assertNotNull(b);
			
			var c:String = result.getObject("c");
			assertNotNull(c);
			
			assertEquals(b, a_property_1.key2);
			assertEquals(c, a_property_1.key3);
		}
		
		public function testParseWithMultipleRefsInObject():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var result:IApplicationContext = parser.parse(
														   <objects>
															   <object id="a" class="Object">
																   <property name="a_property_1">
																	   <object>
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
																   <constructor-arg ref="c"/>
																   <constructor-arg value="true"/>
															   </object>
															   <object id="c" class="String">
																   <constructor-arg value="hello"/>
															   </object>
														   </objects>);
			assertNotNull(result);
			
			var a:Object = result.getObject("a");
			assertNotNull(a);
			
			var a_property_1:Object = a.a_property_1;
			assertNotNull(a_property_1);
			
			var b:Array = result.getObject("b");
			assertNotNull(b);
			assertEquals(1, b[0]);
			assertEquals("hello", b[1]);
			assertEquals(true, b[2]);
			
			var c:String = result.getObject("c");
			assertNotNull(c);
			
			assertEquals(b, a_property_1.key2);
			assertEquals(c, a_property_1.key3);
		}
		
		// TODO test circular references
		public function testParse_shouldThrowCircularRefenceError():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var result:IApplicationContext = parser.parse(
														   <objects>
															   <object id="a" class="Object">
																   <property name="b" ref="b" />
															   </object>
															   <object id="b" class="Object">
																   <property name="a" ref="a" />
															   </object>
														   </objects>);
			//var a:Object = result.getObject("a");
		}
		
		/*public function testParseArrayCollection():void {
		   var parser:XmlObjectDefinitionsParser = new XmlObjectDefinitionsParser();
		   var result:ArrayCollection = parser.parseArrayCollection(
		   <array-collection>
		   <value>a</value>
		   <value>1</value>
		   <value>true</value>
		   </array-collection>
		   );
		   assertNotNull(result);
		   assertEquals(3, result.length);
		   assertEquals("a", result[0]);
		   assertEquals(1, result[1]);
		   assertEquals(true, result[2]);
		   }
		
		   public function testParseArrayCollectionViaListElement():void {
		   var parser:XmlObjectDefinitionsParser = new XmlObjectDefinitionsParser();
		   var result:ArrayCollection = parser.parseArrayCollection(
		   <list>
		   <value>a</value>
		   <value>1</value>
		   <value>true</value>
		   </list>
		   );
		   assertNotNull(result);
		   assertEquals(3, result.length);
		   assertEquals("a", result[0]);
		   assertEquals(1, result[1]);
		   assertEquals(true, result[2]);
		 }*/
		
		/*public function testParseWithRefInArrayCollection():void {
		   var parser:XmlObjectDefinitionsParser = new XmlObjectDefinitionsParser();
		   var result:XmlObjectFactory = parser.parse(
		   <objects>
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
		   </objects>
		   );
		   assertNotNull(result);
		
		   var a:Object = result.getObject("a");
		   assertNotNull(a);
		
		   var a_property_1:ArrayCollection = a.a_property_1;
		   assertNotNull(a_property_1);
		
		   var b:Array = result.getObject("b");
		   assertNotNull(b);
		
		   assertEquals(b, a_property_1.getItemAt(1));
		 }*/
		
		public function testParseWithRefInDictionary():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var result:IApplicationContext = parser.parse(
														   <objects>
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
			assertNotNull(result);
			
			var a:Object = result.getObject("a");
			assertNotNull(a);
			
			var dict:Dictionary = a.a_property_1;
			assertNotNull(dict);
			
			//		var b:Array = result.getObject("b");
			//		assertNotNull(b);
			//	
			//		assertEquals(b, dict["key1"]);
			//	
			var c:Array = result.getObject("c");
			assertNotNull(c);
			//	
			//		assertEquals("value2", dict[c]);
		}
		
		//    private static const PERSON_XML_WITH_SIBLINGS:XML = <beans>
		//                                <bean id="person" class="org.springextensions.actionscript.ioc.testclasses.Person">
		//                                <property name="name">
		//                                  <value>Christophe</value>
		//                                </property>
		//                                <property name="isMarried">
		//                                  <value>true</value>
		//                                </property>
		//                                <property name="friends">
		//                                  <list/>
		//                                </property>
		//                                <property name="siblings">
		//                                  <list>
		//                                  <ref bean="__item0"/>
		//                                  </list>
		//                                </property>
		//                                <property name="age">
		//                                  <value>26</value>
		//                                </property>
		//                                </bean>
		//                                <bean id="__item0" class="org.springextensions.actionscript.ioc.testclasses.Person">
		//                                <property name="name">
		//                                  <value>David</value>
		//                                </property>
		//                                <property name="isMarried">
		//                                  <value>false</value>
		//                                </property>
		//                                <property name="friends">
		//                                  <list/>
		//                                </property>
		//                                <property name="siblings">
		//                                  <list>
		//                                  <ref bean="person"/>
		//                                  </list>
		//                                </property>
		//                                <property name="age">
		//                                  <value>16</value>
		//                                </property>
		//                                </bean>
		//                              </beans>;
		//
		//    private static const INNER_PERSON_BEAN_XML:XML =
		//    <beans>
		//      <bean id="person" class="org.springextensions.actionscript.ioc.testclasses.Person">
		//        <constructor-arg value="Christophe"/>
		//        <property name="colleague">
		//          <bean id="person" class="org.springextensions.actionscript.ioc.testclasses.Person">
		//            <constructor-arg value="Bert"/>
		//          </bean>
		//        </property>
		//      </bean>
		//    </beans>;
		
		/**
		 * Tests parsing of lazy objects. Lazy objects should not be in internal cache after parsing. They are created
		 * later on demand.
		 */
		public function testParse_lazyObjects():void {
			var xml:XML =
				<objects>
					<object id="bert" class="org.springextensions.actionscript.ioc.testclasses.Person" lazy-init="true">
						<property name="name" value="Bert Vandamme"/>
						<property name="age" value="25"/>
						<property name="isMarried" value="false"/>
					</object>
				</objects>;
			
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(xml);
			
			assertTrue(objectFactory.containsObjectDefinition("bert"));
			// Check wether it is in cache. It should not be since it is lazy.
			assertNull(objectFactory.clearObjectFromInternalCache("bert"));
			
			// Crate lazy object and put it in cache.
			assertNotNull(objectFactory.getObject("bert"));
			// Check wether it is in cache. Now it should be there.
			assertNotNull(objectFactory.clearObjectFromInternalCache("bert"));
		}
		
		public function testParse_withNullConstructorArgumentValue():void {
			var xml:XML =
				<objects>
					<object id="bert" class="org.springextensions.actionscript.ioc.testclasses.Person">
						<constructor-arg><null/></constructor-arg>
						<constructor-arg value="25"/>
						<constructor-arg value="false"/>
					</object>
				</objects>;
			
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(xml);
			var bert:Person = objectFactory.getObject("bert");
			assertNull(bert.name);
		}
		
		public function testParse_shouldParseDependsOnAttribute():void {
			var xml:XML = 	    <objects>
					<object id="a" class="org.springextensions.actionscript.ioc.testclasses.Person" depends-on="b,c"/>
					<object id="b" class="org.springextensions.actionscript.ioc.testclasses.Person"/>
					<object id="c" class="org.springextensions.actionscript.ioc.testclasses.Person"/>
				</objects>;
			
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(xml);
			var a:IObjectDefinition = objectFactory.getObjectDefinition("a");
			assertNotNull(a.dependsOn);
			assertEquals(2, a.dependsOn.length);
			var a2:Person = objectFactory.getObject("a");
		}
		
		public function testParse_withDictionaryAsPropertyValue():void {
			var xml:XML =	    <objects xmlns="http://www.springactionscript.org/schema/objects" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xsi:schemaLocation="http://www.springactionscript.org/schema/objects http://www.pranaframework.org/schema/objects/spring-actionscript-objects-1.0.xsd">
					<object id="test" class="Object" singleton="true">
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
			
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(xml);
			assertTrue(objectFactory.numObjectDefinitions == 1);
			var test:IObjectDefinition = objectFactory.getObjectDefinition("test");
			assertNotNull(test);
		}
		
		// --------------------------------------------------------------------
		//
		// parseNode
		//
		// --------------------------------------------------------------------
		
		public function testParseNode_shouldIgnoreAbstractNode():void {
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			
			assertEquals(0, parser.applicationContext.numObjectDefinitions);
			
			parser.parseNode(<object id="myAbstractObject" abstract="true"/>);
			
			assertEquals(0, parser.applicationContext.numObjectDefinitions);
			
			parser.parseNode(<object id="myObject" class="String"/>);
			
			assertEquals(1, parser.applicationContext.numObjectDefinitions);
		}
		
		public function testParseObjectWithFieldRetrievingObjectResultAsProperty():void {
			var xml:XML = <objects xmlns="http://www.springactionscript.org/schema/objects" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xsi:schemaLocation="http://www.springactionscript.org/schema/objects http://www.pranaframework.org/schema/objects/spring-actionscript-objects-1.0.xsd">
					<object id="bert" class="org.springextensions.actionscript.ioc.testclasses.Person">
						<property name="name" value="Bert Vandamme"/>
						<property name="age">
							<object class="org.springextensions.actionscript.ioc.factory.config.FieldRetrievingFactoryObject">
							  <property name="staticField" value="mx.core.FlexVersion.CURRENT_VERSION"/>
							</object>
						</property>
						<property name="isMarried" value="false"/>
					</object>
				</objects>;
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(xml);
			
			var bert:Person = objectFactory.getObject("bert") as Person;
			
			assertEquals(bert.age,FlexVersion.CURRENT_VERSION);
		
		}
	
		public function testParseObjectWithFieldRetrievingObjectResultAsConstructorArg():void {
			var xml:XML = <objects xmlns="http://www.springactionscript.org/schema/objects" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xsi:schemaLocation="http://www.springactionscript.org/schema/objects http://www.pranaframework.org/schema/objects/spring-actionscript-objects-1.0.xsd">
					<object id="bert" class="org.springextensions.actionscript.ioc.testclasses.Person">
						<constructor-arg value="Bert Vandamme"/>
						<constructor-arg>
							<object class="org.springextensions.actionscript.ioc.factory.config.FieldRetrievingFactoryObject">
							  <property name="staticField" value="mx.core.FlexVersion.CURRENT_VERSION"/>
							</object>
						</constructor-arg>
						<constructor-arg value="false"/>
					</object>
				</objects>;
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(xml);
			
			var bert:Person = objectFactory.getObject("bert") as Person;
			
			assertEquals(bert.age,FlexVersion.CURRENT_VERSION);
		
		}

		public function testParseObject_shouldCreateMethodInvocations():void {
			var xml:XML = <objects xmlns="http://www.springactionscript.org/schema/objects" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xsi:schemaLocation="http://www.springactionscript.org/schema/objects http://www.pranaframework.org/schema/objects/spring-actionscript-objects-1.0.xsd">
					<object id="john" class="org.springextensions.actionscript.ioc.testclasses.Person">
						<constructor-arg value="John"/>
						<method-invocation name="addFriend">
							<arg>
								<object class="org.springextensions.actionscript.ioc.testclasses.Person">
									<constructor-arg value="Peter"/>
								</object>
							</arg>
						</method-invocation>
					</object>
				</objects>;
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser();
			var objectFactory:IApplicationContext = parser.parse(xml);

			var john:Person = objectFactory.getObject("john") as Person;

			assertNotNull(john);
			assertNotNull(john.friends);
			assertEquals(1, john.friends.length);

			var peter:Person = john.friends[0];
			assertEquals("Peter", peter.name);
		}

	}
}
