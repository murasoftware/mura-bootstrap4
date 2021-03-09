<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes
	the preparation of a derivative work based on Mura CMS. Thus, the terms
	and conditions of the GNU General Public License version 2 ("GPL") cover
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant
	you permission to combine Mura CMS with programs or libraries that are
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS
	grant you permission to combine Mura CMS with independent software modules
	(plugins, themes and bundles), and to distribute these plugins, themes and
	bundles without Mura CMS under the license of your choice, provided that
	you follow these specific guidelines:

	Your custom code

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

	/admin/
	/core/
	/Application.cfc
	/index.cfm

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that
	meets the above guidelines as a combined work under the terms of GPL for
	Mura CMS, provided that you include the source code of that other code when
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not
	obligated to grant this special exception for your modified version; it is
	your choice whether to do so, or to make such modified version available
	under the GNU General Public License version 2 without this exception.  You
	may, if you choose, apply this exception to your own modified versions of
	Mura CMS.
--->
<cfsilent>
	<!--- In case someone is attempting to use the search box after clicking a tag --->
	<cfif Len(Mura.event('tag')) and Len(Mura.event('keywords'))>
		<cfset Mura.event('tag', '') />
	</cfif>

	<cfparam name="variables.rsnewsearch" default="#queryNew('empty')#"/>
	<cfparam name="request.aggregation" default="false">
	<cfparam name="request.searchSectionID" default="">
	<cfparam name="session.rsSearch" default="#queryNew('empty')#">
	<cfset validCSRFTokens=true>

	<cfif (len(request.keywords) or len(request.tag) ) and isdefined('request.newSearch')>
		<!---
		<cfif variables.Mura.getContentRenderer().validateCSRFTokens and not variables.Mura.validateCSRFTokens(context='search')>
			<cfset session.rsSearch=newResultQuery()/>
			<cfset validCSRFTokens=false>
		<cfelse>
		--->
			<cfset session.aggregation=request.aggregation />
			<cfset variables.rsNewSearch=application.contentManager.getPublicSearch(variables.Mura.event('siteID'),request.keywords,request.tag,request.searchSectionID) />

			<cfif getSite().getExtranet() eq 1>
				<cfset session.rsSearch=variables.Mura.queryPermFIlter(variables.rsnewsearch)/>
			<cfelse>
				<cfset session.rsSearch=variables.rsnewsearch/>
			</cfif>
		<!---</cfif>--->
	<cfelseif request.keywords eq '' and isdefined('request.newSearch')>
		<cfset session.rsSearch=newResultQuery()/>
	</cfif>

	<cfset variables.totalrecords=session.rsSearch.RecordCount>
	<cfset variables.recordsperpage=10>
	<cfset variables.NumberOfPages=Ceiling(variables.totalrecords/variables.recordsperpage)>
	<cfset variables.CurrentPageNumber=Ceiling(request.StartRow/variables.recordsperpage)>
	<cfset variables.next=evaluate((request.startrow+variables.recordsperpage))	>
	<cfset variables.previous=evaluate((request.startrow-variables.recordsperpage))	>
	<cfset variables.through=iif(variables.totalrecords lt variables.next,variables.totalrecords,variables.next-1)>

	<cfset variables.iterator=variables.Mura.getBean("contentIterator")>
	<cfset variables.iterator.setQuery(session.rsSearch,variables.recordsperpage)>
	<cfset variables.iterator.setStartRow(variables.Mura.event("startrow"))>

	<cfif len(request.searchSectionID)>
	<cfset variables.sectionBean=application.contentManager.getActiveContent(request.searchSectionID,variables.Mura.event('siteID')) />
	</cfif>

	<cfset variables.contentListFieldsType="Search">
	<cfset variables.contentListFields="Title,Summary,Tags,Credits">
</cfsilent>
<cfoutput>

	<!---<div class="jumbotron text-center mb-0" style="background-image: url(#m.content().getImageURL(size='hero')#); background-size: cover; background-repeat: no-repeat; background-attachment: scroll;">
		<h1 class="display-4" style="padding: 15px; display: inline-block; text-transform: uppercase; background-color: rgba(0, 0, 0, 0.52); color: white;">#variables.Mura.rbKey('search.searchresults')#</h1>
	</div>--->

	#m.dspObject(
		object="header",
		objectParams=urlDecode(Mura.content('headerParams')),
		targetattr='headerParams'
	)#

	<div id="svSearchResults" class="mura-search-results container #this.searchResultWrapperClass#">
		<div class="#this.searchResultInnerClass#">
			<cfif validCSRFTokens>
				<cfset variables.args=arrayNew(1)>
				<cfset variables.args[1]=session.rsSearch.recordcount>
				<cfif len(request.tag)>
					<cfset variables.args[2]=htmlEditFormat(request.tag)>
					<cfif len(request.searchSectionID)>
						<cfset variables.args[3]=htmlEditFormat(variables.sectionBean.getTitle())>
						<p>#variables.Mura.siteConfig("rbFactory").getResourceBundle().messageFormat(variables.Mura.rbKey('search.searchtagsection'),variables.args)#</p>
					<cfelse>
						<p>#variables.Mura.siteConfig("rbFactory").getResourceBundle().messageFormat(variables.Mura.rbKey('search.searchtag'),variables.args)#</p>
					</cfif>
				<cfelse>
					<cfset variables.args[2]=htmlEditFormat(request.keywords)>
					<cfif len(request.searchSectionID)>
						<cfset variables.args[3]=htmlEditFormat(variables.sectionBean.getTitle())>
				 		<p>#variables.Mura.siteConfig("rbFactory").getResourceBundle().messageFormat(variables.Mura.rbKey('search.searchkeywordsection'),variables.args)#</p>
					<cfelse>
						<p>#variables.Mura.siteConfig("rbFactory").getResourceBundle().messageFormat(variables.Mura.rbKey('search.searchkeyword'),variables.args)#</p>
					</cfif>
				</cfif>
			<cfelse>
				<p>Your request contained invalid tokens</p>
			</cfif>
		</div>


		<cfif variables.totalrecords>
			<!--- more results --->
			<div class="#this.searchResultsMoreResultsRowClass#">
				<div class="moreResults">
					<p>#variables.Mura.rbKey('search.displaying')#: #request.startrow# - #variables.through# #variables.Mura.rbKey('search.of')# #session.rsSearch.recordcount#</p>
					<cfif ( session.rsSearch.recordcount gt 0 and  variables.through lt session.rsSearch.recordcount ) OR variables.previous gte 1>
						<ul class="#searchResultsPagerClass#">
						<cfif variables.previous gte 1>
							<li class="navPrev page-link">
								<a href="?startrow=#variables.previous#&amp;display=search&amp;keywords=#HTMLEditFormat(request.keywords)#&amp;searchSectionID=#HTMLEditFormat(request.searchSectionID)#&amp;tag=#HTMLEditFormat(request.tag)#" aria-label="Previous page">#variables.Mura.rbKey('search.prev')#</a>
							</li>
						</cfif>
						<cfif session.rsSearch.recordcount gt 0 and variables.through lt session.rsSearch.recordcount>
							<li class="navNext page-link">
								<a href="?startrow=#next#&amp;display=search&amp;keywords=#HTMLEditFormat(request.keywords)#&amp;searchSectionID=#HTMLEditFormat(request.searchSectionID)#&amp;tag=#HTMLEditFormat(request.tag)#" aria-label="Next page">#variables.Mura.rbKey('search.next')#</a>
							</li>
						</cfif>
						</ul>
					</cfif>
				</div>
			</div>

			<!--- RESULTS --->
			<div class="#this.searchResultsRowClass#">
				<div id="svPortal" class="mura-index #this.searchResultsListClass#">
					#variables.Mura.dspObject_Include(
						thefile='collection/includes/dsp_content_list.cfm'
						, fields=variables.contentListFields
						, type=variables.contentListFieldsType
						, iterator= variables.iterator
					)#
				</div>
			</div>
			<!--- @END RESULTS --->

			<!--- more results --->
			<div class="#this.searchResultsMoreResultsRowClass#">
				<div class="moreResults">
					<p>#variables.Mura.rbKey('search.displaying')#: #request.startrow# - #variables.through# #variables.Mura.rbKey('search.of')# #session.rsSearch.recordcount#</p>
					<cfif ( session.rsSearch.recordcount gt 0 and  variables.through lt session.rsSearch.recordcount ) OR variables.previous gte 1>
						<ul class="#this.searchResultsPagerClass#">
						<cfif variables.previous gte 1>
							<li class="navPrev page-link">
								<a href="./?startrow=#variables.previous#&amp;display=search&amp;keywords=#HTMLEditFormat(request.keywords)#&amp;searchSectionID=#HTMLEditFormat(request.searchSectionID)#&amp;tag=#HTMLEditFormat(request.tag)#" aria-label="Previous page">#variables.Mura.rbKey('search.prev')#</a>
							</li>
						</cfif>
						<cfif session.rsSearch.recordcount gt 0 and  variables.through lt session.rsSearch.recordcount>
							<li class="navNext page-link">
								<a href="./?startrow=#next#&amp;display=search&amp;keywords=#HTMLEditFormat(request.keywords)#&amp;searchSectionID=#HTMLEditFormat(request.searchSectionID)#&amp;tag=#HTMLEditFormat(request.tag)#" aria-label="Next page">#variables.Mura.rbKey('search.next')#</a>
							</li>
						</cfif>
						</ul>
					</cfif>
				</div>
			</div>
		</cfif>

		<!--- SEARCH AGAIN --->
		<div class="#this.searchAgainRowClass#">
			<div class="#this.searchAgainInnerClass#">
				<form method="post" id="svSearchAgain" name="searchForm" class="mura-search-again #this.searchAgainFormClass#" role="search">
					<p>#variables.Mura.rbKey('search.didnotfind')#</p>
					<label for="txtKeywords">#variables.Mura.rbKey('search.keywords')#</label>
					<div class="#this.searchAgainInputWrapperClass#">
						<input type="text" name="Keywords" id="txtKeywords" class="#this.searchAgainFormInputClass#" value="#esapiEncode('html_attr',request.keywords)#" placeholder="#variables.Mura.rbKey('search.search')#">
						<span class="#this.searchAgainButtonWrapperClass#">
							<button type="submit" class="#this.searchAgainSubmitClass#">
								#Mura.rbKey('search.search')#
							</button>
						</span>
					</div>
					<input type="hidden" name="display" value="search">
					<input type="hidden" name="newSearch" value="true">
					<input type="hidden" name="noCache" value="1">
					<input type="hidden" name="searchSectionID" value="#HTMLEditFormat(request.searchSectionID)#">
					#variables.Mura.renderCSRFTokens(format='form',context='search')#
				</form>
			</div>
		</div>
	</div>
</cfoutput>
