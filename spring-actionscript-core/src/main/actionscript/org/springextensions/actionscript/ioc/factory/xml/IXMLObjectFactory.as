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
package org.springextensions.actionscript.ioc.factory.xml {

  import org.springextensions.actionscript.ioc.factory.config.IConfigurableListableObjectFactory;
  import org.springextensions.actionscript.ioc.factory.support.IObjectDefinitionRegistry;

  /**
   * Interface to be implemented by object factories that load their object
   * definitions from XML files.
   *
   * <p>
   * <b>Authors:</b> Christophe Herreman, Erik Westra<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   * @docref container-documentation.html#instantiating_a_container
   */
  public interface IXMLObjectFactory extends IConfigurableListableObjectFactory, IObjectDefinitionRegistry {

    /**
     * Instructs the object factory to start loading the available configuration(s)
     */
    function load():void;

    /**
     * Use this method to add aditional configuration locations.
     *
     * @param configLocation  The location to add. This is the path to the configuration xml file
     */
    function addConfigLocation(configLocation:String):void;

    /**
     * Use this method to add xml versions of configurations
     *
     * @param config  The xml configuration to add
     */
    function addConfig(config:XML):void;

    /**
     * Adds an embedded config.
     */
    function addEmbeddedConfig(config:Class):void;

    /**
     * Returns an <code>Array</code> of configuration locations.
     */
    function get configLocations():Array;
    
    /**
     * Return an <code>Array</code> of <code>Properties</code> instances.
     */
    function get loadedProperties():Array;
  }
}
