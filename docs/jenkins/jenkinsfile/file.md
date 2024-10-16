

> [!NOTE|label:API]
> - [Class File](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/io/File.html)
>   - [File.exists()](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/io/File.html#exists%28%29)
>   - [File.isDirectory()](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/io/File.html#isDirectory%28%29)
>   - [File.isFile()](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/io/File.html#isFile%28%29)

```groovy
Boolean isFileExist( String file ) {
  Paths.get(file).toFile().isFile()
}

Boolean isDirExist( String dir ) {
  Paths.get(dir).toFile().isDirectory()
}

Boolean pathExist( String path ) {
  Paths.get(path).toFile().exists()
}
```

> [!WARNING|label:`java.io.File`]
> `java.io.File` methods will refer to files on the **controller** where Jenkins is running, and not in the current workspace on the **agent**

