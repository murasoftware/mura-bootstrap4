<cfoutput>
	#m.dspObject(
		object="header",
		objectParams=m.content('headerParams')
	)#
	#m.renderEditableAttribute(attribute="body",type="htmlEditor")#
	#m.dspObject(
		object="folder",
		params=objectParams
	)#
</cfoutput>
