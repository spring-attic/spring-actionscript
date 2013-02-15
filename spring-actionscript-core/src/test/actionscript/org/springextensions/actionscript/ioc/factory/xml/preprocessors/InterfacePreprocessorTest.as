/*
* Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.ioc.factory.xml.preprocessors {
	
	import flash.system.ApplicationDomain;
	
	import flexunit.framework.TestCase;
	
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;
	import org.springextensions.actionscript.ioc.util.Constants;
	import org.springextensions.actionscript.objects.testclasses.*;
	import org.springextensions.actionscript.objects.testinterfaces.*;

	public class InterfacePreprocessorTest extends TestCase {
		
		{
			ITestInterfaceWithInitMethod;
			ITestInterfaceWithSimpleProperty;
			ImplementsTestInterfaceWithSimpleProperty;
			ImplementsTestInterfaceWithInitMethod;
		}

		public function InterfacePreprocessorTest(methodName:String = null) {
			super(methodName);
		}

	    public function testPreprocess_InterfacesShouldBeDeletedAfterProcessing():void {
			default xml namespace = spring_actionscript_objects;
	      var p:InterfacePreprocessor = new InterfacePreprocessor(ApplicationDomain.currentDomain);
	      var xml:XML =  <objects xmlns="http://www.springactionscript.org/schema/objects"
							xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				<interface class="org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithSimpleProperty">
					<property name="testProperty" value="test value"/>
				</interface>
				<interface class="org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithInitMethod" init-method="initialize"/>
			</objects>;
	      xml = p.preprocess(xml);
	      var nodes:XMLList = xml.descendants(Constants.INTERFACE);
	      assertEquals(nodes.length(),0);
	    }

	    public function testPreprocess_InterfaceElementsAndAttributesShouldBeCopiedToClasses():void {
			default xml namespace = spring_actionscript_objects;
	      var p:InterfacePreprocessor = new InterfacePreprocessor(ApplicationDomain.currentDomain);
	      var xml:XML =  <objects xmlns="http://www.springactionscript.org/schema/objects"
							xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				<interface class="org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithSimpleProperty">
					<property name="testProperty" value="test value"/>
				</interface>
				<interface class="org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithInitMethod" init-method="initialize"/>
				<object class="org.springextensions.actionscript.objects.testclasses.ImplementsTestInterfaceWithSimpleProperty"/>
				<object class="org.springextensions.actionscript.objects.testclasses.ImplementsTestInterfaceWithInitMethod"/>
			</objects>;
	      xml = p.preprocess(xml);
	      var nodes:XMLList = xml.descendants(Constants.OBJECT);
	      assertEquals(XML(nodes[0]).children().length(),1);
	      assertEquals(XML(nodes[1]).children().length(),1);
	      assertEquals(XML(nodes[1])["@init-method"],"initialize");
	    }

	    public function testPreprocess_InterfaceElementsAndAttributesShouldBeCopiedToClassesForPropertiesAndMethods():void {
			default xml namespace = spring_actionscript_objects;
	      var p:InterfacePreprocessor = new InterfacePreprocessor(ApplicationDomain.currentDomain);
	      var xml:XML =  <objects xmlns="http://www.springactionscript.org/schema/objects"
							xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				<interface class="org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithSimpleProperty">
					<property name="testProperty" value="test value"/>
				</interface>
				<interface class="org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithInitMethod">
					<method-invocation name="initialize"/>
				</interface>
				<object class="org.springextensions.actionscript.objects.testclasses.ImplementsTestInterfaceWithSimpleProperty"/>
				<object class="org.springextensions.actionscript.objects.testclasses.ImplementsTestInterfaceWithInitMethod"/>
			</objects>;
	      xml = p.preprocess(xml);
	      var nodes:XMLList = xml.descendants(Constants.OBJECT);
	      assertEquals(XML(nodes[0]).children().length(),1);
	      assertEquals(XML(nodes[1]).children().length(),2);
	    }

	    public function testPreprocess_InterfaceElementsAndAttributesShouldBeCopiedToClassesOnlyIfnotExistsYet():void {
			default xml namespace = spring_actionscript_objects;
	      var p:InterfacePreprocessor = new InterfacePreprocessor(ApplicationDomain.currentDomain);
	      var xml:XML =  <objects xmlns="http://www.springactionscript.org/schema/objects"
							xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				<interface class="org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithSimpleProperty">
					<property name="testProperty" value="test value"/>
				</interface>
				<interface class="org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithInitMethod">
					<method-invocation name="initialize"/>
				</interface>
				<object class="org.springextensions.actionscript.objects.testclasses.ImplementsTestInterfaceWithSimpleProperty"/>
				<object class="org.springextensions.actionscript.objects.testclasses.ImplementsTestInterfaceWithInitMethod">
					<property name="testProperty" value="overriden"/>
					<method-invocation name="otherinitialize"/>
				</object>
			</objects>;
	      xml = p.preprocess(xml);
	      var nodes:XMLList = xml.descendants(Constants.OBJECT);
	      assertEquals(XML(nodes[0]).children().length(),1);
	      assertEquals(XML(nodes[1]).children().length(),3);
	      assertEquals(XML(nodes[1]).children()[0]["@value"],"overriden");
	    }
		
		public function testPreprocess_testWithMergedXML():void {
			
			default xml namespace = spring_actionscript_objects;
			
			var p:InterfacePreprocessor = new InterfacePreprocessor(ApplicationDomain.currentDomain);
			var xml:XML =  <objects xmlns="http://www.springactionscript.org/schema/objects"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xmlns:messaging="http://www.springactionscript.org/schema/messaging"
					xmlns:util="http://www.springactionscript.org/schema/util"
					xmlns:rpc="http://www.springactionscript.org/schema/rpc"
					xmlns:t="http://www.springactionscript.org/schema/task">
				
				  <object class="org.springextensions.actionscript.objects.testclasses.ImplementsTestInterfaceWithSimpleProperty"/>
				  <object class="org.springextensions.actionscript.objects.testclasses.ImplementsTestInterfaceWithInitMethod">
					  <property name="testProperty" value="overriden"/>
					  <method-invocation name="otherinitialize"/>
				  </object>
			  </objects>;
			
			var xml2:XML = <objects xmlns="http://www.springactionscript.org/schema/objects"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xmlns:messaging="http://www.springactionscript.org/schema/messaging"
					xmlns:util="http://www.springactionscript.org/schema/util"
					xmlns:rpc="http://www.springactionscript.org/schema/rpc"
					xmlns:t="http://www.springactionscript.org/schema/task">
				  <interface class="org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithSimpleProperty">
					  <property name="testProperty" value="test value"/>
				  </interface>
				  <interface class="org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithInitMethod">
					  <method-invocation name="initialize"/>
				  </interface>
				</objects>;
			
			var xml3:XML = <objects xmlns="http://www.springactionscript.org/schema/objects"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xmlns:messaging="http://www.springactionscript.org/schema/messaging"
					xmlns:util="http://www.springactionscript.org/schema/util"
					xmlns:rpc="http://www.springactionscript.org/schema/rpc"
					xmlns:t="http://www.springactionscript.org/schema/task">
				  <t:task id="nee">
				  </t:task>
				</objects>;

			var childNodes:XMLList = xml2.children();
			xml.appendChild(childNodes);
	
			childNodes = xml3.children();
			xml.appendChild(childNodes);
			
			var xmllist:XMLList = xml.descendants(Constants.INTERFACE);
			assertEquals(xmllist.length(),2);
		}

	}
}