<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [tricky](#tricky)
  - [Viewing Jenkins Jobs' Configuration as XML](#viewing-jenkins-jobs-configuration-as-xml)
  - [using style in Jenkins](#using-style-in-jenkins)
- [crumb issuer](#crumb-issuer)
  - [get crumb](#get-crumb)
  - [visit API via crumb](#visit-api-via-crumb)
  - [restart Jenkins instance](#restart-jenkins-instance)
- [run Jenkins](#run-jenkins)
  - [in docker](#in-docker)
  - [in kubernetes](#in-kubernetes)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## tricky

### [Viewing Jenkins Jobs' Configuration as XML](https://www.jvt.me/posts/2019/11/29/jenkins-config-xml/)
1. install [Job Configuration History](https://plugins.jenkins.io/jobConfigHistory/)
2. open in browser:
  ```bash
  job url   : http: //localhost:8080/job/<job-name>/
  conig url : http: //localhost:8080/job/<job-name>/config.xml
  ```

### using style in Jenkins

{% hint style='tip' %}
> references:
> - [bootstrap.min.css 4.x](https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css)
> - [bootstrap.min.css 5.x](https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css)
>   - [Bootstrap Alerts](https://www.tutorialrepublic.com/twitter-bootstrap-tutorial/bootstrap-alerts.php)
> - [docs.min.css](https://getbootstrap.com/docs/4.0/assets/css/docs.min.css)
> - [bootstrap components](https://getbootstrap.com/docs/4.0/components/alerts/)
> - [bootstrap utilities](https://getbootstrap.com/docs/4.0/utilities/borders/)
>   - [bootstrap colors](https://getbootstrap.com/docs/4.0/utilities/colors/)
> - [The Curious Case of the Slow Jenkins Job](https://marcesher.com/2017/06/27/the-curious-case-of-the-slow-jenkins-job/)
> - [Jekyll Doc Theme 6.0: Alert](https://idratherbewriting.com/documentation-theme-jekyll/mydoc_alerts.html)
{% endhint %}

> [!NOTE|style:callout]
> - bootstrap 4.x
>   ```html
>   <head>
>   <link href="https://getbootstrap.com/docs/4.0/assets/css/docs.min.css" rel="stylesheet" id="bootstrap-css">
>   <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
>   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
>   <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
>   </head>
>   ```
>
> - [bootstap 5.x](https://www.tutorialrepublic.com/twitter-bootstrap-tutorial/bootstrap-get-started.php)
>   ```html
>   <head>
>       <meta charset="utf-8">
>       <meta name="viewport" content="width=device-width, initial-scale=1">
>       <!-- Bootstrap CSS -->
>       <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
>   </head>
>   <body>
>       <!-- Bootstrap JS Bundle with Popper -->
>       <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
>   </body>
>   ```

- bootstrap alert 4.x
  ![bootstrap 4.x alert css](../screenshot/jenkins/description-bootstrap-4.x-alert-css.png)

- bootstrap alert 5.x
  ![bootstrap 5.x alert css](../screenshot/jenkins/description-bootstrap-5.x-alert-css.png)

- callout
  ![callout css](../screenshot/jenkins/description-callout-css.png)


#### bootstrap alert

<!--sec data-title="bootstrap-alert 5.x" data-id="section0" data-show=true data-collapse=true ces-->
> ```css
> .alert{ --bs-alert-bg:transparent;--bs-alert-padding-x:1rem;--bs-alert-padding-y:1rem;--bs-alert-margin-bottom:1rem;--bs-alert-color:inherit;--bs-alert-border-color:transparent;--bs-alert-border:1px solid var(--bs-alert-border-color);--bs-alert-border-radius:0.375rem;position:relative;padding:var(--bs-alert-padding-y) var(--bs-alert-padding-x);margin-bottom:var(--bs-alert-margin-bottom);color:var(--bs-alert-color);background-color:var(--bs-alert-bg);border:var(--bs-alert-border);border-radius:var(--bs-alert-border-radius) }
> .alert-heading{ color:inherit }
> .alert-link{ font-weight:700 }
>
> .fade{ transition:opacity .15s linear }
> .fade:not(.show){ opacity:0 }
>
> .btn-close{ box-sizing:content-box;width:1em;height:1em;padding:.25em .25em;color:#000;background:transparent url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23000'%3e%3cpath d='M.293.293a1 1 0 0 1 1.414 0L8 6.586 14.293.293a1 1 0 1 1 1.414 1.414L9.414 8l6.293 6.293a1 1 0 0 1-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 0 1-1.414-1.414L6.586 8 .293 1.707a1 1 0 0 1 0-1.414z'/%3e%3c/svg%3e") center/1em auto no-repeat;border:0;border-radius:.375rem;opacity:.5 }
> .btn-close:hover{ color:#000;text-decoration:none;opacity:.75 }
> .btn-close:focus{ outline:0;box-shadow:0 0 0 .25rem rgba(13,110,253,.25);opacity:1 }
> .btn-close.disabled,.btn-close:disabled{ pointer-events:none;-webkit-user-select:none;-moz-user-select:none;user-select:none;opacity:.25 }
> .btn-close-white{ filter:invert(1) grayscale(100%) brightness(200%) }
>
> .alert-dismissible{ padding-right:3rem }
> .alert-dismissible .btn-close{ position:absolute;top:0;right:0;z-index:2;padding:1.25rem 1rem }
>
> .alert-primary{ --bs-alert-color:#084298;--bs-alert-bg:#cfe2ff;--bs-alert-border-color:#b6d4fe }
> .alert-primary .alert-link{ color:#06357a }
>
> .alert-secondary{ --bs-alert-color:#41464b;--bs-alert-bg:#e2e3e5;--bs-alert-border-color:#d3d6d8 }
> .alert-secondary .alert-link{ color:#34383c }
>
> .alert-success{ --bs-alert-color:#0f5132;--bs-alert-bg:#d1e7dd;--bs-alert-border-color:#badbcc }
> .alert-success .alert-link{ color:#0c4128 }
>
> .alert-info{ --bs-alert-color:#055160;--bs-alert-bg:#cff4fc;--bs-alert-border-color:#b6effb }
> .alert-info .alert-link{ color:#04414d }
>
> .alert-warning{ --bs-alert-color:#664d03;--bs-alert-bg:#fff3cd;--bs-alert-border-color:#ffecb5 }
> .alert-warning .alert-link{ color:#523e02 }
>
> .alert-danger{ --bs-alert-color:#842029;--bs-alert-bg:#f8d7da;--bs-alert-border-color:#f5c2c7 }
> .alert-danger .alert-link{ color:#6a1a21 }
>
> .alert-light{ --bs-alert-color:#636464;--bs-alert-bg:#fefefe;--bs-alert-border-color:#fdfdfe }
> .alert-light .alert-link{ color:#4f5050 }
>
> .alert-dark{ --bs-alert-color:#141619;--bs-alert-bg:#d3d3d4;--bs-alert-border-color:#bcbebf }
> .alert-dark .alert-link{ color:#101214 }
> ```
>
> - template
>   ```html
>   <div style="--bs-alert-bg:transparent;--bs-alert-padding-x:1rem;--bs-alert-padding-y:1rem;--bs-alert-margin-bottom:1rem;--bs-alert-color:inherit;--bs-alert-border-color:transparent;--bs-alert-border:1px solid var(--bs-alert-border-color);--bs-alert-border-radius:0.375rem;position:relative;padding:var(--bs-alert-padding-y) var(--bs-alert-padding-x);margin-bottom:var(--bs-alert-margin-bottom);color:var(--bs-alert-color);background-color:var(--bs-alert-bg);border:var(--bs-alert-border);border-radius:var(--bs-alert-border-radius); padding-right:3rem;">
>     <h4 style="color:inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">X Alert !</h4>
>     This is a x alert with <a href="#" style="font-weight:700">an example link</a>. Give it a click if you like.
>   </div>
>   ```
<!--endsec-->


<!--sec data-title="bootstrap 5.x :root" data-id="section1" data-show=true data-collapse=true ces-->

![bootstrap 5.x root colors](../screenshot/jenkins/bootstrap-5.x-root-colors.png)

> ```css
> :root{
>   --bs-blue:#0d6efd;
>   --bs-indigo:#6610f2;
>   --bs-purple:#6f42c1;
>   --bs-pink:#d63384;
>   --bs-red:#dc3545;
>   --bs-orange:#fd7e14;
>   --bs-yellow:#ffc107;
>   --bs-green:#198754;
>   --bs-teal:#20c997;
>   --bs-cyan:#0dcaf0;
>   --bs-black:#000;
>   --bs-white:#fff;
>   --bs-gray:#6c757d;
>   --bs-gray-dark:#343a40;
>   --bs-gray-100:#f8f9fa;
>   --bs-gray-200:#e9ecef;
>   --bs-gray-300:#dee2e6;
>   --bs-gray-400:#ced4da;
>   --bs-gray-500:#adb5bd;
>   --bs-gray-600:#6c757d;
>   --bs-gray-700:#495057;
>   --bs-gray-800:#343a40;
>   --bs-gray-900:#212529;
>   --bs-primary:#0d6efd;
>   --bs-secondary:#6c757d;
>   --bs-success:#198754;
>   --bs-info:#0dcaf0;
>   --bs-warning:#ffc107;
>   --bs-danger:#dc3545;
>   --bs-light:#f8f9fa;
>   --bs-dark:#212529;
>   --bs-primary-rgb:13,110,253;
>   --bs-secondary-rgb:108,117,125;
>   --bs-success-rgb:25,135,84;
>   --bs-info-rgb:13,202,240;
>   --bs-warning-rgb:255,193,7;
>   --bs-danger-rgb:220,53,69;
>   --bs-light-rgb:248,249,250;
>   --bs-dark-rgb:33,37,41;
>   --bs-white-rgb:255,255,255;
>   --bs-black-rgb:0,0,0;
>   --bs-body-color-rgb:33,37,41;
>   --bs-body-bg-rgb:255,255,255;
>   --bs-font-sans-serif:system-ui,-apple-system,"Segoe UI",Roboto,"Helvetica Neue","Noto Sans","Liberation Sans",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";
>   --bs-font-monospace:SFMono-Regular,Menlo,Monaco,Consolas,"Liberation Mono","Courier New",monospace;
>   --bs-gradient:linear-gradient(180deg, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0));
>   --bs-body-font-family:var(--bs-font-sans-serif);
>   --bs-body-font-size:1rem;
>   --bs-body-font-weight:400;
>   --bs-body-line-height:1.5;
>   --bs-body-color:#212529;
>   --bs-body-bg:#fff;
>   --bs-border-width:1px;
>   --bs-border-style:solid;
>   --bs-border-color:#dee2e6;
>   --bs-border-color-translucent:rgba(0, 0, 0, 0.175);
>   --bs-border-radius:0.375rem;
>   --bs-border-radius-sm:0.25rem;
>   --bs-border-radius-lg:0.5rem;
>   --bs-border-radius-xl:1rem;
>   --bs-border-radius-2xl:2rem;
>   --bs-border-radius-pill:50rem;
>   --bs-link-color:#0d6efd;
>   --bs-link-hover-color:#0a58ca;
>   --bs-code-color:#d63384;
>   --bs-highlight-bg:#fff3cd
> }
> ```
<!--endsec-->


<!--sec data-title="bootstrap-alert 4.x" data-id="section2" data-show=true data-collapse=true ces-->
> ```css
> .alert{ position:relative; padding:.75rem 1.25rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.25rem }
> .alert-heading{ color:inherit }
> .alert-link{ font-weight:700 }
>
> .alert-dismissible{ padding-right:4rem }
> .alert-dismissible .close{ position:absolute; top:0; right:0; padding:.75rem 1.25rem; color:inherit }
>
> .alert-primary{ color:#004085; background-color:#cce5ff; border-color:#b8daff }
> .alert-primary hr{ border-top-color:#9fcdff }
> .alert-primary .alert-link{ color:#002752 }
>
> .alert-secondary{ color:#383d41; background-color:#e2e3e5; border-color:#d6d8db }
> .alert-secondary hr{ border-top-color:#c8cbcf }
> .alert-secondary .alert-link{ color:#202326 }
>
> .alert-success{ color:#155724; background-color:#d4edda; border-color:#c3e6cb }
> .alert-success hr{ border-top-color:#b1dfbb }
> .alert-success .alert-link{ color:#0b2e13 }
>
> .alert-info{ color:#0c5460; background-color:#d1ecf1; border-color:#bee5eb }
> .alert-info hr{ border-top-color:#abdde5 }
> .alert-info .alert-link{ color:#062c33 }
>
> .alert-warning{ color:#856404; background-color:#fff3cd; border-color:#ffeeba }
> .alert-warning hr{ border-top-color:#ffe8a1 }
> .alert-warning .alert-link{ color:#533f03 }
>
> .alert-danger{ color:#721c24; background-color:#f8d7da; border-color:#f5c6cb }
> .alert-danger hr{ border-top-color:#f1b0b7 }
> .alert-danger .alert-link{ color:#491217 }
>
> .alert-light{ color:#818182; background-color:#fefefe; border-color:#fdfdfe }
> .alert-light hr{ border-top-color:#ececf6 }
> .alert-light .alert-link{ color:#686868 }
>
> .alert-dark{ color:#1b1e21; background-color:#d6d8d9; border-color:#c6c8ca }
> .alert-dark hr{ border-top-color:#b9bbbe }
> .alert-dark .alert-link{ color:#040505 }
> ```
>
> - template
>   ```html
>   <div style="position:relative; padding:.75rem 1.25rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.25rem;">
>     <h4 style="color:inherit">X Alter !</h4>
>     This is a x alert with <a href="#" style="">an example link</a>. Give it a click if you like.
>   </div>
>   ```
<!--endsec-->

- warning
  - 5.x
    ```html
    <div style="--bs-alert-bg:transparent;--bs-alert-padding-x:1rem;--bs-alert-padding-y:1rem;--bs-alert-margin-bottom:1rem;--bs-alert-color:inherit;--bs-alert-border-color:transparent;--bs-alert-border:1px solid var(--bs-alert-border-color);--bs-alert-border-radius:0.375rem;position:relative;padding:var(--bs-alert-padding-y) var(--bs-alert-padding-x);margin-bottom:var(--bs-alert-margin-bottom);color:var(--bs-alert-color);background-color:var(--bs-alert-bg);border:var(--bs-alert-border);border-radius:var(--bs-alert-border-radius); padding-right:3rem; -bs-alert-color:#664d03;--bs-alert-bg:#fff3cd;--bs-alert-border-color:#ffecb5">
      <h4 style="color:inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Warning Alert !</h4>
      This is a warning alert with <a href="#" style="font-weight:700; color:#523e02">an example link</a>. Give it a click if you like.
    </div>
    ```
    - original
      ```html
      <div class="alert alert-warning alert-dismissible fade show">
        <h4 class="alert-heading">Warning Alert !</h4>
        This is a warning alert with <a href="#" class="alert-link">an example link</a>. Give it a click if you like.
      </div>
      ```

  - 4.x
    ```html
    <div style="position:relative; padding:.75rem 1.25rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.25rem; color:#856404; background-color:#fff3cd; border-color:#ffeeba">
      <h4 style="font-size: 1.5rem; color:inherit">Warning Alert !</h4>
      This is a warning alert with <a href="#" style="color:#533f03">an example link</a>. Give it a click if you like.
    </div>

    <!-- 5.x colors -->
    <div style="position:relative; padding:1rem 1rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.375rem; padding-right:3rem; color:#664d03; background-color:#fff3cd; border-color:#ffecb5">
      <h4 style="font-size: 1.5rem; color: #523e02; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Warning Alert !</h4>
      This is a warning alert with <a href="#" style="font-weight:700; color:#523e02">an example link</a>. Give it a click if you like.
    </div>
    ```
    - original
      ```html
      <div class="alert alert-warning" role="alert">
        <h4 class="alert-heading">Warning Alert !</h4>
        This is a warning alert with <a href="#" class="alert-link">an example link</a>. Give it a click if you like.
      </div>
      ```

- success
  - 5.x
    ```html
    <div style="--bs-alert-bg:transparent;--bs-alert-padding-x:1rem;--bs-alert-padding-y:1rem;--bs-alert-margin-bottom:1rem;--bs-alert-color:inherit;--bs-alert-border-color:transparent;--bs-alert-border:1px solid var(--bs-alert-border-color);--bs-alert-border-radius:0.375rem;position:relative;padding:var(--bs-alert-padding-y) var(--bs-alert-padding-x);margin-bottom:var(--bs-alert-margin-bottom);color:var(--bs-alert-color);background-color:var(--bs-alert-bg);border:var(--bs-alert-border);border-radius:var(--bs-alert-border-radius); padding-right:3rem; --bs-alert-color:#0f5132;--bs-alert-bg:#d1e7dd;--bs-alert-border-color:#badbcc">
      <h4 style="color:inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Success Alert !</h4>
      This is a success alert with <a href="#" style="font-weight:700; color:#0c4128">an example link</a>. Give it a click if you like.
    </div>
    ```
    - original
      ```html
      <div class="alert alert-success alert-dismissible fade show">
        <h4 class="alert-heading">Success Alert !</h4>
        This is a success alert with <a href="#" class="alert-link">an example link</a>. Give it a click if you like.
      </div>
      ```

  - 4.x
    ```html
    <div style="position:relative; padding:.75rem 1.25rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.25rem; color:#155724; background-color:#d4edda; border-color:#c3e6cb">
      <h4 style="color:inherit">Success Alert !</h4>
      This is a success alert with <a href="#" style="color:#0b2e13">an example link</a>. Give it a click if you like.
    </div>

    <!-- 5.x color -->
    <div style="position:relative; padding:1rem 1rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.375rem; padding-right:3rem; color:#0f5132; background-color:#d1e7dd; border-color:#badbcc">
      <h4 style="font-size: 1.5rem; color: inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Success Alert !</h4>
      This is a success alert with <a href="#" style="font-weight:700; color:#0c4128">an example link</a>. Give it a click if you like.
    </div>
    ```

  - original
    ```html
    <div class="alert alert-success" role="alert">
      <h4 class="alert-heading">Success Alert !</h4>
      This is a success alert with <a href="#" class="alert-link">an example link</a>. Give it a click if you like.
    </div>
    ```

- danger
  - 5.x
    ```html
    <div style="--bs-alert-bg:transparent;--bs-alert-padding-x:1rem;--bs-alert-padding-y:1rem;--bs-alert-margin-bottom:1rem;--bs-alert-color:inherit;--bs-alert-border-color:transparent;--bs-alert-border:1px solid var(--bs-alert-border-color);--bs-alert-border-radius:0.375rem;position:relative;padding:var(--bs-alert-padding-y) var(--bs-alert-padding-x);margin-bottom:var(--bs-alert-margin-bottom);color:var(--bs-alert-color);background-color:var(--bs-alert-bg);border:var(--bs-alert-border);border-radius:var(--bs-alert-border-radius); padding-right:3rem; --bs-alert-color:#842029;--bs-alert-bg:#f8d7da;--bs-alert-border-color:#f5c2c7">
      <h4 style="color:inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Danger Alert !</h4>
      This is a danger alert with <a href="#" style="font-weight:700; color:#6a1a21">an example link</a>. Give it a click if you like.
    </div>
    ```
    - original
      ```html
      <div class="alert alert-danger alert-dismissible fade show">
        <h4 class="alert-heading">Danger Alert !</h4>
        This is a danger alert with <a href="#" class="alert-link">an example link</a>. Give it a click if you like.
      </div>
      ```

  - 4.x
    ```html
    <div style="position:relative; padding:.75rem 1.25rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.25rem; color:#721c24; background-color:#f8d7da; border-color:#f5c6cb">
      <h4 style="font-size: 1.5rem; color:inherit">Danger Alter !</h4>
      This is a danger alert with <a href="#" style="color:#491217">an example link</a>. Give it a click if you like.
    </div>

    <!-- 5.x color -->
    <div style="position:relative; padding:1rem 1rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.375rem; color:#842029; background-color:#f8d7da; border-color:#f5c2c7">
      <h4 style="font-size: 1.5rem; color:inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Danger Alert !</h4>
      This is a danger alert with <a href="#" style="font-weight:700; color:#6a1a21;">an example link</a>. Give it a click if you like.
    </div>
    ```
    - original
      ```html
      <div class="alert alert-danger" role="alert">
        <h4 class="alert-heading">Danger Alert !</h4>
        This is a danger alert with <a href="#" class="alert-link">an example link</a>. Give it a click if you like.
      </div>
      ```

- primary
  - 5.x
    ```html
    <div style="--bs-alert-bg:transparent;--bs-alert-padding-x:1rem;--bs-alert-padding-y:1rem;--bs-alert-margin-bottom:1rem;--bs-alert-color:inherit;--bs-alert-border-color:transparent;--bs-alert-border:1px solid var(--bs-alert-border-color);--bs-alert-border-radius:0.375rem;position:relative;padding:var(--bs-alert-padding-y) var(--bs-alert-padding-x);margin-bottom:var(--bs-alert-margin-bottom);color:var(--bs-alert-color);background-color:var(--bs-alert-bg);border:var(--bs-alert-border);border-radius:var(--bs-alert-border-radius); padding-right:3rem; --bs-alert-color:#084298;--bs-alert-bg:#cfe2ff;--bs-alert-border-color:#b6d4fe">
      <h4 style="color:inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Primary Alert !</h4>
      This is a primary alert with <a href="#" style="font-weight:700; color:#06357a">an example link</a>. Give it a click if you like.
    </div>
    ```
    - original
      ```html
      <div class="alert alert-primary alert-dismissible fade show">
        <h4 class="alert-heading">Primary Alert !</h4>
        This is a primary alert with <a href="#" class="alert-link">an example link</a>. Give it a click if you like.
      </div>
      ```

  - 4.x
    ```html
    <div style="position:relative; padding:.75rem 1.25rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.25rem; color:#004085; background-color:#cce5ff; border-color:#b8daff">
      <h4 style="font-size: 1.5rem; color:inherit">Primary Alert !</h4>
      This is a primary alert with <a href="#" style="color:#002752">an example link</a>. Give it a click if you like.
    </div>

    <!-- 5.x color -->
    <div style="position:relative; padding:1rem 1rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.375rem; padding-right:3rem; color:#084298; background-color:#cfe2ff; border-color:#b6d4fe">
      <h4 style="font-size: 1.5rem; color:inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Primary Alert !</h4>
      This is a primary alert with <a href="#" style="font-weight:700; color:#06357a">an example link</a>. Give it a click if you like.
    </div>
    ```
    - original
      ```html
      <div class="alert alert-primary" role="alert">
        <h4 class="alert-heading">Primary Alert !</h4>
        This is a primary alert with <a href="#" class="alert-link">an example link</a>. Give it a click if you like.
      </div>
      ```

- info
  - 5.x
    ```html
    <div style="--bs-alert-bg:transparent;--bs-alert-padding-x:1rem;--bs-alert-padding-y:1rem;--bs-alert-margin-bottom:1rem;--bs-alert-color:inherit;--bs-alert-border-color:transparent;--bs-alert-border:1px solid var(--bs-alert-border-color);--bs-alert-border-radius:0.375rem;position:relative;padding:var(--bs-alert-padding-y) var(--bs-alert-padding-x);margin-bottom:var(--bs-alert-margin-bottom);color:var(--bs-alert-color);background-color:var(--bs-alert-bg);border:var(--bs-alert-border);border-radius:var(--bs-alert-border-radius); padding-right:3rem; --bs-alert-color:#055160;--bs-alert-bg:#cff4fc;--bs-alert-border-color:#b6effb">
      <h4 style="color:inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Info Alert !</h4>
      This is a info alert with <a href="#" style="font-weight:700; color:#04414d">an example link</a>. Give it a click if you like.
    </div>
    ```
    - original
      ```html
      <div class="alert alert-info alert-dismissible fade show">
        <h4 class="alert-heading">Info Alert !</h4>
        This is a info alert with <a href="#" class="alert-link">an example link</a>. Give it a click if you like.
      </div>
      ```

  - 4.x
    ```html
    <div style="position:relative; padding:.75rem 1.25rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.25rem; color:#0c5460;background-color:#d1ecf1;border-color:#bee5eb">
      <h4 style="font-size: 1.5rem; color:inherit">Info Alter !</h4>
      This is a info alert with <a href="#" style="color:#062c33">an example link</a>. Give it a click if you like.
    </div>

    <!-- 4.x style 5.x color -->
    <div style="position:relative; padding:1rem 1rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.375rem; padding-right:3rem; color:#055160; background-color:#cff4fc; border-color:#b6effb">
      <h4 style="font-size: 1.5rem; color:inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Info Alert !</h4>
      This is a info alert with <a href="#" style="font-weight:700; color:#04414d">an example link</a>. Give it a click if you like.
    </div>
    ```
    - original
      ```html
      <div class="alert alert-info" role="alert">
        <h4 class="alert-heading">Info Alert !</h4>
        This is a info alert with <a href="#" class="alert-link">an example link</a>. Give it a click if you like.
      </div>
      ```


#### callout

{% hint style='tip' %}
> references:
> - ["Bootstrap Calllouts"](https://bootsnipp.com/snippets/yNK5E)
> - [Bootstrap Callouts](https://codepen.io/superjaberwocky/pen/rLKxOa)
> - [mikeblum/callout.css](https://gist.github.com/mikeblum/aaffe654fc4f5a74c3b8b313fb43b2eb)
> - [docs.min.css](https://getbootstrap.com/docs/4.0/assets/css/docs.min.css)
> - [Callouts](https://rdmd.readme.io/docs/callouts)
> - [How TO - Callout Message](https://www.w3schools.com/HOWTO/howto_js_callout.asp)
{% endhint %}



<!--sec data-title="callout css" data-id="section3" data-show=true data-collapse=true ces-->
> ```css
> .bd-callout { padding: 1.25rem; margin-top: 1.25rem; margin-bottom: 1.25rem; border: 1px solid #eee; border-left-width: .25rem; border-radius: .25rem }
> .bd-callout h4 { margin-top: 0; margin-bottom: .25rem }
>
> .bd-callout p:last-child { margin-bottom: 0 }
> .bd-callout code { border-radius: .25rem }
> .bd-callout+.bd-callout { margin-top: -.25rem }
>
> .bd-callout-info { border-left-color: #5bc0de }
> .bd-callout-info h4 { color: #5bc0de }
>
> .bd-callout-warning { border-left-color: #f0ad4e }
> .bd-callout-warning h4 { color: #f0ad4e }
>
> .bd-callout-danger { border-left-color: #d9534f }
> .bd-callout-danger h4 { color: #d9534f }
>
> .bd-callout-primary{ border-left-color: #007bff }
> .bd-callout-primary h4 { color: #007bff }
>
> .bd-callout-success{ border-left-color: #28a745 }
> .bd-callout-success h4 { color: #28a745 }
>
> .bd-callout-default{ border-left-color: #6c757d }
> .bd-callout-default h4 { color: #6c757d }
> ```
<!--endsec-->

- default
  ```html
  <div style="display: block; padding: 1.25rem; margin-top: 1.25rem; margin-bottom: 1.25rem; border: 1px solid #eee; border-left-width: 0.25rem; border-radius: 0.25rem; border-left-color: #6c757d;">
    <h4 style="margin-top: 0; margin-bottom: 0.25rem; color: #6c757d;">Default Callout</h4>
    This is a default callout.
  </div>
  ```
  - original
    ```html
    <div class="bd-callout bd-callout-default">
      <h4>Default Callout</h4>
      This is a default callout.
    </div>
    ```

- primary
  ```html
  <div style="display: block; padding: 1.25rem; margin-top: 1.25rem; margin-bottom: 1.25rem; border: 1px solid #eee; border-left-width: .25rem; border-radius: .25rem; border-left-color: #007bff">
    <h4 style="margin-top: 0; margin-bottom: 0.25rem; color: #007bff">Primary Callout</h4>
    This is a primary callout.
  </div>
  ```
  - original
    ```html
    <div class="bd-callout bd-callout-primary">
      <h4>Primary Callout</h4>
      This is a primary callout.
    </div>
    ```

- warning
  ```html
  <div style="display: block; padding: 1.25rem; margin-top: 1.25rem; margin-bottom: 1.25rem; border: 1px solid #eee; border-left-width: .25rem; border-radius: .25rem; border-left-color: #f0ad4e">
    <h4 style="margin-top: 0; margin-bottom: 0.25rem; color: #f0ad4e">Warning Callout</h4>
    This is a warning callout.
  </div>
  ```
  - original
    ```html
    <div class="bd-callout bd-callout-warning">
      <h4>Warning Callout</h4>
      This is a warning callout.
    </div>
    ```

- danger
  ```html
  <div style="display: block; padding: 1.25rem; margin-top: 1.25rem; margin-bottom: 1.25rem; border: 1px solid #eee; border-left-width: .25rem; border-radius: .25rem; border-left-color: #d9534f">
    <h4 style="margin-top: 0; margin-bottom: 0.25rem; color: #d9534f">Danger Callout</h4>
    This is a danger callout.
  </div>
  ```
  - original
    ```html
    <div class="bd-callout bd-callout-danger">
      <h4>Danger Callout</h4>
      This is a danger callout.
    </div>
    ```

- succeed
  ```html
  <div style="display: block; padding: 1.25rem; margin-top: 1.25rem; margin-bottom: 1.25rem; border: 1px solid #eee; border-left-width: .25rem; border-radius: .25rem; border-left-color: #28a745">
    <h4 style="margin-top: 0; margin-bottom: 0.25rem; color: #28a745">Succeed Callout</h4>
    This is a succeed callout.
  </div>
  ```
  - original
    ```html
    <div class="bd-callout bd-callout-success">
      <h4>Success Callout</h4>
      This is a success callout.
    </div>
    ```

- info
  ```html
  <div style="display: block; padding: 1.25rem; margin-top: 1.25rem; margin-bottom: 1.25rem; border: 1px solid #eee; border-left-width: .25rem; border-radius: .25rem; border-left-color: #5bc0de">
    <h4 style="margin-top: 0; margin-bottom: 0.25rem; color: #5bc0de">Info Callout</h4>
    This is info callout.
  </div>
  ```
  - original
    ```html
    <div class="bd-callout bd-callout-info">
      <h4>Info Callout</h4>
      This is an info callout.
    </div>
    ```


## crumb issuer

{% hint style='tip' %}
> more info:
> - [CSRF Protection Explained](https://support.cloudbees.com/hc/en-us/articles/219257077-CSRF-Protection-Explained)
> - [Improved CSRF protection](https://jenkins.io/redirect/crumb-cannot-be-used-for-script)
> - [CSRF Protection](https://www.jenkins.io/doc/book/using/remote-access-api/#RemoteaccessAPI-CSRFProtection)
> - [Remote Access API](https://www.jenkins.io/doc/book/using/remote-access-api/)
> - [Jenkins REST API example using crumb](https://gist.github.com/dasgoll/455522f09cb963872f64e23bb58804b2)
> - [About the Jenkins infrastructure project](https://www.jenkins.io/projects/infrastructure/#jenkins)
> - [jenkins on jenkins](https://github.com/jenkins-infra/documentation/blob/main/ci.adoc#jenkins-on-jenkins)
> - [ci.jenkins.io](https://ci.jenkins.io/)
>   - [azure.ci.jenkins.io.yaml](https://github.com/jenkins-infra/jenkins-infra/blob/production/hieradata/clients/azure.ci.jenkins.io.yaml)
>   - [trusted-ci.yaml](https://github.com/jenkins-infra/jenkins-infra/blob/production/hieradata/clients/trusted-ci.yaml)
{% endhint %}


### get crumb

{% hint style='tip' %}
> [`jq` for multiple values](https://github.com/stedolan/jq/issues/785#issuecomment-101475408) and [another answer](https://github.com/stedolan/jq/issues/785#issuecomment-101842421)
{% endhint %}

- via groovy script
  ```groovy
  import hudson.security.csrf.DefaultCrumbIssuer

  DefaultCrumbIssuer issuer = jenkins.model.Jenkins.instance.crumbIssuer
  jenkinsCrumb = "${issuer.crumbRequestField}:${issuer.crumb}"
  ```
  - result
    ```groovy
    println jenkinsCrumb
    Jenkins-Crumb:7248f4a5***********
    ```

- via curl
  ```bash
  $ domain='jenkins.marslo.com'
  $ COOKIEJAR="$(mktemp)"
  $ curl -s \
         --cookie-jar "${COOKIEJAR} \
         https://${domain}/crumbIssuer/api/json |
         jq -r '[.crumbRequestField, .crumb] | "\(.[0]):\(.[1])"'
  Jenkins-Crumb:8b87b6ed98ef923******
  ```
  - or [imarslo: json cheatsheet](../cheatsheet/character/json.html#join)
    ```bash
    $ domain='jenkins.marslo.com'
    $ COOKIEJAR="$(mktemp)"
    $ curl -sSLg \
           --cookie-jar "${COOKIEJAR} \
           https://${domain}/crumbIssuer/api/json |
           jq -r '.crumbRequestField + ":" + .crumb'
    ```

  - [or](https://github.com/stedolan/jq/issues/785#issuecomment-574836419)
    ```bash
    $ COOKIEJAR="$(mktemp)"
    $ curl -s \
           --cookie-jar "${COOKIEJAR} \
           http://jenkins.marslo.com/crumbIssuer/api/json |
           jq -r '[.crumbRequestField, .crumb] | join(":")'
    ```

  - [or via xml](https://www.bbsmax.com/A/x9J2bBxgJ6/)
    ```bash
    $ COOKIEJAR="$(mktemp)"
    $ curl -sSLg \
           --cookie-jar "${COOKIEJAR} \
           "http://${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)"
    Jenkins-Crumb:8b87b6ed98ef923******
    ```

- via web page
  ![jenkins crumb](../screenshot/jenkins/jenkins-crumb.png)

- [via wget](https://support.cloudbees.com/hc/en-us/articles/219257077-CSRF-Protection-Explained?mobile_site=false#usingwget)
  - after jenkins [`2.176.2`](https://www.jenkins.io/security/advisory/2019-07-17/#SECURITY-626)
    ```bash
    # via xml api
    $ COOKIEJAR="$(mktemp)"
    $ wget --user=admin \
           --password=admin \
           --auth-no-challenge \
           --save-cookies "${COOKIEJAR}" \
           --keep-session-cookies \
           -q \
           --output-document \
           - \
           "https://localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")"

    # via json api
    $ COOKIEJAR="$(mktemp)"
    $ wget --user=admin \
           --password=admin \
           --auth-no-challenge \
           --save-cookies "${COOKIEJAR}" \
           --keep-session-cookies \
           -q \
           --output-document \
           - \
           'https://jenkins.marslo.com/crumbIssuer/api/json' |
           jq -r '[.crumbRequestField, .crumb] | join(":")'
    ```

  - before jenkins [`2.176.2`](https://www.jenkins.io/security/advisory/2019-07-17/#SECURITY-626)
    ```bash
    # via xml
    $ wget --user=admin \
           --password=admin \
           --auth-no-challenge \
           -q \
           --output-document \
           - \
           'http://localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'

    # via json
    $ wget --user=admin \
           --password=admin \
           --auth-no-challenge \
           -q \
           --output-document \
           - \
           'https://jenkins.marslo.com/crumbIssuer/api/json' |
           jq -r '[.crumbRequestField, .crumb] | join(":")'
    ```

### visit API via crumb

{% hint style='tip' %}
**@Current after [`2.176.2`](https://www.jenkins.io/security/advisory/2019-07-17/#SECURITY-626)**
```bash
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:admin" \
             --cookie-jar "${COOKIEJAR}" \
             'https://jenkins.marslo.com/crumbIssuer/api/json' |
             jq -r '[.crumbRequestField, .crumb] | join(":")'
      )
```

@Dprecated before jenkins `2.176.2`
```bash
url='http://jenkins.marslo.com'

CRUMB="$(curl -sSLg ${url}/crumbIssuer/api/json |
         jq -r .crumb \
       )"
CRUMB="Jenkins-Crumb:${CRUMB}"

# or
CRUMB="$(curl -s ${url}/crumbIssuer/api/json |
         jq -r '.crumbRequestField + ":" + .crumb' \
       )"

```
{% endhint %}

```bash
$ COOKIEJAR="$(mktemp)"
$ CRUMB=$(curl -u "admin:admin" \
             --cookie-jar "${COOKIEJAR}" \
             'https://jenkins.marslo.com/crumbIssuer/api/json' |
             jq -r '[.crumbRequestField, .crumb] | join(":")'
       )
$ curl -H "${CRUMB}" \
          -d 'cities=Lanzhou' \
          http://jenkins.marslo.com/job/marslo/job/sandbox/buildWithParameters
```
- or
  ```bash
  $ domain='jenkins.marslo.com'
  $ url="https://${domain}"
  $ COOKIEJAR="$(mktemp)"
  $ curl -H "$(curl -s \
                    --cookie-jar "${COOKIEJAR}" \
                    ${url}/crumbIssuer/api/json |
                    jq -r '.crumbRequestField + ":" + .crumb' \
              )" \
            -d 'cities=Lanzhou' \
            ${url}/job/marslo/job/sandbox/buildWithParameters
  ```

- [or](https://www.jenkins.io/doc/book/using/remote-access-api/#RemoteaccessAPI-Submittingjobs)
  ```bash
  $ curl -H "Jenkins-Crumb:${CRUMB}" \
            --data 'cities=Leshan,Chengdu' \
            --data 'provinces=Sichuan' \
            http://jenkins.marslo.com/job/marslo/job/sandbox/buildWithParameters
  ```

- or
  ```bash
  $ domain='jenkins.marslo.com'
  $ url="https://${domain}"
  $ curl -H "$(curl -s ${url}/crumbIssuer/api/json | jq -r '.crumbRequestField + ":" + .crumb')" \
            --data 'cities=Leshan,Chengdu' \
            --data 'provinces=Sichuan' \
            ${url}/job/marslo/job/sandbox/buildWithParameters
  ```

#### [build a job using the REST API and cURL](https://support.cloudbees.com/hc/en-us/articles/218889337-How-to-build-a-job-using-the-REST-API-and-cURL-)
```bash
$ curl -X POST http://developer:developer@localhost:8080/job/test/build
# build with parameters
$ curl -X POST \
          http://developer:developer@localhost:8080/job/test/build \
          --data-urlencode json='{"parameter": [{"name":"paramA", "value":"123"}]}'
```

### [restart Jenkins instance](https://support.cloudbees.com/hc/en-us/articles/216118748-How-to-Start-Stop-or-Restart-your-Instance-)

{% hint style='tip' %}
**@Current after [`2.176.2`](https://www.jenkins.io/security/advisory/2019-07-17/#SECURITY-626)**
```bash
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:admin" \
             --cookie-jar "${COOKIEJAR}" \
             'https://jenkins.marslo.com/crumbIssuer/api/json' |
             jq -r '[.crumbRequestField, .crumb] | join(":")'
      )
```

@Dprecated before jenkins `2.176.2`
```bash
CRUMB="$(curl -sSLg http://jenkins.marslo.com/crumbIssuer/api/json |
         jq -r .crumb \
      )"
CRUMB="Jenkins-Crumb:${CRUMB}"
# or
CRUMB="$(curl -s ${url}/crumbIssuer/api/json |
         jq -r '.crumbRequestField + ":" + .crumb' \
      )"
```
{% endhint %}

```bash
$ curl -X POST \
       -H "${CRUMB}" \
       http://jenkins.marslo.com/safeRestart
```
- or
  ```bash
  $ domain='jenkins.marslo.com'
  $ url="https://${domain}"
  $ COOKIEJAR="$(mktemp)"
  $ curl -X POST \
         -H "$(curl -s \
                    --cookie-jar "${COOKIEJAR}" \
                    ${url}/crumbIssuer/api/json |
                    jq -r '.crumbRequestField + ":" + .crumb' \
            )" \
         ${url}/safeRestart
  ```

## run Jenkins

{% hint style='tip' %}
> refernce:
> - [Jenkins Features Controlled with System Properties](https://www.jenkins.io/doc/book/managing/system-properties/)
> - [-Dhudson.security.ArtifactsPermission=true](https://github.com/jenkinsci/docker/issues/202#issuecomment-244321911)
> - [remoting configuration](https://github.com/jenkinsci/remoting/blob/master/docs/configuration.md)
> - [IMPORTANT JENKINS COMMAND](https://rajeevtechblog.wordpress.com/2018/09/28/important-jenkins-command/)
{% endhint %}

### in docker
```bash
$ docker run \
         --name jenkins \
         --rm \
         --detach   \
         --network jenkins \
         --env DOCKER_HOST=tcp://docker:2376   \
         --env DOCKER_CERT_PATH=/certs/client \
         --env DOCKER_TLS_VERIFY=1   \
         --publish 8080:8080 \
         --publish 50000:50000   \
         --volume jenkins-data:/var/jenkins_home   \
         --volume jenkins-docker-certs:/certs/client:ro   \
         jenkins/jenkins:latest
```

- docker run with `JAVA_OPTS`

  {% hint style='tip' %}
  > more on [Properties in Jenkins Core for `JAVA_OPTS`](config/config.html#properties-in-jenkins-core-for-javaopts)
  > - [encoding](https://stackoverflow.com/a/60419856/2940319)
  > - [How locale setting can break unicode/UTF-8 in Java/Tomcat](https://www.jvmhost.com/articles/locale-breaks-unicode-utf-8-java-tomcat/)
  {% endhint %}

  ```bash
  $ docker run \
           --name jenkins \
           --detach   \
           --rm \
           --network jenkins \
           --env DOCKER_HOST=tcp://docker:2376   \
           --env DOCKER_CERT_PATH=/certs/client \
           --env DOCKER_TLS_VERIFY=1   \
           --publish 8080:8080 \
           --publish 50000:50000   \
           --env JENKINS_ADMIN_ID=admin \
           --env JENKINS_ADMIN_PW=admin \
           --env JAVA_OPTS=" \
                  -XX:+UseG1GC \
                  -Xms8G  \
                  -Xmx16G \
                  -Dfile.encoding=UTF-8 \
                  -Dsun.jnu.encoding=utf-8 \
                  -DsessionTimeout=1440 \
                  -DsessionEviction=43200 \
                  -Djava.awt.headless=true \
                  -Djenkins.ui.refresh=true \
                  -Divy.message.logger.level=4 \
                  -Dhudson.Main.development=true \
                  -Duser.timezone='Asia/Chongqing' \
                  -Dgroovy.grape.report.downloads=true \
                  -Djenkins.install.runSetupWizard=true \
                  -Dpermissive-script-security.enabled=true \
                  -Dhudson.footerURL=https://jenkins.marslo.com \
                  -Djenkins.slaves.NioChannelSelector.disabled=true \
                  -Djenkins.slaves.JnlpSlaveAgentProtocol3.enabled=false \
                  -Dhudson.model.ParametersAction.keepUndefinedParameters=true \
                  -Djenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST=true \
                  -Dhudson.security.ArtifactsPermission=true \
                  -Dhudson.security.LDAPSecurityRealm.groupSearch=true \
                  -Dhudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID=true \
                  -Dcom.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors=true \
                  -Dhudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps=false \
                  -Dhudson.model.DirectoryBrowserSupport.CSP=\"sandbox allow-same-origin allow-scripts; default-src 'self'; script-src * 'unsafe-eval'; img-src *; style-src * 'unsafe-inline'; font-src *;\" \
                " \
           --env JNLP_PROTOCOL_OPTS="-Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false" \
           --volume /opt/JENKINS_HOME:/var/jenkins_home \
           --volume /var/run/docker.sock:/var/run/docker.sock \
           jenkins/jenkins:latest
  ```

### in kubernetes

{% hint style='tip' %}
> reference:
> - [official yaml](https://github.com/jenkinsci/kubernetes-plugin/blob/master/src/main/kubernetes/jenkins.yml)
> - [official sa yaml](https://github.com/jenkinsci/kubernetes-plugin/blob/master/src/main/kubernetes/service-account.yml)
{% endhint %}

```bash
$ cat << EOF | kubectl apply -f -
# namespace
---
kind: Namespace
apiVersion: v1
metadata:
  name: devops
  labels:
    name: devops

# quota
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: quota
  namespace: devops
spec:
  hard:
    requests.cpu: "48"
    requests.memory: 48Gi
    limits.cpu: "48"
    limits.memory: 48Gi

# sa
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: jenkins
  name: jenkins-admin
  namespace: devops
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: jenkins-admin
  labels:
    k8s-app: jenkins
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: jenkins-admin
  namespace: devops

# pv & pvc
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: jenkins-pv
spec:
  capacity:
    storage: 200Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 1.2.3.4
    path: "/jenkins_vol/jenkins/DEVOPS_JENKINS"
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: jenkins-pvc
  namespace: devops
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 100Gi
  storageClassName: ""
  volumeName: jenkins-pv

# deploy
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins
  namespace: devops
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                - aws-hostname-01
                - aws-hostname-02
      containers:
        - name: jenkins
          image: jenkins/jenkins:latest
          imagePullPolicy: IfNotPresent
          env:
            - name: JAVA_OPTS
              value: -Xms2048m
                     -Xmx10240m
                     -XX:PermSize=2048m
                     -XX:MaxPermSize=10240m
                     -DsessionTimeout=1440
                     -DsessionEviction=43200
                     -Djava.awt.headless=true
                     -Divy.message.logger.level=4
                     -Dfile.encoding=UTF-8
                     -Dsun.jnu.encoding=utf-8
                     -Duser.timezone='Asia/Chongqing'
                     -Djenkins.install.runSetupWizard=true
                     -Dpermissive-script-security.enabled=true
                     -Djenkins.slaves.NioChannelSelector.disabled=true
                     -Djenkins.slaves.JnlpSlaveAgentProtocol3.enabled=false
                     -Djenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST=true
                     -Dhudson.model.ParametersAction.keepUndefinedParameters=true
                     -Dcom.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors=true
                     -Dhudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps=false
                     -Dhudson.model.DirectoryBrowserSupport.CSP="sandbox allow-same-origin allow-scripts; default-src 'self'; script-src * 'unsafe-eval'; img-src *; style-src * 'unsafe-inline'; font-src *;"
            - name: JNLP_PROTOCOL_OPTS
              value: -Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false
          ports:
            - name: http-port
              containerPort: 8080
            - name: jnlp-port
              containerPort: 50000
            - name: cli-port
              containerPort: 38338
          volumeMounts:
            - name: jenkins-home
              mountPath: /var/jenkins_home
          resources:
            requests:
              memory: '8Gi'
              cpu: '8'
            limits:
              memory: '16Gi'
              cpu: '16'
      volumes:
        - name: jenkins-home
          persistentVolumeClaim:
            claimName: jenkins-pvc
      serviceAccount: "jenkins-admin"

# svc
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins
  namespace: devops
spec:
  template:
    metadata:
      labels:
        name: jenkins
spec:
  type: ClusterIP
  ports:
    - name: jenkins
      port: 8080
      targetPort: 8080
  selector:
    app: jenkins
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-discovery
  namespace: devops
spec:
  template:
    metadata:
      labels:
        name: jenkins-discovery
spec:
  type: NodePort
  ports:
    - name: jenkins-agent
      port: 50000
      targetPort: 50000
    - name: cli-agent
      port: 38338
      targetPort: 38338
  selector:
    app: jenkins

# ing (for traefik ingress)
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: jenkins
  namespace: devops
  annotations:
    kubernetes.io/ingress.class: traefik
    ingress.kubernetes.io/whitelist-x-forwarded-for: "false"
    traefik.frontend.redirect.entryPoint: https
    ingress.kubernetes.io/ssl-redirect: "true"
  labels:
    app: jenkins
spec:
  rules:
  - host: jenkins.mysite.com
    http:
      paths:
      - backend:
          serviceName: jenkins
          servicePort: 8080
  tls:
  - hosts:
    - jenkins.mysite.com
    secretName: mysite-tls
EOF
```

- for nginx ingress
  ```bash
  ---
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    name: jenkins
    namespace: devops
    annotations:
      kubernetes.io/ingress.class: "nginx"
      nginx.ingress.kubernetes.io/secure-backends: "true"
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
      kubernetes.io/ingress.allow-http: "false"
  spec:
    tls:
    - hosts:
      - jenkins.mysite.com
      secretName: mysite-certs
    rules:
    - host: jenkins.mysite.com
      http:
        paths:
        - path:
          backend:
            serviceName: jenkins
            servicePort: 8080
  ```
