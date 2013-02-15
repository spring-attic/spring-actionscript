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
 package org.springextensions.actionscript.cairngorm {

  import com.adobe.cairngorm.control.CairngormEvent;
  
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  
  import org.as3commons.lang.ClassUtils;
  import org.springextensions.actionscript.utils.Property;

  /**
   * @author Christophe Herreman
   * @author J&uuml;rgen Failenschmid
   * @docref extensions-documentation.html#event_sequences
   */
  public class SequenceEvent {

	/**
	 * Creates a new <code>SequenceEvent</code> instance.
	 */
    public function SequenceEvent(eventClass:Class, 
                                    parameters:Array = null, 
                                    nextEventTriggers:Array = null, 
                                    dispatcher:IEventDispatcher = null) 
    {
      _eventClass = eventClass;
      _parameters = parameters;
      _nextEventTriggers = nextEventTriggers;
      _dispatcher = dispatcher;
    }

	private var _eventClass:Class;
	
	private var _nextEventTriggers:Array;
	
	private var _parameters:Array;

    private var _dispatcher:IEventDispatcher;
    
    public function createEvent():Event {
      return ClassUtils.newInstance(eventClass, getParameterValues()) as Event;
    }
    
    public static function withDispatcher(dispatcher:IEventDispatcher,
                                    eventClass:Class, 
                                    parameters:Array = null, 
                                    nextEventTriggers:Array = null):SequenceEvent 
    {
      return new SequenceEvent(eventClass, parameters, nextEventTriggers, dispatcher);
    }

    public function get eventClass():Class {
      return _eventClass;
    }

    public function get nextEventTriggers():Array {
      return _nextEventTriggers;
    }
    
    public function get parameters():Array {
      return _parameters;
    }

    public function get dispatcher():IEventDispatcher {
      return _dispatcher;
    }

    /**
     * Dispatches the argument event. If there is a dispatcher, the dispatcher
     * is used. Otherwise, if the event is a <tt>CairngormEvent</tt>, it is
     * dispatched using the event's <tt>dispatch</tt> method. Otherwise, nothing
     * happens and the result is <tt>false</tt>.
     * 
     * @param an event
     * @return was the event dispatched successfully? 
     */ 
    public function dispatch(event:Event):Boolean {
      var cairngormEvent:CairngormEvent = event as CairngormEvent;
      return this.dispatcher 
               ? this.dispatcher.dispatchEvent(event) 
               : cairngormEvent 
                   ? cairngormEvent.dispatch() 
                   : false; 
    }

    private function getParameterValues():Array {
      var result:Array = [];

      if (parameters) {
        for (var i:int = 0; i<parameters.length; i++) {
          var p:* = parameters[i];
          if (p is Property) {
            result.push(p.getValue());
					} else {
            result.push(p);
          }
        }
      }

      return result;
    }
  }
}
