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

	[Component(id="movieLister")]
	/**
	 * Provides access to a moviesource. This class is called from the UI to retrieve Movie object.
	 *
	 * @author Christophe Herreman
	 */
	public class MovieLister {

		[Property(ref="csvMovieFinder")]
		// contains movie objects
		// ! the thing to note here is that we type to the IMovieSource interface and not to a specific implementation such
		// as StaticMovieSource or CSVMovieLister
		public var movieSource:IMovieSource;

		// note that we could also make our movieSource private and provide an accessor for it as follows:
		//
		// private var _movieSource:IMovieSource;
		//
		// public function get movieSource():IMovieSource { return _movieSource; }
		// public function set movieSource(value:IMovieSource):void { _movieSource = value; }
		//
		// however, Spring ActionScript does not (currently) support javabean like setter injection so the following line will not work
		//
		// public function setMovieSource(value:IMovieSource):void { _movieSource = value; }

		/**
		 * Creates a new <code>MovieLister</code> object.
		 */
		public function MovieLister() {
			// nothing
		}

		/**
		 * Returns all movies directed by the given director. The movies are <code>Movie</code> objects.
		 *
		 * @param director the name of the director to get its movies from
		 * @return an array with the movies directed by the given director
		 */
		public function getMoviesDirectedBy(director:String):Array {
			var result:Array = [];
			var movies:Array = movieSource.getAll();

			for (var i:int = 0; i < movies.length; i++) {
				var movie:Movie = movies[i];

				if (movie.director.toLowerCase() == director.toLowerCase()) {
					result.push(movie);
				}
			}

			return result;
		}

		/**
		 * Returns all movies.
		 *
		 * @return an array with Movie objects
		 */
		public function getAll():Array {
			return movieSource.getAll();
		}
	}
}
