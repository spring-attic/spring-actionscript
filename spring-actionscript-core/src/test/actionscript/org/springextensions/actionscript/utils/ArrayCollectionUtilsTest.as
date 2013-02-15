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
package org.springextensions.actionscript.utils {
	
	import flexunit.framework.TestCase;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	
	import org.as3commons.lang.IllegalArgumentError;
	
	/**
	 * @author Christophe Herreman
	 */
	public class ArrayCollectionUtilsTest extends TestCase {
		
		public function ArrayCollectionUtilsTest(methodName:String = null) {
			super(methodName);
		}
		
		// --------------------------------------------------------------------
		// createFromCollectionView
		// --------------------------------------------------------------------
		
		public function testCreateFromCollectionView_shouldThrowIllegalArgumentErrorWhenViewIsNull():void {
			try {
				var a:ArrayCollection = ArrayCollectionUtils.createFromCollectionView(null);
				fail("createFromCollectionView() should fail when view is null");
			} catch (e:IllegalArgumentError) {
			}
		}
		
		public function testCreateFromCollectionView():void {
			var collection:ICollectionView = new ArrayCollection([1, 2, 3]);
			var collection2:ArrayCollection = ArrayCollectionUtils.createFromCollectionView(collection);
			assertNotNull(collection2);
			assertEquals(3, collection2.length);
		}
		
		// --------------------------------------------------------------------
		// createFromList
		// --------------------------------------------------------------------
		
		public function testCreateFromList_shouldThrowIllegalArgumentErrorWhenListIsNull():void {
			try {
				var a:ArrayCollection = ArrayCollectionUtils.createFromList(null);
				fail("createFromList() should fail when list is null");
			} catch (e:IllegalArgumentError) {
			}
		}
		
		public function testCreateFromList():void {
			var list:IList = new ArrayCollection([1, 2, 3]);
			var list2:ArrayCollection = ArrayCollectionUtils.createFromList(list);
			assertNotNull(list2);
			assertEquals(3, list2.length);
		}
	
	}
}