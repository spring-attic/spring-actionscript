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
package org.springextensions.actionscript.cairngorm {

  import flexunit.framework.TestCase;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import mx.events.CloseEvent;
  import org.as3commons.lang.IllegalArgumentError;

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class EventSequenceTest extends TestCase {

    public function testAddSequenceWithValidType():void {
      var es:EventSequence = new EventSequence();
      es.addSequenceEvent(CairngormEventSubClass);
    }

    public function testAddSequenceEventWithInvalidType():void {
      var es:EventSequence = new EventSequence();
      try {
        es.addSequenceEvent(Event);
        fail("addSequenceEvent() should fail when passing in a class that is not a subclass of CairngormEvent");
      }
      catch (e:IllegalArgumentError) {}
    }

    public function testAddWithDispatcherWithValidType():void {
      var es:EventSequence = new EventSequence();
      es.addWithDispatcher(new EventDispatcher(), Event);
      es.addWithDispatcher(new EventDispatcher(), CloseEvent);
    }

    public function testAddWithDispatcherWithInvalidType():void {
      var es:EventSequence = new EventSequence();
      try {
        es.addWithDispatcher(new EventDispatcher(), Object);
        fail("addWithDispatcher() should fail when passing in a class that is not an Event");
      }
      catch (e:IllegalArgumentError) {}
    }

  }
}

import com.adobe.cairngorm.control.CairngormEvent;

class CairngormEventSubClass extends CairngormEvent {
  public function CairngormEventSubClass() {
    super("cairngormEventSubClass");
  }
}
