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
package org.springextensions.actionscript.config {
	
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.Proxy;
  import flash.utils.flash_proxy;
  import mx.events.CollectionEvent;
  import mx.events.CollectionEventKind;

	/**
	 * Dispatched when a setting was added.
    * @eventType org.springextensions.actionscript.config.AppSettingsEvent.ADD
    */
    [Event(name="AppSettings_Add",type="org.springextensions.actionscript.config.AppSettingsEvent")]
	/**
	 * Dispatched when the <code>AppSettings</code> changes.
    * @eventType org.springextensions.actionscript.config.AppSettingsEvent.CHANGE
    */
    [Event(name="AppSettings_Change",type="org.springextensions.actionscript.config.AppSettingsEvent")]
	/**
	 * Dispatched when the <code>AppSettings</code> is cleared.
    * @eventType org.springextensions.actionscript.config.AppSettingsEvent.CLEAR
    */
    [Event(name="AppSettings_Clear",type="org.springextensions.actionscript.config.AppSettingsEvent")]
	/**
	 * Dispatched when a setting was deleted.
    * @eventType org.springextensions.actionscript.config.AppSettingsEvent.DELETE
    */
    [Event(name="AppSettings_Delete",type="org.springextensions.actionscript.config.AppSettingsEvent")]
	/**
	 * Dispatched when the external XML file has been loaded and parsed.
	* @eventType org.springextensions.actionscript.config.AppSettingsEvent.LOAD
	*/
	[Event(name="AppSettings_Load",type="org.springextensions.actionscript.config.AppSettingsEvent")]
  /**
   * The AppSettings class is a singleton that holds a set of configuration
   * settings. Each setting consists of a key and a corresponding value.
   *
   * The settings can be accessed (get and set) like properties of the
   * AppSettings class.
   *
   * To add a setting or change the value of an existing setting, simply
   * define it as a property as follows:
   * <pre>AppSettings.getInstance().mySetting = "myValue";</pre>
   *
   * To get a setting, request it as a property:
   * <pre>var result:String = AppSettings.getInstance().mySetting;</pre>
   *
   * To delete a setting, use the delete operator:
   * <pre>delete AppSettings.getInstance().mySetting;</pre>
   *
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public dynamic class AppSettings extends Proxy implements IEventDispatcher {

    private static var _instance:AppSettings;    // the singleton instance

    /**
     * Returns the singleton instance of the AppSettings class.
     */
    public static function getInstance():AppSettings {
      if (!_instance) {
        _instance = new AppSettings(new SingletonEnforcer());
      }
      return _instance;
    }

    /**
     * Constructs a new instance of AppSettings.
     *
     * Since this class is a singleton, the constructor should
     * never be called directly. (This is made impossible with the instance
     * of the internal SingletonEnforcer class that needs to be passed.)
     * To instantiate this class, call the static getInstance() method.
     *
     * @param enforcer An instance of the internal SingletonEnforcer class
     * to enforce a singleton
     * @throws Error when instantiating with a 'null' argument
     */
    public function AppSettings(enforcer:SingletonEnforcer) {
		super();
		AppSettingsInit(enforcer);
    }

	/**
	 * Initializes the <code>AppSettings</code> instance
	 */
	protected function AppSettingsInit(enforcer:SingletonEnforcer):void {
		// prevent instantiation via "new AppSettings(null);"
		if (!enforcer) {
			throw new Error("The 'enforcer' argument for the AppSettings' constructor cannot be 'null' or 'undefined'");
		}
		_entries = [];
		_tempEntries = [];
		_eventDispatcher = new EventDispatcher(this);
	}

    private var _entries:Array;
    private var _eventDispatcher:IEventDispatcher;
    private var _loader:URLLoader;          // loads the external xml data
    private var _tempEntries:Array;        // contains temp settings, needed for Proxy implementation

    //---------------------------------------------------------------------
    // IEventDispatcher implementation
    //---------------------------------------------------------------------
    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
      _eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    /*flash_proxy override function setProperty(name:*, value:*):void {
      var eventType:String = (hasOwnProperty(name)) ? AppSettingsEvent.CHANGE : AppSettingsEvent.ADD;
      var event:AppSettingsEvent = new AppSettingsEvent(eventType, name, value, true, true);
      super.setPropery(name, value);
      dispatchEvent(event);
    }

    flash_proxy override function deleteProperty(name:*):Boolean {
      var value:* = _settings[name];
      delete _settings[name];
      if (!hasOwnProperty(name)) {
        dispatchEvent(new AppSettingsEvent(AppSettingsEvent.DELETE, name, value, true, true));
      }
      return (!hasOwnProperty(name));
    }
    */

    /**
     * Adds a listener to the AppSettings.
     *
     * @param listener The listener object to be added
     */
    public function addListener(listener:IAppSettingsListener, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
      addEventListener(AppSettingsEvent.ADD, listener.AppSettings_Add, useCapture, priority, useWeakReference);
      addEventListener(AppSettingsEvent.CHANGE, listener.AppSettings_Change, useCapture, priority, useWeakReference);
      addEventListener(AppSettingsEvent.CLEAR, listener.AppSettings_Clear, useCapture, priority, useWeakReference);
      addEventListener(AppSettingsEvent.DELETE, listener.AppSettings_Delete, useCapture, priority, useWeakReference);
      addEventListener(AppSettingsEvent.LOAD, listener.AppSettings_Load, useCapture, priority, useWeakReference);
    }

    public function dispatchEvent(event:Event):Boolean {
      return _eventDispatcher.dispatchEvent(event);
    }

    public function hasEventListener(type:String):Boolean {
      return _eventDispatcher.hasEventListener(type);
    }

    /**
     * Loads an xml file or data containing the key/value pairs for the settings
     * and fills the AppSettings. The settings loaded from the xml file are
     * added to the existing settings and settings with the same key are
     * replaced by the new settings in the xml file.
     *
     * The xml file can have any name you like or could even be generated
     * dynamically. The structure of the nodes should look as follows:
     * <pre>
     * <appsettings>
     *   <add key="myFirstSetting" value="aValue"/>
     *   <add key="mySecondSetting" value="anotherValue"/>
     * </appsettings>
     * </pre>
     * @param source The location of the xml file that contains the appsettings or the XML object that contains the settings
     */
    public function load(source:*):void {
      if (source is String) {
        loadFromFile(source);
      }
      else if(source is XML) {
        parseSettingsFromXml(source);
      }
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
      _eventDispatcher.removeEventListener(type, listener, useCapture);
    }

    /**
     * Removes a listener from the AppSettings object.
     *
     * @param listener The listener object to be removed.
     */
    public function removeListener(listener:IAppSettingsListener, useCapture:Boolean = false):void {
      removeEventListener(AppSettingsEvent.ADD, listener.AppSettings_Add, useCapture);
      removeEventListener(AppSettingsEvent.CHANGE, listener.AppSettings_Change, useCapture);
      removeEventListener(AppSettingsEvent.CLEAR, listener.AppSettings_Clear, useCapture);
      removeEventListener(AppSettingsEvent.DELETE, listener.AppSettings_Delete, useCapture);
      removeEventListener(AppSettingsEvent.LOAD, listener.AppSettings_Load, useCapture);
    }

    public function willTrigger(type:String):Boolean {
      return _eventDispatcher.willTrigger(type);
    }

    /**
     * Catches unknown method calls.
     */
    flash_proxy override function callProperty(methodName:*, ... args):* {
      return this[String(methodName)].apply(args);
    }

    /**
     * Deletes a property.
     */
    flash_proxy override function deleteProperty(name:*):Boolean {
      delete _entries[name];
      return (!hasOwnProperty(name));
    }

    //---------------------------------------------------------------------
    // Proxy implementation
    //---------------------------------------------------------------------
    /**
     * Returns the value that matches the value with the given name.
     *
     * @param name The name of the setting you want to get.
     * @returns The value of the setting with the given name. If the key
     * does not exist, undefined is returned.
     */
    flash_proxy override function getProperty(name:*):* {
      return _entries[name];
    }

    /**
     * Checks if a property exists.
     */
    flash_proxy override function hasProperty(name:*):Boolean {
      return (_entries[name] !== undefined);
    }

    /**
     * Returns the name of the next property when looping through the
     * collection.
     */
    flash_proxy override function nextName(index:int):String {
      var count:int = 1;
      var result:String = "";
      for (var x:* in _entries) {
        if (count == index) {
          result = x;
          break;
        }
        count++;
      }
      return result;
    }

    /**
     * Returns the index of the next property while looping through the
     * collection with a for or for each loop.
     */
    flash_proxy override function nextNameIndex(index:int):int {
      if (index == 0) {
        _tempEntries = new Array();
        for (var x:* in _entries) {
          _tempEntries.push(x);
        }
      }
      return ((index < _tempEntries.length) ? (index+1) : 0);
    }

    /**
     * Returns the value of the next property when looping through the
     * collection.
     */
    flash_proxy override function nextValue(index:int):* {
      var count:int = 1;
      var result:*;
      for each (var x:* in _entries) {
        if (count == index) {
          result = x;
          break;
        }
        count++;
      }
      return result;
    }

    /**
     * Sets a property.
     */
    flash_proxy override function setProperty(name:*, value:*):void {
      _entries[name] = value;
      dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD));
    }

    /**
     * Loads settings from an external xml file.
     *
     * @param url The location of the xml file that contains the settings.
     */
    protected function loadFromFile(url:String):void {
      var request:URLRequest = new URLRequest(url);
      _loader = new URLLoader();
      _loader.addEventListener(Event.COMPLETE, xmlLoaderComplete_handler);
      _loader.load(request);
    }

    /**
     * Parses the settings from the given XML instance.
     *
     * @param xml The XML object that contains the settings.
     */
    protected function parseSettingsFromXml(xml:XML):void {
      for each(var i:XML in xml.add){
        this[i.@key] = i.@value;
      }
    }

    /**
     * Handles the Complete event of the URLLoader instance that loads
     * the XML data with the settings.
     */
    protected function xmlLoaderComplete_handler(event:Event):void {
      parseSettingsFromXml(XML(_loader.data));
      dispatchEvent(new AppSettingsEvent(AppSettingsEvent.LOAD, null, null, true, true));
    }
    //---------------------------------------------------------------------
  }
}

// class outside the package of the AppSettings to enforce Singleton access
// @see AppSettings()
class SingletonEnforcer {
}
