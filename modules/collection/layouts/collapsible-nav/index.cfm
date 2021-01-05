<cfparam name="objectParams.mobilelabel" default="Mobile Label">
<cfoutput>
    <div class="mura-collection collapsible-nav">
        <nav class="navbar navbar-expand-lg navbar-light">
                <div class="navbar-toggler" type="button" data-toggle="collapse" data-target="##navbar-#esapiencode('html_attr',objectparams.instanceid)#" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="h3">#esapiencode('html',objectparams.mobilelabel)#</span>
                </div>
            <div class="collapse navbar-collapse" id="navbar-#esapiencode('html_attr',objectparams.instanceid)#">
                <ul class="navbar-nav">
                <cfloop condition="iterator.hasNext()">
                    <cfsilent>
                        <cfset item=iterator.next()>
                    </cfsilent>
                    <li class="nav-item">
                        <a class="nav-link" href="#item.getUrl()#" target="#item.getTarget()#">#item.getTitle()#</a>
                    </li>
                </cfloop>
                </ul>
            </div>
        </nav>        
    </div>
</cfoutput>