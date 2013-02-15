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
  
  import mx.binding.utils.ChangeWatcher;
  import mx.utils.ArrayUtil;
  
  import org.as3commons.lang.Assert;
  import org.as3commons.lang.ClassUtils;
  import org.springextensions.actionscript.utils.Property;

  /**
   * An <code>EventSequence</code> represents a sequence of events to be chained.
   * This allows you to chain commands by chaining the events that are dispatched
   * to the <code>FrontController</code> in order to execute a command.
   * Alternatively, basic <tt>Event</tt>s may also be part of the sequence by
   * specifying an event dispatcher when the events are queued.
   *
   * <p>Using an event sequence, the commands do not have to extend
   * <code>SequenceCommand</code> and hence do not have to set up a <code>nextEvent</code> and
   * dispatch it. This means that your commands can be used in a number of different
   * sequence scenarios without letting the commands know they are chained.
   *
   * <p>The sequencing works by setting up a trigger for an event, based on a
   * property change in an object. This property change will normally be
   * executed by a command.</p>
   *
   * @example The following example sets up an event sequence and dispatches it:
   *
   * <listing version="3.0">var sequence:EventSequence = new EventSequence();
   *
   * sequence.addSequenceEvent(LoadSessionEvent, ["4562-54289778-56985412"]);
   *
   * sequence.addSequenceEvent(LoadExamEvent,
   *  [new Property(ModelLocator.getInstance(), "session", "examId")],
   *  [new Property(ModelLocator.getInstance(), "session")]);
   *
   * sequence.addSequenceEvent(LoadCandidateEvent,
   *  [new Property(ModelLocator.getInstance(), "session", "candidateId")],
   *  [new Property(ModelLocator.getInstance(), "exam")]);
   *
   * sequence.dispatch();</listing>
   *
   * <p>In this example, 3 events are chained. (This sequence is used to load
   * the session of an exam, the exam itself and the candidate)</p>
   *
   * <p>The first event is the <code>LoadSessionEvent</code> that gets
   * the id of a session as its constructor argument. The command that is
   * executed by this event will fetch an exam session and store it in the
   * <code>session</code> property of the <code>ModelLocator</code>. Since
   * this is the first event, it does not define any triggers for the next event.</p>
   *
   * <p>The second event is the <code>LoadExamEvent</code>. This event takes
   * the id of the exam as its constructor argument, fetches an exam and stores
   * it in the <code>exam</code> property of the <code>ModelLocator</code>.
   * Notice the 3rd argument that defines the trigger for this event. It is
   * defined a <code>Property</code> object that contains a reference to the
   * <code>session</code> property in the <code>ModelLocator</code>. This means
   * that this event will be dispatched when the <code>session</code> property has been set.
   * The examId is also passed in as a property and will be evaluated when the
   * sequence creates the next event.</p>
   *
   * <p>The third event is the <code>LoadCandidateEvent</code>. This event takes
   * the <code>session.candidateId</code> as its constructor argument and will be dispatched
   * when the <code>exam</code> property is set on the <code>ModelLocator</code>.</p>
   *
   * <p>
   * <b>Authors:</b> Christophe Herreman, Tony Hillerson, J&uuml;rgen Failenschmid<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   * @docref extensions-documentation.html#event_sequences
   */
  public class EventSequence {

	private var _sequenceEvents:Array;
	
	private var _currentSequenceEvent:SequenceEvent;
	
	private var _currentWatcher:ChangeWatcher;
	
	private var _eventDispatcher:IEventDispatcher;
		
    /**
     * Creates a new EventSequence
     */
	public function EventSequence(eventDispatcher:IEventDispatcher=null) {
		_sequenceEvents = new Array();
		_eventDispatcher = eventDispatcher;
	}

    /**
     * Starts dispatching this event sequence.
     */
    public function dispatch():void {
        if (_sequenceEvents.length == 0) {
            throw new Error("Cannot start event sequence because sequence has no events");
        }
        var firstSequenceEvent:SequenceEvent = _sequenceEvents[0];
        dispatchSequenceEvent(firstSequenceEvent);
    }

    /**
     * Adds a Cairngorm event to this sequence.
     *
     * @param eventClass the class of the event (must be a subclass of CairngormEvent)
     * @param parameters the arguments that will be passed to the event's constructor
     * @param triggers the triggers that will cause the next event to be dispatched
     */
    public function addSequenceEvent(eventClass:Class, parameters:Array = null, triggers:Array = null):void {
      Assert.notNull(eventClass, "The eventClass argument must not be null");
      Assert.subclassOf(eventClass, CairngormEvent);
      _sequenceEvents.push(new SequenceEvent(eventClass, parameters, triggers));
    }

    /**
     * Adds a basic event to this sequence.
     *
     * @param dispatcher the source of the event
     * @param eventClass the class of the event (must be a subclass of Event)
     * @param parameters the arguments that will be passed to the event's constructor
     * @param triggers the triggers that will cause the next event to be dispatched
     */
    public function addWithDispatcher(dispatcher:IEventDispatcher, eventClass:Class, parameters:Array = null, triggers:Array = null):void {
      Assert.notNull(eventClass, "The eventClass argument must not be null");
      Assert.isTrue(eventClass === Event || ClassUtils.isSubclassOf(eventClass, Event), "The eventClass argument must be an Event");
      _sequenceEvents.push(SequenceEvent.withDispatcher(dispatcher, eventClass, parameters, triggers));
    }

    /**
     * In case of failure, this cancels the 'on deck' sequence
     */
    public function cancel():void {
      _currentWatcher.unwatch();
    }
    
    /**
     * Determines the conditions that trigger the argument <tt>nextEvent</tt>.
     * These may depend on the two argument events.
     * 
     * @param event the event that will be dispatched
     * @param nextEvent A description of the next event in the sequence. It
     *          may specify triggers.
     * @return An array of event triggers, or <tt>null</tt>
     * @see SequenceEvent#nextEventTriggers 
     */ 
    protected function calculateTriggers(event:Event, nextEvent:SequenceEvent):Array {
    	return nextEvent.nextEventTriggers;
    }

    /**
     * Dispatches a sequence event.
     * If we detect an event after the one we are about to dispatch, we set
     * up a changewatcher so that we know when to trigger the next event.
     *
     * @param sequenceEvent the event to dispatch
     */
    private function dispatchSequenceEvent(sequenceEvent:SequenceEvent):void {
        _currentSequenceEvent = sequenceEvent;
        var event:Event = sequenceEvent.createEvent();
        var nextSequenceEvent:SequenceEvent = getNextSequenceEvent();

        if (nextSequenceEvent) {
      	    var nextTriggers:Array = calculateTriggers(event, nextSequenceEvent);
            if (nextTriggers) {
                // setup a changewatcher so that we know when to fire the next event
                for (var i:int = 0; i < nextTriggers.length; i++) {
                    var p:Property = nextTriggers[i];
                    _currentWatcher = ChangeWatcher.watch(p.host, p.chain[0], onTriggerChange);
                }
            }
        }
        
		if (_eventDispatcher == null) {
			sequenceEvent.dispatch(event);
		}
		else {
			_eventDispatcher.dispatchEvent(event);
		}
    }

    /**
     * Returns the next sequence event.
     */
    private function getNextSequenceEvent():SequenceEvent {
      var currentIndex:int = ArrayUtil.getItemIndex(_currentSequenceEvent, _sequenceEvents);
      return _sequenceEvents[currentIndex + 1];
    }

    /**
	 * Handles the Event of the trigger for the next event.
     * This trigger is normally a property of an object being set/changed.
     */
	private function onTriggerChange(event:Event):void {
      var nextSequenceEvent:SequenceEvent = getNextSequenceEvent();
      if (_currentWatcher) {
        _currentWatcher.unwatch();
      }
      if (nextSequenceEvent) {
        dispatchSequenceEvent(nextSequenceEvent);
      }
    }
  }
}
