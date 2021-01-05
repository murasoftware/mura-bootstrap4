<cfoutput>
<cfparam name="objectParams.bgStyle" default="">
<cfparam name="objectParams.modalimages" default="false">
<cfparam name="objectParams.accordionPadding" default="loose">
<cfparam name="objectParams.collapseIndicators" default="chevrons">
<cfparam name="objectParams.collapseIndicatorsLocation" default="right">

<div class="mura-control-group">
    <label>Background Style</label>    
    <select class="objectParam" name="bgStyle">
        <option value=""> - </option>
        <option value="text-white bg-primary"<cfif objectParams.bgStyle eq "text-white bg-primary"> selected="selected"</cfif>>Primary</option>
        <option value="text-white bg-secondary"<cfif objectParams.bgStyle eq "text-white bg-secondary"> selected="selected"</cfif>>Secondary</option>
        <option value="text-white bg-success"<cfif objectParams.bgStyle eq "text-white bg-success"> selected="selected"</cfif>>Success</option>
        <option value="text-white bg-danger"<cfif objectParams.bgStyle eq "text-white bg-danger"> selected="selected"</cfif>>Danger</option>
        <option value="text-white bg-warning"<cfif objectParams.bgStyle eq "text-white bg-warning"> selected="selected"</cfif>>Warning</option>
        <option value="text-white bg-info"<cfif objectParams.bgStyle eq "text-white bg-info"> selected="selected"</cfif>>Info</option>
        <option value="bg-light"<cfif objectParams.bgStyle eq "bg-light"> selected="selected"</cfif>>Light</option>
        <option value="text-white bg-dark"<cfif objectParams.bgStyle eq "text-white bg-dark"> selected="selected"</cfif>>Dark</option>
		<option value="text-dark bg-white"<cfif objectParams.bgStyle eq "text-dark bg-white"> selected="selected"</cfif>>White</option>
    </select>
</div>

<div class="mura-control-group">
	<label>Padding</label>
  <select name="accordionPadding" data-displayobjectparam="accordionPadding" class="objectParam">
	  <cfloop list="Tight,Normal,Loose" index="i">
		  <option value="#lcase(i)#"<cfif objectparams.accordionPadding eq i> selected</cfif>>#i#</option>
	  </cfloop>
  </select>
</div>

<div class="mura-control-group">
	<label>Indicator Location</label>
  <select name="collapseIndicatorsLocation" data-displayobjectparam="collapseIndicatorsLocation" class="objectParam">
	  <cfloop list="Left,Right" index="i">
		  <option value="#lcase(i)#"<cfif objectparams.collapseIndicatorsLocation eq i> selected</cfif>>#i#</option>
	  </cfloop>
  </select>
</div>

<div class="mura-control-group">
	<label>Indicator Type</label>
  <select name="collapseIndicators" data-displayobjectparam="collapseIndicators" class="objectParam">
	  <cfloop list="Chevrons,Plus-Min" index="i">
		  <option value="#lcase(i)#"<cfif objectparams.collapseIndicators eq i> selected</cfif>>#i#</option>
	  </cfloop>
  </select>
</div>

<div class="mura-control-group">
  	<label>#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label>
	<select name="imageSize" data-displayobjectparam="imageSize" class="objectParam">
		<cfloop list="Small,Medium,Large" index="i">
			<option value="#lcase(i)#"<cfif i eq feed.getImageSize()> selected</cfif>>#i#</option>
		</cfloop>
		<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>
		<cfloop condition="imageSizes.hasNext()">
			<cfset image=imageSizes.next()>
			<option value="#lcase(image.getName())#"<cfif image.getName() eq feed.getImageSize()> selected</cfif>>#esapiEncode('html',image.getName())#</option>
		</cfloop>
		<option value="custom"<cfif "custom" eq feed.getImageSize()> selected</cfif>>Custom</option>
	</select>
</div>

<div id="imageoptionscontainer" style="display:none">
    <div class="mura-control-group">
    	<label>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
      	<input class="objectParam" name="imageHeight" data-displayobjectparam="imageHeight" type="text" value="#feed.getImageHeight()#" />
    </div>
    <div class="mura-control-group">
        <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</label>
    	<input class="objectParam" name="imageWidth" data-displayobjectparam="imageWidth" type="text" value="#feed.getImageWidth()#" />
    </div>
</div>

<div class="mura-control-group" id="availableFields">
	<label>
		<div>#application.rbFactory.getKeyValue(session.rb,'collections.selectedfields')#</div>
		<button id="editFields" class="btn"><i class="mi-pencil"></i> #application.rbFactory.getKeyValue(session.rb,'collections.edit')#</button>
	</label>
	<div id="sortableFields" class="sortable-sidebar">
    	<cfset displaylist=feed.getdisplaylist()>
    	<ul id="displayListSort" class="displayListSortOptions">
    		<cfloop list="#displaylist#" index="i">
    			<li class="ui-state-highlight">#trim(i)#</li>
    		</cfloop>
    	</ul>
    	<input type="hidden" id="displaylist" class="objectParam" value="#esapiEncode('html_attr',feed.getdisplaylist())#" name="displaylist"  data-displayobjectparam="displaylist"/>
    </div>
</div>

<div class="mura-control-group">
  	<label>#application.rbFactory.getKeyValue(session.rb,'collections.viewimagesasgallery')#</label>
	<select name="modalimages" data-displayobjectparam="modalimages" class="objectParam">
		<cfloop list="True,False" index="i">
			<option value="#i#"<cfif objectparams.modalimages eq i> selected</cfif>>#i#</option>
		</cfloop>
	</select>
</div>
<script>
	$(function(){
		$('##editFields').click(function(){
			frontEndProxy.post({
				cmd:'openModal',
				src:'?muraAction=cArch.selectfields&siteid=#esapiEncode("url",rc.siteid)#&contenthistid=#esapiEncode("url",rc.contenthistid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true&displaylist=' + $("##displaylist").val()
				}
			);
		});

		$("##displayListSort").sortable({
			update: function(event) {
				event.stopPropagation();
				$("##displaylist").val("");
				$("##displayListSort > li").each(function() {
					var current = $("##displaylist").val();

					if(current != '') {
						$("##displaylist").val(current + "," + $(this).html());
					} else {
						$("##displaylist").val($(this).html());
					}

					updateDraft();
				});

				//siteManager.updateObjectPreview();

			}
		}).disableSelection();

		$('##layoutoptionscontainer').show();

		function handleImageSizeChange(){
			if($('select[name="imageSize"]').val()=='custom'){
				$('##imageoptionscontainer').show()
			}else{
				$('##imageoptionscontainer').hide();
				$('##imageoptionscontainer').find(':input').val('AUTO');
			}
		}

		$('select[name="imageSize"]').change(handleImageSizeChange);

		handleImageSizeChange();
	});
</script>
</cfoutput>
