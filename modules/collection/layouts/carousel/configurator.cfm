<cfoutput>
	<cfinclude template="_defaults.cfm">
	<cfset renderer=Mura.getContentRenderer()>

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
	<div class="mura-control-group">
		<label>Show Arrows</label>
		<select name="showArrows" class="objectParam">
			<option value="Yes"<cfif objectparams.showArrows is "Yes"> selected</cfif>>Yes</option>
			<option value="No"<cfif objectparams.showArrows is "No"> selected</cfif>>No</option>
		</select>
	</div>

	<div class="mura-control-group">
		<label>Show Pager</label>
		<select name="showPager" class="objectParam">
			<option value="Yes"<cfif objectparams.showPager is "Yes"> selected</cfif>>Yes</option>
			<option value="No"<cfif objectparams.showPager is "No"> selected</cfif>>No</option>
		</select>
	</div>

	<div class="mura-control-group">
		<label>#application.rbFactory.getKeyValue(session.rb,'collections.showCaption')#</label>
		<select name="showCaption" class="objectParam">
			<option value="Yes"<cfif objectparams.showCaption is "Yes"> selected</cfif>>Yes</option>
			<option value="No"<cfif objectparams.showCaption is "No"> selected</cfif>>No</option>
		</select>
	</div>
	<div class="mura-control-group">
		<label>#application.rbFactory.getKeyValue(session.rb,'collections.autoStart')#</label>
		<select name="autostart" class="objectParam">
			<option value="Yes"<cfif objectparams.autostart is "Yes"> selected</cfif>>Yes</option>
			<option value="No"<cfif objectparams.autostart is "No"> selected</cfif>>No</option>
		</select>
	</div>
	<div class="mura-control-group">
		<label>#application.rbFactory.getKeyValue(session.rb,'collections.interval')#</label>
		<input class="objectParam" name="interval"  type="text" data-validate="numeric" value="#esapiEncode('html_attr',objectparams.interval)#" />
	</div>



	<script>
	 $(function(){

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
