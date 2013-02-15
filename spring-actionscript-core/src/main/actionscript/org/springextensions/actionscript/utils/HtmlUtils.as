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
package org.springextensions.actionscript.utils {
	
	/**
	 * Contains utility methods for working with html.
	 *
	 * <p>
	 * <b>Author:</b> Kristof Neirynck<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public final class HtmlUtils{
		
		/** string used for newline (&lt;BR&gt; or \n work best) */
		public static const BR:String = "<BR>";
		/** string used for tab (&lt;TAB&gt; or \t work best) */
		public static const TAB:String = "<TAB>";
		
		/**
		 * parseTables<br>
		 * Parses tables with the Parse class and outputs String fit for use as htmlText.<br>
		 * No support for nested tables.<br>
		 * Ignores errors thrown by Parse.<br>
		 *
		 * @param html String with &lt;table&gt; notation
		 * @return String with &lt;TEXTFORMAT&gt; notation
		 */
		public static function parseTables(html:String):String{
			var result:String;
			var parsedHtml:Parse;
			try{
				result = "";
				parsedHtml = new Parse(html, null);
			}catch(error:Error){
				//an error occured, ignore it and return the input
				result = html;
				parsedHtml = null;
			}
			for(var table:Parse = parsedHtml; table != null; table = table.more){
				result += table.leader;
				result += "<TEXTFORMAT TABSTOPS=\"";
				var tabPosition:int = 0;
				for(var td:Parse = table.parts.parts; td != null; td = td.more){
					tabPosition += td.width();
					result += tabPosition;
					if(td.more != null){
						result += ",";
					}
				}
				result += "\">";
				
				for(var tr:Parse = table.parts; tr != null; tr = tr.more){
					for(var td2:Parse = tr.parts; td2 != null; td2 = td2.more){
						result += td2.body;
						if(td2.more != null){
							result += TAB;
						}
					}
					if(tr.more != null){
						result += BR;
					}
				}
				result += "</TEXTFORMAT>";
				if(table.more== null){
					result += table.trailer;
				}
			}
			return result;
		}
	}
}
