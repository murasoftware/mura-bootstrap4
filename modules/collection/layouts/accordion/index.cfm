<cfsilent>		
	<cfparam name="objectParams.imageSize" default="medium">
	<cfparam name="objectParams.imageHeight" default="AUTO">
	<cfparam name="objectParams.imageWidth" default="AUTO">
	<cfparam name="objectParams.modalimages" default="false">
	<cfparam name="objectParams.bgStyle" default="">
	<cfparam name="objectParams.accordionPadding" default="loose">
	<cfparam name="objectParams.scrollpages" default="false">
	<cfparam name="objectParams.collapseIndicators" default="chevrons">
	<cfparam name="objectParams.collapseIndicatorsLocation" default="right">

	<cfset imageSizeArgs={
		size=objectParams.imageSize,
		height=objectParams.imageHeight,
		width=objectParams.imageWidth
	}>
</cfsilent>

<cfoutput>
	<div class="mura-collection">
		<div class="accordion #esapiencode('html_attr',objectParams.collapseIndicatorsLocation)#-indicator #esapiencode('html_attr',objectParams.accordionPadding)#-spacing #esapiencode('html_attr',objectParams.collapseIndicators)#" id="accordion-#objectparams.instanceid#">
		<cfloop condition="iterator.hasNext()">
			<cfsilent>
				<cfset item=iterator.next()>
			</cfsilent>
			<div class="card">
				<div class="card-header p-0 #objectParams.bgStyle#" id="##content-#item.getContentID()#">
					<a href="##" class="h5 m-0 d-block text-reset collapsed" data-toggle="collapse" data-target="##content-#item.getContentID()#" aria-expanded="false" aria-controls="content-#item.getContentID()#" role="button">#item.getTitle()#</a>
				</div>
				
				<div id="content-#item.getContentID()#" class="collapse" aria-labelledby="##content-#item.getContentID()#" data-parent="##accordion-#objectparams.instanceid#">
					<div class="card-body px-5"> <!--- #objectParams.bgStyle# ---> <!--- #item.getValue('CardBackgroundStyle')# --->
							<cfif listFindNoCase(objectParams.displaylist,'Image')>
								<div class="mura-item-content">
									<cfif item.hasImage()>
										<cfif objectparams.modalimages>
											<a href="#item.getImageURL(size='small')#" title="#esapiEncode('html_attr',item.getValue('title'))#" data-rel="shadowbox[gallery]" class="#this.contentListItemImageLinkClass#"><img class="mb-4 rounded-lg shadow" src="#item.getImageURL(argumentCollection=imageSizeArgs)#" alt="#esapiEncode('html_attr',item.getValue('title'))#"></a>
										<cfelse>
											<a href="#item.getURL()#"><img class="mb-4 rounded-lg shadow" src="#item.getImageURL(argumentCollection=imageSizeArgs)#" alt="#esapiEncode('html_attr',item.getValue('title'))#"></a>
										</cfif>
									</cfif>
								</div>
							</cfif>
							
							#m.dspObject_include(
								theFile='collection/includes/dsp_meta_list.cfm',
								item=item,
								fields=objectParams.displaylist
							)#
					</div>
				</div>
			</div>
		</cfloop>
		</div>		
	</div>

	#m.dspObject_include(
		theFile='collection/includes/dsp_pagination.cfm',
		iterator=iterator,
		nextN=iterator.getNextN(),
		source=objectParams.source,
		objectParams=objectParams
	)#

	<cfif len(objectParams.viewalllink)>
		<a class="view-all" href="#objectParams.viewalllink#">#HTMLEditFormat(objectParams.viewalllabel)#</a>
	</cfif>
</cfoutput>
