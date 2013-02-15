package {
  import flash.utils.ByteArray;

  [Embed(source="/applicationContext.xml", mimeType="application/octet-stream")]
  /**
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 859 $, $Date: 2008-09-16 12:14:22 +0200 (di, 16 sep 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.7
   */
  public class EmbeddedContext extends ByteArray {
    public function EmbeddedContext() {
      super();
    }

    public function get content():XML {
      return new XML(readUTFBytes(length));
    }
  }
}
