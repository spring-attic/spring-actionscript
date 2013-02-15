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
 package org.springextensions.actionscript.config {

  import flash.events.Event;

  /**
   * An AppSettings event object that contains information about the key and
   * value that caused the event.
   *
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class AppSettingsEvent extends Event {

	/**
	 * Defines the value of the type property of a <code>AppSettingsEvent.ADD</code> event object. 
 	 * @eventType String
     */
    public static const ADD:String = "AppSettings_Add";
	/**
	 * Defines the value of the type property of a <code>AppSettingsEvent.CHANGE</code> event object. 
 	 * @eventType String
     */
    public static const CHANGE:String = "AppSettings_Change";
	/**
	 * Defines the value of the type property of a <code>AppSettingsEvent.CLEAR</code> event object. 
 	 * @eventType String
     */
    public static const CLEAR:String = "AppSettings_Clear";
	/**
	 * Defines the value of the type property of a <code>AppSettingsEvent.DELETE</code> event object. 
 	 * @eventType String
     */
    public static const DELETE:String = "AppSettings_Delete";
	/**
	 * Defines the value of the type property of a <code>AppSettingsEvent.LOAD</code> event object. 
 	 * @eventType String
     */
    public static const LOAD:String = "AppSettings_Load";

    /**
     * The app settings key to which this event refers.
     */
    public var key:String;
    /**
     * The app settings value to which this event refers.
     */
    public var value:*;

    /**
     * Constructs a new <code>AppSettingsEvent</code> instance.
     */
    public function AppSettingsEvent(type:String, key:String, value:*, bubbles:Boolean = false, cancelable:Boolean = false) {
      super(type, bubbles, cancelable);
      this.key = key;
      this.value = value;
    }
    
    /**
     * Returns an exact copy of the current <code>AppSettingsEvent</code> instance.
     */
    override public function clone():Event{
    	return new AppSettingsEvent(this.type, this.key, this.value, this.bubbles, this.cancelable);
    }
    
  }
}
