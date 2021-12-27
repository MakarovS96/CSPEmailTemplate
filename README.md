## intersystems-objectscript-template
This is a template for InterSystems ObjectScript Github repository.
The template goes also with a few files which let you immedietly compile your ObjecScript files in InterSystems IRIS Community Edition in a docker container

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/intersystems-community/objectscript-docker-template.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Test it

Check digest generation:

[http://localhost:61173/templates/digest.csp?week=47&year=2021](http://localhost:61173/templates/digest.csp?week=47&year=2021)

Open IRIS terminal:
``` 
$ docker-compose exec iris iris session iris
```
Or open WebTerminal (preinstalled)

Configure SMPT server

```objectscript
USER>set sc = ##class(dc.ExampleClass).ConfgureSMTP("{SMTP_Username}", "{SMTP_Password}", "{From}", "{To}", "{SMTP_Server}", "{Port}")
```
   
**SMTP_Username** - Your username on SMTP server. *Requireq*   
**SMTP_Password** - Your password on SMTP server. *Requireq*   
**From** - Your email. *Requireq*   
**To** - Recipient email. *Requireq*   
**SMTP_Server** - SMTP server domain. *Requireq*
**Port** - SMTP Port. *Default: 465*

Send Test Email

```objectscript
USER>set sc = ##class(dc.ExampleClass).SendEmail()
```

Result
