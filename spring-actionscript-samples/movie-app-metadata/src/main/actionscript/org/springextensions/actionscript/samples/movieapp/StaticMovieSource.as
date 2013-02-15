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

	[Component("staticMovieSource")]
	/**
	 * The <code>StaticMovieSource</code> has a predefined set of <code>Movie</code> objects.
	 *
	 * @author Christophe Herreman
	 */
	public class StaticMovieSource implements IMovieSource {

		private var _movies:Array;

		/**
		 * Creates a new <code>StaticMovieSource</code> object
		 */
		public function StaticMovieSource() {
			_movies = [];
			_movies.push(new Movie("Reservoir Dogs", "Quentin Tarantino"));
			_movies.push(new Movie("Pulp Fiction", "Quentin Tarantino"));
			_movies.push(new Movie("Batman", "Tim Burton"));
			_movies.push(new Movie("Big Fish", "Tim Burton"));
			_movies.push(new Movie("Corpse Bride", "Tim Burton"));
			_movies.push(new Movie("Braveheart", "Mel Gibson"));
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
			return "StaticMovieSource";
		}
	}
}
