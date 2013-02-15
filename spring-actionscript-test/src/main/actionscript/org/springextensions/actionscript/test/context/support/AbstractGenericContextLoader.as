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
package org.springextensions.actionscript.test.context.support {
import flash.events.Event;
import flash.events.IOErrorEvent;

import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.springextensions.actionscript.context.IApplicationContext;
import org.springextensions.actionscript.context.support.XMLApplicationContext;
import org.springextensions.actionscript.ioc.factory.xml.UtilNamespaceHandler;

//--------------------------------------
//  Events
//--------------------------------------

/**
 * Dispatched when the application context has been loaded.
 *
 * @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event")]

/**
 * <p>
 * Abstract, generic extension of <code>AbstractContextLoader</code> which loads a
 * <code>IApplicationContext</code> from the <em>locations</em> provided to
 * <code>loadContext()</code>.
 * </p>
 *
 * @author Andrew Lewisohn
 * @see #loadContext()
 */
public class AbstractGenericContextLoader extends AbstractContextLoader {

	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = LoggerFactory.getClassLogger(AbstractGenericContextLoader);
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AbstractGenericContextLoader() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  contextLoaded
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the contextLoaded property.
	 */
	private var _contextLoaded:Boolean = false;
	
	/**
	 * @inhertiDoc
	 */
	override public function get contextLoaded():Boolean {
		return _contextLoaded;
	}
	
	//----------------------------------
	//  couldNotLoadContext
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the couldNotLoadContext property.
	 */
	private var _couldNotLoadContext:Boolean = false;
	
	/**
	 * @inhertiDoc
	 */
	override public function get couldNotLoadContext():Boolean {
		return _couldNotLoadContext;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * <p>
	 * Loads a Spring ApplicationContext from the supplied
	 * <code>locations</code>.
	 * </p>
	 * <p>
	 * Implementation details:
	 * </p>
	 * <ul>
	 * <li>Creates a standard <code>XMLApplicationContext</code> instance.</li>
	 * <li>Populates it from the specified config locations</li>
	 * </ul>
	 *
	 * @return a new application context
	 * @see org.springextensions.actionscript.test.context.IContextLoader#loadContext()
	 * @see XMLApplicationContext
	 */
	override public function loadContext(locations:Array):IApplicationContext {
		_contextLoaded = false;
		_couldNotLoadContext = false;
		
		var context:XMLApplicationContext = new XMLApplicationContext(locations);
		context.addNamespaceHandler(new UtilNamespaceHandler());
		context.addEventListener(Event.COMPLETE,complete_handler, false, 0, true);
		context.addEventListener(IOErrorEvent.IO_ERROR, ioError_handler, false, 0, true);
		context.load();
		return context;
	}	
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Handles the successful loading of an application context.
	 */
	private function complete_handler(event:Event):void {
		event.currentTarget.removeEventListener(event.type, complete_handler, false);
		event.currentTarget.removeEventListener(event.type, ioError_handler, false);
		_contextLoaded = true;
		
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	/**
	 * @private
	 * Handles the unsuccessful loading of an application context.
	 */
	private function ioError_handler(event:IOErrorEvent):void {
		event.currentTarget.removeEventListener(event.type, complete_handler, false);
		event.currentTarget.removeEventListener(event.type, ioError_handler, false);
		_couldNotLoadContext = true;
		
		dispatchEvent(new Event(Event.COMPLETE));
	}
}
}