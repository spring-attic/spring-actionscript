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

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class HtmlUtilsTest extends TestCase {

    public function HtmlUtilsTest(methodName:String = null) {
      super(methodName);
    }

    //=====================================================================
    // parseTables(html:String):String
    //=====================================================================
    public function testParseTables1():void {
      var input:String = "";
      var expected:String = "";
      var result:String = HtmlUtils.parseTables(input);
      assertEquals(expected, result);
    }

    public function testParseTables2():void {
      var input:String = "a";
      var expected:String = "a";
      var result:String = HtmlUtils.parseTables(input);
      assertEquals(expected, result);
    }

    public function testParseTables3():void {
      var input:String = "a<table><tr><td></td></tr></table>b";
      var expected:String = "a<TEXTFORMAT TABSTOPS=\"0\"></TEXTFORMAT>b";
      var result:String = HtmlUtils.parseTables(input);
      assertEquals(expected, result);
    }

    public function testParseTables4():void {
      var input:String = "a<table junk>junk<tr junk>junk<td junk>data</td>junk</tr>junk</table>b";
      var expected:String = "a<TEXTFORMAT TABSTOPS=\"0\">data</TEXTFORMAT>b";
      var result:String = HtmlUtils.parseTables(input);
      assertEquals(expected, result);
    }

    public function testParseTables5():void {
      var input:String = "before<table><tr><td width=\"20\">a</td><td width='50'>b</td></tr><tr><td>c</td><td>d</td></tr></table>after";
      var expected:String = "before<TEXTFORMAT TABSTOPS=\"20,70\">a<TAB>b<BR>c<TAB>d</TEXTFORMAT>after";
      var result:String = HtmlUtils.parseTables(input);
      assertEquals(expected, result);
    }

    public function testParseTables6():void {
      var input:String = ""
        + "before<table>\n"
        + "  <tr>\n"
        + "    <td width=40 x>e</td>\n"
        + "    <td width=10>f</td>\n"
        + "  </tr>\n"
        + "  <tr>\n"
        + "    <td>g</td>\n"
        + "    <td>h</td>\n"
        + "  </tr>\n"
        + "</table>after";
      var expected:String = "before<TEXTFORMAT TABSTOPS=\"40,50\">e<TAB>f<BR>g<TAB>h</TEXTFORMAT>after";
      var result:String = HtmlUtils.parseTables(input);
      assertEquals(expected, result);
    }

    public function testParseTables7():void {
      var input:String = ""
        + "before<table>\n"
        + "  <tr>\n"
        + "    <td width=40 x>e</td>\n"
        + "    <td width=10>f</td>\n"
        + "  </tr>\n"
        + "  <tr>\n"
        + "    <td>g</td>\n"
        + "    <td>h</td>\n"
        + "  </tr>\n"
        + "</table>after";
      var expected:String = "before<TEXTFORMAT TABSTOPS=\"40,50\">e<TAB>f<BR>g<TAB>h</TEXTFORMAT>after";
      var result:String = HtmlUtils.parseTables(input);
      assertEquals(expected, result);
    }

  }
}
