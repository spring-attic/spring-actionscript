/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.test.testtypes {

	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public dynamic class Person {

		import mx.core.mx_internal;
		use namespace mx_internal;

		private var _name:String;

		public var age:int;
		private var _isMarried:Boolean;
		public var colleague:Person;
		public var anArray:Array;
		public var anObject:Object;
		private var _friends:Array;
		private var _siblings:Array;
		private var _aWriteOnlyObject:Object;

		public function Person(name:String="", age:int=0, isMarried:Boolean=false) {
			this.name = name;
			this.age = age;
			this.isMarried = isMarried;
			_friends = [];
			_siblings = [];
		}

		public static function createPerson(name:String, age:int):Person {
			return new Person(name, age);
		}

		public static function hiStatic():String {
			return "hi static";
		}

		public static function hiStaticWithArguments(s:String, n:Number):String {
			return "hi static with arguments '" + s + "' and '" + n + "'";
		}

		public function equals(object:Person):Boolean {
			return ((name == object.name) && (age == object.age) && (isMarried == object.isMarried) && (colleague == object.colleague));
		}

		[Ignore]
		[Test]
		public function testDummy():void {

		}

		public function helloWorld():String {
			return "hello world";
		}

		public function isPersonType(type:Class):Boolean {
			return (type === Person);
		}

		/**
		 * Add a person as the friend of this person.
		 * This person is also added as a friend to the friend.
		 * We need this to test recursive serialization.
		 */
		public function addFriend(friend:Person):void {
			if (_friends.indexOf(friend) == -1) {
				_friends.push(friend);
				friend.addFriend(this);
			}
		}

		public function addSibling(sibling:Person):void {
			if (hasSibling(sibling) == false) {
				siblings.push(sibling);
				sibling.addSibling(this);
			}
		}

		public function hasSibling(sibling:Person):Boolean {
			for (var i:int = 0; i < siblings.length; i++) {
				if (siblings[i].equals(sibling)) {
					return true;
				}
			}
			return false;
		}

		/*public function equals(person:Person):Boolean {
		  return ((name == person.name) && (age == person.age) && (isMarried == person.isMarried));
		}*/

		public function toString():String {
			return "[Person(" + name + ", " + age + ", " + isMarried + ")]";
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get isMarried():Boolean {
			return _isMarried;
		}

		public function set isMarried(value:Boolean):void {
			_isMarried = value;
		}

		public function get friends():Array {
			return _friends;
		}

		public function set friends(friends:Array):void {
			_friends = friends;
		}

		public function get siblings():Array {
			return _siblings;
		}

		//public function set siblings(value:Array):void { _siblings = value; }

		// public function get writeObject():Object { return _aWriteOnlyObject; }
		public function set writeObject(object:Object):void {
			_aWriteOnlyObject = object;
		}
	}
}
