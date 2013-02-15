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
package org.springextensions.actionscript.collections {

  import flash.events.Event;
  
  import flexunit.framework.TestCase;

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class PropertiesTest extends TestCase {

    private var _properties:Properties;

    public function PropertiesTest(methodName:String=null) {
      super(methodName);
    }

    override public function setUp():void {
      _properties = new Properties();
    }
    
    public function testFormatURL():void {
    	var url:String = "props.properties";
    	url = _properties.formatURL(url,true);
    	assertEquals("props.properties?",url.substring(0,17));
    	url = "props.properties?a=1";
    	url = _properties.formatURL(url,true);
    	assertEquals("props.properties?a=1&",url.substring(0,21));
    }

    public function testSetGetProperty():void {
      _properties.setProperty("a", "b");
      assertEquals("b", _properties.getProperty("a"));
      _properties.setProperty("a", "c");
      assertEquals("c", _properties.getProperty("a"));
    }

    public function testGetPropertyWithNonExistingKey():void {
      assertEquals(null, _properties.getProperty("noSuchKey"));
    }

    public function testGetPropertyNames():void {
      assertNotNull(_properties.propertyNames);
      assertEquals(0, _properties.propertyNames.length);
      _properties.setProperty("a", "b");
      assertEquals(1, _properties.propertyNames.length);
    }

    public function testLoad():void {
      _properties.addEventListener(Event.COMPLETE, addAsync(onComplete, 1000));
      _properties.load("properties.properties.txt");
    }

    private function onComplete(event:Event):void {
      assertEquals("value of property 1", _properties.getProperty("property1"));
      assertEquals("value of property 2", _properties.getProperty("property2"));
      assertEquals("value of property 3", _properties.getProperty("property3"));
      assertEquals("value of property 4", _properties.getProperty("property4"));
      assertEquals("value of property 5", _properties.getProperty("property5"));
      assertEquals("value of property 6", _properties.getProperty("property6"));
      assertEquals("value of property 7", _properties.getProperty("property7"));
    }

  }
}
