/*
 * Copyright 2007-2011 the original author or authors.
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

  import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
  import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;

  use namespace spring_actionscript_objects;

  /**
   * Preprocesses a "method-invocation" tag to a MethodInvokingObject.
   *
   * <p>
   * <b>Authors:</b> Christophe Herreman, Bert Vandamme<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class MethodInvocationPreprocessor implements IXMLObjectDefinitionsPreprocessor {
	
	/**
	 * Incremented each time we create a MethodInvokingObject to insure we have unique ids.
	 */
	private static var idCounter:uint = 0;
	
    /**
     * Creates a new MethodInvocationPreprocessor.
     */
    public function MethodInvocationPreprocessor() {
    }

    public function preprocess(xml:XML):XML {
      // get the xml's default namespace
      var defaultNameSpace:Namespace = xml.namespace("");
      // and set it as the default namespace for all XML objects in the scope of this method
      // if there is one
      if (defaultNameSpace) {
        default xml namespace = defaultNameSpace;
      }

      var nodes:XMLList = xml.descendants("method-invocation");

      for (var i:int = 0; i < nodes.length(); i++) {
        var node:XML = nodes[i];
        var parentID:String = node.parent().@id;
        var objectID:String = "__methodInvocation" + idCounter++;
        var methodName:String = node.@name;
        
        // create the xml for the method invocation
        // use elements and not attributes for the "ref" and "value" because the AttributeToElementPreprocessor
        // has already executed by now
        var methodInvokingObjectXML:XML =  <object id={objectID} class="org.springextensions.actionscript.ioc.factory.MethodInvokingObject">
                            <property name="target">
                            	<ref>{parentID}</ref>
                            </property>
                            <property name="method">
                            	<value>{methodName}</value>
                            </property>
                            <property name="arguments">
                              <array/>
                            </property>
                          </object>;

        // add arguments
        var argumentsNode:XML = methodInvokingObjectXML.children()[2];
        for each (var argXML:XML in node.arg) {
          argumentsNode.children()[0].appendChild(argXML.children()[0]);
        }

        // add the newly created node
        xml.appendChild(methodInvokingObjectXML);

        // clean up
        try {
          // delete the node
          delete nodes[i];
          // and correct the index
          i--;
        }
        catch (e:Error) {
          // deleting the node failed.
        }
      }

      return xml;
    }
  }
}
