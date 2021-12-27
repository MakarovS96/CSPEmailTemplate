Class dc.ExampleClass
{

ClassMethod ConfgureSMTP(Username As %String, Password As %String, From As %String, To As %String, ServerDomain As %String, Port As %Integer = 465) As %Status
{
        set sc = $$$OK

        set ns = $NAMESPACE
        #dim $NAMESPACE = "%SYS"

        set prop("Protocols") = 24
        set sc = ##class(Security.SSLConfigs).Create("smtptest", .prop)
        return:$$$ISERR(sc) sc

        set $NAMESPACE = ns

        set ^conf("username") = Username
        set ^conf("password") = Password
        set ^conf("from") = From
        set ^conf("to") = To
        set ^conf("serverdomain") = ServerDomain
        set ^conf("port") = Port

        return sc
}

ClassMethod GetConf(Property As %String) As %String [ CodeMode = expression ]
{
$get(^conf($zcvt(Property, "l")), "")
}

ClassMethod SendEmail() As %Status
{
    set sc = $$$OK

    set Username = ..GetConf("Username")
    set Password = ..GetConf("Password")
    set From = ..GetConf("From")
    set To = ..GetConf("To")
    set ServerDomain = ..GetConf("ServerDomain")
    set Port = ..GetConf("Port")

    for str = Username, Password, From, To, ServerDomain{
        return:(str="") $$$ERROR(5001, "Please fill configuration using ""ConfgureSMTP"" func")
    }

    set auth = ##class(%Net.Authenticator).%New()
    set auth.UserName = Username
    set auth.Password = Password

    set s = ##class(%Net.SMTP).%New()                                                                         
    set s.smtpserver = ServerDomain                                                   
    set s.SSLConfiguration = "smtptest"                                                                       
    set s.authenticator = auth                                        
    set s.port = Port                       

    set m = ##class(%Net.MailMessage).%New()
    set m.From = From
    do m.To.Insert(To)
    set m.Subject = "Test Digest CSPEmailTemplate"
    set m.Charset = "UTF-8"
    set m.IsHTML = 1

    set result = ..GetEmailFromTemplate(.sc)
    return:$$$ISERR(sc) sc

    do m.TextData.Write(result)
    set sc = s.Send(m)

    return sc
}

ClassMethod GetEmailFromTemplate(Output sc As %Status) As %String
{
        set sc = $$$OK

	    set req = ##class(%Net.HttpRequest).%New()
        do req.SetParam("year", 2021)
        do req.SetParam("week", 47)
        set sc = req.Get("http://localhost:52773/templates/digest.csp")

        if ($$$ISERR(sc)) {
            return ""
        }

        if (req.HttpResponse.StatusCode = 400) {
            set sc = $$$ERROR(5001, "Empty Digest")
            return ""
        }

        if (req.HttpResponse.StatusCode '= 200) {
            set sc = $$$ERROR(5001, req.HttpResponse.StatusCode_": "_req.HttpResponse.StatusLine)
            return ""
        }

        set result = $zcvt(req.HttpResponse.Data.Read(3641144), "I", "UTF8")

	    return result
}

ClassMethod getDigestData(week, year) As %DynamicObject
{
        if (week '= 47) || (year '= 2021) {
            set res = [{"id":"1","name":"Applications","items":[],"count":0},{"name":"Releases","id":"2","items":[],"count":0}]
            return res
        }

        set res = [
            {
                "id": "1",
                "name": "Applications",
                "items": [
                    {
                        "solName": "API Security Mediator",
                        "solLink": "https://openexchange.intersystems.com/package/API-Security-Mediator",
                        "shortDesc": "InterSystems IRIS Declarative Security Rules for REST APIs",
                        "pubName": "Visum Consult",
                        "pubLink": "https://partner.intersystems.com/company/Visum-Consult"
                    },
                    {
                        "solName": "Audit Mediator",
                        "solLink": "https://openexchange.intersystems.com/package/Audit-Mediator",
                        "shortDesc": "Object Script mediator to audit ObjectScript REST API requests",
                        "pubName": "Visum Consult",
                        "pubLink": "https://partner.intersystems.com/company/Visum-Consult"
                    },
                    {
                        "solName": "passwords-tool",
                        "solLink": "https://openexchange.intersystems.com/package/passwords-tool",
                        "shortDesc": "Generating secure passwords and check strength of passwords",
                        "pubName": "CaretDev",
                        "pubLink": "https://partner.intersystems.com/company/CaretDev"
                    },
                    {
                        "solName": "appmsw-dbdeploy",
                        "solLink": "https://openexchange.intersystems.com/package/appmsw-dbdeploy",
                        "shortDesc": "An example of deploying solutions with prepared databases, even without source code.",
                        "pubName": "Sergey Mikhailenko",
                        "pubLink": "https://openexchange.intersystems.com/user/Sergey%20Mikhailenko/vmRZMGWcu4CDVwK0ZcLA1S1R1XA"
                    },
                    {
                        "solName": "iris-disguise",
                        "solLink": "https://openexchange.intersystems.com/package/iris-disguise",
                        "shortDesc": "Data Anonymization tool for InterSystems IRIS",
                        "pubName": "Henry Hamon Pereira",
                        "pubLink": "https://openexchange.intersystems.com/user/Henry%20Hamon%20Pereira/wq1IdSjT39T5KZ5LgDh3uwi08sY"
                    },
                    {
                        "solName": "iris-saml-example",
                        "solLink": "https://openexchange.intersystems.com/package/iris-saml-example-1",
                        "shortDesc": "InterSystems IRIS - SAML Authentication Test",
                        "pubName": "CaretDev",
                        "pubLink": "https://partner.intersystems.com/company/CaretDev"
                    },
                    {
                        "solName": "Server Manager 3.0 Preview",
                        "solLink": "https://openexchange.intersystems.com/package/Server-Manager-3-0-Preview-1",
                        "shortDesc": "Now an Authentication Provider for VS Code, for better security",
                        "pubName": "John Murray",
                        "pubLink": "https://openexchange.intersystems.com/user/John%20Murray/yvmZwiGZUC2mNdn8wRwyunaOvg"
                    },
                    {
                        "solName": "IRIS Middlewares",
                        "solLink": "https://openexchange.intersystems.com/package/IRIS-Middlewares",
                        "shortDesc": "Specify your middlewares. security treatments on all requests.",
                        "pubName": "davi massaru teixeira muta",
                        "pubLink": "https://openexchange.intersystems.com/user/davi%20massaru%20teixeira%20muta/ygbBNKanLnVDa9ffzk64UznaE"
                    },
                    {
                        "solName": "Data_APP_Security",
                        "solLink": "https://openexchange.intersystems.com/package/Data_APP_Security",
                        "shortDesc": "OAuth Authentication, Authorization & Auditing basics          ",
                        "pubName": "Muhammad Waseem",
                        "pubLink": "https://openexchange.intersystems.com/user/Muhammad%20Waseem/8I7Ne8ED0B6T029jLBqN8aRaJ10"
                    },
                    {
                        "solName": "TimeTracking-workers",
                        "solLink": "https://openexchange.intersystems.com/package/TimeTracking-workers",
                        "shortDesc": "TimeTracking-workers",
                        "pubName": "Evgeniy Potapov",
                        "pubLink": "https://openexchange.intersystems.com/user/Evgeniy%20Potapov/8bFLplXR9DLxN82rbHCmEcKqNM"
                    },
                    {
                        "solName": "zap-api-scan-sample",
                        "solLink": "https://openexchange.intersystems.com/package/zap-api-scan-sample",
                        "shortDesc": "An example on how to scan your REST APIs on IRIS using the OWASP",
                        "pubName": "JosÃ© Roberto Pereira",
                        "pubLink": "https://openexchange.intersystems.com/user/Jos%C3%A9%20Roberto%20Pereira/hYivAh9O4bfh4fs7OYvoXRBRg"
                    }
                ],
                "count": 11
            },
            {
                "name": "Releases",
                "id": "2",
                "items": [
                    {
                        "solName": "DeepSeeWeb",
                        "solLink": "https://openexchange.intersystems.com/package/DeepSeeWeb?tab=history",
                        "shortDesc": "Renderer for DeepSee Dashboards in Browser with MDX2JSON as a Serverside and JS web-client",
                        "pubName": "Anton Gnibeda",
                        "pubLink": "https://openexchange.intersystems.com/user/Anton%20Gnibeda/UlbMrfpAWTlTMKDRG2GNXUSSHQ",
                        "versions": [
                            {
                                "version": "3.1.36",
                                "notes": "<ul>\n<li>fixed issue with click filter and autodrill</li>\n<li>fixed issue with auto drillthrough (empty widgets)</li>\n<li>fixed issue with iframe communication with shared widgets. <code>index</code> now contains widget name, if widget shared by name</li>\n<li>fixed issue with ...</li>\n</ul>\n"
                            },
                            {
                                "version": "3.1.35",
                                "notes": "<ul>\n<li>added legend for tree map widget</li>\n<li>fixed issue with <code>decimalSeparator</code>, <code>numericGroupSeparator</code>, <code>numericGroupSize</code> options for widgets (#228)</li>\n<li>added <code>dataLabels</code> data property for map widget (#231). now values can be displayed directly on ...</li>\n</ul>\n"
                            }
                        ]
                    },
                    {
                        "solName": "Log",
                        "solLink": "https://openexchange.intersystems.com/package/Log?tab=history",
                        "shortDesc": "Simple macros-driven logging system",
                        "pubName": "Eduard Lebedyuk",
                        "pubLink": "https://openexchange.intersystems.com/user/Eduard%20Lebedyuk/i0izhXgB7qUs5qHrMpzMzOlfHA",
                        "versions": [
                            {
                                "version": "1.22.0",
                                "notes": "<p>Code converted to CLS</p>\n"
                            }
                        ]
                    },
                    {
                        "solName": "apptools-admin",
                        "solLink": "https://openexchange.intersystems.com/package/apptools-admin?tab=history",
                        "shortDesc": "Application tools for technical support and DBMS administrator. View and edit arrays, execute queries, including JDBC/ODBC, sending results to email as XLS files. A few simple graphs on the protocols of the system.\n\nThis solution can be installed in earlier versions of Caché and Ensemble (tested 2016.1+). This can be done by importing xml.",
                        "pubName": "Sergey Mikhailenko",
                        "pubLink": "https://openexchange.intersystems.com/user/Sergey%20Mikhailenko/vmRZMGWcu4CDVwK0ZcLA1S1R1XA",
                        "versions": [
                            {
                                "version": "1.1.13",
                                "notes": "<p>update module.xml</p>\n"
                            }
                        ]
                    },
                    {
                        "solName": "API Security Mediator",
                        "solLink": "https://openexchange.intersystems.com/package/API-Security-Mediator?tab=history",
                        "shortDesc": "InterSystems IRIS Declarative Security Rules for REST APIs",
                        "pubName": "Visum Consult",
                        "pubLink": "https://partner.intersystems.com/company/Visum-Consult",
                        "versions": [
                            {
                                "version": "1.2.0",
                                "notes": "<p>YouTube video and header rule implementation</p>\n"
                            },
                            {
                                "version": "1.0.1",
                                "notes": "<p>Fix permissions to swagger and new article</p>\n"
                            }
                        ]
                    },
                    {
                        "solName": "Audit Mediator",
                        "solLink": "https://openexchange.intersystems.com/package/Audit-Mediator?tab=history",
                        "shortDesc": "Object Script mediator to audit ObjectScript REST API requests",
                        "pubName": "Visum Consult",
                        "pubLink": "https://partner.intersystems.com/company/Visum-Consult",
                        "versions": [
                            {
                                "version": "1.0.2",
                                "notes": "<p>YouTube video</p>\n"
                            },
                            {
                                "version": "1.0.1",
                                "notes": "<p>Fix readme and community article</p>\n"
                            }
                        ]
                    },
                    {
                        "solName": "Server Manager 3.0 Preview",
                        "solLink": "https://openexchange.intersystems.com/package/Server-Manager-3-0-Preview-1?tab=history",
                        "shortDesc": "Now an Authentication Provider for VS Code, for better security",
                        "pubName": "John Murray",
                        "pubLink": "https://openexchange.intersystems.com/user/John%20Murray/yvmZwiGZUC2mNdn8wRwyunaOvg",
                        "versions": [
                            {
                                "version": "2.99.2",
                                "notes": "<p>Improve OEX short title</p>\n"
                            },
                            {
                                "version": "2.99.1",
                                "notes": "<ul>\n<li>Simplify name.</li>\n<li>Add icon.</li>\n</ul>\n"
                            }
                        ]
                    },
                    {
                        "solName": "Data_APP_Security",
                        "solLink": "https://openexchange.intersystems.com/package/Data_APP_Security?tab=history",
                        "shortDesc": "OAuth Authentication, Authorization & Auditing basics          ",
                        "pubName": "Muhammad Waseem",
                        "pubLink": "https://openexchange.intersystems.com/user/Muhammad%20Waseem/8I7Ne8ED0B6T029jLBqN8aRaJ10",
                        "versions": [
                            {
                                "version": "1.0.2",
                                "notes": "<p>README.md file is updated\nIcon is added</p>\n"
                            }
                        ]
                    }
                ],
                "count": 7
            }
        ]

        return res
}

}
