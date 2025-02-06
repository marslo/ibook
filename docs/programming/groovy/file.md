

## file

> [!NOTE|label:references:]
> - [Class File](https://docs.oracle.com/javase/8/docs/api/java/io/File.html)
> - [Class FilenameUtils](https://commons.apache.org/proper/commons-io/javadocs/api-1.4/org/apache/commons/io/FilenameUtils.html#getName(java.lang.String))
>   - [FilenameUtils.getName(String)](https://stackoverflow.com/a/39336223/2940319)
> - [Package java.nio.file](https://docs.oracle.com/javase/10/docs/api/java/nio/file/package-summary.html)
> - [Class Paths](https://docs.oracle.com/javase/10/docs/api/java/nio/file/Paths.html) VS. [Interface Path](https://docs.oracle.com/javase/10/docs/api/java/nio/file/Path.html#getFileName())
>   ```groovy
>   // https://stackoverflow.com/a/49019436/2940319
>   assert sun.nio.fs.UnixPath == java.nio.file.Paths.get( '/a/b/c/d.txt' ).getClass()
>   java.nio.file.Path path = java.nio.file.Paths.get( '/a/b/c/d.txt' )
>   ```
>   - [Path getFileName() method in Java with Examples](https://www.geeksforgeeks.org/path-getfilename-method-in-java-with-examples/)
> - [Java Files - java.nio.file.Files Class](https://www.digitalocean.com/community/tutorials/java-files-nio-files-class)

| IO                                                            | NIO                                                                     |
| ------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `File file = new File( 'c:/data' )`<br>`file.createNewFile()` | `Path path = Paths.get( 'c:/data' )`<br>`Files.createFile(path)`        |
| `File file = new File( 'c:/data' )`<br>`file.mkdir()`         | `Path path = Paths.get( 'c:/data' )`<br>`Files.createDirectory(path)`   |
| `File file = new File( 'c:/data' )`<br>`file.mkdirs()`        | `Path path = Paths.get( 'c:/data' )`<br>`Files.createDirectories(path)` |
| `File file = new File( 'c:/data' )`<br>`file.exists()`        | `Path path = Paths.get( 'c:/data' )`<br>`Files.exists(path)`            |


- dirname
  ```groovy
  // via File
  assert '/a/b/c' == ( new File('/a/b/c/d.txt') ).getParentFile().toString()
  assert '/a/b/c' == ( new File('/a/b/c/d.txt') ).getParent()
  assert '/a/b/c' == ( new File('/a/b/c/d.txt') ).parent

  // via java.nio.file.Paths
  assert '/a/b/c' == java.nio.file.Paths.get( '/a/b/c/d.txt' ).getParent().toString()
  assert '/a/b/c' == jhava.nio.file.Paths.get( '/a/b/c/d.txt' ).parent.toString()
  ```

- basename
  ```groovy
  // via File
  assert 'd.txt' == (new File('/a/b/c/d.txt')).getName()
  assert 'd.txt' == (new File('/a/b/c/d.txt')).name

  // via java.nio.file.Paths
  assert 'd.txt' == java.nio.file.Paths.get( '/a/b/c/d.txt' ).getFileName().toString()
  assert 'd.txt' == java.nio.file.Paths.get( '/a/b/c/d.txt' ).fileName.toString()
  ```

- isDirectory || isFile
  ```groovy
  assert true  == ( new File('/Users/marslo/.vimrc') ).isFile()
  assert false == ( new File('/Users/marslo/.vimrc') ).isDirectory()
  ```

## traverse
### `groovy.io.FileType.FILES`

> [!NOTE|label:references:]
> - [* iMarslo: jenkinsfile libs](../../jenkins/jenkinsfile/utility.md#groovyiofiletype)
> - [Groovy Goodness: Traversing a Directory](https://blog.mrhaki.com/2010/04/groovy-goodness-traversing-directory.html) | [Groovy Goodness: Traversing a Directory](https://wjw465150.github.io/blog/Groovy/my_data/Goodness/File-Traversing%20a%20Directory.html)
> - [Recursive listing of all files matching a certain filetype in Groovy](https://stackoverflow.com/a/3665539/2940319)
>   ```groovy
>   import static groovy.io.FileType.FILES
>   ```
> - [Get a list of all the files in a directory (recursive)](https://stackoverflow.com/a/38526252/2940319)

```groovy
#!/usr/bin/env groovy

import groovy.transform.Field

String pathToFolder = '/Users/marslo/.ssh'
new File(pathToFolder).traverse(type: groovy.io.FileType.FILES) {
  println it
}

// vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=Groovy
```

### jenkins libs
```groovy
import groovy.io.FileType
import static groovy.io.FileType.*

@NonCPS
def traverseInPath( String path, String filetype, Integer depth = 1 ) {
  List<String> names = []
  if ( ! [ 'files', 'directories', 'any' ].contains(filetype) ) {
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

- jenkinsfile

  ```groovy
  String path = '/mnt/to/path/1'
  String path2 = '/mnt/to/path/2'

  node ( NODE_NAME ) {
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
