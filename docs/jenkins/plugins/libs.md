
## functions
### get gerrit owner recursively

#### solution 1
```bash
/**
 * get the project owner list<br>
 * the owner of project will find from inherits-from project recursively
 * <p>
 * for example, the project owner of {@code IP/SW/distributions/buildroot/buildroot} will be:<br>
 * owner of {@code IP/SW/distributions} +<br>
 * owner of {@code IP/SW/distributions/buildroot} +<br>
 * owner of {@code IP/SW/distributions/buildroot/buildroot}
 *
 * @param map         the named parameters
 *                    <p><ul>
 *                      <li>▫ {@code project} - <i>required if <code>json</code> is invalid</i> : the project name</li>
 *                      <li>▫ {@code json} - <i>required if <code>project</code> is invalid</i> : the json string that should be parsed</li>
 *                      <li>▫ {@code credential} : the credential for the Gerrit API access, using {@link #GERRIT_CREDENTIAL} by default </li>
 *                      <li>▫ {@code verbose} : the flag to indicate whether to show the verbose message, using {@link #VERBOSE} by default</li>
 *                    </ul></p>
 * @return            the {@code List} structure for project owner list
**/
List<String> getProjectOwner( Map map ) {
  util.checkNecessary( map, 'project' )

  List owners = []
  String json = toJsonString( map?.json ?: getProjectPerms(map) )
  Map content = readJSON text: json, returnPojo: true
  List owner  = content?.local?.getOrDefault( 'refs/*', [:] )
                        .findAll { it.value.keySet().contains('owner') }
                        .collectEntries { it.value.owner }?.rules
                        .findAll { 'ALLOW' == it.value.action }?.collect { it.key }
                        .collect { it.tokenize(':').last() } ?: []
  String parents = content?.inherits_from?.name ?: ''
  String root    = map.project.tokenize('/').take(2).join('/')

  if ( owner ) {
    owners << owner
  } else {
    if ( ! parents || root == parents || ! parents.startsWith(root) ) {
      return owners.flatten().unique()
    } else {
      owners << getProjectOwner( [ project: parents ] << map.findAll{ 'project' != it.key } )
    }
  }
  return owners.flatten().unique()
}

/**
 * get the project owner list
 *
 * @param project     the project name
 * @return            the {@code List} structure for project owner list
**/
List<String> getProjectOwner( String project ) {
  getProjectOwner( project: project )
}

/**
 * add owner list into the vset json
 *
 * @param map         the named parameters that will be passed to {@link #getProjectOwner(java.util.Map)} method and gerritApi specific parameters:
 *                    <ul><li>▪ {@code json} : the {@code List&lt;Map&lt;String, String&gt;&gt;} structure that should be parsed and updated</li></ul>
 * @return            the {@code List&lt;Map&lt;String, String&gt;&gt;} structure for the vset information
 *                    <pre>
 *                    // the result after adding owner list
 *                    [
 *                      [ project: 'PROJECT_NAME', owner: [ 'owner1', 'owner2', 'owner3' ], ... ],
 *                    ]
 *                    </pre>
**/
List<Map> addProjectOwner( Map map ) {
  util.checkNecessary( map, 'json' )
  map.json.collect { e ->
    List owner = getProjectOwner( [ project: e.project ] << map.findAll{ 'json' != it.key } )
    e.collectEntries {[ 'owner': owner ] << it }
  }
}

/**
 * execute the Gerrit API http request and return the response json
 *
 * @param map         the named parameters that will be passed to {@link wrapper#httpRequests(java.util.Map, java.lang.Boolean)} method and gerritApi specific parameters:
 *                    <ul>
 *                      <li>▫ {@code credential} : the credential for the Gerrit API access, using {@link #GERRIT_CREDENTIAL} by default </li>
 *                      <li>▫ {@code dryrun} : the flag to indicate whether to run the script in dryrun mode, using {@link #DRYRUN} by default</li>
 *                      <li>▫ {@code verbose} : the flag to indicate whether to show the verbose message, using {@link #VERBOSE} by default</li>
 *                    </ul>
 * @return            the http response of gerrit API
 *
 * @see               {@link wrapper#httpRequests(java.util.Map, java.lang.Boolean)}
 * @see               <a href="https://gerrit-review.googlesource.com/Documentation/rest-api-projects.html#get-access">AccessInfo</a>
**/
String executor( Map map ) {
  util.checkNecessary( map, 'url' )
  String credential = map.credential ?: GERRIT_CREDENTIAL
  Boolean dryrun    = map.dryrun     ?: DRYRUN
  Boolean verbose   = map.containsKey('verbose') ? wrapper.isBoolean( verbose: map.verbose ) : VERBOSE
  String response   = wrapper.httpRequests( map, dryrun ).withCredential( credential, ! verbose )
  ! dryrun ? response ? response.split('\n').tail().join('\n')
           : util.showError( ">> [ERROR]: failed to get the project access config" )
           : ''
}

/**
 * get curl httpRequests with credential
 *
 * @param map         the named parameters
 *                    <p><ul>
 *                      <li>▪ {@code url} - <b>required*</b> : the url for API request</li>
 *                      <li>▫ {@code method} : the HTTP method, default is {@code GET}</li>
 *                      <li>▫ {@code headers} : the HTTP headers</li>
 *                      <li>▫ {@code body} : the HTTP POST/PUSH body</li>
 *                      <li>▫ {@code netrc} : the local path of netrc file</li>
 *                      <li>▫ {@code file} : the local file path, normally for upload {@code PUT} method</li>
 *                      <li>▫ {@code returned} : <a href="https://www.jenkins.io/doc/pipeline/steps/workflow-durable-task-step/#sh-shell-script">the shell script return type</a>, using {@code stdout} by default</li>
 *                      <li>▫ {@code options}: a {@code List} of CURL opts, using {@link wrapper#CURL_OPTS} if not set</li>
 *                    </ul></p>
 * @param dryrun      whether if show the command only without executing
 * @return            {@code String} format of curl stdout by default, or {@code Boolean} if {@code returned} is {@code status}
 *
 * @see               <a href="https://www.jenkins.io/doc/pipeline/steps/workflow-durable-task-step/#sh-shell-script">sh: Shell Script</a>
 * @see               <a href="https://curl.se/docs/manpage.html">curl(1)</a>
 * @see               {@link #runShell(Boolean)}
**/
def httpRequests( Map map, Boolean dryrun = false ) {
  util.checkNecessary( map, 'url' )
  Map optMatrix = [
    'insecure'   : 'k' ,
    'fail'       : 'f' ,
    'silent'     : 's' ,
    'show-error' : 'S' ,
    'location'   : 'L' ,
    'globoff'    : 'g' ,
    'head'       : 'I' ,
    'verbose'    : 'v'
  ]

  String returned = map.returned
                      ? [ 'stdout', 'status' ].contains( map.returned ) ? map.returned : util.showErr( '`returned` parameter MUST be `stdout` or `status` !' )
                      : 'stdout'
  String opt = '--' + ( map?.options?.findAll{ optMatrix.containsKey(it) } ?: CURL_OPTS ).join(' --')
  opt += " -X ${map.method ?: 'GET'}"
  opt += map?.header ? " -H '${map.header}'"        : ''
  opt += map?.body   ? " -d '${map.body}'"          : ''
  opt += map?.netrc  ? " --netrc-file ${map.netrc}" : ''
  opt += map?.file   ? " --upload-file ${map.file}" : ''

  [
    run            : { Boolean suppress = false ->
                       runShell(dryrun)."${returned}".call( "${suppress ? "${constant.BASH_SHEBANG}\n" : ''}curl ${opt} ${map.url}" )
                     } ,
    withCredential : { String credential, Boolean suppress = false ->
                       util.withCredential( credential ) { Map user ->
                         String cmd =  "${suppress ? "${constant.BASH_SHEBANG}\n" : ''}curl -u ${user.username}:${user.password} ${opt} ${map.url}"
                         runShell(dryrun)."${returned}".call( "${cmd} ${'status' == returned ? '1>/dev/null' : ''}" )
                       }
                     } ,
  ]
}

/**
 * run shell commands with or without dryrun mode and return with the status or stdout
 *
 * @param cmd         the shell command
 * @param dryrun      whether if show the command only without executing
**/
def runShell( Boolean dryrun = DRY_RUN ) {
  [
    status : { String cmd -> dryrun ? util.logger( cmd, 'dryrun' ) : sh( returnStatus: true, script: "${cmd}" ) == 0    } ,
    stdout : { String cmd -> dryrun ? util.logger( cmd, 'dryrun' ) : sh( returnStdout: true, script: "${cmd}" )?.trim() }
  ]
}

/**
 * get the project access config via Gerrit API {@code project/{project}/access}
 *
 * @param map         the named parameters
 *                    <p><ul>
 *                      <li>▪ {@code project} - <b>required*</b>: the project name</li>
 *                      <li>▫ {@code verbose} : the flag to indicate whether to show the verbose message, using {@link #VERBOSE} by default</li>
 *                      <li>▫ {@code credential} : the credential for the Gerrit API access, using {@link #GERRIT_CREDENTIAL} by default </li>
 *                    </ul></p>
 * @return            the project access config json String getting from Gerrit API
 *
 * @see               <a href="https://gerrit-review.googlesource.com/Documentation/rest-api-projects.html#get-access">List Access Rights for Project</a>
**/
String getProjectPerms( Map map ) {
  util.checkNecessary( map, 'project' )
  executor(
    url: "${GERRIT_URL}/a/projects/${URLEncoder.encode(map.project, 'UTF-8')}/access",
    method: 'GET',
    header: "Content-Type: application/json",
    credential: map.credential ?: GERRIT_CREDENTIAL,
    verbose: map.containsKey('verbose') ? wrapper.isBoolean( verbose: map.verbose ) : VERBOSE
  )
}
  ```

#### solution 2
```bash
/**
 * get the project owner list
 *
 * @param map         the named parameters
 *                    <p><ul>
 *                      <li>▫ {@code project} - <i>required if <code>json</code> is invalid</i> : the project name</li>
 *                      <li>▫ {@code json} - <i>required if <code>project</code> is invalid</i> : the json string that should be parsed</li>
 *                      <li>▫ {@code credential} : the credential for the Gerrit API access, using {@link #GERRIT_CREDENTIAL} by default </li>
 *                      <li>▫ {@code verbose} : the flag to indicate whether to show the verbose message, using {@link #VERBOSE} by default</li>
 *                    </ul></p>
 * @return            the {@code List} structure for project owner list
**/
List<String> getProjectOwner( Map map ) {
  util.checkAtLeastOne( map, 'project', 'json'  )
  String json = toJsonString( map?.json ?: getProjectPermsIfExists(map) )
  if ( ! json ) { return [] }
  Map content = readJSON text: json, returnPojo: true
  content?.local?.getOrDefault( 'refs/*', [:] )
                 .findAll { it.value.keySet().contains('owner') }
                 .collectEntries { it.value.owner }?.rules
                 .findAll { 'ALLOW' == it.value.action }?.collect { it.key }
                 .collect { it.tokenize(':').last() } ?: []
}

/**
 * add owner list into the vset json<br>
 * the owner of project will recursively find into super projects.
 * <p>
 * for example, the project owner of {@code IP/SW/distributions/buildroot/buildroot} will be:<br>
 * owner of {@code IP/SW/distributions} +<br>
 * owner of {@code IP/SW/distributions/buildroot} +<br>
 * owner of {@code IP/SW/distributions/buildroot/buildroot}
 *
 * @param map         the named parameters that will be passed to {@link #getProjectOwner(java.util.Map)} method and gerritApi specific parameters:
 *                    <ul><li>▪ {@code json} : the {@code List&lt;Map&lt;String, String&gt;&gt;} structure that should be parsed and updated</li></ul>
 * @return            the {@code List&lt;Map&lt;String, String&gt;&gt;} structure for the vset information
 *                    <pre>
 *                    // the result after adding owner list
 *                    [
 *                      [ project: 'PROJECT_NAME', owner: [ 'owner1', 'owner2', 'owner3' ], ... ],
 *                    ]
 *                    </pre>
**/
List<Map> addProjectOwner( Map map ) {
  util.checkNecessary( map, 'json' )
  Map owners = map.json.collectMany {
                        List list = it.project.tokenize('/')
                        (2..list.size()-1).collect { list[0..it].join('/') }
                      }.unique()
                       .collectEntries {[
                        (it): getProjectOwner( [ project: it ] << map.findAll { 'json' != it.key } )
                      ]}

  map.json.collect { e ->
    List owner = owners.findResults { e.project.startsWith(it.key) ? it.value : [] }.flatten().unique()
    e.collectEntries {[ 'owner': owner ] << it }
  }
}

/**
 * add owner list into the vset json<br>
 * the owner of project will recursively find into super projects.
 *
 * @param json        the {@code List&lt;Map&lt;String, String&gt;&gt;} structure that should be updated
 *                    <pre>
 *                    // the json structure should be like:
 *                    [
 *                      [ project: 'PROJECT_NAME', ... ],
 *                    ]
 *                    </pre>
 * @return            the {@code List&lt;Map&lt;String, String&gt;&gt;} structure for the vset information
 *
 * @see               {@link #addProjectOwner(java.util.Map)}
**/
List<Map> addProjectOwner( List json ) {
  addProjectOwner( json: json )
}

/**
 * execute the Gerrit API http request and return the response json
 *
 * @param map         the named parameters that will be passed to {@link wrapper#httpRequests(java.util.Map, java.lang.Boolean)} method and gerritApi specific parameters:
 *                    <ul>
 *                      <li>▫ {@code credential} : the credential for the Gerrit API access, using {@link #GERRIT_CREDENTIAL} by default </li>
 *                      <li>▫ {@code dryrun} : the flag to indicate whether to run the script in dryrun mode, using {@link #DRYRUN} by default</li>
 *                      <li>▫ {@code verbose} : the flag to indicate whether to show the verbose message, using {@link #VERBOSE} by default</li>
 *                    </ul>
 * @return            the http response of gerrit API
 *
 * @see               {@link wrapper#httpRequests(java.util.Map, java.lang.Boolean)}
 * @see               <a href="https://gerrit-review.googlesource.com/Documentation/rest-api-projects.html#get-access">AccessInfo</a>
**/
String executor( Map map ) {
  util.checkNecessary( map, 'url' )
  String credential = map.credential ?: GERRIT_CREDENTIAL
  Boolean dryrun    = map.dryrun     ?: DRYRUN
  Boolean verbose   = map.containsKey( 'verbose' )
                         ? Boolean.isCase(map.verbose) ? map.verbose : util.showError( '>> [ERROR] `verbose` MUST be in `Boolean` type !' )
                         : VERBOSE
  [
    run             : {
                        String response = wrapper.httpRequests( map, dryrun )
                                                 .withCredential( credential, ! verbose )
                        ! dryrun ? response ? response.split('\n').tail().join('\n')
                                 : util.showError( ">> [ERROR]: failed to get the project access config" )
                                 : ''
                      } ,
    runWithoutError : {
                        String response = wrapper.httpRequests( map, dryrun )
                                                 .runWithoutError( credential, ! verbose )
                        ! dryrun ? response ? response.split('\n').tail().join('\n')
                                 : util.showError( ">> [ERROR]: failed to get the project access config" )
                                 : ''
                      }
    ]
}

/**
 * get the project access config via Gerrit API {@code project/{project}/access} if project exists
 *
 * @param map         the named parameters
 *                    <p><ul>
 *                      <li>▪ {@code project} - <b>required*</b>: the project name</li>
 *                      <li>▫ {@code verbose} : the flag to indicate whether to show the verbose message, using {@link #VERBOSE} by default</li>
 *                      <li>▫ {@code credential} : the credential for the Gerrit API access, using {@link #GERRIT_CREDENTIAL} by default </li>
 *                    </ul></p>
 * @return            the project access config json String getting from Gerrit API
 *
 * @see               <a href="https://gerrit-review.googlesource.com/Documentation/rest-api-projects.html#get-access">List Access Rights for Project</a>
**/
String getProjectPermsIfExists( Map map ) {
  util.checkNecessary( map, 'project' )
  executor(
    url: "${GERRIT_URL}/a/projects/${URLEncoder.encode(map.project, 'UTF-8')}/access",
    method: 'GET',
    header: "Content-Type: application/json",
    credential: map.credential ?: GERRIT_CREDENTIAL,
    verbose: map.containsKey( 'verbose' )
                ? Boolean.isCase(map.verbose) ? map.verbose : util.showError( '>> [ERROR] `verbose` MUST be in `Boolean` type !' )
                : VERBOSE
  ).runWithoutError()
}

/**
 * get curl httpRequests with credential
 *
 * @param map         the named parameters
 *                    <p><ul>
 *                      <li>▪ {@code url} - <b>required*</b> : the url for API request</li>
 *                      <li>▫ {@code method} : the HTTP method, default is {@code GET}</li>
 *                      <li>▫ {@code headers} : the HTTP headers</li>
 *                      <li>▫ {@code body} : the HTTP POST/PUSH body</li>
 *                      <li>▫ {@code netrc} : the local path of netrc file</li>
 *                      <li>▫ {@code file} : the local file path, normally for upload {@code PUT} method</li>
 *                      <li>▫ {@code returned} : <a href="https://www.jenkins.io/doc/pipeline/steps/workflow-durable-task-step/#sh-shell-script">the shell script return type</a>, using {@code stdout} by default</li>
 *                      <li>▫ {@code options}: a {@code List} of CURL opts, using {@link wrapper#CURL_OPTS} if not set</li>
 *                    </ul></p>
 * @param dryrun      whether if show the command only without executing
 * @return            {@code String} format of curl stdout by default, or {@code Boolean} if {@code returned} is {@code status}
 *
 * @see               <a href="https://www.jenkins.io/doc/pipeline/steps/workflow-durable-task-step/#sh-shell-script">sh: Shell Script</a>
 * @see               <a href="https://curl.se/docs/manpage.html">curl(1)</a>
 * @see               {@link #runShell(Boolean)}
**/
def httpRequests( Map map, Boolean dryrun = false ) {
  util.checkNecessary( map, 'url' )
  Map optMatrix = [
    'insecure'   : 'k' ,
    'fail'       : 'f' ,
    'silent'     : 's' ,
    'show-error' : 'S' ,
    'location'   : 'L' ,
    'globoff'    : 'g' ,
    'head'       : 'I' ,
    'verbose'    : 'v'
  ]

  String returned = map.returned
                      ? [ 'stdout', 'status' ].contains( map.returned ) ? map.returned : util.showErr( '`returned` parameter MUST be `stdout` or `status` !' )
                      : 'stdout'
  String opt = '--' + ( map?.options?.findAll{ optMatrix.containsKey(it) } ?: CURL_OPTS ).join(' --')
  opt += " -X ${map.method ?: 'GET'}"
  opt += map?.header ? " -H '${map.header}'"        : ''
  opt += map?.body   ? " -d '${map.body}'"          : ''
  opt += map?.netrc  ? " --netrc-file ${map.netrc}" : ''
  opt += map?.file   ? " --upload-file ${map.file}" : ''

  [
    run            : { Boolean suppress = false ->
                       runShell(dryrun)."${returned}".call( "${suppress ? "${BASH_SHEBANG}\n" : ''}curl ${opt} ${map.url}" )
                     } ,
    withCredential : { String credential, Boolean suppress = false ->
                       util.withCredential( credential ) { Map user ->
                         String cmd =  "${suppress ? "${BASH_SHEBANG}\n" : ''}curl -u ${user.username}:${user.password} ${opt} ${map.url}"
                         runShell(dryrun)."${returned}".call( "${cmd} ${'status' == returned ? '1>/dev/null' : ''}" )
                       }
                     } ,
    runWithoutError: { String credential, Boolean suppress = false ->
                       util.withCredential( credential ) { Map user ->
                         String cmd =  "${suppress ? "${BASH_SHEBANG}\n" : ''} set +e; curl -u ${user.username}:${user.password} ${opt} ${map.url}"
                         runShell(dryrun)."${returned}".call( "${cmd} ${'status' == returned ? '>/dev/null 2>&1' : ''}  || echo 'skip'" )
                       }
                     }
  ]
}
```
