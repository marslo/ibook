<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Path](#path)
- [Files](#files)
  - [traverseInPath](#traverseinpath)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:API]
> - [Class File](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/io/File.html)
>   - [File.exists()](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/io/File.html#exists%28%29)
>   - [File.isDirectory()](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/io/File.html#isDirectory%28%29)
>   - [File.isFile()](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/io/File.html#isFile%28%29)

## Path
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

## Files
### traverseInPath
- jenkinsfile
  ```groovy
  // the mount path in `NODE_NAME` node
  String path = '/mnt/path/to/dir'

  node ( 'NODE_NAME' ) {
    println ( ">> traverse all FILES/DIRECTORIES in ${path} in maxDepth 0 : " )
    println traverseInPath( path, 'any', 0 ).join('\n')

    println ( ">> traverse all FILES/DIRECTORIES in ${path} in maxDepth 1 : " )
    println traverseInPath( path, 'any', 1 ).join('\n')

    println ( ">> traverse all FILES in ${path} in maxDepth 2 : " )
    println traverseInPath( path, 'files', 2 ).join('\n')

    println ( ">> traverse all FILES in ${path} in maxDepth 3 : " )
    println traverseInPath( path, 'files', 3 ).join('\n')
  }
  ```

- lib
  ```groovy
  @NonCPS
  def traverseInPath( String path, String filetype, Integer depth = 1 ) {
    List<String> names = []
    if ( ! [ 'files', 'directories', 'any' ].contains(filetype) ) {\
      currentBuild.description = "`filetype` support only ${[ 'files', 'directories', 'any' ].join(',')} !"
      currentBuild.result = 'NOT_BUILT'
      currentBuild.getRawBuild().getExecutor().interrupt(Result.NOT_BUILT)
    }

    Closure sortByTypeThenName = { a, b ->
      a.isFile() != b.isFile() ? a.isFile() <=> b.isFile() : a.name.toLowerCase() <=> b.name.toLowerCase()
    }

    new File(path).traverse(
      type     : FileType.valueOf( filetype.toUpperCase() ),
      maxDepth : depth,
      sort     : sortByTypeThenName
    ) {
      names << it
    }

    return names
  }
  ```

