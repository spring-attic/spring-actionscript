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
package org.springextensions.actionscript.samples.movieapp {

  import flexunit.framework.TestCase;

  /**
   * @author Christophe Herreman
   */
  public class StaticMovieSourceTest extends TestCase {

    public function StaticMovieSourceTest(methodName:String=null) {
      super(methodName);
    }

    public function testGetAll_shouldContainSeveralMovieObjects():void {
      var source:IMovieSource = new StaticMovieSource();
      var movies:Array = source.getAll();
      assertNotNull(movies);
      assertTrue(movies.length > 0);
      for (var i:int = 0; i<movies.length; i++) {
        assertTrue(movies[i] is Movie);
      }
    }

  }
}