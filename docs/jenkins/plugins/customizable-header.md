<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [system messages](#system-messages)
- [jcasc](#jcasc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> [!NOTE|label:references:]
> - [Customizable Header](https://plugins.jenkins.io/customizable-header/)

## system messages

> [!NOTE|label:references]
> - [CSS Gradient](https://cssgradient.io/)
> - [show all gradients](https://uigradients.com/#SummerDog)
> - [CSS Gradient Generator](https://www.colorzilla.com/gradient-editor/)
> - [RGBA to RGB converter](https://borderleft.com/toolbox/rgba/)

- `linear-gradient(135deg, #92FFC0 10%, #002661 100%);` | `#2a647c`
- `linear-gradient(90deg, rgba(72,97,91,1) 27%, rgba(131,148,97,1) 100%);` | `#48615b`
- `linear-gradient(90deg, rgba(100,145,115,1) 0%, rgba(219,213,164,1) 100%);` | `#a8b88f`
- `linear-gradient(90deg, rgba(49,71,85,1) 0%, rgba(38,160,218,1) 100%);` | `#2b7aa1`
- `linear-gradient(90deg, rgba(21,153,87,1) 0%, rgba(21,87,153,1) 100%);` | `#156a86`
- `linear-gradient(90deg, rgba(0,129,109,1) 0%, rgba(255,175,1,1) 100%);` | `#00816D`
- `linear-gradient(90deg, rgba(247,157,0,1) 0%, rgba(100,243,140,1) 100%);` | `#8EDA64`
- `linear-gradient(90deg, rgba(241,242,181,1) 0%, rgba(19,80,88,1) 100%);` | `#527E73`
- `linear-gradient(90deg, rgba(0,114,206,1) 0%, rgba(0,199,177,1) 100%);` | `#0072ce`
- `linear-gradient(90deg, rgba(255,78,80,1) 0%, rgba(249,212,35,1) 100%);` | `#fbae30` | [DanceToForget](https://uigradients.com/#DanceToForget)
- `linear-gradient(90deg, rgba(192,36,37,1) 0%, rgba(240,203,53,1) 100%);` | `#e29b30` | [BacktotheFuture](https://uigradients.com/#BacktotheFuture)
- `linear-gradient(90deg, rgba(253,200,48,1) 0%, rgba(243,115,53,1) 100%);` | `#f79733` | [CitrusPeel](https://uigradients.com/#CitrusPeel)
- `linear-gradient(90deg, rgba(0,65,106,1) 0%, rgba(121,159,12,1) 50%, rgba(255,224,0,1) 100%);` | `#b2bb07` | [Earthly](https://uigradients.com/#Earthly)
- `linear-gradient( 91deg,  rgba(72,154,78,1) 5.2%, rgba(251,206,70,1) 95.9% );`
- `radial-gradient( circle farthest-corner at 10% 20%,  rgba(91,140,245,1) 0%, rgba(240,131,252,1) 79.4% );`
- `linear-gradient( 129.1deg,  rgba(243,199,83,1) 26.8%, rgba(18,235,207,1) 114.1% );`
- `linear-gradient( 65.9deg,  rgba(85,228,224,1) 5.5%, rgba(75,68,224,0.74) 54.2%, rgba(64,198,238,1) 55.2%, rgba(177,36,224,1) 98.4% );`
- `linear-gradient(90deg, #FDBB2D 0%, #22C1C3 100%);` | [Retro Wagon](https://cssgradient.io/swatches/)
- `linear-gradient( 90deg,  rgba(226,66,249,0.94) 10.2%, rgba(79,147,249,1) 77.3% );`
- `radial-gradient( circle farthest-corner at 10% 20%,  rgba(171,102,255,1) 0%, rgba(116,182,247,1) 90% );`

## jcasc
```yaml
appearance:
  customHeader:
    enabled: true
    header: "logo"
    headerColor:
      backgroundColor: "linear-gradient(135deg, #92FFC0 10%, #002661 100%);"
      color: "white"
      hoverColor: "#2a647c"
    logo:
      svg:
        logoPath: "https://artifactory.sample.com/artifactory/devops/jenkins/icon/header/logo-vert-padded-square-BLACK.svg"
    logoText: "DevOps Dev Jenkins"
    systemMessages:
    - level: danger
      message: "DevOps Dev Jenkins -- the development environment, will be extremely unstable and restarted often"
    thinHeader: false
```
