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
package org.springextensions.actionscript.samples.movieapp {
	
	/**
	 * A <code>CSVMovieSource</code> holds a set of <code>Movie</code> objects, parsed from a string that is passed in to
	 * its constructor.
	 *
	 * <p>The constructor argument must have the following form: "[moviename1],[director1],[moviename2],[director2]"</p>
	 *
	 * @author Christophe Herreman
	 */
	public class CSVMovieSource implements IMovieSource {
		
		private var _movies:Array;
		
		/**
		 * Creates a new <code>CSVMovieSource</code> object.
		 *
		 * @param source the csv string that defines the movies
		 */
		public function CSVMovieSource(source:String) {
			_movies = parseMovies(source);
		}
		
		/**
		 * Returns an array with all the <code>Movie</code> objects in this source.
		 *
		 * @return an array with all the movies in this source
		 */
		public function getAll():Array {
			return _movies;
		}
		
		public function toString():String {
			return "CSVMovieSource";
		}
		
		/**
		 * Parses the csv source string to an array of <code>Movie</code> objects.
		 *
		 * @return an array with all the movies in this source
		 */
		private function parseMovies(source:String):Array {
			var result:Array = [];
			var parts:Array = source.split(",");
			
			for (var i:int = 0; i < parts.length; i += 2) {
				result.push(new Movie(parts[i], parts[i + 1]));
			}
			
			return result;
		}
	}
}
